function fzf_select_file --argument-names start_dir
    for cmd in gls fzf grealpath
        if not type -q $cmd
            echo "fzf_select_file: $cmd not found" >&2
            commandline --function repaint
            return 1
        end
    end

    set -l prefix ""
    set -l base_dir $PWD
    set -l insert_base $PWD
    set -l replace_token 0

    if test -n "$start_dir"
        # 起点ディレクトリが指定された場合はそこから探索する
        set base_dir (path resolve -- $start_dir)
        if not test -d "$base_dir"
            commandline --function repaint
            return
        end
    else
        # 入力途中のパスがあれば、そのディレクトリを探索の起点にする
        set -l current_token (commandline -ct)

        set -l path_like 0
        if string match -q -- '*/*' "$current_token"
            or string match -q -- '~*' "$current_token"
            or string match -q -- '.*' "$current_token"
            set path_like 1
        end

        if test $path_like = 1
            set replace_token 1

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
                set prefix (string replace -r '[^/]*$' '' -- $current_token)
                set -l expanded (string replace -r '^~(?=/|$)' $HOME -- $prefix)
                if test -n "$expanded"
                    set base_dir (path resolve -- $expanded)
                end
            end

            # 入力途中のディレクトリが存在しない場合は通常の探索に戻す
            if not test -d "$base_dir"
                set prefix ""
                set base_dir $PWD
            end

            # プレフィックスが base_dir を指すので、挿入パスも base_dir 基準にする
            set insert_base $base_dir
        end
    end

    set -l current_dir $base_dir

    while true
        set -l selected (gls --group-directories-first -aF "$current_dir" | fzf --prompt="Select > ")

        if test -z "$selected"
            commandline --function repaint
            return
        end

        set -l clean_selected (string replace -r '[*/=>@|]$' '' -- "$selected")
        set -l target_path (path resolve "$current_dir/$clean_selected")

        # ディレクトリなら中へ潜る（"." は今いるディレクトリ自体の確定）
        if test "$clean_selected" != "."; and test -d "$target_path"
            set current_dir "$target_path"
            continue
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

        if test $replace_token = 1
            commandline -t -- "$prefix$escaped_path"
        else
            commandline -i -- "$escaped_path"
        end
        commandline --function repaint
        break
    end
end
