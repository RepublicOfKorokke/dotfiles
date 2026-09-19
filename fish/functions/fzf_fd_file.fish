function fzf_fd_file
    set -l current_dir "."

    while true
        set -l selected (fd --type f "$current_dir" | fzf --prompt="Select > ")

        if test -z "$selected"
            commandline --function repaint
            return
        end

        set -l clean_selected (string replace -r '[*/=>@|]$' '' -- "$selected")
        set -l target_path (path resolve "$current_dir/$clean_selected")
        set -l relative_path (grealpath --relative-to=$PWD "$target_path")

        if test -f "$relative_path"
            commandline -i (string escape -- "$relative_path")
            commandline --function repaint
            break
        end
    end
end
