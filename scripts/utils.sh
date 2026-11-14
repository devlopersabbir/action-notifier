#!/usr/bin/env bash

# Validate required environment variables for a given provider
validate_required_vars() {
  local missing_vars=()
  for var in "$@"; do
    if [[ -z "${!var}" ]]; then
      missing_vars+=("$var")
    fi
  done

  if [[ ${#missing_vars[@]} -ne 0 ]]; then
    echo "❌ [${PROVIDER^^}] Missing required inputs/environment variables: ${missing_vars[*]}"
    exit 1
  fi
}

# Execute a command (typically curl) with retry logic
# Expects a function or command that prints the HTTP status code to stdout
send_with_retry() {
  local provider_name="$1"
  shift
  local success=false

  for i in $(seq 1 "$RETRY_COUNT"); do
    HTTP_STATUS=$("$@") || true

    if [[ "$HTTP_STATUS" =~ ^2[0-9]{2}$ ]]; then
      echo "✅ [${provider_name}] Notification sent successfully (HTTP ${HTTP_STATUS})"
      success=true
      break
    else
      echo "⚠️ [${provider_name}] Attempt ${i}/${RETRY_COUNT} failed (HTTP ${HTTP_STATUS:-error}). Retrying in ${RETRY_DELAY} seconds..."
      if [[ "$i" -lt "$RETRY_COUNT" ]]; then
        sleep "$RETRY_DELAY"
      fi
    fi
  done

  if [[ "$success" != "true" ]]; then
    echo "❌ [${provider_name}] Failed to send notification after ${RETRY_COUNT} attempts."
    exit 1
  fi
}
