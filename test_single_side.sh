#!/bin/bash
# 測試單邊控制版本的VCO

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "======================================================"
echo "  VCO單邊控制版本測試 (方案3)"
echo "======================================================"
echo ""

# PMOS-Only
echo -e "${BLUE}[1/2] 測試PMOS-Only控制 (Vctrl高→頻率低)${NC}"
ngspice -b vco_kvco_pmos_only.cir -o vco_kvco_pmos_only_output.txt
echo -e "${GREEN}✓ PMOS-Only完成${NC}"
echo ""

# NMOS-Only
echo -e "${BLUE}[2/2] 測試NMOS-Only控制 (Vctrl高→頻率高)${NC}"
ngspice -b vco_kvco_nmos_only.cir -o vco_kvco_nmos_only_output.txt
echo -e "${GREEN}✓ NMOS-Only完成${NC}"
echo ""

# 繪製結果
echo -e "${BLUE}繪製單邊控制比較圖...${NC}"
python3 plot_single_side.py

echo ""
echo -e "${GREEN}======================================================"
echo "  單邊控制測試完成!"
echo "======================================================${NC}"
echo ""
echo "生成的檔案:"
echo "  - vco_kvco_pmos_only_results.csv (PMOS-Only控制)"
echo "  - vco_kvco_nmos_only_results.csv (NMOS-Only控制)"
echo "  - vco_single_side_comparison.png (單邊控制比較圖)"
echo ""
