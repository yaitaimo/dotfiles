function workspace_manage -d 'Manage workspaces with search or create functionality'
    # fzf でワークスペースを選択または新規作成用の名前を入力
    set current_date (date +%Y%m%d)

    set workspace_name (ls ~/Workspace | fzf +m --print-query --query $current_date)
    set workspace_name (echo $workspace_name | awk '{print $NF}')

    # 入力がない場合は終了
    if test -z "$workspace_name"
        echo "No workspace selected or created."
        commandline -f execute
        commandline -f repaint
        return 1
    end

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
    commandline -f execute
    commandline -f repaint
end
