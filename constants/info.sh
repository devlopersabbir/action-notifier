#!/usr/bin/env bash
set -e

# Extract Git information with safe fallbacks to GitHub Actions environment variables
export BRANCH_NAME="${GITHUB_REF_NAME:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')}"
export COMMIT_HASH="${GITHUB_SHA:-$(git rev-parse HEAD 2>/dev/null || echo 'unknown')}"
export SHORT_SHA="${COMMIT_HASH:0:7}"

if git rev-parse --git-dir >/dev/null 2>&1; then
  export COMMIT_MESSAGE="$(git log -1 --pretty=%s 2>/dev/null || echo 'No commit message')"
  export COMMIT_BODY="$(git log -1 --pretty=%b 2>/dev/null || echo '')"
  export COMMIT_AUTHOR="$(git log -1 --pretty=%an 2>/dev/null || echo "${GITHUB_ACTOR:-unknown}")"
  export COMMIT_EMAIL="$(git log -1 --pretty=%ae 2>/dev/null || echo '')"
  export COMMIT_DATE="$(git log -1 --pretty=%ad 2>/dev/null || echo '')"
else
  export COMMIT_MESSAGE="Commit ${SHORT_SHA}"
  export COMMIT_BODY=""
  export COMMIT_AUTHOR="${GITHUB_ACTOR:-unknown}"
  export COMMIT_EMAIL=""
  export COMMIT_DATE=""
fi

# GitHub URLs
export SERVER_URL="${GITHUB_SERVER_URL:-https://github.com}"
export REPO_NAME="${GITHUB_REPOSITORY:-unknown/unknown}"
export REPO_URL="${SERVER_URL}/${REPO_NAME}"
export BRANCH_URL="${REPO_URL}/tree/${BRANCH_NAME}"
export COMMIT_URL="${REPO_URL}/commit/${COMMIT_HASH}"
export AUTHOR_URL="${REPO_URL}/commits?author=${COMMIT_AUTHOR}"
export RUN_URL="${REPO_URL}/actions/runs/${GITHUB_RUN_ID:-}"

# Status-based defaults
case "${STATUS,,}" in
  success)
    export DEFAULT_MESSAGE="✅ Job Succeeded"
    export DISCORD_COLOR=3066993   # Green (#2ECC71)
    ;;
  cancelled|canceled)
    export DEFAULT_MESSAGE="⚠️ Job Cancelled"
    export DISCORD_COLOR=15105570  # Orange (#E67E22)
    ;;
  info)
    export DEFAULT_MESSAGE="ℹ️ Workflow Notification"
    export DISCORD_COLOR=3447003   # Blue (#3498DB)
    ;;
  *)
    export DEFAULT_MESSAGE="🚨 Deployment / Job Failed"
    export DISCORD_COLOR=15158332  # Red (#E74C3C)
    ;;
esac

# Pre-formatted GitHub context for HTML (Telegram HTML mode)
export GITHUB_INFO_HTML=$(cat <<EOF
👨‍💻 <b>Author:</b> <a href="${AUTHOR_URL}">${COMMIT_AUTHOR}</a>
🌱 <b>Branch:</b> <a href="${BRANCH_URL}">${BRANCH_NAME}</a>
📝 <b>Commit:</b> <a href="${COMMIT_URL}">${COMMIT_MESSAGE} (${SHORT_SHA})</a>
📁 <b>Repository:</b> <a href="${REPO_URL}">${REPO_NAME}</a>
EOF
)

# Pre-formatted GitHub context for Markdown (Telegram Markdown / Discord fallback)
export GITHUB_INFO_MARKDOWN=$(cat <<EOF
👨‍💻 **Author:** [${COMMIT_AUTHOR}](${AUTHOR_URL})
🌱 **Branch:** [${BRANCH_NAME}](${BRANCH_URL})
📝 **Commit:** [${COMMIT_MESSAGE} (${SHORT_SHA})](${COMMIT_URL})
📁 **Repository:** [${REPO_NAME}](${REPO_URL})
EOF
)
