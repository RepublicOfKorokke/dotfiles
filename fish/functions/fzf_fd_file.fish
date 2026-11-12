function fzf_fd_file
    for cmd in fd fzf grealpath
        if not type -q $cmd
            echo "fzf_fd_file: $cmd not found" >&2
            commandline --function repaint
            return 1
        end
    end

    # 隠しファイル・ignore 対象を含めるかを選ぶ
    set -l default_label 'default (respect ignore)'
    set -l all_label 'include hidden/ignored'
    set -l scope (printf '%s\n' "$default_label" "$all_label" | fzf --prompt="fd scope > ")

    if test -z "$scope"
        commandline --function repaint
        return
    end

    set -l fd_flags
    if test "$scope" = "$all_label"
        set fd_flags --no-ignore --hidden
    end

    # 入力途中のパスがあれば、そのディレクトリを検索の起点にする
    set -l context (__fzf_path_context)
    set -l path_like $context[1]
    set -l prefix (string unescape -- $context[2])
    set -l base_dir (string unescape -- $context[3])

    set -l selected (fd $fd_flags --type f . "$base_dir" | fzf --prompt="Select > ")

    if test -z "$selected"
        commandline --function repaint
        return
    end

    set -l target_path (path resolve -- "$selected")
    __fzf_insert_path "$prefix" "$base_dir" $path_like "$target_path"
    commandline --function repaint
end
