# Troubleshooting & FAQ ❓

Common issues and solutions when using `action-notifier`.

---

## ❌ Common Errors

### 1. `❌ [DISCORD] Missing required inputs/environment variables: WEBHOOK_URL`
* **Cause**: The `webhook_url` input was empty or the secret name in your workflow doesn't match the secret configured in your repository settings.
* **Fix**:
  1. Go to **Settings → Secrets and variables → Actions** in your GitHub repo.
  2. Verify the secret is named `DISCORD_WEBHOOK_URL`.
  3. Note that GitHub does not pass repository secrets to workflows triggered by `pull_request` from **external forks** for security reasons.

---

### 2. `❌ [TELEGRAM] Missing required inputs/environment variables: BOT_TOKEN CHAT_ID`
* **Cause**: Either `bot_token` or `chat_id` was not provided when `provider: telegram` is active.
* **Fix**:
  * If you intended to use Discord, make sure you specified `provider: discord` in your `with:` block (since `provider` defaults to `telegram`).
  * If you are using Telegram, verify both `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` secrets exist.

---

### 3. `⚠️ [Telegram] Attempt 1/2 failed (HTTP 400)`
* **Cause**:
  * Invalid `chat_id`, or the bot hasn't been added to the group/channel.
  * Unclosed HTML tags in your custom `message` when `parse_mode: HTML` is used.
* **Fix**:
  * Ensure you have started a conversation with the bot or promoted it to Admin in your channel.
  * Check that any `<b>` or `<i>` tags in `message` are properly closed (`</b>`, `</i>`).

---

### 4. `⚠️ [Discord] Attempt 1/2 failed (HTTP 400 / 404)`
* **Cause**:
  * `HTTP 404`: The Discord Webhook was deleted or the URL is incomplete.
  * `HTTP 400`: Ensure you copied the standard Discord Webhook URL (do not append `/slack` or `/github` to the end of the URL).

---

### 5. Commit message shows `Commit <sha>` instead of the full message
* **Cause**: Your workflow job did not run `actions/checkout@v4` before running `action-notifier`.
* **Fix**: Add `- uses: actions/checkout@v4` as an earlier step in the job so the `.git` history is available on the runner.
