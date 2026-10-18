# 好測試與壞測試

以下範例以 pytest 撰寫，情境取自 BOM／替代料／成本計算這類生產力工具。

## 好測試

**整合式**：透過真實介面測試，而不是 mock 內部零件。

```python
# 好：測試可觀察的行為
def test_alternate_with_same_package_and_rating_is_accepted():
    original = Part(mpn="GRM188R71H104KA93D", package="0603", voltage_v=50, capacitance_nf=100)
    candidate = Part(mpn="CL10B104KB8NNNC", package="0603", voltage_v=50, capacitance_nf=100)

    result = screen_alternate(original, candidate)

    assert result.accepted is True
```

特徵：

- 測試呼叫端在意的行為
- 只使用公開 API
- 能撐過內部重構
- 描述「做什麼」，而不是「怎麼做」
- 每個測試只有一個邏輯上的斷言

## 壞測試

**測實作細節**：和內部結構綁在一起。

```python
# 壞：測試實作細節
def test_screen_alternate_calls_compare_package(mocker):
    spy = mocker.patch("sourcing.screening._compare_package", return_value=True)
    screen_alternate(original, candidate)
    spy.assert_called_once_with("0603", "0603")
```

警訊：

- mock 內部協作者
- 測試私有函式（`_` 開頭）
- 斷言呼叫次數或呼叫順序
- 行為沒變，重構後測試卻壞了
- 測試名稱描述「怎麼做」而非「做什麼」
- 繞過介面、用外部手段驗證

```python
# 壞：繞過介面去驗證
def test_save_quote_writes_to_sqlite(tmp_path):
    db_path = tmp_path / "cache.db"
    save_quote(db_path, mpn="LM358DR", unit_price=0.12)
    row = sqlite3.connect(db_path).execute(
        "SELECT unit_price FROM quotes WHERE mpn = ?", ("LM358DR",)
    ).fetchone()
    assert row is not None

# 好：透過介面驗證
def test_saved_quote_can_be_loaded_back(tmp_path):
    db_path = tmp_path / "cache.db"
    save_quote(db_path, mpn="LM358DR", unit_price=0.12)
    assert load_quote(db_path, mpn="LM358DR").unit_price == 0.12
```

**套套邏輯測試**：期望值只是把實作重講一遍，所以必然通過。

```python
# 壞：期望值用和程式碼一樣的方法重算
def test_bom_cost_sums_extended_prices():
    lines = [Line(qty=2, unit_price=10), Line(qty=1, unit_price=5)]
    expected = sum(l.qty * l.unit_price for l in lines)
    assert bom_cost(lines) == expected

# 好：期望值是獨立、已知的字面值（手算過）
def test_bom_cost_sums_extended_prices():
    lines = [Line(qty=2, unit_price=10), Line(qty=1, unit_price=5)]
    assert bom_cost(lines) == 25
```

## 浮點數與金額

成本計算常遇到浮點誤差。期望值仍然要是手算的字面值，比較時用 `pytest.approx`，或在程式中改用 `decimal.Decimal`：

```python
def test_unit_cost_uses_price_break_for_order_quantity():
    breaks = [PriceBreak(min_qty=1, unit_price=0.50), PriceBreak(min_qty=1000, unit_price=0.32)]
    assert unit_price_for(breaks, qty=2500) == pytest.approx(0.32)
```
