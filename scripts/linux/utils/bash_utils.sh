#!/usr/bin/env bash
# --------------------------------------------------------------------------------
# Utilitários
# --------------------------------------------------------------------------------

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
      log_warning "Root privileges are required, please enter your password below"
      command sudo --validate
    fi
    if [[ "${exec}" == true ]]; then
      exec sudo "$@"
    else
      command sudo "$@"
    fi
  fi
}
