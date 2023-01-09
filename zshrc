autoload -Uz compinit
compinit
path+=("${HOME}/bin")
source <(kubectl completion zsh)
alias k=kubectl
alias dok='minikube start; eval $(minikube -p minikube docker-env)'
alias sh='sqlite3 ~/Library/Safari/History.db "SELECT url FROM history_items ORDER BY visit_count" | fzf | xargs open'
ch() {
  local cols sep
  cols=$((COLUMNS/3))
  sep='{::}'
  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
  sqlite3 -separator $sep /tmp/h "select substr(title, 1, $cols), url from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}
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

export MAVEN_OPTS='-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true'

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
