# VCO設計版本說明

## 概述

本專案包含多個VCO（電壓控制振盪器）設計版本，用於探索不同的KVCO特性曲線。所有設計基於SkyWater 130nm PDK的三級CMOS環形振盪器。

## 設計版本一覽

### 1. 原始雙邊控制設計

**檔案**: `vco_controlled.cir`

**特點**:
- 每個反向器使用PMOS和NMOS雙邊控制
- PMOS控制: W=1.0μm, NMOS控制: W=0.5μm
- 控制範圍: 0.6V - 1.3V
- 頻率範圍: 0.055 GHz ~ 1.11 GHz
- **曲線特性**: 峰值型（先升後降）

**使用**:
```bash
ngspice -b vco_controlled.cir -o output.txt
```

---

### 2. 尺寸調整版本（方案4測試）

#### V1: PMOS主導
**檔案**: `vco_size_tuned_v1.cir`, `vco_kvco_sweep_v1.cir`

**特點**:
- PMOS控制: W=3.0μm (增強)
- NMOS控制: W=0.42μm (減弱)
- 頻率範圍: 0.055 GHz ~ 1.67 GHz
- **曲線特性**: 峰值型

#### V2: NMOS主導
**檔案**: `vco_size_tuned_v2.cir`, `vco_kvco_sweep_v2.cir`

**特點**:
- PMOS控制: W=0.42μm (減弱)
- NMOS控制: W=3.0μm (增強)
- 頻率範圍: 0.052 GHz ~ 1.63 GHz
- **曲線特性**: 峰值型

#### V3: 極端PMOS主導
**檔案**: `vco_size_tuned_v3.cir`, `vco_kvco_sweep_v3.cir`

**特點**:
- PMOS控制: W=5.0μm (極大)
- NMOS控制: W=0.42μm (極小)
- 頻率範圍: 0.055 GHz ~ 1.72 GHz
- **曲線特性**: 峰值型

**批次測試**:
```bash
./test_all_versions.sh
```

**結論**: 調整尺寸比例無法改變峰值特性

---

### 3. 單邊控制設計（方案3測試）

#### PMOS-Only控制
**檔案**: `vco_pmos_only.cir`, `vco_kvco_pmos_only.cir`

**特點**:
- 只使用PMOS控制電晶體 (W=2.0μm)
- NMOS側直接接地
- 控制邏輯: **Vctrl ↑ → 頻率 ↓**
- 穩定範圍: 0.7V - 1.2V
- 頻率範圍: 0.77 GHz ~ 4.68 GHz
- **曲線特性**: 在穩定區間內單調遞減

**電路結構**:
```spice
* 每個反向器
XM_ctrl_p vdd_inv vctrl vdd vdd pfet W=2.0
XM_n out in 0 0 nfet            (直接接地)
XM_p out in vdd_inv vdd pfet
```

#### NMOS-Only控制
**檔案**: `vco_nmos_only.cir`, `vco_kvco_nmos_only.cir`

**特點**:
- 只使用NMOS控制電晶體 (W=2.0μm)
- PMOS側直接接Vdd
- 控制邏輯: **Vctrl ↑ → 頻率 ↑**
- 穩定範圍: 0.65V - 1.8V
- 頻率範圍: 1.04 GHz ~ 4.28 GHz
- **曲線特性**: 在穩定區間內單調上升

**電路結構**:
```spice
* 每個反向器
XM_ctrl_n gnd_inv vctrl 0 0 nfet W=2.0
XM_n out in gnd_inv 0 nfet
XM_p out in vdd vdd pfet        (直接接Vdd)
```

**批次測試**:
```bash
./test_single_side.sh
```

**結論**: 在穩定區間內可獲得單調曲線，但有不穩定區域

---

### 4. 優化版本

#### PMOS優化控制
**檔案**: `vco_pmos_optimized.cir`

**特點**:
- PMOS控制: W=4.0μm (增大提高穩定性)
- 限制掃描範圍: 0.4V - 1.8V
- 避開極低電壓的不穩定區域

---

## 測試腳本說明

### run_vco_sim.sh
**功能**: 互動式執行基本VCO模擬

**選項**:
1. 基本VCO模擬 (固定Vctrl=0.9V)
2. KVCO曲線掃描
3. 執行全部模擬
4. 僅繪製KVCO曲線圖

### test_all_versions.sh
**功能**: 批次測試所有尺寸調整版本

**生成**:
- `vco_kvco_v1/v2/v3_results.csv` - 各版本數據
- `vco_versions_comparison.png` - 比較圖
- `vco_kvco_v1/v2/v3_plot.png` - 獨立曲線圖

### test_single_side.sh
**功能**: 批次測試單邊控制版本

**生成**:
- `vco_kvco_pmos_only_results.csv` - PMOS控制數據
- `vco_kvco_nmos_only_results.csv` - NMOS控制數據
- `vco_single_side_comparison.png` - 比較圖

---

## Python繪圖腳本

### plot_kvco.py
基本KVCO曲線繪製，支援中文字型

**使用**:
```bash
python3 plot_kvco.py [input.csv] [output.png]
```

### plot_all_versions.py
繪製多個版本的比較圖

**功能**:
- 同時顯示所有版本
- 獨立繪製每個版本
- 自動判斷曲線單調性

### plot_single_side.py
繪製單邊控制版本的比較

**功能**:
- PMOS vs NMOS比較
- 單調性分析
- 穩定區間標示

---

## 選擇指南

### 需要單調遞減曲線
→ **使用 PMOS-Only控制**
- 檔案: `vco_pmos_only.cir`
- 建議範圍: 0.7V - 1.2V
- 特性: Vctrl ↑ → 頻率 ↓

### 需要單調上升曲線
→ **使用 NMOS-Only控制**
- 檔案: `vco_nmos_only.cir`
- 建議範圍: 0.65V - 1.8V
- 特性: Vctrl ↑ → 頻率 ↑

### 需要最高頻率範圍
→ **使用極端PMOS主導 (V3)**
- 檔案: `vco_size_tuned_v3.cir`
- 頻率: 最高可達1.72 GHz
- 注意: 峰值型曲線

### 研究目的/教學
→ **測試所有版本並比較**
```bash
./test_all_versions.sh
./test_single_side.sh
```

---

## 已知限制

1. **雙邊控制必定產生峰值**
   - 原因: 中間電壓時兩側同時最佳
   - 無法通過調整尺寸消除

2. **單邊控制有不穩定區**
   - 極低Vctrl時頻率跳動
   - 建議避開<0.7V區域

3. **控制範圍受限**
   - 穩定區間約0.5V - 1.0V
   - 需要更大範圍請考慮專業設計

---

## 下一步改進方向

### 短期（立即可實作）
- [ ] 限制工作範圍使用穩定區間
- [ ] 測試L=0.5μm提高穩定性
- [ ] 優化控制電晶體寬度

### 中期（需重新設計）
- [ ] Current-starved設計
- [ ] 添加偏壓電路
- [ ] 多段控制切換

### 長期（專業級）
- [ ] 差動對控制
- [ ] PVT補償
- [ ] 自動校準電路

---

## 參考文件

- `VCO設計指南.md` - 完整設計說明
- `VCO測試結果總結.md` - 詳細測試數據
- `VCO使用說明.md` - 原始設計說明
- `vco_design_options.md` - 調整選項指南

---

**版本**: v2.2
**日期**: 2025-10-05
**狀態**: 準備提交至 vco-nori 分支
