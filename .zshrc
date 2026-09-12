# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="bureau-light"

plugins=(
  asdf
  fzf
  git
  web-search
  you-should-use
  pass
)

# Environment
export EDITOR=nvim
export VISUAL=nvim
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

NOTES_DIR="$HOME/Documents/notes"
DATABASE_DIR="$HOME/Documents/database"
JOURNAL_DIR="$HOME/journal"

# PATH
typeset -U path PATH

path=(
  "$HOME/.local/bin"
  "$HOME/.composer/vendor/bin"
  "$HOME/go/bin"
  "$HOME/.antigravity/antigravity/bin"
  "/opt/homebrew/opt/mysql@8.0/bin"
  "/opt/homebrew/opt/dotnet/bin"
  $path
)

# Docker completions must be in fpath before Oh My Zsh runs compinit
[[ -d "$HOME/.docker/completions" ]] &&
  fpath=("$HOME/.docker/completions" $fpath)

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HIST_STAMPS="yyyy-mm-dd"
HISTORY_IGNORE='(ls|ls *|cd|cd *|pwd|exit)'

# fzf
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m'

source "$ZSH/oh-my-zsh.sh"

# History behavior
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS

# Completion colors for light terminal themes
zstyle ':completion:*' list-colors \
  'di=1;34' \
  'ow=1;34' \
  'tw=1;34' \
  'ln=35' \
  'ex=31' \
  'fi=0'

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------

alias vim='nvim'
alias sv='sudoedit'
alias ivm='nvim'

alias clr='clear'
alias cat='bat'
alias mc='mc --nosubshell'
alias png='ping -c 3 8.8.8.8'

# Ripgrep
alias rgl='rg -l'

# Git
alias gs='git status --short --branch'
alias glg="git log --reverse --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an (%ae)%Creset' --abbrev-commit"
alias gl='git log --pretty=format:"%h %C(magenta)%ad | %C(white)%s%d %C(magenta)[%an]" --date=short --graph --max-count=40'

# Network
alias myip='curl http://ipecho.net/plain; echo'
alias myipextend='curl ipinfo.io; echo'

# Directories
alias cdw='cd ~/Develop'
alias cdd='cd ~/Downloads'

# nginx
alias nginxreload='sudo nginx -s reload'
alias nginxrestart='sudo nginx -s stop && sudo nginx'
alias nginxservers='cd /opt/homebrew/etc/nginx/servers'
alias nginxlist='ll /opt/homebrew/etc/nginx/servers'

# PHP
alias php74='/opt/homebrew/opt/php@7.4/bin/php'
alias php81='/opt/homebrew/opt/php@8.1/bin/php'
alias php84='/opt/homebrew/opt/php@8.4/bin/php'

# Dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# ---------------------------------------------------------------------------
# Repository backups
# ---------------------------------------------------------------------------

git_backup() (
  local dir="$1"
  local message="$2"

  cd "$dir" || return 1

  git pull --ff-only || return 1
  git add -A

  if ! git diff --cached --quiet; then
    git commit -m "$message" || return 1
  fi

  git push origin
)

nu() {
  local date
  date=$(date '+%Y-%m-%d')

  git_backup "$NOTES_DIR" "notes backup from: $date" || return 1
  git_backup "$DATABASE_DIR" "database backup from: $date"
}

jsync() {
  git_backup "$JOURNAL_DIR" "log from $(date '+%Y-%m-%d')"
}

j() {
  nvim "$JOURNAL_DIR/index.txt"
}

jr() {
  cat "$JOURNAL_DIR/index.txt"
}

# ---------------------------------------------------------------------------
# PHP
# ---------------------------------------------------------------------------

phpv() {
  if [[ -z "$1" ]]; then
    echo "Usage: phpv <version>"
    return 2
  fi

  brew unlink php >/dev/null 2>&1 || true
  brew link --overwrite --force "php@$1" &&
    rehash &&
    php -v
}

# ---------------------------------------------------------------------------
# Corporate network
# ---------------------------------------------------------------------------

BASTION_HOST="externalguest@93.183.67.195"
BASTION_PORT=2314
BASTION_KEY="$HOME/.ssh/id_rsa_sshuttle"

bastion() {
  ssh \
    -p "$BASTION_PORT" \
    -i "$BASTION_KEY" \
    "$@" \
    "$BASTION_HOST"
}

alias ssh-rabb='bastion -L 15672:10.140.128.5:15672'
alias ssh-kub='bastion -L 6443:10.140.64.13:6443'
alias ssh-db='bastion -L 33066:10.140.128.5:3306'

sshu() {
  local net="${1:-10.140.0.0/16}"
  local port="${2:-12345}"

  sudo sshuttle \
    --dns \
    --disable-ipv6 \
    --listen "127.0.0.1:$port" \
    -e "ssh -p $BASTION_PORT -i $BASTION_KEY" \
    -r "$BASTION_HOST" \
    "$net"
}

sshu-all() {
  local port="${1:-12345}"

  sudo sshuttle \
    --dns \
    --disable-ipv6 \
    --listen "127.0.0.1:$port" \
    -e "ssh -p $BASTION_PORT -i $BASTION_KEY" \
    -r "$BASTION_HOST" \
    0/0
}

sshu-stop() {
  pkill -INT -f 'sshuttle.*--listen 127\.0\.0\.1:' || true
}

sshu-test() {
  local port="${1:-12345}"

  echo "Слушатель sshuttle на 127.0.0.1:$port:"
  lsof -iTCP:"$port" -sTCP:LISTEN

  echo "PF anchor sshuttle-$port:"
  sudo pfctl -a "sshuttle-$port" -s nat
}

# ---------------------------------------------------------------------------
# Tool integrations
# ---------------------------------------------------------------------------

# NVM
export NVM_DIR="$HOME/.nvm"

[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] &&
  source "/opt/homebrew/opt/nvm/nvm.sh"

[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] &&
  source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# JetBrains
[[ -f "$HOME/.jetbrains.vmoptions.sh" ]] &&
  source "$HOME/.jetbrains.vmoptions.sh"

# GPG
export GPG_TTY="$TTY"

# pass
export PASSWORD_STORE_CLIP_TIME=30
export PASSWORD_STORE_CHARACTER_SET_NO_SYMBOLS="[:digit:]"
export PASSWORD_STORE_GPG_OPTS="-a"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
