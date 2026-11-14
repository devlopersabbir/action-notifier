# Welcome to the Action Notifier Wiki 🔔

**Action Notifier** is a universal, lightweight GitHub Action designed to send rich, context-aware CI/CD notifications to your team's favorite communication channels — including **Discord** and **Telegram**.

---

## 🌟 Key Highlights

* **Multi-Provider Support**: Switch between `discord` and `telegram` with a single `provider` input.
* **Automatic Git & GitHub Metadata**: Every notification automatically includes clickable links to:
  * 📁 **Repository**
  * 🌱 **Branch**
  * 📝 **Commit Message & Short SHA**
  * 👨‍💻 **Commit Author & Workflow Run**
* **Status-Aware Formatting**: Automatically adapts colors and default messages based on `${{ job.status }}` (`failure`, `success`, `cancelled`, `info`).
* **Built-In Retry Engine**: Automatically retries failed HTTP requests to handle temporary network or API hiccups.

---

## 🧭 Quick Navigation

| Guide | Description |
| :--- | :--- |
| 🚀 **[Installation & Setup](Installation-and-Setup)** | How to add `action-notifier` to any GitHub Actions workflow and configure secrets. |
| 💬 **[Discord Configuration](Discord-Configuration)** | Step-by-step guide to creating a Discord Webhook and sending rich embeds. |
| ✈️ **[Telegram Configuration](Telegram-Configuration)** | How to create a Telegram Bot with `@BotFather`, find your `chat_id`, and send alerts. |
| 🛠️ **[Configuration Reference](Configuration-Reference)** | Complete list of inputs, defaults, status codes, and environment variables. |
| ➕ **[Adding New Providers](Adding-New-Providers)** | Developer guide for adding new notification channels (Slack, Teams, Webhook). |
| ❓ **[Troubleshooting & FAQ](Troubleshooting-and-FAQ)** | Common issues and how to fix them quickly. |

---

## ⚡ Quick Example

```yaml
- name: Notify Discord on Failure
  if: failure()
  uses: devlopersabbir/action-notifier@v2
  with:
    provider: discord
    webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
    status: ${{ job.status }}
    message: "🚨 **Production Deployment Failed!**"
```
