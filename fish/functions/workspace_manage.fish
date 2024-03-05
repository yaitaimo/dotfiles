function workspace_create -d 'Create a new workspace with current date'
    # ワークスペースの名前を受け取る
    set -l workspace_name_suffix (commandline -b)
    if not [ -n "$workspace_name_suffix" ]
        echo "ERROR: Please provide a workspace name suffix."
        return 1
    end

    # 現在の日付をフォーマット
    set -l date_prefix (date "+%Y-%m-%d")

    # ワークスペース名の組み立て
    set -l workspace_name "$date_prefix-$workspace_name_suffix"

    # ワークスペースディレクトリのパスを定義
    set -l workspace_path ~/Workspace/"$workspace_name"

    # ディレクトリがすでに存在するかどうかを確認
    if [ -d "$workspace_path" ]
        echo "ERROR: Workspace '$workspace_name' already exists."
        return 1
    end

    # ワークスペースディレクトリを作成
    mkdir -p "$workspace_path"

    # ワークスペースディレクトリに移動
    cd "$workspace_path"
    echo "Workspace '$workspace_name' created and entered."

    # コマンドラインを再描画
    commandline -f repaint
end

function workspace_search -d 'Workspace search'
    set -l selector
    [ -n "$WORKSPACE_SELECTOR" ]; and set selector $WORKSPACE_SELECTOR; or set selector fzf
    set -l selector_options
    [ -n "$WORKSPACE_SELECTOR_OPTS" ]; and set selector_options $WORKSPACE_SELECTOR_OPTS

    if not type -qf $selector
        printf "\nERROR: '$selector' not found.\n"
        return 1
    end

    set -l query (commandline -b)
    [ -n "$query" ]; and set flags --query="$query"; or set flags
    switch "$selector"
        case fzf fzf-tmux peco percol fzy sk
            ls ~/Workspace | "$selector" $selector_options $flags | read select
        case \*
            printf "\nERROR.\n"
    end
    [ -n "$select" ]; and cd ~/Workspace/"$select"
    commandline -f repaint
end

function fish_user_key_bindings
  bind \cw workspace_search
end
