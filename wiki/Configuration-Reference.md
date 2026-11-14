# Configuration Reference 🛠️

Complete reference of all inputs and environment variables supported by `action-notifier`.

---

## 🌐 Universal Inputs

These inputs apply to all notification providers:

| Input | Description | Default | Required |
| :--- | :--- | :--- | :---: |
| `provider` | Notification channel to use (`telegram`, `discord`). Case-insensitive. | `telegram` | ❌ |
| `status` | Job or workflow status (`failure`, `success`, `cancelled`, `info`). Controls default message and Discord embed color. | `${{ job.status }}` | ❌ |
| `message` | Custom message body. If omitted, a status-specific default message is used. | Status-based | ❌ |
| `retry_count` | Number of HTTP delivery attempts before failing the action. | `2` | ❌ |
| `retry_delay` | Wait time (in seconds) between failed retry attempts. | `5` | ❌ |

---

## 💬 Discord Inputs (`provider: discord`)

| Input | Description | Default | Required |
| :--- | :--- | :--- | :---: |
| `webhook_url` | Discord channel Webhook URL. | — | ✅ |
| `username` | Custom display name for the Discord webhook bot. | `Action Notifier` | ❌ |
| `avatar_url` | Custom avatar image URL for the Discord webhook bot. | GitHub Mark Logo | ❌ |

---

## ✈️ Telegram Inputs (`provider: telegram`)

| Input | Description | Default | Required |
| :--- | :--- | :--- | :---: |
| `bot_token` | Telegram Bot Token obtained from `@BotFather`. | — | ✅ |
| `chat_id` | Target Telegram user, group, or channel ID. | — | ✅ |
| `parse_mode` | Message formatting mode: `HTML` or `Markdown`. | `HTML` | ❌ |

---

## 🔍 Auto-Extracted GitHub Context Variables

Internally, `constants/info.sh` extracts the following metadata automatically and makes them available to all provider scripts:

| Variable | Description |
| :--- | :--- |
| `REPO_NAME` | Full repository name (`owner/repo`) |
| `REPO_URL` | URL to the GitHub repository |
| `BRANCH_NAME` | Current branch or tag name (`GITHUB_REF_NAME`) |
| `BRANCH_URL` | URL to the branch tree on GitHub |
| `COMMIT_HASH` | Full 40-character commit SHA |
| `SHORT_SHA` | 7-character short commit SHA |
| `COMMIT_MESSAGE` | Commit subject line |
| `COMMIT_URL` | URL to the commit diff on GitHub |
| `COMMIT_AUTHOR` | Git commit author name (falls back to `GITHUB_ACTOR`) |
| `AUTHOR_URL` | URL to the author's commits in the repository |
| `RUN_URL` | Direct URL to the current GitHub Actions workflow run |
