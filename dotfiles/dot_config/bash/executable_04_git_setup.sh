#!/usr/bin/env sh
# ~/.config/bash/04_git_setup.sh
# --------------------------------------------------------------------------------
# Git: prompt e autocomplete
# --------------------------------------------------------------------------------

# ==============================================================================
# Pré-condições
# ==============================================================================

# Evita execução em ambientes incompatíveis (ex: Wine)
if test -n "$WINELOADERNOEXEC"; then
    return
fi

# Verifica se o Git está disponível
if ! command -v git >/dev/null 2>&1; then
    return
fi

# ==============================================================================
# Descoberta de caminhos
# ==============================================================================

# Caminho interno de execução do Git
GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"

# Se não foi possível determinar o caminho, aborta
if [[ -z "$GIT_EXEC_PATH" ]]; then
    return
fi

# ==============================================================================
# Localização dos scripts de completion
# ==============================================================================

# Remove sufixos comuns do caminho interno do Git
BASE_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
BASE_PATH="${BASE_PATH%/lib/git-core}"

# Caminho esperado para scripts auxiliares
COMPLETION_PATH="$BASE_PATH/share/git/completion"

# ==============================================================================
# Carregamento (prompt e autocomplete)
# ==============================================================================

# Prompt (__git_ps1)
if test -f "$COMPLETION_PATH/git-prompt.sh"; then
    source "$COMPLETION_PATH/git-prompt.sh"
fi

# Autocomplete
if test -f "$COMPLETION_PATH/git-completion.bash"; then
    source "$COMPLETION_PATH/git-completion.bash"
fi
