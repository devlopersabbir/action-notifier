#!/usr/bin/env bash
set -e
# Backward-compatible wrapper that delegates to the universal router
export PROVIDER="${PROVIDER:-telegram}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/notify.sh"
