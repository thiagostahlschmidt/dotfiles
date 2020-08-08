source  ~/.config/fish/alias.fish

set -g fish_color_autosuggestion '555'  'brblack'
set -g fish_color_cancel -r
set -g fish_color_command --bold
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end brmagenta
set -g fish_color_error brred
set -g fish_color_escape 'bryellow'  '--bold'
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator bryellow
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection brblue
set -g fish_color_search_match 'bryellow'  '--background=brblack'
set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline
set -g fish_user_paths "/usr/local/opt/openjdk/bin" $fish_user_paths
set -gx CPPFLAGS "-I/usr/local/opt/openjdk/include"
set -gx EDITOR vim
set -gx FZF_LEGACY_KEYBINDINGS 0
set -gx FZF_DEFAULT_COMMAND  'rg --files --no-ignore-vcs --hidden'
set -gx FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border --color fg:14,fg+:3,hl:5,hl+:5,bg:-1,bg+:-1 --color info:6,prompt:6,spinner:1,pointer:3'

starship init fish | source
