# Commit檢查清單 - vco-nori分支

## 準備提交的檔案

### ✅ 新增的電路檔案（必須提交）

**基本VCO**:
- [ ] `vco_controlled.cir` - 原始雙邊控制設計
- [ ] `vco_pmos_only.cir` - PMOS單邊控制
- [ ] `vco_nmos_only.cir` - NMOS單邊控制

**尺寸調整版本**:
- [ ] `vco_size_tuned_v1.cir` - V1: PMOS主導
- [ ] `vco_size_tuned_v2.cir` - V2: NMOS主導
- [ ] `vco_size_tuned_v3.cir` - V3: 極端PMOS
- [ ] `vco_improved.cir` - 改良版（如果需要）
- [ ] `vco_pmos_optimized.cir` - 優化PMOS

**KVCO掃描電路**:
- [ ] `vco_kvco_sweep.cir` - 原始版本掃描
- [ ] `vco_kvco_sweep_v1.cir` - V1掃描
- [ ] `vco_kvco_sweep_v2.cir` - V2掃描
- [ ] `vco_kvco_sweep_v3.cir` - V3掃描
- [ ] `vco_kvco_pmos_only.cir` - PMOS單邊掃描
- [ ] `vco_kvco_nmos_only.cir` - NMOS單邊掃描

### ✅ Python腳本（必須提交）

- [ ] `plot_kvco.py` - 基本KVCO繪圖
- [ ] `plot_all_versions.py` - 多版本比較
- [ ] `plot_single_side.py` - 單邊控制比較
- [ ] `plot_vdd_freq.py` - 原有的VDD掃描繪圖

### ✅ Bash腳本（必須提交）

- [ ] `run_vco_sim.sh` - 互動式模擬腳本
- [ ] `test_all_versions.sh` - 測試所有版本
- [ ] `test_single_side.sh` - 測試單邊控制

### ✅ 文檔（必須提交）

**主要文檔**:
- [ ] `README_VCO_DESIGNS.md` - VCO設計版本說明
- [ ] `VCO設計指南.md` - 完整設計指南
- [ ] `VCO測試結果總結.md` - 測試結果分析
- [ ] `QUICKSTART.md` - 快速開始指南

**次要文檔**:
- [ ] `VCO使用說明.md` - 原有使用說明
- [ ] `vco_design_options.md` - 設計選項指南

**參考文檔**:
- [ ] `COMMIT_CHECKLIST.md` - 本檔案
- [ ] `.gitignore_vco` - 建議的gitignore規則

### ⚠️ 參考檔案（選擇性提交）

- [ ] `new_vco.odt` - 原始需求文件（已存在）

### ❌ 不要提交的檔案

**模擬輸出**:
- `*.raw` - ngspice原始數據（太大）
- `*_output.txt` - 模擬日誌
- `*_log.txt` - 測試日誌

**結果數據** (可選):
- `*_results.csv` - CSV數據（可提交或不提交）

**圖片** (可選):
- `*.png` - 圖片檔案（看需求）
  - 建議：提交幾個代表性的比較圖
  - 不提交：所有raw檔案產生的圖

**臨時檔案**:
- `/tmp/vco_images/` - 從ODT提取的圖片
- `version_test_log.txt`
- `single_side_test_log.txt`

---

## 建議的提交流程

### 1. 建立新分支
```bash
git checkout -b vco-nori
```

### 2. 添加檔案
```bash
# 添加所有VCO電路檔案
git add vco_*.cir

# 添加Python腳本
git add plot_*.py

# 添加Bash腳本
git add run_vco_sim.sh test_*.sh

# 添加文檔
git add *VCO*.md QUICKSTART.md vco_design_options.md

# 添加代表性圖片（可選）
git add vco_versions_comparison.png
git add vco_single_side_comparison.png
git add vco_kvco_plot.png
```

### 3. 檢查將要提交的檔案
```bash
git status
```

### 4. 提交
```bash
git commit -m "Add VCO design variations and testing framework

- 實作多種VCO控制方案（雙邊/單邊控制）
- 添加尺寸調整版本測試（方案4）
- 添加單邊控制版本測試（方案3）
- 完整的KVCO曲線測試與分析
- 互動式模擬腳本與批次測試工具
- 完善的中文文檔與使用指南

參考: new_vco.odt 設計需求"
```

### 5. 推送到遠端（如果需要）
```bash
git push origin vco-nori
```

---

## 提交訊息建議

### 簡短版
```
Add VCO voltage control design variations and testing suite
```

### 詳細版
```
Add VCO design variations and comprehensive testing framework

新增功能:
- 三種控制方案：雙邊控制、PMOS-Only、NMOS-Only
- 尺寸調整版本：V1(PMOS主導)、V2(NMOS主導)、V3(極端PMOS)
- KVCO特性曲線掃描與分析
- 自動化測試腳本（test_all_versions.sh、test_single_side.sh）
- Python繪圖工具（支援中文、多版本比較）
- 互動式模擬腳本（run_vco_sim.sh）

測試結果:
- 方案4（尺寸調整）：無法消除峰值特性
- 方案3（單邊控制）：在穩定區間內可獲得單調曲線
- PMOS-Only: 0.7-1.2V穩定範圍，單調遞減
- NMOS-Only: 0.65-1.8V穩定範圍，單調上升

文檔:
- README_VCO_DESIGNS.md - 版本說明
- VCO設計指南.md - 完整設計指南
- VCO測試結果總結.md - 測試分析
- QUICKSTART.md - 快速開始指南

參考: new_vco.odt
```

---

## 檢查點

### 程式碼品質
- [ ] 所有.cir檔案包含正確的PDK路徑
- [ ] Python腳本包含中文字型設定
- [ ] Bash腳本有執行權限
- [ ] 所有腳本都經過測試

### 文檔完整性
- [ ] README清楚說明各版本差異
- [ ] 快速開始指南易於理解
- [ ] 測試結果總結包含數據
- [ ] 設計指南解釋原理

### 可重現性
- [ ] 其他人可以根據文檔執行模擬
- [ ] 測試腳本自動化程度高
- [ ] 依賴項目明確列出

---

## 後續工作（不在此次commit）

### 下一版本改進
- [ ] 實作current-starved設計
- [ ] 添加偏壓電路
- [ ] 增加通道長度測試（L=0.5μm）
- [ ] 實作差動對控制

### 文檔增強
- [ ] 添加更多波形圖範例
- [ ] 製作教學影片
- [ ] 英文版文檔

### 工具改進
- [ ] GUI介面
- [ ] 自動參數優化
- [ ] 批次結果比較工具

---

**準備好了嗎？**

檢查完所有項目後，執行提交！

```bash
# 最後檢查
git status
git diff --staged

# 確認無誤後提交
git commit -m "你的提交訊息"
```
