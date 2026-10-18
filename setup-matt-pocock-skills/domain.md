# 領域文件

工程類 skill 在探索程式碼時，應該如何使用這個 repo 的領域文件。

## 探索之前，先讀這些

- repo 根目錄的 **`GLOSSARY.md`**，或
- repo 根目錄的 **`GLOSSARY-MAP.md`**（如果存在）：它會指向每個 context 各自的 `GLOSSARY.md`。讀與主題相關的每一份。
- **`docs/adr/`**：讀與你即將動手的區域相關的 ADR。在多 context 的 repo 中，也要查看 `src/<context>/docs/adr/` 裡屬於該 context 的決策。

如果其中任何檔案不存在，**安靜地繼續**。不要指出它們不存在，也不要預先建議建立它們。`/domain-modeling` skill（透過 `/grill-with-docs` 和 `/improve-codebase-architecture` 觸發）會在術語或決策真正確定時延遲建立它們。

## 檔案結構

單一 context 的 repo（大多數 repo）：

```
/
├── GLOSSARY.md
├── docs/adr/
│   ├── 0001-cost-rollup-uses-moq-price-break.md
│   └── 0002-sqlite-for-part-cache.md
└── src/
```

多 context 的 repo（根目錄有 `GLOSSARY-MAP.md`）：

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                          ← 全系統層級的決策
└── src/
    ├── sourcing/
    │   ├── GLOSSARY.md
    │   └── docs/adr/                  ← 該 context 專屬的決策
    └── costing/
        ├── GLOSSARY.md
        └── docs/adr/
```

## 使用術語表的用語

當你的產出提到某個領域概念時（issue 標題、重構提案、假設、測試名稱），使用 `GLOSSARY.md` 所定義的術語。不要飄移到術語表明確列為「避免使用」的同義詞。

如果你需要的概念還不在術語表裡，這是一個訊號：要嘛你正在發明專案沒在用的語言（重新考慮），要嘛真的有缺口（記下來交給 `/domain-modeling`）。

## 標出與 ADR 的衝突

如果你的產出和既有的 ADR 矛盾，要明確提出來，而不是默默覆蓋：

> _與 ADR-0007（成本計算採用 MOQ 價格級距）矛盾，但值得重新討論，因為……_
