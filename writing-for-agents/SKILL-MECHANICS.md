# Skill 機制

這是 [`writing-for-agents`](SKILL.md) 的 skill 專屬分支：當文件是 skill 時有什麼不同（frontmatter、呼叫方式的選擇、路由型 skill）。其他所有寫法都屬於 `SKILL.md` 中的通用參考。

## 呼叫方式

有兩種選擇，在兩種負擔之間取捨：

- **模型呼叫型（model-invoked）** skill 保留 `description`，讓 agent 能自主觸發它，其他 skill 也能呼叫它。你仍然可以手動輸入它的名稱：模型呼叫永遠**包含**使用者呼叫；description 只會增加 agent 發現它的能力，從不移除人的使用權。description 是這個 skill 的頂層情境指標，被迫一直常駐載入：用永久的情境負擔換取可發現性。一個內容全是參考的模型呼叫型 skill，也是存放共用參考的地方之一：其他 skill 可以呼叫它，所以多個 skill 都需要的參考可以放在同一個地方。做法：不要設定 `disable-model-invocation`，並撰寫面向模型、帶有觸發分支的 description（`SKILL.md` 中撰寫指標的規則全部適用）。
- **使用者呼叫型（user-invoked）** skill 讓 description 脫離 agent 的觸及範圍：只有人輸入它的名稱才能呼叫它，其他 skill 都不能。情境負擔為零，但它花的是認知負擔：你就是那個必須記得它存在的索引。做法：設定 `disable-model-invocation: true`；`description` 變成給人看的一行摘要，拿掉觸發清單。

只有當 agent 必須自己觸及這個 skill、或另一個 skill 必須觸及它時，才選擇模型呼叫型。如果它永遠只會被手動觸發，就做成使用者呼叫型，不付任何情境負擔。

兩個使用者呼叫型 skill 都需要的共用參考，不能放在其中任何一個裡：它們都沒有 description，誰也觸發不了誰。把它推到 skill 系統之外的一個普通檔案：任何 skill 都能指向的外部參考。

## 依呼叫方式拆分

這是拆分的「呼叫方式」切法（「順序」切法在 `SKILL.md`）：當你有一個應該能單獨觸發它的明確主導詞（一個你真的會在提示詞中使用的觸發詞），或另一個 skill 必須觸及它時，就拆出一個模型呼叫型 skill。新的常駐 description 要付情境負擔，所以這種獨立觸及必須值得。

## 路由型 skill

當使用者呼叫型 skill 多到你記不住時，累積起來的認知負擔可以用**路由型 skill**來解決：一個使用者呼叫型 skill，列出其他 skill 的名稱以及何時該用哪一個，讓人只需要記住一個 skill，而不是很多個。它只能提示，永遠無法觸發它們：使用者呼叫型 skill 沒有 description，所以除了人以外，什麼都觸及不到它們。
