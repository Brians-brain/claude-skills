---
name: setup-matt-pocock-skills
description: "為這個儲存庫設定工程類 skill 需要的環境：需求追蹤系統（issue tracker）、分類標籤的用語、領域文件的位置。第一次使用其他工程類 skill 之前執行一次。"
disable-model-invocation: true
---

# 設定工程類 skill

全程使用繁體中文與使用者溝通。

為每個 repo 建立工程類 skill 所預設的設定：

- **Issue tracker**：issue 放在哪裡（預設 GitHub；也內建支援本地 markdown）
- **Triage 標籤**：五種標準 triage 角色所使用的標籤字串
- **領域文件**：`GLOSSARY.md` 與 ADR 放在哪裡，以及讀取它們的規則

這是一個由提示驅動的 skill，不是確定性的腳本。先探索、呈現你的發現、跟使用者確認，然後才寫入。

## 流程

### 1. 探索

查看目前的 repo，了解它的初始狀態。讀取所有存在的東西，不要假設：

- `git remote -v` 與 `.git/config`：這是 GitHub repo 嗎？是哪一個？
- repo 根目錄的 `AGENTS.md` 與 `CLAUDE.md`：哪一個存在？其中是否已經有 `## Agent skills` 段落？
- repo 根目錄的 `GLOSSARY.md` 與 `GLOSSARY-MAP.md`
- `docs/adr/` 以及任何 `src/*/docs/adr/` 目錄
- `docs/agents/`：這個 skill 之前的產出是否已經存在？
- `.scratch/`：代表已經在使用本地 markdown issue tracker 慣例的跡象
- 是否已安裝 `triage` skill？（與本 skill 並列的 `triage` 資料夾，或你可用的 skill 中有 `triage`。）這決定 B 段是否要執行。
- Monorepo 訊號：`pnpm-workspace.yaml`、`package.json` 中的 `workspaces` 欄位、有自己 `src/` 的 `packages/*`，或 Python 的多套件結構（多個各自帶 `pyproject.toml` 的子目錄）。這些只會出現在真正大型的多套件 repo；沒有這些訊號就代表單一 context，幾乎所有 repo 都是如此。

### 2. 呈現發現並詢問

摘要說明有什麼、缺什麼。然後依序處理各段：一段、一個回答，再下一段。

每一段都以建議答案開頭，讓使用者一個字就能接受。只有當選擇真的會分岔時，才附一行說明；如果探索已經確定答案，就整段跳過（沒裝 `triage` 時跳過 B 段，沒有 monorepo 時跳過 C 段）。

**A 段：Issue tracker。**

> 說明：「Issue tracker」是這個 repo 的 issue 所在的地方。`to-tickets`、`triage`、`to-spec` 等 skill 會讀寫它。它們需要知道是要呼叫 `gh issue create`、在 `.scratch/` 底下寫 markdown 檔，還是照你描述的其他流程做。請選擇你實際追蹤這個 repo 工作的地方。

預設態度：這些 skill 是為 GitHub 設計的。如果 `git remote` 指向 GitHub，就建議 GitHub。如果 `git remote` 指向 GitLab（`gitlab.com` 或自架主機），就建議 GitLab。否則（或使用者另有偏好時），提供以下選項：

- **GitHub**：issue 放在 repo 的 GitHub Issues（使用 `gh` CLI）
- **GitLab**：issue 放在 repo 的 GitLab Issues（使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI）
- **本地 markdown**：issue 以檔案形式放在這個 repo 的 `.scratch/<feature>/` 底下（適合個人專案或沒有遠端的 repo）
- **其他**（Jira、Linear 等）：請使用者用一段話描述流程，本 skill 會把它記錄成自由文字

把選擇記錄在 `docs/agents/issue-tracker.md`。GitHub 與 GitLab 範本帶有一個「把 PR 當成請求來源」的旗標，預設為**關閉**。保持關閉，也不要提起它：想把外部 PR 放進 triage 佇列的使用者，之後可以自己在檔案裡打開。

**B 段：Triage 標籤用語。** 如果沒有安裝 `triage` skill（探索時已得知），整段跳過，因為沒安裝的 skill 不需要標籤。

如果有安裝，只問一個問題：

> 要使用預設的 triage 標籤嗎？（建議：**是**）

預設是五個標準角色，每個標籤字串就等於角色名稱：`needs-triage`、`needs-info`、`ready-for-agent`、`ready-for-human`、`wontfix`。回答**是**就照原樣寫入。只有當使用者說否時（通常是因為他的 tracker 已經用了別的名稱，例如用 `bug:triage` 代表 `needs-triage`），才收集要覆寫的名稱，讓 `triage` 套用既有的標籤，而不是建立重複的標籤。

**C 段：領域文件。** 預設為**單一 context**（repo 根目錄一個 `GLOSSARY.md` 加上 `docs/adr/`）。這適用於幾乎所有 repo，直接寫入，不用問。

只有當探索發現 monorepo 訊號時，才提供**多 context** 選項（根目錄一個 `GLOSSARY-MAP.md`，指向各 context 的 `GLOSSARY.md`），並確認使用者要哪一種配置。

### 3. 確認與編輯

給使用者看以下草稿：

- 要加進 `CLAUDE.md` 或 `AGENTS.md`（依步驟 4 的規則選擇）的 `## Agent skills` 區塊
- `docs/agents/issue-tracker.md`、`docs/agents/domain.md`、`docs/agents/triage-labels.md`（最後一個只在有安裝 `triage` 時）的內容

讓使用者在寫入前先編輯。

### 4. 寫入

**選擇要編輯的檔案：**

- 如果 `CLAUDE.md` 存在，編輯它。
- 否則，如果 `AGENTS.md` 存在，編輯它。
- 如果兩者都不存在，問使用者要建立哪一個；不要替他決定。

`CLAUDE.md` 已經存在時，絕不建立 `AGENTS.md`（反之亦然）；永遠編輯已經存在的那一個。

如果選定的檔案中已經有 `## Agent skills` 區塊，就原地更新內容，而不是再附加一份重複的。不要覆蓋使用者對周圍段落的修改。

區塊內容：

```markdown
## Agent skills

### Issue tracker

[一行摘要：issue 在哪裡追蹤]。見 `docs/agents/issue-tracker.md`。

### Triage labels

[一行摘要：標籤用語]。見 `docs/agents/triage-labels.md`。

### Domain docs

[一行摘要：配置為「單一 context」或「多 context」]。見 `docs/agents/domain.md`。
```

只有在有安裝 `triage` 且 B 段有執行時，才加入 `### Triage labels` 子區塊並寫入 `docs/agents/triage-labels.md`。否則兩者都省略。

如果 B 段在 GitHub 或 GitLab 上執行過，為 tracker 中還沒有的每個標籤建立標籤（`gh label create`／`glab label create`）。

然後以本 skill 資料夾中的範本為起點，寫入文件：

- [issue-tracker-github.md](./issue-tracker-github.md)：GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md)：GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md)：本地 markdown issue tracker
- [triage-labels.md](./triage-labels.md)：標籤對照（只在有安裝 `triage` 時）
- [domain.md](./domain.md)：領域文件的讀取規則與配置

如果是「其他」issue tracker，根據使用者的描述從頭撰寫 `docs/agents/issue-tracker.md`。

### 5. 完成

告訴使用者設定已完成，以及哪些工程類 skill 現在會讀取這些檔案。提醒他之後可以直接編輯 `docs/agents/*.md`；只有在要更換 issue tracker 或從頭開始時，才需要重新執行這個 skill。
