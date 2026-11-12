# 入力途中のトークンから探索開始位置と挿入方法を求める
# 出力（1行ずつ、string escape 済み）: path_like, prefix, base_dir
#
# path_like が 1 のときは、選択結果でトークン全体を置換する
# （カーソル以降の文字列は破棄される）
function __fzf_path_context
    set -l current_token (commandline -t)
    set -l path_like 0
    set -l prefix ""
    set -l base_dir $PWD

    if string match -q -- '*/*' "$current_token"
        or string match -q -- '~*' "$current_token"
        or string match -q -- '.*' "$current_token"
        set path_like 1
    end

    if test $path_like = 1
        if test "$current_token" = "~"
            # 単独の ~ はホームディレクトリとして扱う
            set prefix "~/"
            set base_dir $HOME
        else if string match -q -- '*/' "$current_token"
            # ディレクトリまで入力済みなら、そのディレクトリから開始する
            set prefix "$current_token"
            set -l expanded (string replace -r '^~(?=/|$)' $HOME -- "$current_token")
            set base_dir (path resolve -- $expanded)
        else
            # ファイル名の入力途中なら、その親ディレクトリから開始する
            set prefix (string replace -r '[^/]*$' '' -- "$current_token")
            set -l expanded (string replace -r '^~(?=/|$)' $HOME -- "$prefix")
            if test -n "$expanded"
                set base_dir (path resolve -- $expanded)
            end
        end

        # 入力途中のディレクトリが存在しない場合は通常の探索に戻す
        if not test -d "$base_dir"
            set path_like 0
            set prefix ""
            set base_dir $PWD
        end
    end

    printf '%s\n' $path_like
    string escape -- "$prefix"
    string escape -- "$base_dir"
end
