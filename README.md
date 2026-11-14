# Action Notifier 🔔

**Universal GitHub Actions notification dispatcher for Telegram, Discord, and more.**

Send instant, context-rich notifications from your CI/CD workflows to your favorite communication channels when deployments succeed, fail, or require attention.

---

## ⚡ Features

- **Multi-Provider Support**: Built-in support for **Telegram** and **Discord** (easily extensible for Slack, Teams, and custom Webhooks).
- **Automatic GitHub Context**: Automatically attaches clickable links for:
  - 📁 Repository
  - 🌱 Branch
  - 📝 Commit message & short SHA
  - 👨‍💻 Commit Author & Workflow Run
- **Status-Aware Styling**: Automatically adjusts default messages and Discord embed colors based on job status (`failure`, `success`, `cancelled`, `info`).
- **Built-in Resiliency**: Configurable **retry count** and **retry delay** for network reliability.
- **Backward Compatible**: Defaults to `provider: telegram`, so existing Telegram workflows continue working seamlessly.

---

## 📚 Documentation & Setup Guides (Wiki)

- 🏠 **[Wiki Home](wiki/Home.md)**
- 🚀 **[Installation & Setup](wiki/Installation-and-Setup.md)**
- 💬 **[Discord Configuration Guide](wiki/Discord-Configuration.md)** (Webhook creation, status colors, examples)
- ✈️ **[Telegram Configuration Guide](wiki/Telegram-Configuration.md)** (`@BotFather`, finding `chat_id`, HTML/Markdown examples)
- 🛠️ **[Configuration Reference](wiki/Configuration-Reference.md)**
- ➕ **[Adding New Providers](wiki/Adding-New-Providers.md)**
- ❓ **[Troubleshooting & FAQ](wiki/Troubleshooting-and-FAQ.md)**

---

## 🛠️ Inputs

### Universal Inputs

| Name          | Description                                            | Default              | Required |
| :------------ | :----------------------------------------------------- | :------------------- | :------: |
| `provider`    | Notification channel: `telegram` or `discord`          | `telegram`           |    ❌    |
| `status`      | Job status (`failure`, `success`, `cancelled`, `info`) | `${{ job.status }}`  |    ❌    |
| `message`     | Custom notification message body                       | Status-based default |    ❌    |
| `retry_count` | Number of retry attempts if delivery fails             | `2`                  |    ❌    |
| `retry_delay` | Delay between retries (in seconds)                     | `5`                  |    ❌    |

### Telegram Inputs (`provider: telegram`)

| Name         | Description                                | Default |     Required      |
| :----------- | :----------------------------------------- | :------ | :---------------: |
| `bot_token`  | Telegram Bot Token                         | —       | ✅ (for Telegram) |
| `chat_id`    | Telegram Chat ID (user, group, or channel) | —       | ✅ (for Telegram) |
| `parse_mode` | Message parse mode: `HTML` or `Markdown`   | `HTML`  |        ❌         |

### Discord Inputs (`provider: discord`)

| Name          | Description                           | Default           |     Required     |
| :------------ | :------------------------------------ | :---------------- | :--------------: |
| `webhook_url` | Discord channel Webhook URL           | —                 | ✅ (for Discord) |
| `username`    | Override Discord webhook display name | `Action Notifier` |        ❌        |
| `avatar_url`  | Override Discord webhook avatar URL   | GitHub Mark Icon  |        ❌        |

---

## 🔧 Usage Examples

### 1. Discord Notification (Rich Embed)

```yaml
- name: Notify Discord on Failure
  if: failure()
  uses: devlopersabbir/action-notifier@v1.2.0
  with:
    provider: discord
    webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
    status: ${{ job.status }}
    message: |
      **🚨 Production Deployment Failed!**
      Please inspect the workflow logs immediately.
```

### 2. Telegram Notification

```yaml
- name: Notify Telegram on Failure
  if: failure()
  uses: devlopersabbir/action-notifier@v1.2.0
  with:
    provider: telegram
    bot_token: ${{ secrets.TELEGRAM_BOT_TOKEN }}
    chat_id: ${{ secrets.TELEGRAM_CHAT_ID }}
    status: ${{ job.status }}
    message: |
      <b>🚨 Deployment Failed!</b>
      Please check logs immediately.
    retry_count: 3
    retry_delay: 3
    parse_mode: HTML
```

---

## ➕ Adding a New Provider

Because of the modular architecture, adding a new provider (e.g., `slack`) takes only two steps:

1. Create `scripts/providers/slack.sh` and use `validate_required_vars` and `send_with_retry` from `scripts/utils.sh`.
2. Add any provider-specific inputs to `action.yaml` if needed (`notify.sh` automatically routes `provider: slack` to `scripts/providers/slack.sh`).

---

## 🔐 Security Best Practices

- Never hardcode tokens or webhook URLs in your workflow files.
- Always store credentials in **GitHub Actions Secrets** (`Settings → Secrets and variables → Actions`):
  - `DISCORD_WEBHOOK_URL`
  - `TELEGRAM_BOT_TOKEN`
  - `TELEGRAM_CHAT_ID`

---

## 🏷️ Author

**Sabbir Hossain Shuvo**
