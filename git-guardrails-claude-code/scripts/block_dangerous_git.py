#!/usr/bin/env python3
"""Claude Code PreToolUse hook：封鎖危險的 git 指令。

從 stdin 讀取 hook 的 JSON 輸入，若 tool_input.command 符合任一危險樣式，
就在 stderr 印出原因並以結束碼 2 結束（Claude Code 會因此阻止該指令）。
其他情況以結束碼 0 結束。
"""

import json
import re
import sys

DANGEROUS_PATTERNS = [
    r"git\s+push",
    r"git\s+reset\s+--hard",
    r"git\s+clean\s+-[a-zA-Z]*f",
    r"git\s+branch\s+-D",
    r"git\s+checkout\s+\.",
    r"git\s+restore\s+\.",
    r"push\s+--force",
    r"reset\s+--hard",
]


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return 0

    command = (payload.get("tool_input") or {}).get("command") or ""

    for pattern in DANGEROUS_PATTERNS:
        if re.search(pattern, command):
            print(
                f"BLOCKED: '{command}' matches dangerous pattern '{pattern}'. "
                "The user has prevented you from doing this.",
                file=sys.stderr,
            )
            return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
