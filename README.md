# Brian 的 Claude Code Skills

這是我個人使用的 Claude Code skill 集合，主要用來開發 Python 生產力工具（例如替代料篩選、OEM 專案成本計算）。整個 repo 的根目錄就是 `~/.claude/skills`，所以 clone 下來即可使用；換電腦時也只要 clone 一次，之後用 `git pull` 同步。

這些 skill 改編自 Matt Pocock 的 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT 授權）。我把它們翻成繁體中文，把 TypeScript 範例改成 Python／pytest 與 BOM、替代料、成本計算的情境，並把 git 防護 hook 從需要 `jq` 的 bash 腳本改寫成跨平台的 Python。

## 整體設計：一條主流程，加上幾個匝道

這套 skill 不是一堆各自獨立的工具，而是一條流水線。它要解決的是 coding agent 的四個常見失敗：agent 做的不是你要的（雙方沒對齊）、agent 講話太囉嗦（沒有共同語言）、寫出來的程式不能用（缺回饋迴路）、程式碼越來越亂（沒有在設計上投入）。

**主流程**是「想法 → 上線」。先用 `grill-with-docs` 把想法拷問清楚，同時把術語寫進 `GLOSSARY.md`、把重要決策寫成 ADR；遇到紙上解決不了的問題，就用 `prototype` 做拋棄式原型回答它。如果工作大到需要多個 session，用 `to-spec` 把討論整理成 spec，再用 `to-tickets` 切成垂直切片的 ticket，然後逐張 `implement`，或用 `implement-spec` 平行跑完。實作時一律透過 `tdd` 一次做一個 red → green 切片，完成後由 `code-review` 從「是否符合規範」與「是否符合 spec」兩個軸審查；送 PR 時由 `pr` 決定內文格式。最後用 `retro` 回顧整個 session，把犯過的錯變成自動檢查或寫作規範，讓下一次從更好的環境開始。

**匝道**是會產生工作、再匯入主流程的情境：別人回報的 bug 或需求用 `triage` 整理成可以交給 agent 的 issue；難纏的 bug 用 `diagnosing-bugs` 先建立會變紅的回饋迴路再除錯；大到一個 session 裝不下、還看不清方向的專案，用 `wayfinder` 在 issue tracker 上畫一張決策地圖，一次解決一個決策。

**底層詞彙**有兩個：`domain-modeling` 維護專案的領域語言（術語表與 ADR），`codebase-design` 提供 deep module 的設計詞彙（模組、介面、深度、seam、轉接器）。其他 skill 會在需要時自動呼叫它們。

記不住該用哪個時，直接問 `/ask-matt`，它會告訴你目前的狀況該走哪條路。

## 收錄的 skill（28 個）

### 前置設定

| Skill | 呼叫方式 | 用途 |
|---|---|---|
| setup-matt-pocock-skills | `/setup-matt-pocock-skills` | 每個 repo 執行一次：設定 issue tracker（GitHub／本地 markdown）、triage 標籤、文件位置 |
| git-guardrails-claude-code | `/git-guardrails-claude-code` | 安裝 hook，阻止 Claude 執行 `git push`、`reset --hard` 等危險指令 |
| ask-matt | `/ask-matt` | 路由器：描述狀況，告訴你該用哪個 skill |

### 主流程

| Skill | 呼叫方式 | 用途 |
|---|---|---|
| grill-with-docs | `/grill-with-docs` | 拷問想法，同時建立 GLOSSARY 與 ADR（在 repo 中的首選） |
| prototype | 自動或 `/prototype` | 拋棄式原型：驗證邏輯／狀態模型，或比較 UI 變體 |
| to-spec | `/to-spec` | 把討論整理成 spec，發布到 issue tracker |
| to-tickets | `/to-tickets` | 把 spec 切成帶阻擋關係的垂直切片 ticket |
| implement | `/implement` | 依 ticket 實作（內含 tdd 與 code-review） |
| implement-spec | `/implement-spec` | 平行子 agent 一次實作整份 spec |
| tdd | 自動或 `/tdd` | 測試驅動開發（pytest） |
| code-review | 自動或 `/code-review` | 雙軸審查：Standards＋Spec |
| pr | 自動 | 撰寫 PR 內文：示意圖、前後證據、合併風險 |
| retro | `/retro` | 回顧 session，改善 agent 的工作環境 |

### 匝道與維護

| Skill | 呼叫方式 | 用途 |
|---|---|---|
| triage | `/triage` | 讓 issue 在 triage 狀態機中流轉，撰寫 agent 簡報 |
| diagnosing-bugs | 自動或 `/diagnosing-bugs` | 分階段除錯：先建立回饋迴路，再提假設 |
| wayfinder | `/wayfinder` | 大型專案：在 issue tracker 上畫決策地圖 |
| improve-codebase-architecture | `/improve-codebase-architecture` | 掃描可加深的模組，產出 HTML 報告 |

### 底層詞彙

| Skill | 呼叫方式 | 用途 |
|---|---|---|
| grilling | 自動 | 拷問機制本體（其他 skill 都呼叫它） |
| domain-modeling | 自動 | 維護術語表與 ADR |
| codebase-design | 自動 | deep module 設計詞彙與原則 |

### 獨立使用

| Skill | 呼叫方式 | 用途 |
|---|---|---|
| grill-me | `/grill-me` | 只拷問、不寫文件（沒有 repo 時用） |
| research | 自動或 `/research` | 背景 agent 從一手來源調查並寫成筆記 |
| handoff | `/handoff` | 把對話壓縮成交接文件給新 session |
| to-questionnaire | `/to-questionnaire` | 產生給客戶／供應商填寫的問卷 |
| wizard | 自動或 `/wizard` | 產生互動式 bash 精靈，帶人完成手動設定步驟 |
| wait-what | `/wait-what` | 「剛剛那段我沒看懂」，請 Claude 簡單重講 |
| teach | `/teach` | 跨多個 session 的長期學習工作區 |
| writing-for-agents | 自動 | 撰寫 skill、CLAUDE.md 的寫作指南 |

「自動」表示 Claude 會依據對話內容自行判斷何時使用；你也可以直接輸入 `/名稱` 呼叫。只標 `/名稱` 的 skill 只能手動呼叫。

## 安裝

`~/.claude/skills` 必須是空的或不存在，才能直接 clone 進去。如果之前已經用 zip 裝過，先把舊資料夾改名備份。

**Windows（PowerShell）：**

```powershell
Rename-Item "$HOME\.claude\skills" "skills.bak"   # 若之前裝過才需要
git clone https://github.com/Brians-brain/claude-skills.git "$HOME\.claude\skills"
```

**macOS／Linux：**

```bash
mv ~/.claude/skills ~/.claude/skills.bak   # 若之前裝過才需要
git clone https://github.com/Brians-brain/claude-skills.git ~/.claude/skills
```

裝好後重開 Claude Code，輸入 `/` 應該能看到上表的指令。

**第一次使用時：**

1. 在每台電腦（或每個專案）執行一次 `/git-guardrails-claude-code`，完成 git 防護 hook 的設定。
2. 在每個要使用工程類流程的 repo 中執行一次 `/setup-matt-pocock-skills`。它會偵測到 GitHub remote 並建議用 GitHub Issues 當 issue tracker；個人小專案也可以選「本地 markdown」，issue 會以檔案形式放在 `.scratch/`。

`wizard` 產生的是 bash 腳本，在 Windows 上要用 Git Bash 或 WSL 執行。

## 更新與同步

在任何一台電腦修改了 skill，就在 `~/.claude/skills` 裡 commit 並 push；其他電腦執行 `git pull` 即可同步。

```bash
cd ~/.claude/skills
git pull
```

## 翻譯說明

所有 `SKILL.md` 與大部分參考文件都已翻成繁體中文，並在每個 skill 開頭指示 Claude 以繁體中文溝通、以繁體中文撰寫 spec、ticket、PR 與報告。以下參考文件保留英文原文，因為它們主要是給 agent 讀的技術細節，或是我不使用的平台：

- `improve-codebase-architecture/HTML-REPORT.md`（HTML 報告的版面與樣式規格；報告輸出仍為繁體中文）
- `setup-matt-pocock-skills/issue-tracker-gitlab.md`（GitLab 設定範本）

## 授權

依原專案採用 MIT 授權，原著作權屬於 Matt Pocock，見 [LICENSE](LICENSE)。`pr` skill 的摘要視覺化選單來自 Dex Horthy 的 `show-me` skill，見 `pr/CREDITS.md`。本 repo 的修改內容（翻譯、範例改寫、Python hook）同樣以 MIT 授權釋出。
