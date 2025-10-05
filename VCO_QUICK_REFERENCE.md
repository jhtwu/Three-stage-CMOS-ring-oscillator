# VCO 快速參考指南

**最終設計**: 3-Stage Ring Oscillator with PMOS-only Control
**日期**: 2025-10-06

---

## 快速開始

### 1. 基本模擬

```bash
cd /home/jimmy/project/vco/Three-stage-CMOS-ring-oscillator
ngspice -b vco_circuit_jpg.cir -o output.txt
```

**預期結果** (Vctrl = 0.9V):
- Period ≈ 400 ps
- Frequency ≈ 2.5 GHz

### 2. KVCO 特性掃描

```bash
ngspice -b vco_kvco_circuit_jpg.cir -o kvco_output.txt
python3 plot_circuit_jpg.py
```

**輸出**:
- `vco_kvco_circuit_jpg_results.csv` - 數據
- `vco_circuit_jpg_plot.png` - 圖表

### 3. 查看電路圖

```bash
xschem vco_dual_bias.sch
```

---

## 電路規格

### 基本參數

| 參數 | 值 |
|------|------|
| 電源電壓 (Vdd) | 1.8 V |
| 控制電壓範圍 | 0.7 ~ 1.2 V (推薦) |
| 頻率範圍 | 0.25 ~ 3.68 GHz (推薦範圍) |
| Stage 數量 | 3 |
| PDK | SkyWater 130nm |

### 電晶體尺寸

| 元件 | 型號 | W (μm) | L (μm) |
|------|------|--------|--------|
| PMOS 控制 | pfet_01v8 | 2.0 | 0.15 |
| Inverter PMOS | pfet_01v8 | 0.84 | 0.15 |
| Inverter NMOS | nfet_01v8 | 0.42 | 0.15 |

---

## 性能總結

### KVCO 特性

**推薦工作範圍**: Vctrl = 0.7V ~ 1.2V

| Vctrl (V) | 頻率 (GHz) |
|-----------|-----------|
| 0.70 | 3.68 |
| 0.80 | 3.37 |
| 0.90 | 2.50 |
| 1.00 | 1.71 |
| 1.10 | 0.81 |
| 1.20 | 0.25 |

**特性**:
- ✓ 單調遞減
- ✓ 動態範圍 ~15:1
- ✓ 平均 KVCO ≈ -6.86 GHz/V

---

## 常用命令

### 模擬

```bash
# 基本模擬
ngspice -b vco_circuit_jpg.cir

# KVCO 掃描
ngspice -b vco_kvco_circuit_jpg.cir

# 互動模式
ngspice vco_circuit_jpg.cir
```

### 繪圖

```bash
# 生成 KVCO 曲線圖
python3 plot_circuit_jpg.py

# 查看圖表
xdg-open vco_circuit_jpg_plot.png
```

### 數據分析

```bash
# 查看 CSV 數據
cat vco_kvco_circuit_jpg_results.csv

# 過濾有效數據
grep -v "^$" vco_kvco_circuit_jpg_results.csv | grep -v "^Vctrl"
```

---

## 修改參數指南

### 調整控制電壓範圍

編輯 `vco_kvco_circuit_jpg.cir`:

```spice
* 修改掃描範圍
foreach vctrl_val 0.6 0.65 0.7 ... 1.3 1.35 1.4
```

### 調整電晶體尺寸

編輯 `vco_circuit_jpg.cir`:

```spice
* PMOS 控制電晶體 - 調整 W 改變控制強度
XM1_ctrl_p vdd_inv1 vctrl vdd vdd sky130_fd_pr__pfet_01v8 L=0.15 W=2.0

* Inverter PMOS - 調整 W/L 改變速度
XM1_p out1 in1 vdd_inv1 vdd sky130_fd_pr__pfet_01v8 L=0.15 W=0.84

* Inverter NMOS - 調整 W/L 改變速度
XM1_n out1 in1 0 0 sky130_fd_pr__nfet_01v8 L=0.15 W=0.42
```

**調整建議**:
- ↑ W (控制電晶體) → ↓ 控制靈敏度
- ↑ W (inverter) → ↑ 速度，↓ 延遲
- ↑ L → ↓ 速度，↑ 穩定性

### 改變 Stage 數量

修改 inverter 連接：
- 3-stage: in1 → out1 → out2 → in1 (目前)
- 5-stage: in1 → out1 → out2 → out3 → out4 → in1
- 7-stage: 以此類推

**效果**:
- ↑ Stage 數 → ↓ 最高頻率
- 奇數 stage 才能振盪

---

## 故障排除

### 問題 1: 電路無法起振

**症狀**: `measure ... out of interval`

**可能原因**:
1. 控制電壓超出範圍（太低或太高）
2. 初始條件設定錯誤
3. 電晶體尺寸不當

**解決方法**:
```spice
* 確認初始條件
.ic v(in1)=0 v(out1)=1.8 v(out2)=0

* 使用安全的控制電壓
Vctrl vctrl 0 DC 0.9  ; 在 0.7~1.2V 範圍內
```

### 問題 2: PDK 找不到

**症狀**: `Error: Could not find library file`

**解決方法**:
```bash
# 檢查 PDK 路徑
ls /opt/pdk/sky130A/libs.tech/ngspice/

# 確認 .cir 檔案第一行
.lib /opt/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt
```

### 問題 3: Xschem 找不到元件

**症狀**: `Symbol not found`

**解決方法**:
```bash
# 使用提供的啟動腳本
./run_xschem.sh

# 或設定環境變數
export XSCHEM_LIBRARY_PATH="/usr/share/xschem/xschem_library/devices:..."
```

### 問題 4: Python 繪圖中文亂碼

**症狀**: 圖表中文顯示為方框

**解決方法**:
```bash
# 安裝中文字型
sudo apt-get install fonts-noto-cjk

# 腳本已包含字型設定
plt.rcParams["font.family"] = "Noto Serif CJK JP"
```

---

## 檔案結構

```
Three-stage-CMOS-ring-oscillator/
├── vco_circuit_jpg.cir              # 最終電路設計
├── vco_kvco_circuit_jpg.cir         # KVCO 掃描電路
├── plot_circuit_jpg.py              # 繪圖腳本
├── vco_dual_bias.sch                # Xschem 電路圖
├── xschemrc                         # Xschem 配置
├── run_xschem.sh                    # Xschem 啟動腳本
├── VCO_EXPERIMENT_REPORT.md         # 完整實驗報告
├── VCO_QUICK_REFERENCE.md           # 本文件
├── vco_kvco_circuit_jpg_results.csv # 模擬數據
├── vco_circuit_jpg_plot.png         # KVCO 曲線圖
└── archive_old_experiments/         # 舊實驗檔案
```

---

## 重要公式

### 頻率計算

```
f = 1 / (2 × N × τ_inv)
```
其中:
- N = stage 數量 (本設計 = 3)
- τ_inv = 單個 inverter 延遲

### KVCO 計算

```
KVCO = df / dVctrl
```

在推薦範圍 (0.7~1.2V):
```
KVCO_avg ≈ (0.25 - 3.68) / (1.2 - 0.7) ≈ -6.86 GHz/V
```

### 功耗估算

```
P ≈ C_L × V_dd² × f
```
其中:
- C_L = 負載電容
- V_dd = 1.8V
- f = 振盪頻率

---

## 進階應用

### 整合到 PLL

```
VCO → Phase Detector → Loop Filter → VCO
                ↑                      ↓
            Reference              Vctrl
```

### 溫度補償

考慮添加 bandgap reference 提供穩定的 Vctrl。

### 功耗優化

- 降低 Vdd (需重新表徵)
- 減少 stage 數量的 W/L
- 使用 sleep mode

---

## 相關資源

### 文件
- 完整報告: `VCO_EXPERIMENT_REPORT.md`
- 電路圖說明: `vco_dual_bias_schematic.txt`

### 線上資源
- SkyWater PDK: https://skywater-pdk.readthedocs.io/
- ngspice Manual: https://ngspice.sourceforge.io/docs.html
- Xschem: https://xschem.sourceforge.io/

### 相關專案
- 原始專案: Three-stage-CMOS-ring-oscillator
- Branch: pdk-env-support

---

**最後更新**: 2025-10-06
**版本**: 1.0
**維護者**: Jimmy
