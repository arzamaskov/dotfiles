# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Constants
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export NOTES_DIR="~/Documents/knowledge-base/"
export CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
export EDITOR=/opt/homebrew/bin/nvim

# Zsh theme
ZSH_THEME="bureau"
# ZSH_THEME="bureau-light"
# ZSH_THEME="af-magic"
# ZSH_THEME="robbyrussell"

# ZSH options
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
setopt prompt_subst

# Colors
autoload -U colors && colors

# Zsh plugins
plugins=(
    asdf
    brew
    fzf
    git
    pass
    vi-mode
    web-search
    you-should-use
)

source $ZSH/oh-my-zsh.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# Aliases
alias clr=clear
alias cat=bat
alias vim=nvim

# Ripgrep aliases
alias rgl="rg -l"

# Git aliases
alias gs="git status --short --branch"
alias glg="git log --reverse --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an (%ae)%Creset' --abbrev-commit"

# cd
alias cdd="cd ~/Downloads"
alias cdw="cd ~/Develop"

# Docker aliases
alias dps='docker ps'

# NOTES UPDATE
alias nu="(cd $NOTES_DIR && git pull && git add . && git commit -m 'Notes backup from script: ${CURRENT_DATE}' && git push origin)"

# Get IP address from console
alias myip="curl http://ipecho.net/plain; echo"

# Find duplicates
alias fd=find-duplicates

# Enable fzf auto-completions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add fuzzy-search to git
fpath+=${ZDOTDIR:-~}/.zsh_functions
autoload -U fzf-git-branch
autoload -U fzf-git-checkout
autoload -U fzf-git-merge
autoload -U find-duplicates

# Aliases for git function
alias gbf='fzf-git-branch'
alias gcf='fzf-git-checkout'
alias gmef='fzf-git-merge'

# Set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set ripgrep as default and `m` option to make multiple selections with <Tab> or <Shift-Tab>
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m'
fi

# Add vendor binaries in the PATH
export PATH="$PATH:$HOME/.config/composer/vendor/bin"
export PATH="$PATH:$HOME/.asdf/installs/php/8.2.13/.composer/vendor/bin"
export PATH="$PATH:$HOME/.asdf/installs/php/8.1.24/.composer/vendor/bin"
export PATH="$PATH:$HOME/.asdf/installs/php/8.0.30/.composer/vendor/bin"
export PATH="$PATH:$HOME/.asdf/installs/php/7.4.33/.composer/vendor/bin"
export PATH="$HOME/.symfony5/bin:$PATH"

setopt correctall
