# ==========================================
# OH MY ZSH
# ==========================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="norm"

plugins=(
  git
  sudo
  zsh-autosuggestions
  zsh-completions
  fast-syntax-highlighting
  fzf
)

source $ZSH/oh-my-zsh.sh

# ==========================================
# ENVIRONMENT
# ==========================================

export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"

export PGHOST="/var/run/postgresql"
DISABLE_AUTO_TITLE="true"
unset zle_bracketed_paste 
# ==========================================
# HISTORY
# ==========================================

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history

# ==========================================
# ZSH OPTIONS
# ==========================================

setopt autocd
setopt interactivecomments
setopt correct



# ==========================================
# ZOXIDE
# ==========================================

eval "$(zoxide init zsh)"

# ==========================================
# FZF
# ==========================================

source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS='
  --height=40%
  --layout=reverse
  --border
  --color=bg+:#434C5E,bg:#2E3440,spinner:#88C0D0,hl:#81A1C1
  --color=fg:#D8DEE9,header:#81A1C1,info:#A3BE8C,pointer:#88C0D0
  --color=marker:#EBCB8B,fg+:#ECEFF4,prompt:#B48EAD,hl+:#81A1C1
'
# ==========================================
# NORD COLORS
# ==========================================

export BAT_THEME="Nord"

# ==========================================
# EZA
# ==========================================

alias ls="eza --icons --group-directories-first"
alias ll="eza -lah --icons --group-directories-first"
alias la="eza -a --icons"
alias lt="eza --tree --level=2 --icons"

# ==========================================
# BAT
# ==========================================

alias cat="batcat"

# ==========================================
# NEOVIM
# ==========================================

alias v="nvim"
alias vim="nvim"
alias nano="nvim"
# ==========================================
# GIT
# ==========================================

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# ==========================================
# GENERAL
# ==========================================

alias c="clear"
alias ..="cd .."
alias ...="cd ../.."

# ==========================================
# COMPLETIONS
# ==========================================
# ==========================================
# COMPLETIONS
# ==========================================

# O Oh My Zsh já chama o compinit internamente por causa dos seus plugins.
# Mantemos apenas as estilizações do menu de completação para não duplicar processos.
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ==========================================
# PROMPT
# ==========================================

PROMPT_EOL_MARK=""

# ==========================================
# NORD MANPAGES
# ==========================================

export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;38;5;81m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;223;48;5;236m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[4;38;5;110m'

# ==========================================
# BETTER TERMINAL COLORS
# ==========================================

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# ==========================================
# NODE VERSION MANAGER (NVM)
# ==========================================

# 1. Garante a integridade do comando nativo 'hash' antes do script rodar
unalias hash 2>/dev/null

export NVM_DIR="$HOME/.nvm"

# ==========================================
# NODE VERSION MANAGER (NVM) - LAZY LOADING
# ==========================================

export NVM_DIR="$HOME/.nvm"

# Cria uma função que carrega o NVM real quando disparada
_load_nvm() {
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        # Força o ZSH a usar o comando nativo 'hash' caso algum plugin tenha criado um alias
        disable -f hash 2>/dev/null
        enable -f hash 2>/dev/null
        
        # Carrega o NVM isolando o ambiente
        setopt LOCAL_OPTIONS NO_MONITOR 2>/dev/null
        \. "$NVM_DIR/nvm.sh"
        
        # Carrega completações se existirem
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi
}

# Cria placeholders para os comandos comuns. 
# Quando você digita um deles, ele carrega o NVM e executa o comando original.
nvm() {
    unset -f nvm node npm npx
    _load_nvm
    nvm "$@"
}

node() {
    unset -f nvm node npm npx
    _load_nvm
    node "$@"
}

npm() {
    unset -f nvm node npm npx
    _load_nvm
    npm "$@"
}

npx() {
    unset -f nvm node npm npx
    _load_nvm
    npx "$@"
}

