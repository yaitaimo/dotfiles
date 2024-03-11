function workspace_manage -d 'Manage workspaces with search or create functionality'
    # fzf でワークスペースを選択または新規作成用の名前を入力
    set -l query (ls ~/Workspace | fzf +m --print-query | head -n 2)

    # 入力がない場合は終了
    if test -z "$query"
        commandline -f repaint
        return 1
    end

    # ワークスペース名を決定
    set -l workspace_name (string trim "$query")

    # ワークスペースのフルパスを設定
    set -l workspace_path ~/Workspace/"$workspace_name"

    # ワークスペースが存在する場合は移動、存在しない場合は作成して移動
    if test -d "$workspace_path"
        echo "Entering workspace '$workspace_name'."
        cd "$workspace_path"
    else
        echo "Creating and entering new workspace: '$workspace_name'."
        mkdir -p "$workspace_path"
        cd "$workspace_path"
    end

    # コマンドラインを再描画
    commandline -f repaint
end
