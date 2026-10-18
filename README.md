# Brian 的 Claude Code Skills

這是我個人使用的 Claude Code skill 集合，主要用來開發 Python 生產力工具（例如替代料篩選、OEM 專案成本計算）。整個 repo 的根目錄就是 `~/.claude/skills`，所以 clone 下來即可使用，換電腦時也只要 clone 一次，之後用 `git pull` 同步。

這些 skill 改編自 Matt Pocock 的 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT 授權）。我把它們翻成繁體中文，把 TypeScript 範例改成 Python／pytest 與 BOM、替代料情境，並把 git 防護 hook 從需要 `jq` 的 bash 腳本改寫成跨平台的 Python。

## 收錄的 skill

整套 skill 圍繞一個想法：在讓 agent 動手之前，先把需求和用詞對齊；動手時用測試和回饋迴路約束它；出問題時用紀律而不是猜測去除錯。

**對齊需求。** `grilling` 是核心機制，它把一件事拆成決策樹，每一回合把目前能問的問題一次問完並附上建議答案，直到沒有任何東西被默默假設。`grill-me` 是呼叫它的捷徑。`grill-with-docs` 在拷問的同時呼叫 `domain-modeling`，把確定下來的術語寫進 `GLOSSARY.md`、把重要決策寫成 ADR，讓之後每個 session 的 Claude 都講同一套語言。

**實作與除錯。** `tdd` 規範 red → green 的循環：先約定要在哪些 seam 上測，一次只做一個垂直切片，並避開綁死實作與套套邏輯這類壞測試。`diagnosing-bugs` 要求先建立一個會因該 bug 變紅的回饋迴路，才准開始提出假設，接著重現、最小化、驗證假設、修正並補回歸測試。

**輔助工具。** `research` 派背景 agent 從一手來源（官方文件、datasheet、API 文件）查資料並寫成附來源的筆記。`handoff` 把長對話壓縮成交接文件給新 session。`to-questionnaire` 把自己答不了的問題轉成問卷，交給客戶或供應商填寫。`git-guardrails-claude-code` 安裝一個 hook，阻止 Claude 執行 `git push`、`reset --hard` 等破壞性指令。

| Skill | 呼叫方式 | 用途 |
|---|---|---|
| grilling | 自動 | 拷問機制本體 |
| grill-me | `/grill-me` | 只拷問，不寫文件 |
| grill-with-docs | `/grill-with-docs` | 拷問並建立 GLOSSARY 與 ADR |
| domain-modeling | 自動 | 維護術語表與 ADR |
| tdd | 自動或 `/tdd` | 測試驅動開發（pytest） |
| diagnosing-bugs | 自動或 `/diagnosing-bugs` | 分階段除錯 |
| research | 自動或 `/research` | 一手來源研究筆記 |
| handoff | `/handoff` | 產生交接文件 |
| to-questionnaire | `/to-questionnaire` | 產生給他人填寫的問卷 |
| git-guardrails-claude-code | `/git-guardrails-claude-code` | 安裝 git 防護 hook |

「自動」表示 Claude 會依據對話內容自行判斷何時使用。

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

裝好後重開 Claude Code，輸入 `/` 應該能看到上表的指令。第一次使用時，在專案裡執行一次 `/git-guardrails-claude-code` 完成 hook 設定。

## 更新與同步

在任何一台電腦修改了 skill，就在 `~/.claude/skills` 裡 commit 並 push；其他電腦執行 `git pull` 即可同步。

```bash
cd ~/.claude/skills
git pull
```

## 授權

依原專案採用 MIT 授權，原著作權屬於 Matt Pocock，見 [LICENSE](LICENSE)。本 repo 的修改內容（翻譯、範例改寫、Python hook）同樣以 MIT 授權釋出。
