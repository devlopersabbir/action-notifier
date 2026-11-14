#!/usr/bin/env bash
set -e

validate_required_vars WEBHOOK_URL

# Strip simple HTML tags (e.g., <b>, <i>) or convert them to Markdown in case user passed HTML-formatted message
CLEAN_MESSAGE=$(echo "$MESSAGE" | sed -e 's/<b>/**/g' -e 's/<\/b>/**/g' -e 's/<i>/*/g' -e 's/<\/i>/*/g')

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Build JSON payload safely using jq (pre-installed on GitHub runners)
PAYLOAD=$(jq -n \
  --arg username "$DISCORD_USERNAME" \
  --arg avatar_url "$DISCORD_AVATAR_URL" \
  --arg description "$CLEAN_MESSAGE" \
  --argjson color "$DISCORD_COLOR" \
  --arg repo_name "$REPO_NAME" \
  --arg repo_url "$REPO_URL" \
  --arg branch_name "$BRANCH_NAME" \
  --arg branch_url "$BRANCH_URL" \
  --arg commit_msg "$COMMIT_MESSAGE" \
  --arg short_sha "$SHORT_SHA" \
  --arg commit_url "$COMMIT_URL" \
  --arg author "$COMMIT_AUTHOR" \
  --arg author_url "$AUTHOR_URL" \
  --arg run_url "$RUN_URL" \
  --arg timestamp "$TIMESTAMP" \
  '{
    username: $username,
    avatar_url: $avatar_url,
    embeds: [
      {
        title: ("GitHub Actions — " + $repo_name),
        url: $run_url,
        description: $description,
        color: $color,
        fields: [
          {
            name: "📁 Repository",
            value: ("[" + $repo_name + "](" + $repo_url + ")"),
            inline: true
          },
          {
            name: "🌱 Branch",
            value: ("[" + $branch_name + "](" + $branch_url + ")"),
            inline: true
          },
          {
            name: "👨‍💻 Author",
            value: ("[" + $author + "](" + $author_url + ")"),
            inline: true
          },
          {
            name: "📝 Commit",
            value: ("[" + $commit_msg + " (`" + $short_sha + "`)](" + $commit_url + ")"),
            inline: false
          }
        ],
        footer: {
          text: "Action Notifier"
        },
        timestamp: $timestamp
      }
    ]
  }')

send_discord_request() {
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD"
}

send_with_retry "Discord" send_discord_request
