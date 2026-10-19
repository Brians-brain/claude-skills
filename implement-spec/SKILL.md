---
name: implement-spec
description: "把 /to-spec 寫好的規格書與 /to-tickets 切好的工作單實作成程式碼，由多個子代理平行進行。"
disable-model-invocation: true
---

與使用者溝通使用繁體中文。

你已經拿到一份 spec。這份 spec 應該有相關的 ticket，描述如何實作它。

Issue tracker 應該已經提供給你了。如果沒有，告訴使用者先執行 `/setup-matt-pocock-skills`。

目標是把整份 spec 實作在單一條**整合分支**上，並且每張 ticket 都依照 issue tracker 結案的方式解決。

這些 ticket 不是一份步驟清單。它們是一張帶有阻擋關係的**任務圖**。這代表永遠有一個隨時可以被接手的 ticket **前沿**。

與子 agent 之間的溝通要精簡。主要透過**情境指標**溝通：指向 spec、ticket、研究筆記和先前的 commit。不要重複透過指標就能取得的資訊。

**實作子 agent** 盡可能在背景執行，以達到最大的平行度。

## 步驟

1. 閱讀 spec 與 ticket，理解任務圖。

2. （選用）用一個**探索子 agent** 進行 ticket 需要的任何探索：相關的程式碼檔案或外部文件。確保探索子 agent 可以存檔：它應該把 markdown 筆記存在 repo 之外、之後所有子 agent 都能存取的目錄。這讓**實作子 agent** 能專注在實作，而不是探索。

3. 建立整合分支。如果 issue tracker 是透過 PR 結案，或使用者要求開 PR，就在步驟 5 第一次合併之後開一個 draft PR（沒有領先 main 任何 commit 的分支無法開 PR），並標記為會關閉這份 spec 與這些 ticket。

4. 用**實作子 agent** 實作每張 ticket，每個都在自己的 worktree、自己的分支上。每個實作子 agent：
   - 開始前確認它的 worktree 是基於整合分支，如果不是就重設到整合分支上；
   - 用 Skill tool 呼叫 `tdd` 來實作 ticket；
   - 回報完成前，把整合分支的最新版本合併進自己的分支

5. 當一個**實作子 agent** 完成後，用一個**合併子 agent** 把它的成果合併到整合分支。

6. 如果這改變了可接手 ticket 的**前沿**，就再啟動更多**實作子 agent** 處理新的 ticket。這樣可以達到最大的平行度。

7. 所有 ticket 都完成後，對整合分支用 Skill tool 呼叫 `code-review-zh`。用單一個**實作子 agent** 修正審查提出的所有問題。

8. 如果有 draft PR，把它標記為可以審查。否則，依照 issue tracker 結案的方式解決每張 ticket，並回報整合分支。

9. 清理所有**實作子 agent** 的 worktree。
