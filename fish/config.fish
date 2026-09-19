function fish_greeting
    echo TTY: (set_color yellow)(tty)(set_color normal)
end

zoxide init fish | source
podman completion fish | source

# bind shortcut keys
# bind \cq 'fzf_change_env'
bind \cr 'fzf_command_history'
bind \cq 'fzf_select_file'
bind \ct 'fzf_fd_file'
