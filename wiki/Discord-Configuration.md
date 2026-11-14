# Discord Configuration 💬

This guide walks you through setting up rich Discord Embed notifications for your GitHub Actions workflows.

---

## 1. Create a Discord Webhook

1. Open **Discord** and go to the server where you want to receive notifications.
2. Click the **⚙️ Edit Channel** icon next to your target text channel (e.g., `#deployments` or `#ci-alerts`).
3. Select **Integrations** from the left sidebar.
4. Click **Webhooks** → **New Webhook**.
5. Customize the webhook name (e.g., `Action Notifier`) and select the channel.
6. Click **Copy Webhook URL**.
   * *Format looks like:* `https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz...`

---

## 2. Add Secret to GitHub

1. Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**.
2. Click **New repository secret**.
3. Set **Name** to `DISCORD_WEBHOOK_URL`.
4. Paste the copied Discord Webhook URL into **Secret** and click **Add secret**.

---

## 3. Workflow Examples

### Example A: Notify Only on Job Failure

```yaml
      - name: Notify Discord on Failure
        if: failure()
        uses: devlopersabbir/action-notifier@v1.2.0
        with:
          provider: discord
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          status: failure
          message: |
            🚨 **Production Deployment Failed!**
            Please inspect the workflow logs immediately.
```

### Example B: Notify on Both Success and Failure (Dynamic Color)

By passing `status: ${{ job.status }}` and `if: always()`, the Discord embed automatically turns **Green** on success, **Red** on failure, and **Orange** when cancelled:

```yaml
      - name: Notify Discord Pipeline Status
        if: always()
        uses: devlopersabbir/action-notifier@v1.2.0
        with:
          provider: discord
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          status: ${{ job.status }}
```

### Example C: Custom Bot Username, Avatar & Retry Options

```yaml
      - name: Notify Discord with Custom Bot Profile
        if: always()
        uses: devlopersabbir/action-notifier@v1.2.0
        with:
          provider: discord
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          status: ${{ job.status }}
          username: "Release Bot 🚀"
          avatar_url: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
          message: "📦 **Release v2.1.0** pipeline finished with status: `${{ job.status }}`"
          retry_count: 3
          retry_delay: 5
```

---

## 🎨 Discord Embed Status Colors

| `status` Input | Embed Sidebar Color | Hex Code | Default Message (if `message` is omitted) |
| :--- | :--- | :--- | :--- |
| `failure` *(default)* | 🔴 Red | `#E74C3C` | `🚨 Deployment / Job Failed` |
| `success` | 🟢 Green | `#2ECC71` | `✅ Job Succeeded` |
| `cancelled` | 🟠 Orange | `#E67E22` | `⚠️ Job Cancelled` |
| `info` | 🔵 Blue | `#3498DB` | `ℹ️ Workflow Notification` |

---

## 📋 What the Discord Embed Includes

Every Discord notification automatically renders an embed with:
* **Title**: `GitHub Actions — <owner>/<repo>` (clickable link to the exact workflow run)
* **Description**: Your custom `message` (supports Discord Markdown like `**bold**`, `*italic*`, `` `code` ``, and `[links](https://...)`)
* **Inline Fields**:
  * 📁 **Repository** (clickable link)
  * 🌱 **Branch** (clickable link)
  * 👨‍💻 **Author** (clickable link)
  * 📝 **Commit** (commit message + short SHA with clickable link)
* **Footer & UTC Timestamp**
