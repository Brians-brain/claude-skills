---
name: implement
description: "依照一份規格書或一組工作單，實作一項工作。"
disable-model-invocation: true
---

與使用者溝通使用繁體中文。

實作使用者在 spec 或 ticket 中描述的工作。

如果使用者傳入一個 ticket 參照，從 issue tracker 取得它，並在開始前說出它的標題。如果參照不明確，就問。

盡可能在事先約定好的 seam 上，用 Skill tool 呼叫 "tdd"。

定期執行型別檢查（若專案有設定 `mypy` 或 `pyright`）、定期執行單一測試檔，並在最後執行一次完整的測試套件。

完成後，用 Skill tool 呼叫 "code-review-zh" 審查這次的工作。

把工作 commit 到目前的分支。
