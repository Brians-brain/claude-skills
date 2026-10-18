---
name: handoff
description: 把目前對話壓縮成一份交接文件，讓另一個 agent 或新的 session 能接手。
argument-hint: "下一個 session 要用來做什麼？"
disable-model-invocation: true
---

撰寫一份交接文件，以繁體中文摘要目前對話，讓一個全新的 agent 能接著做。存到作業系統的暫存目錄（`$TMPDIR`，沒有就用 `/tmp`；Windows 用 `%TEMP%`），不要存在目前的工作目錄，然後告訴使用者完整路徑。

文件中要包含一個「建議使用的 skill」段落，列出下一個 agent 應該用 Skill tool 呼叫哪些 skill。

不要重複已經記錄在其他產出物裡的內容（spec、計畫、ADR、issue、commit、diff），改用路徑或 URL 引用。

遮蔽所有敏感資訊，例如 API key、密碼、個人可識別資訊。

如果使用者有傳入參數，把它當成下一個 session 要專注的事情，並據此調整文件內容。
