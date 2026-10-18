# Issue tracker：GitHub

這個 repo 的 issue 與 spec 都以 GitHub issue 的形式存在。所有操作都使用 `gh` CLI。issue 的標題與內文以繁體中文撰寫；指令、程式碼、標籤字串維持原文。

## 慣例

- **建立 issue**：`gh issue create --title "..." --body "..."`。多行內文用 heredoc。
- **讀取 issue**：`gh issue view <number> --json number,title,body,labels,comments`。
- **列出 issue**：`gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`，搭配適當的 `--label` 與 `--state` 篩選。
- **把 issue 設為某個父 issue 的子 issue**：`gh issue create --parent <parent> ...`，或事後用 `gh issue edit <parent> --add-sub-issue <child>`（`gh` 2.94 以上）。較舊的 `gh`：`gh api --method POST repos/<owner>/<repo>/issues/<parent>/sub_issues -F sub_issue_id=<child-db-id>`（資料庫 id，同下方**阻擋關係**）。不支援子 issue 時，在子 issue 內文最上方寫 `Part of #<parent>`。
- **留言**：`gh issue comment <number> --body "..."`
- **加上／移除標籤**：`gh issue edit <number> --add-label "..."`／`--remove-label "..."`
- **關閉**：`gh issue close <number> --comment "..."`

從 `git remote -v` 推斷 repo；在 clone 內執行時，`gh` 會自動推斷。

## 把 PR 當成 triage 來源

**把 PR 當成請求來源：否。**_（如果這個 repo 把外部 PR 當成功能請求，改成「是」；`/triage` 會讀取這個旗標。）_

設為「是」時，PR 會使用和 issue 相同的標籤與狀態，搭配對應的 `gh pr` 指令：

- **讀取 PR**：`gh pr view <number> --comments`，以及用 `gh pr diff <number>` 看 diff。
- **列出待 triage 的外部 PR**：`gh api --paginate 'repos/{owner}/{repo}/pulls?state=open' --jq '.[] | select(.author_association | IN("OWNER","MEMBER","COLLABORATOR") | not) | {number, title, author: .user.login, author_association, labels: [.labels[].name]}'`。
- **留言／標籤／關閉**：`gh pr comment`、`gh pr edit --add-label`／`--remove-label`、`gh pr close`。

GitHub 的 issue 和 PR 共用同一組編號，所以單獨一個 `#42` 可能是兩者之一：先用 `gh pr view 42` 判斷，失敗再改用 `gh issue view 42`。

## 當 skill 說「發布到 issue tracker」

建立一個 GitHub issue。

## 當 skill 說「取得相關的 ticket」

照上方**讀取 issue** 的方式讀取。

## Wayfinding 操作

供 `/wayfinder` 使用。**地圖**是一個 issue，ticket 是它的**子** issue。

- **地圖**：一個標有 `wayfinder:map` 標籤的 issue，內文包含 Notes／Decisions-so-far／Fog。`gh issue create --label wayfinder:map`。
- **子 ticket**：以 GitHub 子 issue 的方式連到地圖的 issue（見**把 issue 設為某個父 issue 的子 issue**）。沒有啟用子 issue 時，把子 issue 加到地圖內文的任務清單中，並在子 issue 內文最上方寫 `Part of #<map>`。標籤：`wayfinder:<type>`（`research`／`prototype`／`grilling`／`task`）。一旦被認領，ticket 就指派給負責推進的開發者。
- **阻擋關係**：使用 GitHub **原生的 issue 相依性**，這是標準且在 UI 上可見的表示方式。用 `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>` 加上一條邊，其中 `<blocker-db-id>` 是阻擋者的數字**資料庫 id**（`gh api repos/<owner>/<repo>/issues/<n> --jq .id`，**不是** `#number` 或 `node_id`）。GitHub 會回報 `issue_dependencies_summary.blocked_by`（只計算未關閉的阻擋者，也就是即時的關卡）。不支援相依性時，退而在子 issue 內文最上方寫一行 `Blocked by: #<n>, #<n>`。當所有阻擋者都關閉時，ticket 就解除阻擋。
- **前沿查詢**：列出地圖底下未關閉的子 issue（`gh issue list --state open`，範圍限定在地圖的子 issue／任務清單），排除有未關閉阻擋者（`issue_dependencies_summary.blocked_by > 0`，或 `Blocked by` 行中有未關閉的 issue）或已有指派人的；依地圖順序取第一個。
- **認領**：`gh issue edit <n> --add-assignee @me`，這是該 session 的第一個寫入動作。
- **解決**：`gh issue comment <n> --body "<答案>"`，然後 `gh issue close <n>`，再把一個情境指標（摘要＋連結）附加到地圖的 Decisions-so-far。
