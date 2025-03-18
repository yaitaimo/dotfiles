function switch_aws_profile
    # ~/.aws/config からプロファイル名を抽出
    set profiles (grep '^\[profile ' ~/.aws/config | sed -e 's/^\[profile //' -e 's/\]$//')

    # プロファイルが見つからなければエラーメッセージを表示
    if test (count $profiles) -eq 0
        echo "No AWS profiles found in ~/.aws/config"
        commandline -f execute
        commandline -f repaint
        return 1
    end

    # fzf でプロファイルを選択
    set selected_profile (echo $profiles | tr ' ' '\n' | fzf --prompt="Select an AWS profile: ")

    # 選択したプロファイルを検証
    if test -n "$selected_profile"
        echo "Selected profile: $selected_profile"
        set -gx AWS_PROFILE $selected_profile
        commandline -f execute
        commandline -f repaint
    else
        commandline -f repaint
        return 1
    end
end
