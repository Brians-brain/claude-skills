# Issue tracker：GitLab

這個 repo 的 issue 與 spec 都以 GitLab issue 的形式存在。所有操作都使用 [`glab`](https://gitlab.com/gitlab-org/cli) CLI。issue 的標題與內文以繁體中文撰寫；指令、程式碼、標籤字串維持原文。

## 慣例

- **建立 issue**：`glab issue create --title "..." --description "..."`。多行內文用 heredoc；傳 `--description -` 會開啟編輯器。
- **讀取 issue**：`glab issue view <number> --comments`。需要機器可讀的輸出時加 `-F json`。
- **列出 issue**：`glab issue list -O json`，搭配適當的 `--label` 篩選。
- **留言**：`glab issue note <number> --message "..."`。GitLab 把留言叫做「note」。
- **加上／移除標籤**：`glab issue update <number> --label "..."`／`--unlabel "..."`。多個標籤可以用逗號分隔，或重複這個參數。
- **關閉**：`glab issue close <number>`。`glab issue close` 不接受關閉時的留言，所以先用 `glab issue note <number> --message "..."` 寫下說明，再關閉。
- **合併請求**：GitLab 把 PR 叫做「merge request」（MR）。用 `glab mr create`、`glab mr view`、`glab mr note` 等，用法和 `gh pr ...` 相同，只是 `pr` 換成 `mr`、`comment`／`--body` 換成 `note`／`--message`。

從 `git remote -v` 推斷 repo；在 clone 內執行時，`glab` 會自動推斷。

## 把 MR 當成 triage 來源

**把 MR 當成請求來源：否。**_（如果這個 repo 把外部 merge request 當成功能請求，改成「是」；`/triage` 會讀取這個旗標。）_

設為「是」時，MR 會使用和 issue 相同的標籤與狀態，搭配對應的 `glab mr` 指令：

- **讀取 MR**：`glab mr view <number> --comments`，以及用 `glab mr diff <number>` 看 diff。
- **列出待 triage 的外部 MR**：`glab mr list -F json`，只留下作者不是專案成員／擁有者的 MR（外部貢獻者的 MR，而不是維護者進行中的工作）。
- **留言／標籤／關閉**：`glab mr note`、`glab mr update --label`／`--unlabel`、`glab mr close`。

和 GitHub 不同，GitLab 的 issue 和 MR 各自編號，所以只要知道維護者指的是哪一種，`#42` 就不會有歧義。

## 當 skill 說「發布到 issue tracker」

建立一個 GitLab issue。

## 當 skill 說「取得相關的 ticket」

執行 `glab issue view <number> --comments`。

## Wayfinding 操作

供 `/wayfinder` 使用。**地圖**是一個 issue，ticket 是它的**子** issue。

- **地圖**：一個標有 `wayfinder:map` 標籤的 issue，內文包含 Notes／Decisions-so-far／Fog。`glab issue create --label wayfinder:map`。（在有原生 epic 的 GitLab 方案上，也可以用 epic 當地圖；加標籤的 issue 則在所有方案都能用。）
- **子 ticket**：內文最上方寫 `Part of #<map>`，標籤為 `wayfinder:<type>`（`research`／`prototype`／`grilling`／`task`）的 issue。一旦被認領，ticket 就指派給負責推進的開發者。
- **阻擋關係**：使用 GitLab **原生的阻擋連結**，這是標準且在 UI 上可見的表示方式。用 `/blocked_by #<n>` 快速動作，以留言的方式加上（`glab issue note <child> --message "/blocked_by #<blocker>"`）。原生阻擋連結是 Premium／Ultimate 方案的功能；免費方案（或無法使用時）退而在內文最上方寫一行 `Blocked by: #<n>, #<n>`。當所有阻擋者都關閉時，ticket 就解除阻擋。
- **前沿查詢**：`glab issue list -O json`，範圍限定在地圖的子 issue，排除有未關閉阻擋者的（原生 `blocked_by` 連結指向未關閉的 issue，可用 `glab api projects/:id/issues/<child-iid>/links` 查；或 `Blocked by` 行中有未關閉的 issue），以及已有指派人的；依地圖順序取第一個。
- **認領**：`glab issue update <n> --assignee @me`，這是該 session 的第一個寫入動作。
- **解決**：`glab issue note <n> --message "<答案>"`，然後 `glab issue close <n>`，再把一個情境指標（摘要＋連結）附加到地圖的 Decisions-so-far。
