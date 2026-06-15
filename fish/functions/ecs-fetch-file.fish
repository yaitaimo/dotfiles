function ecs-fetch-file --description "Interactively fetch command output from an ECS container"
    if not command -q uv
        echo "uv が見つかりません。先に uv をインストールしてください。" >&2
        return 1
    end

    set script_path ~/bin/ecs-fetch-file.py
    if not test -f $script_path
        echo "$script_path が見つかりません。dotfiles の mac_install.sh を実行してリンクしてください。" >&2
        return 1
    end

    uv run $script_path $argv
end
