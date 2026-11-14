# Installation & Setup 🚀

`action-notifier` is a **Composite GitHub Action**, meaning there is nothing to install on your servers or local machine. You simply reference it inside your repository's `.github/workflows/*.yml` file.

---

## 1. Prerequisites

1. A GitHub repository with **GitHub Actions** enabled.
2. `actions/checkout@v4` step in your workflow job (recommended so `action-notifier` can read the full commit message and author name from Git history; otherwise it falls back to GitHub environment variables).
3. Credentials for your chosen provider:
   * **Discord**: A Discord Webhook URL ([See Discord Guide](Discord-Configuration))
   * **Telegram**: A Bot Token and Chat ID ([See Telegram Guide](Telegram-Configuration))

---

## 2. Configure GitHub Secrets

Never hardcode tokens or webhook URLs directly in your workflow YAML files. Store them securely in **GitHub Actions Secrets**:

1. Open your repository on GitHub.
2. Navigate to **Settings** → **Secrets and variables** → **Actions**.
3. Click **New repository secret**.
4. Add the required secrets for your provider:

| Provider | Secret Name (Recommended) | Value |
| :--- | :--- | :--- |
| **Discord** | `DISCORD_WEBHOOK_URL` | Your Discord channel webhook URL |
| **Telegram** | `TELEGRAM_BOT_TOKEN` | Token from `@BotFather` |
| **Telegram** | `TELEGRAM_CHAT_ID` | User, group, or channel Chat ID |

---

## 3. Add to Your Workflow

Add `devlopersabbir/action-notifier` as the **last step** of your job in `.github/workflows/ci.yml` (or `deploy.yml`):

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run build & tests
        run: |
          echo "Running tests..."
          npm test

      - name: Send Notification
        if: failure() # Or use always() to notify on both success and failure
        uses: devlopersabbir/action-notifier@v1.1.0
        with:
          provider: discord
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          status: ${{ job.status }}
          message: "🚨 **Build & Deploy Failed!** Please check the workflow logs."
```

---

## 4. Choosing When to Trigger Notifications (`if:` Conditions)

GitHub Actions gives you full control over when the notification step runs:

| Condition | When it triggers | Best Use Case |
| :--- | :--- | :--- |
| `if: failure()` | Only when a previous step in the job fails | Alerting on broken builds or failed deployments |
| `if: success()` | Only when all previous steps succeed | Announcing successful production releases |
| `if: always()` | Runs regardless of success, failure, or cancellation | Full pipeline status reporting (pair with `status: ${{ job.status }}`) |
| `if: cancelled()` | Only when the workflow is manually or automatically cancelled | Monitoring aborted runs |

---

## Next Steps

* 👉 **[Configure Discord Notifications](Discord-Configuration)**
* 👉 **[Configure Telegram Notifications](Telegram-Configuration)**
