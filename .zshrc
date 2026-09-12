# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Constants
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export EDITOR=/opt/homebrew/bin/nvim
export NOTES_DIR="~/Documents/notes/"
export DATABASE_DIR="~/Documents/database/"
export JOURNAL_DIR="~/journal"
# export CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
export CURRENT_DATE=$(date "+%Y-%m-%d")

# Zsh theme
ZSH_THEME="bureau-light"
# ZSH_THEME="bureau"
# ZSH_THEME="af-magic"
# ZSH_THEME="robbyrussell"

# ZSH options
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"
HIST_STAMPS="yyyy-mm-dd"

# https://zsh.sourceforge.io/Doc/Release/Options.html (16.2.4 History)
setopt EXTENDED_HISTORY      # Делать записи в файле истории в формате ':start:elapsed;command'.
setopt SHARE_HISTORY         # Использовать во всех сессиях общее хранилище истории.
setopt HIST_IGNORE_DUPS      # Не делать повторную запись о только что записанном событии.
setopt HIST_IGNORE_ALL_DUPS  # Удалять старую запись о событии в том случае, если новое событие является дубликатом старого.
setopt HIST_IGNORE_SPACE     # Не делать записи о командах, начинающихся с пробела.
setopt HIST_SAVE_NO_DUPS     # Не записывать дубликаты событий в файл истории.
setopt HIST_VERIFY           # Перед выполнением команд показывать записи о них из истории команд.
setopt INC_APPEND_HISTORY    # Писать данные в файл истории немедленно, а не тогда, когда осуществляется выход из оболочки.
setopt APPEND_HISTORY        # Добавлять записи к файлу истории (по умолчанию).
setopt HIST_NO_STORE         # Не хранить записи о командах history.
setopt HIST_REDUCE_BLANKS    # Убирать лишние пробелы из командных строк, добавляемых в историю.

# Colors
autoload -U colors && colors

# Zsh plugins
plugins=(
    asdf
    fzf
    git
    web-search
    you-should-use
    pass
)

source $ZSH/oh-my-zsh.sh

# Completion colors tuned for light terminal themes.
zstyle ':completion:*' list-colors \
  'di=1;34' 'ow=1;34' 'tw=1;34' 'ln=35' 'ex=31' 'fi=0'

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# Aliases

# Backup notes and database
alias nu="(cd $NOTES_DIR && git pull && git add . && git commit -m 'notes backup from: ${CURRENT_DATE}' && git push origin; cd $DATABASE_DIR && git pull && git add . && git commit -m 'database backup from: ${CURRENT_DATE}' && git push origin)"
alias jsync="(cd $JOURNAL_DIR && git pull && git add . && git commit -m 'log from ${CURRENT_DATE}' && git push origin)"
alias j="nvim ~/journal/index.txt"
alias jr="cat ~/journal/index.txt"

alias mc="mc --nosubshell"

alias clr=clear
alias cat=bat
alias png="ping -c 3 8.8.8.8"
alias ivm=nvim

# PHP aliases
alias php74="/opt/homebrew/opt/php@7.4/bin/php"
alias php81="/opt/homebrew/opt/php@8.1/bin/php"
alias php84="/opt/homebrew/opt/php@8.4/bin/php"

# Open sudo files in nvim
alias sv=sudoedit
alias vim=nvim

# Ripgrep aliases
alias rgl="rg -l"

# Git aliases
alias gs="git status --short --branch"
alias glg="git log --reverse --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an (%ae)%Creset' --abbrev-commit"
alias gl='git log --pretty=format:"%h %C(magenta)%ad | %C(white)%s%d %C(magenta)[%an]" --date=short --graph --max-count=40 $*'

# Get IP address from console
alias myip="curl http://ipecho.net/plain; echo"
alias myipextend="curl ipinfo.io; echo"

# Connect to MySQL
# alias db='mysql -u admin -proot'
# alias db='mysql -h 127.0.0.1 -u root -ptmp magento2'

# nginx aliases
alias nginxreload="sudo nginx -s reload"
alias nginxrestart="sudo nginx -s stop && sudo nginx"
alias nginxservers="cd /opt/homebrew/etc/nginx/servers"
alias nginxlist="ll /opt/homebrew/etc/nginx/servers"

# Go to the project directory
alias cdw="cd ~/Develop"
alias cdd="cd ~/Downloads/"
# alias cdm="cd ~/Develop/magento/"

# PHP Code Sniffer
# alias phpcs="phpcs --standard=PSR12"

# Docker aliases
alias dc="docker-compose -f ~/Develop/magento/docker-compose/fml.loc/docker-compose.local.yml exec web bash"
alias dct="docker-compose -f ~/Develop/magento/docker-compose/fml.loc/docker-compose.local.yml exec web bin/phpunit -c /repo/magento/dev/tests/integration/phpunit.xml"
alias dcs="docker-compose -f ~/Develop/magento/docker-compose/fml.loc/docker-compose.local.yml up -d"
alias dcd="docker-compose -f ~/Develop/magento/docker-compose/fml.loc/docker-compose.local.yml down"

# sshutle
# alias sshuttle="sshuttle --no-latency-control -e 'ssh -p 2314 -i ~/.ssh/id_rsa' -r externalguest@93.183.67.195 185.12.0.0/16"
# alias sshuttle="sshuttle --no-latency-control -e 'ssh -i ~/.ssh/id_rsa' -r ec2-user@185.123.79.35 185.12.0.0/16"
# alias sshuttle="sshuttle --no-latency-control -e 'ssh -p 2314 -i /Users/arzamaskov/.ssh/id_rsa_sshuttle' -r externalguest@93.183.67.195 10.140.0.0/16"
# alias sshuttle="sshuttle --dns --no-latency-control -e 'ssh -i /Users/arzamaskov/.ssh/id_rsa_sshuttle' -r ec2-user@185.123.79.35 172.31.0.0/16"
alias ssh-rabb="ssh -L 15672:10.140.128.5:15672 externalguest@93.183.67.195 -p 2314 -i /Users/arzamaskov/.ssh/id_rsa_sshuttle"
alias ssh-kub="ssh -L 6443:10.140.64.13:6443 externalguest@93.183.67.195 -p 2314 -i ~/.ssh/id_rsa_sshuttle"
# alias ssh-kub1="ssh -L 6443:10.140.128.24.13:6443 externalguest@93.183.67.195 -p 2314 -i ~/.ssh/id_rsa_sshuttle"
alias ssh-db="ssh -L 33066:10.140.128.5:3306 externalguest@93.183.67.195 -p 2314 -i ~/.ssh/id_rsa_sshuttle"
# # alias ssh-mq="ssh -L 8161:172.31.0.31:8161 externalguest@93.183.67.195 -p 2314 -i ~/.ssh/id_rsa_sshuttle"
# alias ssh-mq-test="ssh -L 61616:172.31.0.31:61616 externalguest@93.183.67.195 -p 2314 -i ~/.ssh/id_rsa_sshuttle"
# alias ssh-mq="ssh -L 8161:10.140.70.35:8161 externalguest@93.183.67.195 -p 2314 -i ~/.ssh/id_rsa_sshuttle"
# alias ssh-db="ssh -N -L 3307:172.22.0.3:3306 root@147.45.233.236"

# Dotfiles repository
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

#
#172.22.0.3
# Cursor AI
# alias ca="cursor-agent"

# Enable fzf auto-completions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set ripgrep as default and `m` option to make multiple selections with <Tab> or <Shift-Tab>
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m'
fi

# Git commit sign
export GPG_TTY=$(tty)

# Make switching PHP versions easy
function phpv() {
    brew unlink php
    brew link --overwrite --force "php@$1"
    php -v
}

export PATH="$PATH:$HOME/.composer/vendor/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/arzamaskov/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# SSHuttle to 10.140/16 (правильный listen на 127.0.0.1)
sshu() {
  local NET="${1:-10.140.0.0/16}"
  local PORT="${2:-12345}"
  sudo sshuttle --dns --disable-ipv6 \
    --listen "127.0.0.1:${PORT}" \
    -e "ssh -p 2314 -i $HOME/.ssh/id_rsa_sshuttle" \
    -r externalguest@93.183.67.195 \
    "$NET"
}

# Прогнать ВЕСЬ трафик через бастион (для диагностики или когда надо)
sshu-all() {
  local PORT="${1:-12345}"
  sudo sshuttle --dns --disable-ipv6 \
    --listen "127.0.0.1:${PORT}" \
    -e "ssh -p 2314 -i $HOME/.ssh/id_rsa_sshuttle" \
    -r externalguest@93.183.67.195 \
    0/0
}

# Акуратная остановка (посылает SIGINT всем процессам sshuttle)
sshu-stop() {
  pkill -INT -f 'sshuttle.*--listen 127\.0\.0\.1:' || true
}

# Быстрый самотест (запусти в другом окне sshu; этот проверит редиректор и доступ)
sshu-test() {
  local PORT="${1:-12345}"
  echo "Смотрю слушатель sshuttle на 127.0.0.1:${PORT}…"
  lsof -iTCP:"${PORT}" -sTCP:LISTEN
  echo "Показываю pf-правила анкора sshuttle-${PORT}…"
  sudo pfctl -a "sshuttle-${PORT}" -s nat
}



# Added by Antigravity
export PATH="/Users/arzamaskov/.antigravity/antigravity/bin:$PATH"
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
export PATH="/opt/homebrew/opt/dotnet/bin:$PATH"

# Pass
export PASSWORD_STORE_CLIP_TIME=30
export PASSWORD_STORE_CHARACTER_SET_NO_SYMBOLS="[:digit:]"
export PASSWORD_STORE_GPG_OPTS="-a"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

export PATH="$HOME/go/bin:$PATH"
