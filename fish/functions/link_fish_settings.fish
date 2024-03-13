function link_fish_settings
    # リンクを作成する基本ディレクトリを設定します。
    set fish_global_config ~/.config/fish

    # 各ディレクトリに対して処理を実行します。
    for dir in completions conf.d functions
        # グローバル設定の対応するディレクトリを確認します。
        if not test -d $fish_global_config/$dir
            # 存在しない場合はディレクトリを作成します。
            mkdir -p $fish_global_config/$dir
        end

        # 対象ディレクトリ内のファイルに対してループ処理を行います。
        for file in $PWD/fish/$dir/*
            # シンボリックリンクを作成します。
            ln -sf $file $fish_global_config/$dir/(basename $file)
        end
    end

    echo "fish 設定のリンクが完了しました。"
end

