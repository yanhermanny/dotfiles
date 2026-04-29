#!/usr/bin/env bash
# --------------------------------------------------------------------------------
# Logger
# --------------------------------------------------------------------------------

# ---- colors ------------------------------------------------------------------
readonly COLOR_DEFAULT="0;37"
readonly COLOR_GRAY="0;90"
readonly COLOR_BLUE="1;34"
readonly COLOR_CYAN="1;36"
readonly COLOR_RED="1;31"
readonly COLOR_GREEN="0;32"
readonly COLOR_YELLOW="0;33"
readonly COLOR_BRIGHT_YELLOW="1;33"

# ---- core log function -------------------------------------------------------
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

# ---- semantic log functions --------------------------------------------------
_log_normal() {
  _log_color "0;37" "$@"
}

_log_info() {
  _log_color "$COLOR_BLUE" "ℹ️" "$@"
}

_log_task() {
  _log_color "$COLOR_CYAN" "🔃" "$@"
}

_log_warning() {
  _log_color "$COLOR_YELLOW" "⚠️" "$@"
}

_log_error() {
  _log_color "$COLOR_RED" "❌" "$@"
}

_log_success() {
  _log_color "$COLOR_GREEN" "✅" "$@"
}

_log_comment() {
  _log_color "$COLOR_GRAY" "$@"
}

_log_command() {
  _log_color "$COLOR_BRIGHT_YELLOW" "👉" "$@"
}

# ---- log function ------------------------------------------------------------
log() {
  local message=""
  local level=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -l|--level) level="$2"; shift 2 ;;
      --level=*) level="${1#*=}"; shift ;;
      -*) _log_error "-bash: log: $1: invalid option"; _log_error "log: usage: log "message" [--level <level>]"; return 1 ;;
      *) message="$1"; shift ;;
    esac
  done

  level="${level,,}"

  case "$level" in
    info)    _log_info "$message" ;;
    task)    _log_task "$message" ;;
    warning) _log_warning "$message" ;;
    error)   _log_error "$message" ;;
    success) _log_success "$message" ;;
    comment) _log_comment "$message" ;;
    command) _log_command "$message" ;;
    "" )     _log_normal "$message" ;;
    *)       _log_error "function log: invalid log level: [$level]"; return 1 ;;
  esac
}
