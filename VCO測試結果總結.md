# VCO KVCO曲線調整測試結果總結

## 目標
獲得單調遞減的KVCO曲線，類似參考文件中的綠色曲線。

## 測試的方案

### 方案4: 電晶體尺寸調整（雙邊控制）

**測試版本**:
1. **原始版本**: PMOS=1.0μm, NMOS=0.5μm
2. **V1 (PMOS主導)**: PMOS=3.0μm, NMOS=0.42μm
3. **V2 (NMOS主導)**: PMOS=0.42μm, NMOS=3.0μm
4. **V3 (極端PMOS)**: PMOS=5.0μm, NMOS=0.42μm

**結果**: ❌ 全部失敗
- 所有版本都呈現**峰值型曲線**（先上升後下降）
- 調整尺寸比例無法改變這個本質特性
- 峰值頻率範圍: 1.11 ~ 1.72 GHz

**原因**:
雙邊控制（同時使用PMOS和NMOS）會在中間電壓產生最佳工作點：
- 低Vctrl: PMOS導通好 + NMOS導通差 → 中等速度
- 中Vctrl: PMOS和NMOS都在最佳點 → **最高速度（峰值）**
- 高Vctrl: PMOS導通差 + NMOS導通好 → 中等速度

### 方案3: 單邊控制

**測試版本**:
1. **PMOS-Only**: 只使用PMOS控制電晶體（W=2.0μm）
2. **NMOS-Only**: 只使用NMOS控制電晶體（W=2.0μm）

**結果**: ❌ 部分失敗
- PMOS-Only在**0.2-0.6V區間有不穩定現象**（頻率異常跳動）
- 在穩定區間（0.7V-1.2V）確實呈現遞減趨勢
- NMOS-Only也有類似問題

**觀察到的問題**:
```
Vctrl    Frequency
0.4V  →  3.80 GHz
0.45V →  5.07 GHz  ← 異常上升
0.5V  →  5.05 GHz
0.55V →  5.00 GHz
0.6V  →  3.34 GHz  ← 異常下降
0.65V →  4.82 GHz  ← 異常上升
0.7V  →  4.68 GHz
...   →  持續下降 ✓
```

## 分析與建議

### 為什麼會有異常跳動？

1. **電晶體工作區域轉換**
   - 極低Vctrl時，控制電晶體可能在線性區和飽和區之間切換
   - 造成阻抗突然變化

2. **振盪器啟動條件**
   - 某些電壓點可能接近振盪器的臨界條件
   - 小的參數變化就導致大的頻率變化

3. **寄生效應**
   - 在極端工作條件下，寄生電容/電阻的影響變大

### 改進建議

#### 選項A: 限制工作範圍（最簡單）

只使用**穩定的電壓範圍**，例如PMOS-Only的0.7V-1.2V區間：

```spice
* 修改掃描範圍
foreach vctrl_val 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2
```

**優點**:
- 立即可用
- 在此範圍內確實是單調遞減

**缺點**:
- 控制範圍較小（0.7V-1.2V = 0.5V範圍）
- 不是從0V開始

#### 選項B: 使用更長的通道長度

增加控制電晶體的L來改善穩定性：

```spice
* 改用L=0.5um提高穩定性
XM_ctrl_p vdd_inv vctrl vdd vdd pfet L=0.5 W=4.0
```

**優點**:
- 更穩定的工作特性
- 更好的線性度

**缺點**:
- 頻率範圍可能降低

#### 選項C: 添加偏壓電路

使用電阻分壓或電流鏡提供穩定的偏壓：

```spice
* 添加偏壓電阻
Rbias1 vctrl vbias 10k
Rbias2 vbias 0 10k
* 使用vbias作為實際控制電壓
```

#### 選項D: 改用差動對控制（專業方案）

使用差動對來控制電流：

```spice
* 差動對電流控制
XM_diff1 itail vctrl vdd vdd pfet
XM_diff2 itail vctrl_bar vdd vdd pfet
* itail供應給反向器
```

## 實際建議的實作順序

### 1. 立即可用方案（選項A）
修改`vco_kvco_pmos_only.cir`，限制掃描範圍為0.7V-1.2V，可立即獲得單調遞減曲線。

### 2. 改進方案（選項B）
測試L=0.5um的控制電晶體，看是否能擴大穩定範圍。

### 3. 完整重設計（選項D）
如果需要完整的0V-1.8V控制範圍且高線性度，建議採用current-starved設計。

## 生成的檔案清單

### 電路檔案
- `vco_controlled.cir` - 原始雙邊控制版本
- `vco_size_tuned_v1/v2/v3.cir` - 尺寸調整版本
- `vco_pmos_only.cir` - PMOS單邊控制
- `vco_nmos_only.cir` - NMOS單邊控制
- `vco_pmos_optimized.cir` - 優化版PMOS控制

### 掃描電路
- `vco_kvco_sweep.cir` - 原始版本掃描
- `vco_kvco_sweep_v1/v2/v3.cir` - 尺寸調整版本掃描
- `vco_kvco_pmos_only.cir` - PMOS單邊掃描
- `vco_kvco_nmos_only.cir` - NMOS單邊掃描

### 結果與圖表
- `vco_versions_comparison.png` - 尺寸調整版本比較
- `vco_single_side_comparison.png` - 單邊控制比較
- `vco_kvco_plot.png` - 原始KVCO曲線
- `vco_kvco_v1/v2/v3_plot.png` - 各版本曲線圖

### 腳本
- `test_all_versions.sh` - 測試所有尺寸調整版本
- `test_single_side.sh` - 測試單邊控制版本
- `plot_kvco.py` - KVCO曲線繪製腳本
- `plot_all_versions.py` - 版本比較繪製
- `plot_single_side.py` - 單邊控制繪製

## 結論

**方案4（尺寸調整）**: 無法消除峰值特性

**方案3（單邊控制）**: 在特定電壓範圍內可獲得單調遞減曲線，但有穩定性問題

**推薦下一步**:
1. 使用選項A限制工作範圍（最快）
2. 或測試選項B改用較長通道長度
3. 或考慮採用current-starved專業設計（方案1）

您想要選擇哪個選項繼續？
