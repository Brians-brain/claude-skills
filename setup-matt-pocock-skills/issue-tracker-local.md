# Issue tracker：本地 Markdown

這個 repo 的 issue 與 spec 以 markdown 檔的形式放在 `.scratch/`。內容以繁體中文撰寫。

## 慣例

- 一個功能一個目錄：`.scratch/<feature-slug>/`
- spec 是 `.scratch/<feature-slug>/spec.md`
- 實作 issue 是一個 ticket 一個檔案，放在 `.scratch/<feature-slug>/issues/<NN>-<slug>.md`，從 `01` 開始編號，絕不合併成單一 tickets 檔
- Triage 狀態記錄在每個 issue 檔案靠近頂端的一行 `Status:`（角色字串見 `triage-labels.md`）
- 留言與對話歷史附加在檔案底部的 `## Comments` 標題下

## 當 skill 說「發布到 issue tracker」

在 `.scratch/<feature-slug>/` 底下建立一個新檔案（目錄不存在就建立）。

## 當 skill 說「取得相關的 ticket」

讀取所指路徑的檔案。使用者通常會直接給路徑或 issue 編號。

## Wayfinding 操作

供 `/wayfinder` 使用。**地圖**是一個檔案，每個 ticket 是一個**子**檔案。

- **地圖**：`.scratch/<effort>/map.md`（內文包含 Notes／Decisions-so-far／Fog）。
- **子 ticket**：`.scratch/<effort>/issues/NN-<slug>.md`，從 `01` 開始編號，內文寫問題。用一行 `Type:` 記錄 ticket 類型（`research`／`prototype`／`grilling`／`task`）；用一行 `Status:` 記錄 `claimed`／`resolved`。
- **阻擋關係**：靠近頂端的一行 `Blocked by: NN, NN`。當它列出的每個檔案都是 `resolved` 時，ticket 就解除阻擋。
- **前沿**：掃描 `.scratch/<effort>/issues/`，找出未關閉、未被阻擋、未被認領的檔案；依編號取第一個。
- **認領**：在做任何工作之前，設定 `Status: claimed` 並存檔。
- **解決**：把答案附加在 `## Answer` 標題下，設定 `Status: resolved`，再把一個情境指標（摘要＋連結）附加到 `map.md` 的 Decisions-so-far。
