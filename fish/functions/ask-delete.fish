function ask-delete
    set -l branches (git branch | string trim)
    for branch in $branches
        if not string match -q -r '^\*|master|main' -- $branch
            echo "------------------------------------"
            echo -e "💡 \033[1mBranch: $branch\033[0m"
            echo "Delete this branch? (y/N):"
            read -l confirm
            switch $confirm
                case y Y
                    git branch -D $branch
                    echo -e "✅ \033[32mDeleted branch:\033[0m $branch"
                case '*'
                    echo -e "⏭️  \033[33mSkipped branch:\033[0m $branch"
            end
        end
    end
    echo "------------------------------------"
    echo -e "🎉 \033[1mBranch cleanup completed!\033[0m"
end
