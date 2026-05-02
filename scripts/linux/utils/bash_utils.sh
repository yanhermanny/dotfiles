#!/usr/bin/env bash
# --------------------------------------------------------------------------------
# Utilitários
# --------------------------------------------------------------------------------

# ---- source guard ------------------------------------------------------------
[[ -n "${__BASH_UTILS_SH_LOADED:-}" ]] && return
readonly __BASH_UTILS_SH_LOADED=1

# ---- source logger library ---------------------------------------------------
LOGGER_LIB="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/logger.sh"
if [[ ! -f "$LOGGER_LIB" ]]; then
  printf "\033[%sm%s\033[0m\n" "1;31" "❌ Required library not found: $LOGGER_LIB" >&2
  exit 1
fi
source "$LOGGER_LIB"

# ---- wraper para sudo --------------------------------------------------------
sudo() {
  local exec=false
  if [[ "$1" == "exec" ]]; then
    shift
    exec=true
  fi

  if [[ "$(id -u)" -eq 0 ]]; then
    if [[ "${exec}" == true ]]; then
      exec "$@"
    else
      "$@"
    fi
  else
    if ! command sudo --non-interactive true 2>/dev/null; then
      log "Root privileges are required, please enter your password below" --level WARNING
      command sudo --validate
    fi
    if [[ "${exec}" == true ]]; then
      exec sudo "$@"
    else
      command sudo "$@"
    fi
  fi
}
