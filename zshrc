autoload -Uz compinit
compinit
path+=("${HOME}/bin")
source <(kubectl completion zsh)
alias k=kubectl
alias bh='sqlite3 ~/Library/Safari/History.db "SELECT url FROM history_items ORDER BY visit_count" | fzf | xargs open'
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
unsetopt prompt_cr prompt_sp

FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --color fg:14,fg+:3,hl:5,hl+:5,bg:-1,bg+:-1 --color info:6,prompt:6,spinner:1,pointer:3'

export GOPATH=${HOME}/Projects/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin

[ -f ~/.zsh/zsh-z/zsh-z.plugin.zsh ] && source ~/.zsh/zsh-z/zsh-z.plugin.zsh
[ -f ~/.zsh/.fzf.zsh ] && source ~/.zsh/.fzf.zsh
[ -f ~/.zsh/zsh-apple-touchbar/zsh-apple-touchbar.zsh ] && source ~/.zsh/zsh-apple-touchbar/zsh-apple-touchbar.zsh

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    vim)          fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' ;;
    *)            fzf "$@" ;;
  esac
}

function check_environment() {
  grep -qE '^[*].*[12]s' <(kubectl config get-contexts) &&\
  echo -ne "\n\033[31;7m[💀 WARNING - PRODUCTION 💀]\033[0m"
}

typeset -a precmd_functions
precmd_functions+=(check_environment)
eval "$(starship init zsh)"
