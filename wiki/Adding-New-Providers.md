# Adding New Providers ➕

`action-notifier` is architected so that adding a new notification channel (e.g., **Slack**, **Microsoft Teams**, **Mattermost**, or a **Custom Webhook**) requires minimal code and zero duplication of retry or Git-extraction logic.

---

## 🏗️ How Dispatching Works

1. `action.yaml` passes inputs as environment variables to `scripts/notify.sh`.
2. `scripts/notify.sh` loads:
   * `constants/config.sh` (defaults)
   * `constants/info.sh` (Git/GitHub context variables & status colors)
   * `scripts/utils.sh` (`validate_required_vars` and `send_with_retry`)
3. `scripts/notify.sh` converts `PROVIDER` to lowercase and automatically sources `scripts/providers/<provider>.sh`.

---

## 🛠️ Step-by-Step: Adding a New Provider (Example: `slack`)

### Step 1: Create `scripts/providers/slack.sh`

Create a new script in `scripts/providers/` that validates its required variables and defines a request function passed to `send_with_retry`:

```bash
#!/usr/bin/env bash
set -e

# 1. Validate required environment variables
validate_required_vars WEBHOOK_URL

# 2. Build payload using jq
PAYLOAD=$(jq -n \
  --arg text "${MESSAGE}\n\n${GITHUB_INFO_MARKDOWN}" \
  '{ text: $text }')

# 3. Define HTTP request function returning HTTP status code
send_slack_request() {
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST "$WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD"
}

# 4. Execute with built-in retry engine
send_with_retry "Slack" send_slack_request
```

### Step 2: Expose Any New Inputs in `action.yaml`

If your provider reuses `webhook_url`, no new inputs are needed! Otherwise, add provider-specific inputs to `action.yaml` and pass them in the `env:` block.

### Step 3: Document in the Wiki & `README.md`

Add usage examples and setup steps for the new provider.
