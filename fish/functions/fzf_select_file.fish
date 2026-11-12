function fzf_select_file
    for cmd in gls fzf grealpath
        if not type -q $cmd
            echo "fzf_select_file: $cmd not found" >&2
            commandline --function repaint
            return 1
        end
    end

    # 入力中のパスから選ぶか、zoxide で起点を選ぶかを決める
    set -l direct_label 'direct (typed path)'
    set -l zoxide_label 'zoxide (select start dir)'
    set -l mode (printf '%s\n' "$direct_label" "$zoxide_label" | fzf --prompt="start > ")

    if test -z "$mode"
        commandline --function repaint
        return
    end

    set -l path_like 0
    set -l prefix ""
    set -l base_dir $PWD

    if test "$mode" = "$zoxide_label"
        if not command -q zoxide
            echo "fzf_select_file: zoxide not found" >&2
            commandline --function repaint
            return 1
        end

        set base_dir (zoxide query -i)

        if test -z "$base_dir"
            commandline --function repaint
            return
        end

        set base_dir (path resolve -- $base_dir)
        if not test -d "$base_dir"
            commandline --function repaint
            return
        end
    else
        # 入力途中のパスがあれば、そのディレクトリを探索の起点にする
        set -l context (__fzf_path_context)
        set path_like $context[1]
        set prefix (string unescape -- $context[2])
        set base_dir (string unescape -- $context[3])
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

        __fzf_insert_path "$prefix" "$base_dir" $path_like "$target_path"
        commandline --function repaint
        break
    end
end
