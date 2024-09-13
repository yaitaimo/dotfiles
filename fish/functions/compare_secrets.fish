#!/usr/bin/env fish

function compare_secrets
    # 引数のチェック
    if test (count $argv) -ne 3
        echo "Usage: compare_secrets.fish <secret-arn> <first-version-id> <second-version-id>"
        echo "Example: compare_secrets.fish arn:aws:secretsmanager:ap-northeast-1:123456789012:secret:example-secret v1 v2"
        return 1
    end

    # 引数の変数割り当て
    set SECRET_ARN $argv[1]
    set FIRST_VERSION_ID $argv[2]
    set SECOND_VERSION_ID $argv[3]

    # 一時ファイルを作成
    set TEMPFILE1 (mktemp)
    set TEMPFILE2 (mktemp)

    # シークレットの内容を取得して一時ファイルに出力
    function get_secret_value
        set secret_arn $argv[1]
        set version_id $argv[2]
        aws secretsmanager get-secret-value --secret-id $secret_arn --version-id $version_id | jq -r '.SecretString | fromjson'
    end

    # 一時ファイルにシークレットを保存し、エラーチェック
    get_secret_value $SECRET_ARN $FIRST_VERSION_ID > $TEMPFILE1
    if test $status -ne 0
        echo "Failed to retrieve secret for version: $FIRST_VERSION_ID"
        rm $TEMPFILE1 $TEMPFILE2
        return 1
    end

    get_secret_value $SECRET_ARN $SECOND_VERSION_ID > $TEMPFILE2
    if test $status -ne 0
        echo "Failed to retrieve secret for version: $SECOND_VERSION_ID"
        rm $TEMPFILE1 $TEMPFILE2
        return 1
    end

    # シークレットの比較
    echo "Comparing secrets for versions $FIRST_VERSION_ID and $SECOND_VERSION_ID..."
    diff $TEMPFILE1 $TEMPFILE2

    # 結果の出力
    if test $status -eq 0
        echo "The secrets are identical."
    else
        echo "The secrets differ."
    end

    # 一時ファイルの削除
    rm $TEMPFILE1 $TEMPFILE2
end

