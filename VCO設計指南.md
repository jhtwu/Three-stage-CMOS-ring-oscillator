# 電壓控制環形振盪器 (VCO) 設計指南

## 專案概述

本專案實現了基於SkyWater 130nm PDK的三級CMOS環形振盪器VCO，並測試了多種控制方案以優化KVCO特性曲線。

## 設計目標

根據 `new_vco.odt` 的需求：
1. 實現三個反向器組成的環形振盪器
2. 每個反向器加入控制電晶體來調整頻率
3. 確認 in1、out1、out2 平均且穩定的振盪
4. 測量KVCO曲線（頻率 vs 控制電壓）

## 電路架構

### 基本反向器鏈
```
in1 → [Inv1] → out1 → [Inv2] → out2 → [Inv3] → in1 (feedback)
```

### 控制方式演進

#### 1. 原始設計：雙邊控制
```
每個反向器:
- PMOS控制電晶體 (Vdd → vdd_inv)
- NMOS控制電晶體 (gnd_inv → GND)
- 標準反向器核心
```

**特點**:
- Vctrl 控制兩個電晶體
- 產生峰值型KVCO曲線（先升後降）

#### 2. 尺寸調整版本（方案4）
通過調整PMOS/NMOS控制電晶體的寬度比例來改變特性：
- **V1**: PMOS=3.0μm, NMOS=0.42μm (PMOS主導)
- **V2**: PMOS=0.42μm, NMOS=3.0μm (NMOS主導)
- **V3**: PMOS=5.0μm, NMOS=0.42μm (極端PMOS)

**結果**: 無法消除峰值特性

#### 3. 單邊控制版本（方案3）
只使用一種控制電晶體：

**PMOS-Only**:
```
XM_ctrl_p vdd_inv vctrl vdd vdd pfet
XM_n out in 0 0 nfet        (直接接地)
XM_p out in vdd_inv vdd pfet
```

**NMOS-Only**:
```
XM_ctrl_n gnd_inv vctrl 0 0 nfet
XM_n out in gnd_inv 0 nfet
XM_p out in vdd vdd pfet    (直接接Vdd)
```

**結果**: 在特定電壓範圍內可獲得單調曲線

## 測試結果摘要

### 方案4：尺寸調整（雙邊控制）

| 版本 | PMOS寬度 | NMOS寬度 | 頻率範圍 | 曲線特性 |
|------|----------|----------|----------|----------|
| 原始 | 1.0μm | 0.5μm | 0.055~1.11 GHz | 峰值型 |
| V1 | 3.0μm | 0.42μm | 0.055~1.67 GHz | 峰值型 |
| V2 | 0.42μm | 3.0μm | 0.052~1.63 GHz | 峰值型 |
| V3 | 5.0μm | 0.42μm | 0.055~1.72 GHz | 峰值型 |

**結論**: ❌ 調整尺寸無法改變峰值特性

### 方案3：單邊控制

| 版本 | 控制方式 | 有效範圍 | 頻率範圍 | 曲線特性 |
|------|----------|----------|----------|----------|
| PMOS-Only | W=2.0μm | 0.7~1.2V | 0.77~4.68 GHz | 部分單調 |
| NMOS-Only | W=2.0μm | 0.65~1.8V | 1.04~4.28 GHz | 部分單調 |

**結論**: ⚠️ 在穩定區間內可獲得單調遞減曲線，但有不穩定區域

## 檔案結構

### 電路檔案

**基本VCO電路**:
- `vco_controlled.cir` - 原始雙邊控制版本
- `vco_pmos_only.cir` - PMOS單邊控制
- `vco_nmos_only.cir` - NMOS單邊控制

**尺寸調整版本**:
- `vco_size_tuned_v1.cir` - PMOS主導（W=3.0/0.42）
- `vco_size_tuned_v2.cir` - NMOS主導（W=0.42/3.0）
- `vco_size_tuned_v3.cir` - 極端PMOS（W=5.0/0.42）

**KVCO掃描電路**:
- `vco_kvco_sweep.cir` - 原始版本KVCO掃描
- `vco_kvco_sweep_v1/v2/v3.cir` - 尺寸調整版本掃描
- `vco_kvco_pmos_only.cir` - PMOS單邊掃描
- `vco_kvco_nmos_only.cir` - NMOS單邊掃描
- `vco_pmos_optimized.cir` - 優化PMOS控制（限制範圍）

### Python繪圖腳本

- `plot_kvco.py` - 基本KVCO曲線繪製
- `plot_all_versions.py` - 多版本比較繪製
- `plot_single_side.py` - 單邊控制比較繪製

### 執行腳本

- `run_vco_sim.sh` - 基本VCO模擬執行（互動式選單）
- `test_all_versions.sh` - 測試所有尺寸調整版本
- `test_single_side.sh` - 測試單邊控制版本

### 文檔

- `VCO使用說明.md` - 原始設計使用說明
- `VCO設計指南.md` - 本文檔
- `VCO測試結果總結.md` - 詳細測試結果
- `vco_design_options.md` - 設計選項與調整指南

## 快速開始

### 1. 執行基本VCO模擬

```bash
./run_vco_sim.sh
```

選擇：
1. 基本VCO模擬 (固定Vctrl=0.9V)
2. KVCO曲線掃描
3. 執行全部模擬
4. 僅繪製KVCO曲線圖

### 2. 測試尺寸調整版本

```bash
./test_all_versions.sh
```

生成檔案：
- `vco_versions_comparison.png` - 版本比較圖
- `vco_kvco_v1/v2/v3_plot.png` - 各版本獨立圖

### 3. 測試單邊控制版本

```bash
./test_single_side.sh
```

生成檔案：
- `vco_single_side_comparison.png` - 單邊控制比較
- `vco_kvco_pmos_only_plot.png` - PMOS單邊曲線
- `vco_kvco_nmos_only_plot.png` - NMOS單邊曲線

## 設計參數調整

### 改變頻率範圍

修改反向器電晶體尺寸：
```spice
* 增大W → 提高頻率
XM_n out in 0 0 nfet L=0.15 W=0.84  (原本0.42)
XM_p out in vdd vdd pfet L=0.15 W=1.68  (原本0.84)
```

### 改變控制範圍

修改控制電晶體尺寸：
```spice
* 增大W → 增強控制能力
XM_ctrl_p vdd_inv vctrl vdd vdd pfet L=0.15 W=4.0  (原本2.0)
```

### 改善穩定性

增加通道長度：
```spice
* 增大L → 更穩定，但速度較慢
XM_ctrl_p vdd_inv vctrl vdd vdd pfet L=0.5 W=4.0  (L從0.15改為0.5)
```

## 已知問題與限制

### 1. 雙邊控制的峰值問題

**現象**: 所有雙邊控制版本都呈現峰值型曲線

**原因**: 在中間電壓時，PMOS和NMOS同時在最佳工作點

**解決方案**: 改用單邊控制或current-starved設計

### 2. 單邊控制的不穩定區域

**現象**: 在極低Vctrl（<0.7V）時頻率異常跳動

**原因**:
- 控制電晶體在線性區/飽和區轉換
- 接近振盪器臨界條件
- 寄生效應影響

**解決方案**:
- 限制工作範圍（0.7V-1.2V）
- 使用較長通道長度（L=0.5μm）
- 添加偏壓電路

### 3. 控制範圍限制

**現象**: 可用控制範圍較小（約0.5V）

**原因**: 避開不穩定區域後剩餘範圍有限

**解決方案**:
- 採用專業的current-starved設計
- 使用差動對控制
- 添加bias電路擴展範圍

## 建議的改進方向

### 短期改進（立即可用）

1. **限制工作範圍**
   - 使用PMOS-Only的0.7V-1.2V穩定區間
   - 獲得可靠的單調遞減曲線

2. **調整控制電晶體**
   - 測試L=0.5μm提高穩定性
   - 測試不同W值優化頻率範圍

### 中期改進（需要重新設計）

1. **Current-Starved設計**
   - 使用電流源限制反向器電流
   - 更好的線性度和控制範圍

2. **添加偏壓電路**
   - 電阻分壓或電流鏡提供穩定偏壓
   - 改善低電壓區穩定性

### 長期改進（專業級）

1. **差動對控制**
   - 使用差動對產生控制電流
   - 最佳線性度

2. **PVT補償**
   - 添加製程/電壓/溫度補償電路
   - 確保不同條件下的穩定性

## 參考資料

- SkyWater 130nm PDK 文檔
- `new_vco.odt` - 原始設計需求
- `Three stage cmos ring oscillator.pdf` - 理論背景
- `vco_design_options.md` - 詳細設計選項

## 版本歷史

- **v1.0** - 原始雙邊控制設計
- **v1.1** - 添加KVCO掃描功能
- **v2.0** - 方案4尺寸調整測試
- **v2.1** - 方案3單邊控制測試
- **v2.2** - 文檔完善與整理

---

**最後更新**: 2025-10-05
**作者**: Claude Code with Jimmy
**專案**: Three-stage CMOS Ring Oscillator VCO
