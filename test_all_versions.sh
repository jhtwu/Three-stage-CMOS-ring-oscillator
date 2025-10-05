#!/bin/bash
# 測試所有尺寸調整版本的VCO

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "======================================================"
echo "  VCO尺寸調整版本測試"
echo "======================================================"
echo ""

# V1: PMOS主導
echo -e "${BLUE}[1/3] 測試V1: PMOS主導 (W=3.0/0.2)${NC}"
ngspice -b vco_kvco_sweep_v1.cir -o vco_kvco_sweep_v1_output.txt
echo -e "${GREEN}✓ V1完成${NC}"
echo ""

# V2: NMOS主導
echo -e "${BLUE}[2/3] 測試V2: NMOS主導 (W=0.2/3.0)${NC}"
ngspice -b vco_kvco_sweep_v2.cir -o vco_kvco_sweep_v2_output.txt
echo -e "${GREEN}✓ V2完成${NC}"
echo ""

# V3: 極端PMOS主導
echo -e "${BLUE}[3/3] 測試V3: 極端PMOS主導 (W=5.0/0.1)${NC}"
ngspice -b vco_kvco_sweep_v3.cir -o vco_kvco_sweep_v3_output.txt
echo -e "${GREEN}✓ V3完成${NC}"
echo ""

# 繪製所有結果
echo -e "${BLUE}繪製比較圖...${NC}"
python3 plot_all_versions.py

echo ""
echo -e "${GREEN}======================================================"
echo "  所有測試完成!"
echo "======================================================${NC}"
echo ""
echo "生成的檔案:"
echo "  - vco_kvco_v1_results.csv (V1: PMOS主導)"
echo "  - vco_kvco_v2_results.csv (V2: NMOS主導)"
echo "  - vco_kvco_v3_results.csv (V3: 極端PMOS主導)"
echo "  - vco_versions_comparison.png (比較圖)"
echo ""
