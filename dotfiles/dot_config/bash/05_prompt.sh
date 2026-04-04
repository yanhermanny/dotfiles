#!/bin/sh
# ~/.config/bash/05_prompt.sh
# --------------------------------------------------------------------------------
# Definição do Prompt (PS1)
# --------------------------------------------------------------------------------

# ======================== Definição do visual do prompt =========================
set_custom_prompt() {
    # Variáveis de Cores (códigos de escape ANSI)
    local RESET="\[\033[0m\]"
    local RED="\[\033[01;31m\]"
    local GREEN="\[\033[01;32m\]"
    local CYAN="\[\033[01;36m\]"
    local BLUE="\[\033[01;34m\]"
    local SEPARATOR=":"

    # Verifica se o shell está rodando como administrador (root)
    if net session > /dev/null 2>&1; then
      local TITLEPREFIX='ADMIN: '
    else
      local TITLEPREFIX=''
    fi
    PS1='\[\033]0;$TITLEPREFIX$PWD\007\]' # Define o título da janela

    # Cor do usuário: vermelho se root, verde se usuário normal
    local USER_COLOR="$GREEN"
    [ "$EUID" -eq 0 ] && USER_COLOR="$RED"

    # Elementos do prompt
    local USER_HOST="${USER_COLOR}"'\u@\h'"${RESET}"
    local DIR="${BLUE}"'\w'"${RESET}"
    local GIT_BRANCH=""
    if type __git_ps1 > /dev/null 2>&1; then
        GIT_BRANCH="${CYAN}$(__git_ps1)${RESET}"
    fi

    # Prompt final com separadores
    PS1="${PS1}${USER_HOST}${SEPARATOR}${DIR}${GIT_BRANCH}"'\$ '
}

# Aplicar o prompt a cada linha
if [[ -n "$PROMPT_COMMAND" ]]; then
    PROMPT_COMMAND="${PROMPT_COMMAND}; set_custom_prompt"
else
    PROMPT_COMMAND="set_custom_prompt"
fi


# Limpa variáveis temporárias
unset RESET RED GREEN CYAN BLUE SEPARATOR USER_COLOR TITLEPREFIX USER_HOST DIR GIT_BRANCH
# ================================================================================
