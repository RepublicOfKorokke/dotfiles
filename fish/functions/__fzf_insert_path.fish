# 選択したパスをプレフィックスと置換/挿入モードに従ってコマンドラインへ反映する
function __fzf_insert_path --argument-names prefix base_dir path_like target_path
    # プレフィックスが入力済みならそのディレクトリ基準、なければ $PWD 基準
    set -l insert_base $PWD
    if test -n "$prefix"
        set insert_base $base_dir
    end

    set -l relative_path (grealpath --relative-to="$insert_base" -- "$target_path" 2>/dev/null)
    if test -z "$relative_path"
        # 壊れたリンクなどで realpath が解決できない場合は絶対パスを使う
        set relative_path "$target_path"
    end

    set -l escaped_path ""
    if test "$relative_path" != "."
        set escaped_path (string escape -- "$relative_path")
    else if test -z "$prefix"
        # 起点ディレクトリ自体を選んだ場合でも何か挿入されるようにする
        set escaped_path "."
    end

    if test "$path_like" = 1
        # トークン全体を置換（カーソル以降は破棄）
        commandline -t -- "$prefix$escaped_path"
    else
        commandline -i -- "$escaped_path"
    end
end
