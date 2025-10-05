#!/bin/bash
# VCO 模擬執行腳本
# 用於執行電壓控制環形振盪器的完整模擬流程

set -e  # 遇到錯誤時停止

echo "======================================================"
echo "  三級CMOS環形振盪器VCO模擬"
echo "======================================================"
echo ""

# 顏色定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 選單
echo "請選擇要執行的模擬:"
echo "  1) 基本VCO模擬 (固定Vctrl=0.9V)"
echo "  2) KVCO曲線掃描 (掃描Vctrl 0.1V-1.7V)"
echo "  3) 執行全部模擬"
echo "  4) 僅繪製KVCO曲線圖"
echo ""
read -p "請輸入選項 [1-4]: " choice

case $choice in
    1)
        echo -e "${BLUE}執行基本VCO模擬...${NC}"
        ngspice -b vco_controlled.cir -o vco_controlled_output.txt
        echo ""
        echo -e "${GREEN}✓ 模擬完成!${NC}"
        echo "  輸出檔案: vco_controlled_output.txt"
        echo "  波形資料: vco_controlled.raw"
        echo ""
        tail -15 vco_controlled_output.txt
        ;;

    2)
        echo -e "${BLUE}執行KVCO曲線掃描...${NC}"
        echo -e "${YELLOW}(這可能需要幾分鐘時間)${NC}"
        echo ""
        ngspice -b vco_kvco_sweep.cir -o vco_kvco_sweep_output.txt
        echo ""
        echo -e "${GREEN}✓ KVCO掃描完成!${NC}"
        echo "  結果檔案: vco_kvco_results.csv"
        echo ""
        echo -e "${BLUE}繪製KVCO曲線圖...${NC}"
        python3 plot_kvco.py
        echo ""
        echo -e "${GREEN}✓ 完成! 請查看 vco_kvco_plot.png${NC}"
        ;;

    3)
        echo -e "${BLUE}執行完整模擬流程...${NC}"
        echo ""

        echo -e "${BLUE}[1/3] 執行基本VCO模擬...${NC}"
        ngspice -b vco_controlled.cir -o vco_controlled_output.txt
        echo -e "${GREEN}✓ 基本模擬完成${NC}"
        echo ""

        echo -e "${BLUE}[2/3] 執行KVCO曲線掃描...${NC}"
        echo -e "${YELLOW}(這可能需要幾分鐘時間)${NC}"
        ngspice -b vco_kvco_sweep.cir -o vco_kvco_sweep_output.txt
        echo -e "${GREEN}✓ KVCO掃描完成${NC}"
        echo ""

        echo -e "${BLUE}[3/3] 繪製KVCO曲線圖...${NC}"
        python3 plot_kvco.py
        echo ""

        echo -e "${GREEN}======================================================"
        echo "  所有模擬完成!"
        echo "======================================================${NC}"
        echo ""
        echo "生成的檔案:"
        echo "  - vco_controlled.raw (基本模擬波形)"
        echo "  - vco_controlled_output.txt (基本模擬輸出)"
        echo "  - vco_kvco_results.csv (KVCO掃描數據)"
        echo "  - vco_kvco_plot.png (KVCO曲線圖)"
        echo ""
        ;;

    4)
        echo -e "${BLUE}繪製KVCO曲線圖...${NC}"
        if [ ! -f "vco_kvco_results.csv" ]; then
            echo -e "${YELLOW}警告: 找不到 vco_kvco_results.csv${NC}"
            echo "請先執行選項 2 或 3 進行KVCO掃描"
            exit 1
        fi
        python3 plot_kvco.py
        echo ""
        echo -e "${GREEN}✓ 完成! 請查看 vco_kvco_plot.png${NC}"
        ;;

    *)
        echo "無效的選項"
        exit 1
        ;;
esac

echo ""
echo "======================================================"
