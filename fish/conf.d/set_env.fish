set -x EDITOR "nvim"
set -x LS_COLORS (vivid generate molokai)
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_DEFAULT_OPTS "--bind 'backward-eof:abort,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all' --cycle --reverse --height=75%"
set -x FZF_DEFAULT_COMMAND 'rg -uu --files --hidden --glob "!.git"'

