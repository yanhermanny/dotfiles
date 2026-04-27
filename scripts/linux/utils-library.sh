#!/usr/bin/env bash
# --------------------------------------------------------------------------------
# Utilitários
# --------------------------------------------------------------------------------

set -euo pipefail

# ==============================================================================
# Log
# ==============================================================================

# ---- colors ------------------------------------------------------------------
readonly COLOR_DEFAULT="0;37"
readonly COLOR_GRAY="0;90"
readonly COLOR_BLUE="1;34"
readonly COLOR_CYAN="1;36"
readonly COLOR_RED="1;31"
readonly COLOR_GREEN="0;32"
readonly COLOR_YELLOW="0;33"
readonly COLOR_BRIGHT_YELLOW="1;33"

# ---- log functions -----------------------------------------------------------
_log_color() {
  local color_code="$1"
  shift

  local prefix=""
  if [[ $# -gt 1 ]]; then
    prefix="$1"
    shift
  fi

  # Interpreta escapes
  local message
  message=$(printf "%b" "$@")

  # Extrai TODAS as quebras de linha iniciais de uma vez
  local trimmed="${message#${message%%[!$'\n']*}}"
  local leading_newlines="${message%"$trimmed"}"
  message="$trimmed"

  # Imprime quebras iniciais
  printf "%s" "$leading_newlines"

  # Imprime mensagem
  if [[ -n "$prefix" ]]; then
    printf "\033[%sm%s %s\033[0m\n" "$color_code" "$prefix" "$message"
  else
    printf "\033[%sm%s\033[0m\n" "$color_code" "$message"
  fi
}

log() {
  _log_color "0;37" "$@"
}

log_info() {
  _log_color "$COLOR_BLUE" "ℹ️" "$@"
}

log_task() {
  _log_color "$COLOR_CYAN" "🔃" "$@"
}

log_warning() {
  _log_color "$COLOR_YELLOW" "⚠️" "$@"
}

log_error() {
  _log_color "$COLOR_RED" "❌" "$@"
}

log_success() {
  _log_color "$COLOR_GREEN" "✅" "$@"
}

log_comment() {
  _log_color "$COLOR_GRAY" "$@"
}

log_command() {
  _log_color "$COLOR_BRIGHT_YELLOW" "👉" "$@"
}

# ==============================================================================
# Sudo
# ==============================================================================
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
