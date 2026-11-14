#!/usr/bin/env bash

# General retry defaults (can be overridden by action inputs)
export RETRY_COUNT="${RETRY_COUNT:-2}"
export RETRY_DELAY="${RETRY_DELAY:-5}"

# Provider default
export PROVIDER="${PROVIDER:-telegram}"
export STATUS="${STATUS:-failure}"

# Telegram defaults
export TELEGRAM_API="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
export PARSE_MODE="${PARSE_MODE:-HTML}"

# Discord defaults
export DISCORD_USERNAME="${DISCORD_USERNAME:-Action Notifier}"
export DISCORD_AVATAR_URL="${DISCORD_AVATAR_URL:-https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png}"
