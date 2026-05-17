function __git_sweep_default_branch
    set -l extras_default_branch (git config --get git-extras.default-branch 2>/dev/null)
    if test -n "$extras_default_branch"
        echo $extras_default_branch
        return 0
    end

    set -l init_default_branch (git config --get init.defaultBranch 2>/dev/null)
    if test -n "$init_default_branch"
        echo $init_default_branch
        return 0
    end

    echo main
end

function __git_sweep_worktree_path_for_branch --argument-names branch
    git worktree list --porcelain | awk -v target="refs/heads/$branch" '
        $1 == "worktree" { path = $2 }
        $1 == "branch" && $2 == target { print path }
    '
end

function __git_sweep_worktree_is_dirty --argument-names worktree_path
    test -n "(git -C "$worktree_path" status --porcelain --untracked-files=normal 2>/dev/null)"
end

function __git_sweep_remove_worktrees_for_branches
    set -l current_pwd (pwd)

    for branch in $argv
        set -l worktree_path (__git_sweep_worktree_path_for_branch $branch)
        if test -z "$worktree_path"
            continue
        end

        if test "$worktree_path" = "$current_pwd"
            continue
        end

        if __git_sweep_worktree_is_dirty "$worktree_path"
            echo "Skipped dirty worktree for $branch: $worktree_path"
            continue
        end

        if git worktree remove "$worktree_path"
            echo "Removed worktree for $branch: $worktree_path"
        else
            echo "Skipped worktree for $branch after remove failed: $worktree_path"
        end
    end
end

function __git_sweep_merged_branches
    set -l default_branch (__git_sweep_default_branch)
    set -l current_branch (git rev-parse --abbrev-ref HEAD)

    for branch in (git for-each-ref refs/heads/ --merged HEAD --format='%(refname:short)')
        if test "$branch" = "$default_branch"
            continue
        end

        if test "$branch" = "$current_branch"
            continue
        end

        if string match -q 'svn*' -- $branch
            continue
        end

        echo $branch
    end
end

function __git_sweep_squashed_branches
    set -l target_branch (git rev-parse --abbrev-ref HEAD)

    for branch in (git for-each-ref refs/heads/ --format='%(refname:short)')
        if test "$branch" = "$target_branch"
            continue
        end

        set -l merge_base (git merge-base $target_branch $branch 2>/dev/null)
        if test $status -ne 0
            continue
        end

        set -l tree (git rev-parse "$branch^{tree}" 2>/dev/null)
        if test $status -ne 0
            continue
        end

        set -l synthetic_commit (git commit-tree $tree -p $merge_base -m _ 2>/dev/null)
        if test $status -ne 0
            continue
        end

        set -l cherry_result (git cherry $target_branch $synthetic_commit 2>/dev/null)
        if string match -q -- '-*' $cherry_result
            echo $branch
        end
    end
end

function git-sweep
    set -l squashed_branches (__git_sweep_squashed_branches)
    __git_sweep_remove_worktrees_for_branches $squashed_branches
    git delete-squashed-branches

    set -l merged_branches (__git_sweep_merged_branches)
    __git_sweep_remove_worktrees_for_branches $merged_branches
    git delete-merged-branches

    ask-delete
end
