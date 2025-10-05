# Xschem 電路圖使用說明

## 檔案位置
- **電路圖檔案**: `vco_dual_bias.sch`

## 如何查看電路圖

### 方法 1: 在圖形介面中打開
```bash
cd /home/jimmy/project/vco/Three-stage-CMOS-ring-oscillator
xschem vco_dual_bias.sch
```

這會打開一個圖形視窗，顯示完整的電路圖，包括：
- 3 個 Inverter stage
- 每個 stage 的 PMOS/NMOS 控制電晶體
- 所有的連線和標籤
- 電源供應和偏壓源

### 方法 2: 匯出成 PDF
```bash
xschem --pdf vco_dual_bias.sch
```
會產生 `vco_dual_bias.pdf`

### 方法 3: 匯出成 PNG
```bash
xschem --png vco_dual_bias.sch
```
會產生 `vco_dual_bias.png`

### 方法 4: 從 Xschem 產生 netlist
在 Xschem 中打開後，按 `Netlist` 按鈕可以產生 SPICE netlist

## 電路架構

電路包含以下部分：

### 電源和控制
- `Vdd`: 1.8V 電源
- `Vbias_p`: PMOS 控制電壓 (0.6~1.2V)
- `Vbias_n`: NMOS 控制電壓 (0.6~1.2V)

### Stage 1 (Inverter 1)
- `M1_ctrl_p`: PMOS 控制電晶體 (W=2.0μm)
- `M1_ctrl_n`: NMOS 控制電晶體 (W=1.0μm)
- `M1_p`: Inverter PMOS (W=0.84μm)
- `M1_n`: Inverter NMOS (W=0.42μm)
- 輸入: `in1`
- 輸出: `out1`

### Stage 2 (Inverter 2)
- `M2_ctrl_p`, `M2_ctrl_n`: 控制電晶體
- `M2_p`, `M2_n`: Inverter 電晶體
- 輸入: `out1`
- 輸出: `out2`

### Stage 3 (Inverter 3)
- `M3_ctrl_p`, `M3_ctrl_n`: 控制電晶體
- `M3_p`, `M3_n`: Inverter 電晶體
- 輸入: `out2`
- 輸出: `in1` (回授到 Stage 1)

## Xschem 快捷鍵

在 Xschem 中：
- `f`: 全畫面顯示 (fit to window)
- `z`: 放大
- `Shift+z`: 縮小
- `q`: 顯示屬性
- `e`: 編輯元件
- `Netlist`: 產生 netlist
- `Simulate`: 執行模擬

## 注意事項

1. 確保 SkyWater PDK 已正確安裝
2. 環境變數 `SKYWATER_MODELS` 和 `SKYWATER_STDCELLS` 需要正確設定
3. 如果要修改電路，可以直接在 Xschem 中編輯

## 替代方案

如果無法使用 Xschem 的圖形介面，您也可以：
1. 查看 `vco_dual_bias_schematic.txt` - ASCII 文字版電路圖
2. 查看 `vco_dual_bias.cir` - SPICE netlist
3. 使用在線工具匯入 .cir 檔案繪製電路圖

## 從 Xschem 產生的電路圖內容

電路圖會顯示：
- 完整的 3-stage ring oscillator
- 每個 stage 的雙 bias 控制結構
- 所有電晶體及其參數 (W, L)
- 訊號節點標籤
- 電源和地線連接
- 回授路徑 (in1 → out1 → out2 → in1)
