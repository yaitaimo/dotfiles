function git-sweep
    git delete-squashed-branches
    git delete-merged-branches
    ask-delete
end
