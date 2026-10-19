---
name: triage
description: "把需求單（issue）與外部合併請求依分類流程往下推進：分類、驗證、必要時追問，並寫出能直接交給代理執行的任務簡報。"
disable-model-invocation: true
---

# Triage

與使用者溝通、以及發到 issue tracker 的留言，都使用繁體中文。

讓專案 issue tracker 上的 issue 在一個小型的 triage 角色狀態機中流轉。

如果這個 repo 把外部 pull request 當成請求來源（見 issue tracker 設定），triage 也涵蓋 PR：**PR 就是附了程式碼的 issue**，使用同樣的角色、同樣的狀態、同樣的狀態機，只有幾處差異在下方標為「若是 PR」。依照 tracker 設定，把單獨的 `#42` 解析為 issue 或 PR。

Triage 期間發到 issue tracker 的每則留言或 issue，**都必須**以這段聲明開頭：

```
> *本內容由 AI 在 triage 過程中產生。*
```

## 參考文件

- [AGENT-BRIEF.md](AGENT-BRIEF.md)：如何撰寫耐久的 agent 簡報
- [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)：`.out-of-scope/` 知識庫如何運作

## 角色

兩個**類別**角色：

- `bug`：有東西壞了
- `enhancement`：新功能或改善

五個**狀態**角色：

- `needs-triage`：維護者需要評估
- `needs-info`：等待回報者提供更多資訊
- `ready-for-agent`：已完整定義，可交給無人看管的 agent
- `ready-for-human`：需要由人實作
- `wontfix`：不會處理

若是 PR，同樣的狀態以附帶的程式碼來解讀：`ready-for-agent` 表示已附上簡報，agent 應該對 diff 進行下一步；`ready-for-human` 表示已經可以讓人合併。

每個 triage 過的 issue 都應該恰好帶有一個類別角色和一個狀態角色。如果狀態角色有衝突，先標出來並詢問維護者，再做其他事。

這些是標準角色名稱。issue tracker 實際使用的標籤字串可能不同。對照表應該已經提供給你了。如果沒有，告訴使用者先執行 `/setup-matt-pocock-skills`。

狀態轉換：沒有標籤的 issue 通常先進入 `needs-triage`；從那裡移到 `needs-info`、`ready-for-agent`、`ready-for-human` 或 `wontfix`。回報者回覆後，`needs-info` 回到 `needs-triage`。維護者隨時可以推翻；看起來不尋常的轉換要標出來，並先詢問再進行。

## 呼叫方式

維護者呼叫 `/triage`，並用自然語言描述他想做什麼。解讀請求並採取行動。例如：

- 「給我看需要我處理的東西」
- 「我們來看 #42」（issue 或 PR）
- 「把 #42 移到 ready-for-agent」
- 「有哪些可以交給 agent 接手？」

## 顯示需要處理的東西

查詢 issue tracker，呈現三個分組，最舊的排前面：

1. **沒有標籤**：從未 triage 過。
2. **`needs-triage`**：評估進行中。
3. **自上次 triage 筆記後回報者有新動態的 `needs-info`**：需要重新評估。

當 PR 也在範圍內時，把外部 PR 納入這些分組，並在每一行標上 `[PR]` 或 `[issue]`。探索只會找出**外部**PR（tracker 設定定義了誰算外部），所以協作者正在進行中的 PR 不算 triage 工作。這個篩選只適用於探索；明確指名的 PR 不論作者是誰都會 triage。

顯示數量，以及每一項的一行摘要。讓維護者挑選。

## Triage 特定的 issue 或 PR

1. **收集情境。** 閱讀完整的 issue 或 PR（內文、留言、標籤、作者、日期；若是 PR，也讀 diff）。解析先前的 triage 筆記，避免重問已經解決的問題。使用專案術語表的用語探索程式碼，並尊重該區域的 ADR。對程式碼做兩項檢查：(a) **重複性**：以領域概念（而不只是請求的字面）搜尋被要求的行為是否已經有實作，並回報你查過哪裡。如果找到了，它就是「已實作」的 `wontfix`（步驟 5）。(b) **先前是否被拒絕**：閱讀 `.out-of-scope/*.md`，提出任何和這個請求相似的紀錄。

2. **提出建議。** 告訴維護者你建議的類別與狀態以及理由，加上與請求相關的程式碼簡要摘要（包括是否已經實作）。等待指示。

3. **驗證主張。** 在任何拷問之前，先檢查主張是否站得住腳。如果是 bug，依回報者的步驟重現它。如果是 PR，確認 diff 做到它聲稱的事：checkout 下來，執行相關的測試或指令。回報結果：已確認（附程式碼路徑）、失敗，或細節不足（強烈的 `needs-info` 訊號）。經過確認的驗證能讓 agent 簡報強得多。

4. **拷問（如果需要）。** 如果請求需要補充細節，用 Skill tool 呼叫兩次，分別是 "grilling" 和 "domain-modeling"，一次一回合問題地把它拷問成形，並在決策確定時當場磨利領域術語、更新 `GLOSSARY.md`／ADR。

5. **套用結果：**
   - `ready-for-agent`：發一則 agent 簡報留言（[AGENT-BRIEF.md](AGENT-BRIEF.md)）。
   - `ready-for-human`：結構和 agent 簡報相同，但註明為什麼不能委派（需要判斷、需要外部存取、設計決策、手動測試）。
   - `needs-info`：發 triage 筆記（範本見下方）。
   - 若是 `wontfix`，關閉 issue，留言內容取決於**原因**：
     - **已實作**：這個變更已經存在於程式碼中。指出它在哪裡；**不要**寫進 `.out-of-scope/`（那個知識庫是給**被拒絕**的請求，不是給已經做好的）。
     - **拒絕（bug）**：禮貌地說明，然後關閉。
     - **拒絕（enhancement）**：寫進 `.out-of-scope/`，在留言中連結它，然後關閉（[OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)）。
   - `needs-triage`：套用角色。如果有部分進展，可選擇性留言。

## 快速覆寫狀態

如果維護者說「把 #42 移到 ready-for-agent」，信任他，直接套用角色。確認你即將做什麼（角色變更、留言、關閉），然後執行。跳過拷問。如果在沒有拷問的情況下移到 `ready-for-agent`，問他要不要寫 agent 簡報。

## Needs-info 範本

```markdown
## Triage 筆記

**目前已經確認的：**

- 第 1 點
- 第 2 點

**我們還需要你（@回報者）提供的：**

- 問題 1
- 問題 2
```

把拷問中解決的所有事情記在「目前已經確認的」底下，讓工作不會遺失。問題必須具體、可行動，不能是「請提供更多資訊」。

## 接續先前的 session

如果 issue 或 PR 上已經有先前的 triage 筆記，先閱讀它們，檢查回報者是否回答了尚未解決的問題，並在繼續之前呈現更新後的狀況。不要重問已經解決的問題。
