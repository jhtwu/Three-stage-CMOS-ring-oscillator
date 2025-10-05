# SkyWater 130nm PDK 安裝指南

## 為什麼需要 PDK?

**PDK (Process Design Kit)** 包含了製程相關的元件模型、參數和規則。沒有 PDK，ngspice 無法知道電晶體的物理特性，因此**絕對無法執行模擬**。

本專案使用 **SkyWater 130nm PDK**，這是 Google 和 SkyWater Technology Foundry 合作開發的開源 PDK。

## 快速安裝 (推薦方法)

### 方法 1: 使用 volare

```bash
# 1. 安裝 volare (PDK 管理工具)
pip3 install volare

# 2. 下載並啟用 SkyWater 130nm PDK
volare enable --pdk sky130

# 3. PDK 預設會安裝到以下位置:
#    ~/.volare/volare/sky130/...
```

**如果 PDK 路徑不同於本專案預設路徑**，請修改電路檔案:
- `ring_oscillator.cir` (第 3 行)
- `vdd_sweep.cir` (第 3 行)

將:
```spice
.lib /home/jimmy/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt
```

改為你的實際路徑，例如:
```spice
.lib ~/.volare/volare/sky130/versions/bdc9412b3e468c102d01b7cf6337be06ec6e9c9a/sky130A/libs.tech/ngspice/sky130.lib.spice tt
```

### 方法 2: 從 GitHub 手動安裝

```bash
# 1. 克隆 SkyWater PDK 倉庫
git clone https://github.com/google/skywater-pdk.git
cd skywater-pdk

# 2. 下載必要的子模組
git submodule update --init libraries/sky130_fd_pr/latest

# 3. 建立符號連結 (可選)
mkdir -p /home/jimmy/pdk
ln -s $(pwd)/libraries/sky130_fd_pr/latest /home/jimmy/pdk/sky130A
```

### 方法 3: 使用 Open PDKs

```bash
# 1. 克隆 Open PDKs
git clone https://github.com/RTimothyEdwards/open_pdks.git
cd open_pdks

# 2. 編譯並安裝
./configure --enable-sky130-pdk
make
sudo make install
```

## 驗證安裝

### 檢查關鍵檔案是否存在

```bash
# 檢查主要庫檔案
ls -l /home/jimmy/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice

# 或檢查 volare 安裝的路徑
ls -l ~/.volare/volare/sky130/*/sky130A/libs.tech/ngspice/sky130.lib.spice
```

### 運行測試腳本

```bash
cd Three-stage-CMOS-ring-oscillator
./run_all.sh
```

如果看到:
```
✓ SkyWater PDK 已安裝: /path/to/sky130.lib.spice
```
表示安裝成功!

## 常見問題

### Q1: 我的 PDK 安裝在不同位置怎麼辦?

**答**: 修改電路檔案中的 `.lib` 路徑，或建立符號連結:

```bash
# 方法 A: 建立符號連結
mkdir -p /home/jimmy/pdk
ln -s /your/actual/pdk/path/sky130A /home/jimmy/pdk/sky130A

# 方法 B: 直接修改電路檔案
# 編輯 ring_oscillator.cir 和 vdd_sweep.cir
```

### Q2: 如何找到我的 PDK 實際路徑?

```bash
# 如果使用 volare
volare ls-remote
volare path sky130

# 或搜尋系統中的 PDK
find ~ -name "sky130.lib.spice" 2>/dev/null
```

### Q3: 沒有 PDK 能否執行模擬?

**答**: **不能**。沒有 PDK，ngspice 無法找到電晶體模型，模擬會立即失敗並顯示:
```
Error: can't find model 'sky130_fd_pr__nfet_01v8'
```

### Q4: PDK 檔案很大嗎?

**答**: 完整的 SkyWater PDK 約 **1-2 GB**。如果空間有限:
1. 只下載必要的元件庫
2. 使用 volare 管理特定版本

### Q5: 能用其他 PDK 嗎?

**答**: 理論上可以，但需要:
1. 修改電路中的元件名稱
2. 調整電晶體尺寸參數
3. 更新 `.lib` 路徑

不建議初學者這樣做。

## PDK 目錄結構

```
sky130A/
├── libs.tech/
│   └── ngspice/
│       ├── sky130.lib.spice        ← 主要庫檔案
│       ├── corners/
│       │   ├── tt.spice            ← typical-typical corner
│       │   ├── ff.spice            ← fast-fast corner
│       │   └── ss.spice            ← slow-slow corner
│       └── ...
└── libs.ref/
    └── sky130_fd_pr/
        └── spice/
            ├── sky130_fd_pr__nfet_01v8*.spice
            ├── sky130_fd_pr__pfet_01v8*.spice
            └── ...
```

## 參考資源

- **SkyWater PDK 官方倉庫**: https://github.com/google/skywater-pdk
- **SkyWater 文檔**: https://skywater-pdk.readthedocs.io/
- **volare 工具**: https://github.com/efabless/volare
- **Open PDKs**: https://github.com/RTimothyEdwards/open_pdks

## 技術支援

如果遇到 PDK 相關問題:
1. 查看本專案的 `專案說明_繁體中文.md` 疑難排解章節
2. 參考 SkyWater PDK 官方文檔
3. 在 GitHub Issues 提問

---

**重要**: 請確保在執行任何模擬之前先安裝 PDK!
