#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ACTION_ROOT="${GITHUB_ACTION_PATH:-$ROOT_DIR}"

# Load shared configuration, Git/GitHub context, and helper functions
source "${ACTION_ROOT}/constants/config.sh"
source "${ACTION_ROOT}/constants/info.sh"
source "${ACTION_ROOT}/scripts/utils.sh"

# Fall back to default message if not provided
if [[ -z "${MESSAGE}" ]]; then
  export MESSAGE="${DEFAULT_MESSAGE}"
fi

PROVIDER_LOWER="${PROVIDER,,}"
PROVIDER_SCRIPT="${ACTION_ROOT}/scripts/providers/${PROVIDER_LOWER}.sh"

if [[ ! -f "$PROVIDER_SCRIPT" ]]; then
  echo "❌ Unsupported notification provider: '${PROVIDER}'. Supported providers: telegram, discord"
  exit 1
fi

echo "🔔 Dispatching notification via provider: ${PROVIDER_LOWER}..."
source "$PROVIDER_SCRIPT"
