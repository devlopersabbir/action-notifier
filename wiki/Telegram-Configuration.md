# Telegram Configuration ✈️

This guide walks you through creating a Telegram Bot, finding your `chat_id`, and sending formatted notifications from GitHub Actions.

---

## 1. Create a Telegram Bot

1. Open Telegram and search for **[@BotFather](https://t.me/BotFather)**.
2. Start a chat and send the command:
   ```text
   /newbot
   ```
3. Follow the prompts to give your bot a **Display Name** (e.g., `My CI Notifier`) and a **Username** ending in `bot` (e.g., `my_org_ci_bot`).
4. `@BotFather` will reply with your **HTTP API Token**:
   * *Example:* `1234567890:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw`
5. Copy this token — this is your `TELEGRAM_BOT_TOKEN`.

---

## 2. Get Your Telegram Chat ID

You can send notifications to a **Personal Chat**, a **Group**, or a **Channel**:

### Option A: Personal Chat or Group Chat
1. Start a conversation with your new bot (click **Start**) or add the bot to your Telegram Group.
2. Send a test message in the chat (e.g., `Hello` or `/start @your_bot_username`).
3. Open the following URL in your browser (replace `<YOUR_BOT_TOKEN>` with your actual token):
   ```text
   https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
   ```
4. Look for the `"chat":{"id": ...}` field in the JSON response:
   * Personal chat IDs are positive numbers (e.g., `123456789`).
   * Group/Supergroup chat IDs are negative numbers (e.g., `-1001234567890`).

### Option B: Telegram Channel
1. Add your bot to the Telegram Channel as an **Administrator** (with **Post Messages** permission).
2. If your channel is public, you can use `@channel_username` or forward a message from the channel to [@userinfobot](https://t.me/userinfobot) / inspect `getUpdates` to get the `-100...` numeric ID.

---

## 3. Add Secrets to GitHub

1. Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**.
2. Create two secrets:
   * `TELEGRAM_BOT_TOKEN`: Your bot token from `@BotFather`
   * `TELEGRAM_CHAT_ID`: Your numeric chat ID (including the `-` sign if it's a group/channel)

---

## 4. Workflow Examples

### Example A: HTML Formatting (Default)

```yaml
      - name: Notify Telegram on Failure
        if: failure()
        uses: devlopersabbir/action-notifier@v2
        with:
          provider: telegram
          bot_token: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          chat_id: ${{ secrets.TELEGRAM_CHAT_ID }}
          status: ${{ job.status }}
          parse_mode: HTML
          message: |
            <b>🚨 Deployment Failed!</b>
            <i>Please check the workflow logs immediately.</i>
          retry_count: 3
          retry_delay: 5
```

### Example B: Markdown Formatting

```yaml
      - name: Notify Telegram with Markdown
        if: always()
        uses: devlopersabbir/action-notifier@v2
        with:
          provider: telegram
          bot_token: ${{ secrets.TELEGRAM_BOT_TOKEN }}
          chat_id: ${{ secrets.TELEGRAM_CHAT_ID }}
          status: ${{ job.status }}
          parse_mode: Markdown
          message: |
            *🔔 Workflow Completed*
            Status: `${{ job.status }}`
```

---

## 📨 Example Telegram Output

```text
🚨 Deployment Failed!
Please check the workflow logs immediately.

👨‍💻 Author: sabbir
🌱 Branch: main
📝 Commit: feat: add discord provider (a1b2c3d)
📁 Repository: devlopersabbir/action-notifier
```
*(In Telegram, Author, Branch, Commit, and Repository are clickable links!)*
