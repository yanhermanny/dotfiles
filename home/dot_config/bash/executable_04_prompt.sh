#!/usr/bin/env sh
# ~/.config/bash/04_prompt.sh
# --------------------------------------------------------------------------------
# Prompt (PS1)
# --------------------------------------------------------------------------------

# ==============================================================================
# Definição do prompt
# ==============================================================================
set_custom_prompt() {
  # ---- Cores (ANSI) --------------------------------------------------------
  local RESET="\[\033[0m\]"
  local RED="\[\033[01;31m\]"
  local GREEN="\[\033[01;32m\]"
  local CYAN="\[\033[01;36m\]"
  local BLUE="\[\033[01;34m\]"

  # ---- Configurações gerais ------------------------------------------------
  local SEPARATOR=":"

  # ---- Título da janela ----------------------------------------------------

  # Detecta privilégio administrativo (Windows / Git Bash)
  local TITLEPREFIX=""
  if net session > /dev/null 2>&1; then
    TITLEPREFIX='ADMIN: '
  fi

  # Define título: [ADMIN:] caminho atual
  local WINDOW_TITLE='\[\033]0;'${TITLEPREFIX}'\w\007\]'

  # ---- Usuário (cor depende de privilégio) ---------------------------------
  local USER_COLOR="$GREEN"
  [ "$EUID" -eq 0 ] && USER_COLOR="$RED"

  local USER_HOST="${USER_COLOR}"'\u@\h'"${RESET}"

  # ---- Diretório atual -----------------------------------------------------
  local DIR="${BLUE}"'\w'"${RESET}"

  # ---- Git (branch atual) --------------------------------------------------
  local GIT_BRANCH=""
  if type __git_ps1 > /dev/null 2>&1; then
    GIT_BRANCH="${CYAN}$(__git_ps1)${RESET}"
  fi

  # ---- Montagem final do PS1 -----------------------------------------------
  PS1="${WINDOW_TITLE}${USER_HOST}${SEPARATOR}${DIR}${GIT_BRANCH}"'\$ '
}

# ==============================================================================
# Aplicação do prompt
# ==============================================================================

# Executa a função a cada renderização do prompt
if [[ -n "$PROMPT_COMMAND" ]]; then
  if [[ "$PROMPT_COMMAND" != *"set_custom_prompt"* ]]; then
    PROMPT_COMMAND="$PROMPT_COMMAND; set_custom_prompt"
  fi
else
  PROMPT_COMMAND="set_custom_prompt"
fi
