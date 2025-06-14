#!/bin/bash

# Logging utility functions

# Log levels
readonly LOG_LEVEL_ERROR=0
readonly LOG_LEVEL_WARN=1
readonly LOG_LEVEL_INFO=2
readonly LOG_LEVEL_DEBUG=3

# Current log level (default to INFO)
LOG_LEVEL=$LOG_LEVEL_INFO

# Initialize logging
init_logging() {
    local verbose=$1
    
    if [[ "$verbose" == "true" ]]; then
        LOG_LEVEL=$LOG_LEVEL_DEBUG
    fi
}

# Log message with timestamp
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [[ $level -le $LOG_LEVEL ]]; then
        case $level in
            $LOG_LEVEL_ERROR)
                echo -e "\033[31m[ERROR] $timestamp - $message\033[0m" >&2
                ;;
            $LOG_LEVEL_WARN)
                echo -e "\033[33m[WARN]  $timestamp - $message\033[0m" >&2
                ;;
            $LOG_LEVEL_INFO)
                echo -e "\033[32m[INFO]  $timestamp - $message\033[0m"
                ;;
            $LOG_LEVEL_DEBUG)
                echo -e "\033[36m[DEBUG] $timestamp - $message\033[0m"
                ;;
        esac
    fi
}

# Log functions for different levels
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