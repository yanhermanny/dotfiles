#!/bin/sh
# ~/.config/bash/02_input.sh
# --------------------------------------------------------------------------------
# Configurações de Entrada (Input, Readline e Autocomplete)
# --------------------------------------------------------------------------------

# =========================== Carregar bash-completion ===========================
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
# ================================================================================

# ============================== Histórico do Shell ==============================
# Localização do arquivo de histórico
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/bash_history"

# Garante que o diretório existe
mkdir -p "$(dirname "$HISTFILE")"

# Garante que o arquivo existe e é legível/escrevível
if [[ ! -f "$HISTFILE" ]]; then
    touch "$HISTFILE"
    chmod 600 "$HISTFILE"
fi

# Sempre adicionar, nunca sobrescrever o histórico anterior
shopt -s histappend

# Salvar cada comando imediatamente após execução
if [[ -n "$PROMPT_COMMAND" ]]; then
    PROMT_COMMAND='history -a; history -n; '"$PROMPT_COMMAND"
else
    PROMPT_COMMAND='history -a; history -n'
fi

# Limitar número de comandos mantidos na memória
HISTSIZE=5000

# Limitar tamanho total do arquivo $HISTFILE
HISTFILESIZE=20000

# Evita duplicatas e comandos consecutivos repetidos
# ignoreboth = ignoredups + ignorespace
# erasedups  = remove duplicatas antigas do arquivo
HISTCONTROL=ignoreboth:erasedups

# Evita registrar comandos sensíveis (como senhas ou tokens)
HISTIGNORE="*password*:*secret*:*token*"
# ================================================================================

# ===================== Configurações de Readline (Bindings) =====================
# Mapeia a tecla Home para ir para o início da linha (com o ^[[H)
bind '"\e[1~": beginning-of-line'

# Mapeia a tecla End para ir para o fim da linha (com o ^[[F)
bind '"\e[4~": end-of-line'

# ESC deletes the whole line
bind '"\e":kill-whole-line'

# CTRL+L clears the display
bind '"\C-l":clear-display'
# ================================================================================

# ======================== Configurações de Autocomplete =========================
# Usa menu de autocomplete estilo "ciclo" (TAB/SHIFT+TAB)
bind 'set show-all-if-ambiguous off'        # Mostra sugestões automaticamente
bind 'set completion-ignore-case on'        # Ignora diferenças de maiúsculas/minúsculas
bind 'set colored-stats on'                 # Habilita cores no autocomplete
bind 'set visible-stats on'                 # Exibe símbolos visuais para indicar o tipo do ítem

# TAB = próxima sugestão, SHIFT+TAB = anterior
bind '"\t":menu-complete'                   # TAB → completa o próximo item
bind '"\e[Z":menu-complete-backward'        # SHIFT+TAB → volta para a sugestão anterior
# ================================================================================

# ============================ Outras Opções de Shell ============================
# Permite expressões complexas como `ls *.(png|jpg)` (Extended Globbing)
shopt -s extglob

# Evita o som de campainha (beep) no terminal
set bell-style none

# Não exibe caracteres de controle (como ^M) no terminal
set echo-control-characters off

# Adiciona uma barra (/) ao final dos symbolic links que apontam para diretórios
set mark-symlinked-directories on
# ================================================================================
