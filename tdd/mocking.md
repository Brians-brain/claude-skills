# 什麼時候該 mock

只在**系統邊界**上 mock：

- 外部 API（經銷商報價 API、匯率 API、寄信服務等）
- 資料庫（有時候；能用測試用資料庫就優先用，例如 SQLite 放在 `tmp_path`）
- 時間與隨機數
- 檔案系統（有時候；pytest 的 `tmp_path` 通常比 mock 更好）

不要 mock：

- 你自己的類別或模組
- 內部協作者
- 任何你能控制的東西

## 為可 mock 而設計

在系統邊界上，把介面設計成容易 mock：

**1. 使用依賴注入（dependency injection）**

把外部依賴從外面傳進來，而不是在函式內部自己建立：

```python
# 容易 mock
def fetch_unit_price(mpn: str, qty: int, client: PriceClient) -> float:
    return client.unit_price(mpn, qty)

# 難以 mock
def fetch_unit_price(mpn: str, qty: int) -> float:
    client = DistributorClient(api_key=os.environ["DIST_API_KEY"])
    return client.unit_price(mpn, qty)
```

測試時傳入一個簡單的假物件即可，不需要 `mocker.patch`：

```python
class FakePriceClient:
    def __init__(self, prices: dict[str, float]):
        self.prices = prices

    def unit_price(self, mpn: str, qty: int) -> float:
        return self.prices[mpn]

def test_fetch_unit_price_returns_distributor_price():
    client = FakePriceClient({"LM358DR": 0.12})
    assert fetch_unit_price("LM358DR", 100, client) == 0.12
```

**2. 偏好 SDK 式介面，而非通用的 fetch 函式**

為每個外部操作建立專屬的方法，而不是一個內含條件邏輯的通用函式：

```python
# 好：每個方法都能獨立 mock
class DistributorApi:
    def search_part(self, mpn: str) -> PartInfo: ...
    def price_breaks(self, mpn: str) -> list[PriceBreak]: ...
    def stock(self, mpn: str) -> int: ...

# 壞：mock 時必須在假物件裡寫條件判斷
class DistributorApi:
    def request(self, endpoint: str, params: dict) -> dict: ...
```

SDK 式的好處：

- 每個 mock 只回傳一種固定形狀
- 測試準備裡不需要條件邏輯
- 一眼看出測試用到哪些端點
- 每個端點都有各自的型別提示（type hints）
