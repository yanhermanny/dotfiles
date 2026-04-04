#!/bin/sh
# ~/.config/bash/04_git_setup.sh
# --------------------------------------------------------------------------------
# Encontra e carrega a função __git_ps1
# --------------------------------------------------------------------------------

if test -z "$WINELOADERNOEXEC"; then
    # Verifica se o Git está instalado
    if command -v git >/dev/null 2>&1; then
        # 1. Tenta encontrar o caminho de execução do Git
        GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"

        # 2. Se o Git foi encontrado, monta o caminho para os scripts de completion
        if [[ -n "$GIT_EXEC_PATH" ]]; then
            COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
            COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
            COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"

            # 3. Carrega (source) as bibliotecas
            if test -f "$COMPLETION_PATH/git-prompt.sh"; then
                source "$COMPLETION_PATH/git-prompt.sh"
            fi
            if test -f "$COMPLETION_PATH/git-completion.bash"; then
                source "$COMPLETION_PATH/git-completion.bash"
            fi
        fi
    fi
fi
