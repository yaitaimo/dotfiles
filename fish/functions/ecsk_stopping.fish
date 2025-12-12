#!/usr/bin/env fish

function ecsk_stopping
    # クラスターの一覧を取得
    set clusters (aws ecs list-clusters --query 'clusterArns[]' --output text | tr '\t' '\n')

    if test -z "$clusters"
        echo "ECSクラスターが見つかりませんでした。"
        return 1
    end

    # タスク情報を格納するリストを初期化
    set task_list

    # 各クラスターでタスクを検索
    for cluster in $clusters
        # クラスター名を抽出
        set cluster_name (echo $cluster | awk -F/ '{print $NF}')

        # desired status が STOPPED のタスクを取得
        set tasks (aws ecs list-tasks --cluster $cluster_name --desired-status STOPPED --query 'taskArns[]' --output text | tr '\t' '\n')

        if test -z "$tasks"
            continue
        end

        # タスクの詳細情報を取得し、status が RUNNING のものをフィルタリング
        set task_details (aws ecs describe-tasks --cluster $cluster_name --tasks $tasks --query 'tasks[?lastStatus==`RUNNING`]' --output json)

        # タスク情報をリストに追加
        for task in (echo $task_details | jq -c '.[]')
            set task_list $task_list $task
        end
    end

    if test -z "$task_list"
        echo "条件に合致するタスクが見つかりませんでした。"
        return 1
    end

    # タスクの一覧を表示
    echo "接続するタスクを選択してください："
    for i in (seq 1 (count $task_list))
        set task (echo $task_list[$i] | jq '.')
        set task_name (echo $task | jq -r '.')
        set task_arn (echo $task | jq -r '.taskArn')
        set cluster_arn (echo $task | jq -r '.clusterArn')
        set cluster_name (echo $cluster_arn | awk -F/ '{print $NF}')
        set task_id (echo $task_arn | awk -F/ '{print $NF}')
        echo "$i) クラスター: $cluster_name, タスク名: $task_name, タスクID: $task_id"
    end

    read -p "タスクの番号を入力してください: " selection

    if test -z "$selection" -o "$selection" -lt 1 -o "$selection" -gt (count $task_list)
        echo "無効な選択です。"
        return 1
    end

    # 選択したタスク情報を取得
    set selected_task (echo $task_list[$selection] | jq '.')

    # クラスター名とタスクIDを取得
    set selected_task_arn (echo $selected_task | jq -r '.taskArn')
    set selected_task_id (echo $selected_task_arn | awk -F/ '{print $NF}')
    set selected_cluster_arn (echo $selected_task | jq -r '.clusterArn')
    set selected_cluster_name (echo $selected_cluster_arn | awk -F/ '{print $NF}')
    set container_names (echo $selected_task | jq -r '.containers[].name' | tr ' ' '\n')

    echo $container_names

    for i in (seq 1 (count $container_names))
        set container_name (echo $container_names[$i])
        echo "$i) コンテナ名: $container_name"
    end

    read -p "コンテナ名の番号を入力してください: " selection

    if test -z "$selection" -o "$selection" -lt 1 -o "$selection" -gt (count $container_names)
        echo "無効な選択です。"
        return 1
    end

    set container_name (echo $container_names[$selection])

    # タスクに接続
    aws ecs execute-command \
        --cluster $selected_cluster_name \
        --task $selected_task_id \
        --container $container_name \
        --interactive \
        --command "/bin/bash"
end

