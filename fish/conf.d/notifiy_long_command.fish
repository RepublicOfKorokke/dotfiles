function notify_long_command --on-event fish_postexec
    set -l duration (test -n "$CMD_DURATION"; and echo "$CMD_DURATION"; or echo 0)
    test $duration -lt 3000; and return

    set -l cmd_base (string split --no-empty " " -- $argv[1])[1]
    set -l exclude_list nvim vim vi man less top htop btop btm tail ssh bat lazygit pi opencode dejima glow
    if contains $cmd_base $exclude_list
        return
    end

    set -l cmd_name $argv[1]
    set -l finish_time (date "+%H:%M:%S")
    set -l title "$finish_time ("$duration"ms)"

    printf "\a"
    if type -q osascript
        osascript -e "display notification \"$cmd_name\" with title \"$title\" sound name \"Glass\""
    else if type -q notify-send
        notify-send -u critical "$title" "$cmd_name"
    end
end
