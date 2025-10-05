# 電壓控制環形振盪器 (VCO) 使用說明

## 概述

本專案實現了一個三級CMOS環形振盪器VCO，每個反向器都加入了PMOS/NMOS控制電晶體來調整電源供應，從而實現電壓控制的振盪頻率。

## 電路特點

- **電路架構**: 三級環形振盪器 (Ring Oscillator)
- **控制方式**: 通過Vctrl電壓控制每個反向器的電源供應
- **製程技術**: SkyWater 130nm PDK
- **電源電壓**: VDD = 1.8V
- **控制電壓範圍**: 0.6V ~ 1.3V (有效振盪範圍)
- **頻率範圍**: 約 55 MHz ~ 1.11 GHz

## 檔案說明

### 電路檔案
- `vco_controlled.cir` - 基本VCO電路 (固定Vctrl=0.9V)
- `vco_kvco_sweep.cir` - KVCO特性掃描電路

### 腳本檔案
- `run_vco_sim.sh` - 模擬執行腳本 (推薦使用)
- `plot_kvco.py` - KVCO曲線繪製腳本

### 輸出檔案
- `vco_controlled.raw` - 基本模擬波形數據
- `vco_controlled_output.txt` - 基本模擬輸出日誌
- `vco_kvco_results.csv` - KVCO掃描數據
- `vco_kvco_plot.png` - KVCO特性曲線圖

## 快速開始

### 方法1: 使用執行腳本 (推薦)

```bash
./run_vco_sim.sh
```

然後選擇要執行的模擬:
1. 基本VCO模擬 (快速測試)
2. KVCO曲線掃描 (完整特性分析)
3. 執行全部模擬
4. 僅繪製KVCO曲線圖

### 方法2: 手動執行

#### 基本VCO模擬
```bash
ngspice -b vco_controlled.cir -o vco_controlled_output.txt
```

#### KVCO曲線掃描
```bash
ngspice -b vco_kvco_sweep.cir -o vco_kvco_sweep_output.txt
python3 plot_kvco.py
```

## 電路設計

### 電路拓撲

每個反向器單元包含:
1. **PMOS控制電晶體** (W=1.0μm, L=0.15μm)
   - 連接VDD到反向器電源
   - 閘極由Vctrl控制

2. **NMOS控制電晶體** (W=0.5μm, L=0.15μm)
   - 連接反向器接地到GND
   - 閘極由Vctrl控制

3. **標準CMOS反向器**
   - PMOS: W=0.84μm, L=0.15μm
   - NMOS: W=0.42μm, L=0.15μm

### 工作原理

- 當Vctrl增加時，PMOS控制電晶體阻抗增加，NMOS控制電晶體阻抗減小
- 這會改變反向器的有效電源電壓和驅動能力
- 從而改變延遲時間和振盪頻率

## 模擬結果

### 基本VCO模擬 (Vctrl = 0.9V)
- **振盪頻率**: 約 1.11 GHz
- **振盪週期**: 約 0.9 ns
- **模擬時間**: 300 ns

### KVCO特性曲線

KVCO曲線顯示頻率vs控制電壓的關係:

- **有效控制範圍**: 0.6V ~ 1.3V
- **峰值頻率**: 約 1.11 GHz (在Vctrl ≈ 0.9-0.95V)
- **曲線特性**: 先上升後下降 (符合理論預期)

曲線形狀解釋:
1. **低Vctrl區 (0.6V-0.9V)**: 頻率隨電壓增加而上升
2. **峰值區 (0.9V-0.95V)**: 達到最高頻率
3. **高Vctrl區 (1.0V-1.3V)**: 頻率隨電壓增加而下降

這種特性與參考文獻中的綠色曲線形狀一致。

## 波形驗證

模擬中應確認以下三點:
1. **in1** - 穩定且規律的振盪
2. **out1** - 與in1相位差約120°
3. **out2** - 與out1相位差約120°

三個節點應該平均且穩定地振盪，形成環形振盪器的特徵。

## 設計參數調整

如果需要調整VCO特性，可以修改以下參數:

### 改變頻率範圍
在電路檔案中修改控制電晶體尺寸:
```spice
* PMOS控制電晶體
XM1_ctrl_p vdd_inv1 vctrl vdd vdd sky130_fd_pr__pfet_01v8 L=0.15 W=1.0

* NMOS控制電晶體
XM1_ctrl_n gnd_inv1 vctrl 0 0 sky130_fd_pr__nfet_01v8 L=0.15 W=0.5
```

增大W值 → 增加驅動能力 → 提高頻率
減小W值 → 降低驅動能力 → 降低頻率

### 改變控制範圍
在 `vco_kvco_sweep.cir` 中修改掃描範圍:
```spice
foreach vctrl_val 0.1 0.15 0.2 ... 1.7
```

## 故障排除

### 振盪器無法起振
- 檢查初始條件設定: `.ic v(in1)=0 v(out1)=1.8 v(out2)=0`
- 確認控制電壓在有效範圍內 (0.6V-1.3V)

### 量測失敗
- 增加模擬時間讓電路穩定
- 調整量測觸發的RISE數值 (目前使用RISE=10)

### 頻率過高/過低
- 調整控制電晶體尺寸
- 調整反向器電晶體尺寸

## 參考資料

- SkyWater 130nm PDK 文檔
- 三級CMOS環形振盪器理論
- new_vco.odt 中的設計規格

## 技術支援

如有問題，請檢查:
1. PDK安裝是否正確 (使用 `/opt/pdk`)
2. ngspice版本 (建議 v42 或更新)
3. Python matplotlib 是否安裝

---

**建立日期**: 2025-10-05
**電路版本**: v1.0
