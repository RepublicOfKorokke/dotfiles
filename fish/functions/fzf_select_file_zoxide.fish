function fzf_select_file_zoxide
    # zoxide で起点ディレクトリを選び、そこからファイルを選択する
    if not command -q zoxide
        echo "fzf_select_file_zoxide: zoxide not found" >&2
        commandline --function repaint
        return 1
    end

    set -l start_dir (zoxide query -i)

    if test -z "$start_dir"
        commandline --function repaint
        return
    end

    fzf_select_file "$start_dir"
end
