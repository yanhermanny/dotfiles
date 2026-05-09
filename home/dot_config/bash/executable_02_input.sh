#!/usr/bin/env bash
# ~/.config/bash/02_input.sh
# --------------------------------------------------------------------------------
# Configurações de Entrada (Input, Readline e Autocomplete)
# --------------------------------------------------------------------------------

# ==============================================================================
# bash-completion
# ==============================================================================
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# ==============================================================================
# Histórico do shell
# ==============================================================================

# ---- Arquivo de histórico (XDG) ----------------------------------------------
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/bash_history"

# Garante que diretório e arquivo existam
mkdir -p "$(dirname "$HISTFILE")"
if [[ ! -f "$HISTFILE" ]]; then
  touch "$HISTFILE"
  chmod 600 "$HISTFILE"
fi

# ---- Comportamento do histórico ----------------------------------------------

# Sempre adicionar ao invés de sobrescrever
shopt -s histappend

# Sincroniza histórico entre sessões (append + reload)
if [[ -n "$PROMPT_COMMAND" ]]; then
  if [[ "$PROMPT_COMMAND" != *"history -a; history -n"* ]]; then
    PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
  fi
else
  PROMPT_COMMAND="history -a; history -n"
fi

# Tamanho do histórico
HISTSIZE=5000        # memória
HISTFILESIZE=20000   # arquivo

# Controle de duplicatas e privacidade
# ignoreboth = ignoredups + ignorespace
# erasedups  = remove duplicatas antigas
HISTCONTROL=ignoreboth:erasedups

# Evita registrar comandos sensíveis (como senhas ou tokens)
HISTIGNORE="*password*:*secret*:*token*"

# ==============================================================================
# Readline (keybindings)
# ==============================================================================

# Navegação básica
bind '"\e[1~": beginning-of-line'   # Home
bind '"\e[4~": end-of-line'         # End

# Edição
bind '"\e":kill-whole-line'         # ESC → apaga linha inteira

# Limpeza de tela
bind '"\C-l":clear-display'         # Ctrl+L

# ==============================================================================
# Autocomplete
# ==============================================================================

# Comportamento geral
bind 'set show-all-if-ambiguous off'   # não mostra lista automaticamente
bind 'set completion-ignore-case on'   # case insensitive
bind 'set colored-stats on'            # cores
bind 'set visible-stats on'            # indicadores visuais

# Navegação no menu
bind '"\t":menu-complete'              # TAB → próximo
bind '"\e[Z":menu-complete-backward'   # SHIFT+TAB → anterior

# ==============================================================================
# Opções gerais do shell
# ==============================================================================

# Globbing avançado (ex: *.@(png|jpg))
shopt -s extglob

# Readline / terminal behavior
set bell-style none                    # desativa beep
set echo-control-characters off        # oculta ^C, ^M, etc
set mark-symlinked-directories on      # adiciona "/" em symlinks de diretório
