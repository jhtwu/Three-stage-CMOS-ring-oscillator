# VCO設計選項與KVCO曲線調整指南

## 目前結果 vs 預期結果

### 預期的KVCO曲線特性 (參考文件)
- **形狀**: 單調遞減
- **起始**: Vctrl=0V時頻率最高 (~1.5 GHz)
- **結束**: Vctrl=1.8V時頻率最低 (~750 MHz)
- **特點**: 當控制電壓增加，頻率線性下降

### 目前的KVCO曲線特性
- **形狀**: 先上升後下降（峰值型）
- **峰值**: 在Vctrl≈0.9V達到最高頻率
- **有效範圍**: 0.6V-1.3V
- **問題**: 不是單調遞減

## 問題分析

目前電路使用的是**對稱控制**方式:
```
PMOS控制: 閘極連到Vctrl → Vctrl↑時，PMOS阻抗↑
NMOS控制: 閘極連到Vctrl → Vctrl↑時，NMOS阻抗↓
```

這導致在中間電壓有最佳工作點，形成峰值。

## 調整方案

### 方案1: Starved Inverter (電流限制型) - 推薦
**原理**: 用NMOS電流源限制反向器的下拉電流
- Vctrl ↑ → 電流源導通更多 → 更多電流 → 速度更快 → 頻率更高（或相反設計）

**優點**:
- 可產生單調曲線
- 線性度較好
- 控制範圍大

**電路修改**:
```spice
* 方式A: NMOS作為電流源（Vctrl高→頻率低）
XM_ctrl source vctrl 0 0 nfet W=1.0 L=0.15
XM_inv_n drain input source 0 nfet W=0.42 L=0.15

* 方式B: NMOS作為電流源（Vctrl高→頻率高）
* 需要使用反向電壓或bias電路
```

### 方案2: 改變控制電壓範圍
**簡單調整**: 只使用曲線的下降部分
- 目前: 0.6V - 1.3V (完整峰值)
- 改為: 0.9V - 1.3V (只用下降段)

**修改方式**:
在 `vco_kvco_sweep.cir` 中:
```spice
foreach vctrl_val 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6
```

**優點**:
- 不用改電路
- 立即可用

**缺點**:
- 控制範圍小
- 不是從0V開始

### 方案3: 單邊控制（只用PMOS或NMOS）
**原理**: 只在一側加控制電晶體

**A. 只用PMOS控制 (Vctrl高→頻率低)**
```spice
* PMOS控制電晶體（Vdd到反向器電源）
XM_ctrl_p vdd_inv vctrl vdd vdd pfet L=0.15 W=2.0

* 標準反向器，電源由控制電晶體供應
XM_p out in vdd_inv vdd pfet L=0.15 W=0.84
XM_n out in 0 0 nfet L=0.15 W=0.42
```

**B. 只用NMOS控制 (Vctrl高→頻率高)**
```spice
* NMOS控制電晶體（接地到反向器接地）
XM_ctrl_n gnd_inv vctrl 0 0 nfet L=0.15 W=2.0

* 標準反向器，接地由控制電晶體控制
XM_p out in vdd vdd pfet L=0.15 W=0.84
XM_n out in gnd_inv 0 nfet L=0.15 W=0.42
```

### 方案4: 調整電晶體尺寸比例

**目前尺寸**:
```spice
PMOS控制: W=1.0μm
NMOS控制: W=0.5μm
```

**調整建議**:

**A. 加大PMOS控制，減小NMOS控制**
```spice
PMOS控制: W=3.0μm (加大影響)
NMOS控制: W=0.2μm (減小影響)
```
→ 讓PMOS主導，可能改善曲線形狀

**B. 反之**
```spice
PMOS控制: W=0.2μm
NMOS控制: W=3.0μm
```
→ 讓NMOS主導

### 方案5: 差動控制（互補電壓）

使用兩個控制電壓: Vctrl 和 Vctrl_bar (=VDD-Vctrl)

```spice
* 產生互補電壓
Vctrl vctrl 0 DC 0.9
Ectrl_bar vctrl_bar 0 vdd vctrl 1

* PMOS用Vctrl，NMOS用Vctrl_bar
XM_ctrl_p vdd_inv vctrl vdd vdd pfet W=1.0
XM_ctrl_n gnd_inv vctrl_bar 0 0 nfet W=1.0
```

這樣當Vctrl增加時:
- PMOS阻抗增加
- NMOS阻抗也增加（因為vctrl_bar減少）
- 兩者同向變化

## 推薦實作步驟

### 立即可試（方案2）
1. 修改掃描範圍為0.9V-1.6V（只用下降段）
2. 重新執行模擬
3. 觀察是否更接近單調下降

### 中期改善（方案3）
1. 建立只用PMOS控制的版本
2. 調整尺寸達到合適的頻率範圍
3. 驗證單調性

### 完整重設計（方案1）
1. 實作current-starved inverter
2. 使用適當的偏壓電路
3. 達到最佳線性度

## 參數調整快速參考

| 參數 | 增加效果 | 減少效果 |
|------|---------|---------|
| PMOS控制寬度 | 更大控制範圍 | 更小控制範圍 |
| NMOS控制寬度 | 更大控制範圍 | 更小控制範圍 |
| 反向器PMOS寬度 | 更高頻率 | 更低頻率 |
| 反向器NMOS寬度 | 更高頻率 | 更低頻率 |
| 控制電晶體L | 更好控制性 | 更快速度 |

## 下一步建議

1. **快速驗證**: 先試方案2，只用0.9V-1.6V範圍
2. **如果需要完整範圍**: 試方案3的單邊控制
3. **如果需要最佳性能**: 重新設計為方案1的current-starved結構

您想要先試哪個方案？
