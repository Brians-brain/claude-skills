# GLOSSARY.md 格式

## 結構

```md
# {Context 名稱}

{一到兩句話說明這個 context 是什麼、為什麼存在。}

## 用語

**替代料（Alternate Part）**：
可在不改 PCB 設計的前提下，取代 BOM 中某顆指定料的另一顆元件。
_避免使用_：代用料、相容料、second source

**原廠料號（MPN）**：
元件製造商賦予該元件的唯一料號。
_避免使用_：型號、part number（未說明是哪一種時）

**價格級距（Price Break）**：
經銷商依採購數量區間給出的單價。
_避免使用_：階梯價、量價
```

## 規則

- **要有主見。** 同一個概念有多種說法時，選最好的一個，其餘列在 `_避免使用_` 底下。
- **定義要精簡。** 最多一到兩句。定義它**是什麼**，不是它**做什麼**。
- **只收錄這個專案特有的術語。** 一般程式概念（timeout、錯誤類型、工具函式模式）不屬於這裡，即使專案大量使用。加入術語前先問：這是這個 context 獨有的概念，還是一般程式概念？只有前者才收錄。
- **自然形成群組時，用子標題分組。** 如果所有術語都屬於同一個內聚的領域，平鋪一個清單即可。

## 單一 context 與多 context 的 repo

**單一 context（大多數 repo）：** repo 根目錄放一個 `GLOSSARY.md`。

**多個 context：** repo 根目錄放一個 `GLOSSARY-MAP.md`，列出各個 context、它們的位置，以及彼此的關係：

```md
# Glossary Map

## Contexts

- [Sourcing](./src/sourcing/GLOSSARY.md)：篩選與比對替代料
- [Costing](./src/costing/GLOSSARY.md)：計算 BOM 與 OEM 專案成本

## 關係

- **Sourcing → Costing**：Sourcing 產出「已核可替代料清單」，Costing 據此計算各方案成本
- **Sourcing ↔ Costing**：共用 `Mpn` 與 `PriceBreak` 型別
```

本 skill 依以下規則判斷適用哪種結構：

- 若有 `GLOSSARY-MAP.md`，讀它找出各個 context
- 若只有根目錄的 `GLOSSARY.md`，就是單一 context
- 若兩者都沒有，在第一個術語確定時於根目錄延遲建立 `GLOSSARY.md`

有多個 context 時，判斷目前話題屬於哪一個；判斷不出來就問使用者。
