function ask-delete
    # リモートモードフラグの初期化
    set -l target_remote 0

    # 引数の確認（--remoteがあるか）
    if test (count $argv) -gt 0
        if test "$argv[1]" = "--remote"
            set target_remote 1
        end
    end

    set -l branches ""

    # 対象ブランチのリスト取得
    if test $target_remote -eq 1
        echo -e "🔍 \033[1mTarget: Remote branches\033[0m"
        set branches (git branch -r | grep -v 'origin/HEAD' | string trim)
    else
        echo -e "🔍 \033[1mTarget: Local branches\033[0m"
        set branches (git branch | string trim)
    end

    # ブランチの削除確認ループ
    for branch in $branches
        # リモートブランチの前置き「origin/」を取り除く
        set -l clean_branch (echo $branch | sed 's#^origin/##')

        # main, master, develop, 現在のブランチをスキップ
        if string match -q -r 'main|master|develop|^\*' -- $clean_branch
            echo -e "⏭️  \033[33mSkipped branch:\033[0m $clean_branch"
            continue
        end

        echo "------------------------------------"
        echo -e "💡 \033[1mBranch: $branch\033[0m"
        echo "Delete this branch? (y/N):"
        read -l confirm

        switch $confirm
            case y Y
                if test $target_remote -eq 1
                    # リモートブランチを削除
                    git push origin --delete $clean_branch
                    echo -e "✅ \033[32mDeleted remote branch:\033[0m origin/$clean_branch"
                else
                    # ローカルブランチを削除
                    git branch -D $clean_branch
                    echo -e "✅ \033[32mDeleted local branch:\033[0m $clean_branch"
                end
            case '*'
                echo -e "⏭️  \033[33mSkipped branch:\033[0m $clean_branch"
        end
    end

    echo "------------------------------------"
    echo -e "🎉 \033[1mBranch cleanup completed!\033[0m"
end
