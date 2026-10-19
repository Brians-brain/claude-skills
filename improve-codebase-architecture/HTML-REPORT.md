# HTML 報告格式

架構審查的結果是一個自給自足的 HTML 檔，放在作業系統的暫存目錄。Tailwind 和 Mermaid 都從 CDN 載入。Mermaid 能可靠地畫出圖形狀的關係；手工的 div 和內嵌 SVG 負責比較有編輯感的視覺（質量圖、剖面圖）。兩者混著用：不要什麼都靠 Mermaid，不然看起來會很制式。

## 骨架

```html
<!doctype html>
<html lang="zh-Hant">
  <head>
    <meta charset="utf-8" />
    <title>{{repo name}} 架構審查</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* Tailwind 不好處理的少數東西：
         虛線的 seam、像手畫的箭頭等 */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## 頁首

儲存庫名稱、日期，以及精簡的圖例：實線方框＝模組、虛線＝seam、紅色箭頭＝洩漏、粗框深色方塊＝深模組。不要寫開場白，直接進入候選。

## 候選卡片

重點在圖。文字少而白話，直接使用 `/codebase-design` 術語表裡的詞，不必客套。

每個候選是一個 `<article>`：

- **標題**：簡短，說出要加深的是什麼（例如「把訂單收件流程收合成一個模組」）。
- **徽章列**：建議強度（`強烈建議`＝翠綠、`值得探索`＝琥珀、`推測性`＝石板灰），加上一個依賴類別的標籤（`同程序內`、`可在本機替換`、`連接埠與轉接器`、`mock`）。
- **檔案**：等寬字型的清單，`font-mono text-sm`。
- **之前／之後圖**：主角。左右兩欄並排，樣式見下方。
- **問題**：一句話，哪裡痛。
- **解法**：一句話，改了什麼。
- **好處**：條列，每條不超過 12 個字。例如「測試只碰一個介面」「定價邏輯不再外洩」「刪掉 4 個淺包裝層」。
- **ADR 提示**（有的話）：琥珀底色框裡的一行字。

不要寫解釋性的段落。如果一張圖要配一段話才看得懂，就重畫那張圖。

## 圖的樣式

挑最適合這個候選的樣式，混著用，不要每張圖都長得一樣。變化本身就是重點之一。

### Mermaid 圖（畫依賴與呼叫流程的主力）

當重點是「X 呼叫 Y 再呼叫 Z，看看有多亂」時，用 Mermaid 的 `flowchart` 或 `graph`。外面包一張 Tailwind 樣式的卡片，才不會像硬塞進來的。用 classDef 把洩漏的邊塗成紅色、把深模組塗成深色。序列圖很適合表達「之前：來回 6 次；之後：1 次」。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手工方框與箭頭（Mermaid 的排版不聽話時）

模組用有邊框和標籤的 `<div>`。箭頭用內嵌 SVG 的 `<line>` 或 `<path>`，絕對定位在一個相對定位的容器上。想讓「之後」的圖看起來像一個粗框的深模組、內部細節淡化時用這個，因為 Mermaid 畫不出那種份量感。

### 剖面圖（適合呈現層層都很淺）

把水平色帶（`h-12 border-l-4`）疊起來，表示一次呼叫穿過的各層。之前：6 層薄薄的、每層什麼都沒做。之後：1 條厚帶，標上合併後的職責。

### 質量圖（適合呈現「介面和實作一樣寬」）

每個模組畫兩個長方形：一個代表介面的表面積，一個代表實作。之前：介面長方形幾乎和實作一樣高（淺）。之後：介面長方形很矮、實作長方形很高（深）。

### 呼叫圖收合

之前：一棵函式呼叫樹，畫成層層巢狀的方框。之後：同一棵樹收合成一個方框，原本的呼叫變成內部的，淡淡地畫在裡面。

## 風格

- 走編輯排版的感覺，不要像企業儀表板。留白要多。標題可以用襯線字型（`font-serif` 和 stone／slate 色系很搭）。
- 顏色要節制：一個強調色（翠綠或靛藍），加上紅色表示洩漏、琥珀色表示警告。
- 圖高約 320px，讓之前／之後並排時不用捲動。
- 圖裡的模組標籤用 `text-xs uppercase tracking-wider`，讀起來像示意圖，而不是介面元素。
- 唯二的腳本是 Tailwind CDN 和 Mermaid 的 ESM 匯入。除此之外報告是靜態的：沒有應用程式碼，除了 Mermaid 本身的渲染外沒有互動。

## 首要建議段落

一張比較大的卡片：候選名稱、一句話說明為什麼、一個連到該候選卡片的錨點連結。就這樣。

## 語氣

用白話的繁體中文，簡潔；架構的名詞和動詞一律取自 `/codebase-design`。簡潔不是用詞飄移的藉口。

**一律使用：** 模組、介面、實作、深度、深、淺、seam、轉接器、槓桿、局部性。

**不要替換成：** 元件、服務、單元（指模組時）· API、簽章（指介面時）· 邊界（指 seam 時）· 層、包裝（其實是在說模組時）。

**符合這個風格的說法：**

- 「訂單收件模組很淺：介面幾乎和實作一樣。」
- 「定價邏輯越過 seam 外洩。」
- 「加深：一個介面，一個地方測試。」
- 「兩個轉接器讓這個 seam 站得住：正式環境用 HTTP，測試用記憶體內版本。」

**好處條列**要用術語表的詞說出得到什麼：「局部性：bug 集中在一個模組」「槓桿：一個介面，N 個呼叫處」「介面變小，實作吸收掉那些包裝」。不要寫「比較好維護」或「程式碼更乾淨」，這些詞不在術語表裡，沒有資格出現。

不要含糊其辭、不要清喉嚨式的開場、不要「值得注意的是……」。能寫成條列的句子就寫成條列；能刪的條列就刪。術語不在 `/codebase-design` 術語表裡時，先找一個表裡有的詞，不要自己發明新詞。
