#!/usr/bin/env bash
set -e

validate_required_vars BOT_TOKEN CHAT_ID

# Choose context format based on parse_mode
if [[ "${PARSE_MODE^^}" == "HTML" ]]; then
  CONTEXT_BLOCK="$GITHUB_INFO_HTML"
else
  CONTEXT_BLOCK="$GITHUB_INFO_MARKDOWN"
fi

FULL_MESSAGE="${MESSAGE}

${CONTEXT_BLOCK}"

send_telegram_request() {
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$TELEGRAM_API" \
    --data-urlencode "chat_id=${CHAT_ID}" \
    --data-urlencode "text=${FULL_MESSAGE}" \
    --data-urlencode "parse_mode=${PARSE_MODE}"
}

send_with_retry "Telegram" send_telegram_request
