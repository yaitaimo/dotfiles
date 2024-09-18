#!/usr/bin/env fish

function compare_secrets
    # 初期化
    set -l use_labels 0
    set -l SECRET_ARN
    set -l FIRST_VERSION_ID
    set -l SECOND_VERSION_ID

    # 引数の解析
    set -l args $argv
    while test (count $args) -gt 0
        switch $args[1]
            case '--use-labels'
                set use_labels 1
                set args $args[2..-1]
            case '*'
                if test -z "$SECRET_ARN"
                    set SECRET_ARN $args[1]
                else if test -z "$FIRST_VERSION_ID"
                    set FIRST_VERSION_ID $args[1]
                else if test -z "$SECOND_VERSION_ID"
                    set SECOND_VERSION_ID $args[1]
                else
                    echo "Unexpected argument: $args[1]"
                    return 1
                end
                set args $args[2..-1]
        end
    end

    # 引数のチェック
    if test $use_labels -eq 1
        if test -z "$SECRET_ARN"
            echo "Usage: compare_secrets.fish <secret-arn> [--use-labels]"
            return 1
        end
        set FIRST_VERSION_ID 'AWSPREVIOUS'
        set SECOND_VERSION_ID 'AWSCURRENT'
    else
        if test -z "$SECRET_ARN" -o -z "$FIRST_VERSION_ID" -o -z "$SECOND_VERSION_ID"
            echo "Usage: compare_secrets.fish <secret-arn> <first-version-id> <second-version-id>"
            echo "Example: compare_secrets.fish arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example-secret v1 v2"
            return 1
        end
    end

    # 一時ファイルを作成
    set TEMPFILE1 (mktemp)
    set TEMPFILE2 (mktemp)

    # シークレットの内容を取得する関数
    function get_secret_value
        set secret_arn $argv[1]
        set version_id $argv[2]
        set use_labels $argv[3]
        if test $use_labels -eq 1
            aws secretsmanager get-secret-value --secret-id $secret_arn --version-stage $version_id | jq -r '.SecretString | fromjson'
        else
            aws secretsmanager get-secret-value --secret-id $secret_arn --version-id $version_id | jq -r '.SecretString | fromjson'
        end
    end

    # シークレットを取得して一時ファイルに保存
    get_secret_value $SECRET_ARN $FIRST_VERSION_ID $use_labels > $TEMPFILE1
    if test $status -ne 0
        echo "Failed to retrieve secret for version: $FIRST_VERSION_ID"
        rm $TEMPFILE1 $TEMPFILE2
        return 1
    end

    get_secret_value $SECRET_ARN $SECOND_VERSION_ID $use_labels > $TEMPFILE2
    if test $status -ne 0
        echo "Failed to retrieve secret for version: $SECOND_VERSION_ID"
        rm $TEMPFILE1 $TEMPFILE2
        return 1
    end

    # シークレットの比較
    echo "Comparing secrets for versions $FIRST_VERSION_ID and $SECOND_VERSION_ID..."
    diff --label="Secret ($FIRST_VERSION_ID)" --label="Secret ($SECOND_VERSION_ID)" $TEMPFILE1 $TEMPFILE2

    # 結果の出力
    if test $status -eq 0
        echo "The secrets are identical."
    else
        echo "The secrets differ."
    end

    # 一時ファイルの削除
    rm $TEMPFILE1 $TEMPFILE2
end

