function workspace_manage -d 'Manage workspaces with search or create functionality'
    # fzf でワークスペースを選択または新規作成用の名前を入力
    set -l results (ls ~/Workspace | fzf --print-query --height=10 --prompt="Select or type new workspace name: ")
    set -l query (echo $results | head -n 1)
    set -l selected_workspace (echo $results | tail -n +2)

    # ユーザが何も選択しなかった場合の対応
    if not [ -n "$query" ]
        echo "No workspace selected or entered. Operation cancelled."
        return 1
    end

    # ユーザが入力したクエリを使用してワークスペース名を決定
    set -l workspace_name (string trim "$query")

    # ワークスペースのフルパスを設定
    set -l workspace_path ~/Workspace/"$workspace_name"

    # 選択または入力されたワークスペースが既に存在するかチェック
    if [ -d "$workspace_path" ]
        # 存在する場合はそのディレクトリに移動
        echo "Entering workspace '$workspace_name'."
        cd "$workspace_path"
    else
        # 存在しない場合は新しくディレクトリを作成して移動
        echo "Creating and entering new workspace: '$workspace_name'."
        mkdir -p "$workspace_path"
        cd "$workspace_path"
    end

    # コマンドラインを再描画
    commandline -f repaint
end
