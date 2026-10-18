#!/usr/bin/env bash
# 人在迴路中（Human-in-the-loop）的重現腳本。
# 複製這個檔案，修改下方步驟，然後執行。
# Agent 執行腳本；使用者在自己的終端機裡依照提示操作。
#
# 用法：
#   bash hitl-loop.template.sh
#
# 兩個輔助函式：
#   step "<指示>"            → 顯示指示，等待按 Enter
#   capture 變數 "<問題>"    → 顯示問題，把回答讀進變數
#
# 最後，擷取到的值會以 KEY=VALUE 印出，供 agent 解析。
#
# capture 會把值印回終端機讓 agent 讀取，所以只用它擷取「觀察結果」，
# 登入、輸入密碼這類動作請用 step 交給使用者自己做。

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [完成後按 Enter] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 從這裡開始修改 ------------------------------------------------------

step "用 Excel 開啟 output/bom_cost.xlsx。"

capture WRONG "第 12 列的單價是否和經銷商網站上的價格不一致？(y/n)"

capture SHOWN "請貼上 Excel 裡顯示的數值（或輸入 none）："

# --- 修改到這裡為止 ------------------------------------------------------

printf '\n--- 擷取結果 ---\n'
printf 'WRONG=%s\n' "$WRONG"
printf 'SHOWN=%s\n' "$SHOWN"
