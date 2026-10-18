---
name: git-guardrails-claude-code
description: 設定 Claude Code hook，在危險的 git 指令（push、reset --hard、clean、branch -D 等）執行前就擋下來。當使用者想防止破壞性的 git 操作、加上 git 安全 hook，或封鎖 git push/reset 時使用。
---

# 設定 Git 防護欄

全程使用繁體中文與使用者溝通。

設定一個 PreToolUse hook，在 Claude 執行危險的 git 指令之前攔截並封鎖。hook 腳本以 Python 撰寫，Windows、macOS、Linux 都能用，不需要安裝 `jq`。

## 會被封鎖的指令

- `git push`（所有變體，包含 `--force`）
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

被封鎖時，Claude 會看到一則訊息，告訴它沒有權限執行這些指令。使用者仍然可以自己在終端機執行。

## 步驟

### 1. 詢問範圍

問使用者：只裝在**這個專案**（`.claude/settings.json`），還是**所有專案**（`~/.claude/settings.json`）？

### 2. 確認 Python 指令

執行 `python3 --version`；如果失敗，改試 `python --version`（Windows 常見）。記下可用的那個指令，下面以 `<python>` 代稱。

### 3. 複製 hook 腳本

隨附的腳本在：[scripts/block_dangerous_git.py](scripts/block_dangerous_git.py)

依範圍複製到目標位置：

- **專案**：`.claude/hooks/block_dangerous_git.py`
- **全域**：`~/.claude/hooks/block_dangerous_git.py`

在 macOS／Linux 上用 `chmod +x` 設為可執行。

### 4. 把 hook 加進設定檔

加到對應的設定檔：

**專案**（`.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "<python> \"$CLAUDE_PROJECT_DIR/.claude/hooks/block_dangerous_git.py\""
          }
        ]
      }
    ]
  }
}
```

**全域**（`~/.claude/settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "<python> ~/.claude/hooks/block_dangerous_git.py"
          }
        ]
      }
    ]
  }
}
```

把 `<python>` 換成步驟 2 確認的指令。在 Windows 上，`~` 可能無法展開，改用完整路徑（例如 `C:/Users/<使用者>/.claude/hooks/block_dangerous_git.py`）。

如果設定檔已存在，把 hook **合併**進既有的 `hooks.PreToolUse` 陣列。不要覆蓋其他設定。

### 5. 詢問是否客製化

問使用者要不要增加或移除封鎖清單中的項目。例如：使用者若希望 Claude 能 push 到自己的 feature branch，可以移除 `git push`，只保留 `--force`。依回答修改複製過去的腳本中的 `DANGEROUS_PATTERNS`。

### 6. 驗證

執行一次快速測試：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <python> <腳本路徑>
```

應該以結束碼 2 結束，並在 stderr 印出 BLOCKED 訊息。再用一個安全指令（例如 `git status`）測試，應該以結束碼 0 結束。
