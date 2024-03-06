#!/usr/bin/env fish
for branch in (git branch | string trim)
    if not string match -q -r '^\*|master|main' -- $branch
        echo "Delete branch $branch? (y/N):"
        read -l confirm
        switch $confirm
            case y Y
                git branch -D $branch
            case '*'
                echo "Skipping $branch..."
        end
    end
end

