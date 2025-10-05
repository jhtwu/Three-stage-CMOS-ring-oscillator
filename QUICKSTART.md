# VCO快速開始指南

## 前置需求

1. **ngspice** (v42或更新版本)
2. **Python 3** with matplotlib, pandas, numpy
3. **SkyWater 130nm PDK** 安裝於 `/opt/pdk`

## 5分鐘快速測試

### 1. 基本VCO測試（最快）

```bash
# 執行互動式模擬腳本
./run_vco_sim.sh
```

選擇選項 **1** (基本VCO模擬)

**預期結果**:
```
控制電壓 Vctrl = 0.9V
period = 9.001298e-10
freq_mhz = 1.110951e+03
```

### 2. KVCO曲線測試

```bash
# 在互動式選單選擇選項 2
./run_vco_sim.sh  # 選擇 2

# 或直接執行
ngspice -b vco_kvco_sweep.cir -o output.txt
python3 plot_kvco.py
```

**預期生成**:
- `vco_kvco_results.csv` - 數據
- `vco_kvco_plot.png` - 曲線圖

### 3. 比較所有設計

```bash
# 測試所有尺寸調整版本（約5-10分鐘）
./test_all_versions.sh

# 測試單邊控制版本（約5-10分鐘）
./test_single_side.sh
```

---

## 常見使用場景

### 場景A: 我需要單調遞減的KVCO曲線

**推薦**: PMOS-Only控制

```bash
# 1. 執行模擬
ngspice -b vco_kvco_pmos_only.cir -o pmos_output.txt

# 2. 繪製曲線
python3 plot_single_side.py

# 3. 查看結果
# 檔案: vco_kvco_pmos_only_plot.png
```

**特性**:
- 控制範圍: 0.7V - 1.2V (穩定區)
- 頻率範圍: 0.77 ~ 4.68 GHz
- 曲線: 單調遞減 (Vctrl ↑ → 頻率 ↓)

### 場景B: 我需要比較不同設計

```bash
# 一次執行所有測試
./test_all_versions.sh && ./test_single_side.sh

# 查看比較圖
# - vco_versions_comparison.png (尺寸調整版本)
# - vco_single_side_comparison.png (單邊控制)
```

### 場景C: 我要自訂參數

1. 複製電路檔案:
```bash
cp vco_pmos_only.cir my_vco.cir
```

2. 編輯 `my_vco.cir`:
```spice
* 修改控制電晶體寬度
XM1_ctrl_p vdd_inv1 vctrl vdd vdd pfet L=0.15 W=3.0  (改這裡)

* 修改控制電壓
Vctrl vctrl 0 DC 1.0  (改這裡)
```

3. 執行:
```bash
ngspice -b my_vco.cir -o my_output.txt
```

---

## 檔案快速參考

### 推薦使用的電路

| 需求 | 檔案 | 特性 |
|------|------|------|
| 單調遞減 | `vco_pmos_only.cir` | Vctrl ↑ → 頻率 ↓ |
| 單調上升 | `vco_nmos_only.cir` | Vctrl ↑ → 頻率 ↑ |
| 最高頻率 | `vco_size_tuned_v3.cir` | 峰值1.72 GHz |
| 教學比較 | 全部 | 執行測試腳本 |

### 主要輸出檔案

| 檔案 | 說明 |
|------|------|
| `*.raw` | ngspice原始波形數據 |
| `*_results.csv` | KVCO掃描數據（CSV格式）|
| `*_plot.png` | KVCO曲線圖 |
| `*_output.txt` | 模擬日誌 |

---

## 常見問題排除

### Q: 找不到PDK檔案

**錯誤訊息**:
```
Error: Could not find library file .../sky130.lib.spice
```

**解決方法**:
```bash
# 檢查PDK安裝位置
ls /opt/pdk/sky130A/libs.tech/ngspice/

# 如果在其他位置，編輯.cir檔案第一行
# 將 /opt/pdk 改為實際路徑
```

### Q: Python繪圖中文亂碼

**解決方法**:
```bash
# 腳本已包含中文字型設定
# 如果仍有問題，安裝Noto字型
sudo apt-get install fonts-noto-cjk
```

### Q: 振盪器無法起振

**檢查事項**:
1. 控制電壓是否在有效範圍內（0.7V-1.2V）
2. 初始條件是否正確設定
3. 模擬時間是否足夠長（建議300ns）

**解決方法**:
```spice
* 確認初始條件
.ic v(in1)=0 v(out1)=1.8 v(out2)=0

* 延長模擬時間
.tran 0.1n 500n  (從300n改為500n)
```

### Q: 頻率量測失敗

**錯誤訊息**:
```
Error: measure t1 when(WHEN) : out of interval
```

**原因**: 在該電壓下無法穩定振盪

**解決方法**:
- 避開極低/極高控制電壓
- PMOS-Only: 使用0.7V-1.2V
- NMOS-Only: 使用0.65V-1.8V

---

## 效能提示

### 加速模擬

```bash
# 使用較大的時間步長（降低精度但更快）
.tran 0.2n 300n  (從0.1n改為0.2n)

# 減少掃描點數
foreach vctrl_val 0.7 0.8 0.9 1.0 1.1 1.2  (只用6個點)
```

### 批次處理

```bash
# 平行執行多個模擬
ngspice -b vco_v1.cir -o out1.txt &
ngspice -b vco_v2.cir -o out2.txt &
ngspice -b vco_v3.cir -o out3.txt &
wait
```

---

## 下一步

### 深入學習
- 閱讀 `VCO設計指南.md` 了解設計原理
- 閱讀 `VCO測試結果總結.md` 了解測試結論
- 閱讀 `README_VCO_DESIGNS.md` 了解所有版本

### 進階調整
- 閱讀 `vco_design_options.md` 了解調整選項
- 修改電晶體尺寸優化性能
- 實作current-starved設計

### 貢獻
- 報告問題或建議
- 分享你的設計變體
- 改進文檔

---

**需要幫助?**
- 查看詳細文檔在專案根目錄
- 檢查 `VCO使用說明.md`
- 查看原始需求文件 `new_vco.odt`

**最後更新**: 2025-10-05
