#!/bin/bash

# Logging levels
readonly LOG_LEVEL_ERROR=0
readonly LOG_LEVEL_WARN=1
readonly LOG_LEVEL_INFO=2
readonly LOG_LEVEL_DEBUG=3

# Default log level
LOG_LEVEL=$LOG_LEVEL_DEBUG

# Log directory
LOG_DIR="$(dirname "$(dirname "$(dirname "$0")")")/logs"
mkdir -p "$LOG_DIR"

# Get current timestamp
get_timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

# Log message with level
log_message() {
  local level=$1
  local message=$2
  local timestamp=$(get_timestamp)
  local log_file="$LOG_DIR/$(date '+%Y-%m-%d').log"

  # Only log if message level is less than or equal to current log level
  if [ $level -le $LOG_LEVEL ]; then
    case $level in
      $LOG_LEVEL_ERROR)
        echo -e "\033[31m[ERROR] $timestamp - $message\033[0m" | tee -a "$log_file" >&2
        ;;
      $LOG_LEVEL_WARN)
        echo -e "\033[33m[WARN] $timestamp - $message\033[0m" | tee -a "$log_file"
        ;;
      $LOG_LEVEL_INFO)
        echo -e "\033[32m[INFO] $timestamp - $message\033[0m" | tee -a "$log_file"
        ;;
      $LOG_LEVEL_DEBUG)
        echo -e "\033[36m[DEBUG] $timestamp - $message\033[0m" | tee -a "$log_file"
        ;;
    esac
  fi
}

# Logging functions
log_error() {
  log_message $LOG_LEVEL_ERROR "$1"
}

log_warn() {
  log_message $LOG_LEVEL_WARN "$1"
}

log_info() {
  log_message $LOG_LEVEL_INFO "$1"
}

log_debug() {
  log_message $LOG_LEVEL_DEBUG "$1"
} 