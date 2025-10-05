#!/bin/bash
# 三級 CMOS 環形振盪器 - 完整測試腳本
# 執行所有模擬並產生分析報告

echo "=========================================="
echo "三級 CMOS 環形振盪器測試腳本"
echo "=========================================="
echo ""

# 檢查工具是否安裝
echo "[1/5] 檢查必要工具..."
if ! command -v ngspice &> /dev/null; then
    echo "❌ 錯誤: ngspice 未安裝"
    echo "請執行: sudo apt install ngspice"
    exit 1
fi
echo "✓ ngspice 已安裝: $(ngspice --version | head -1)"

if ! python3 -c "import matplotlib, pandas" 2>/dev/null; then
    echo "❌ 錯誤: Python 套件未安裝"
    echo "請執行: pip3 install --break-system-packages matplotlib pandas"
    exit 1
fi
echo "✓ Python 繪圖套件已安裝"

# 檢查 SkyWater PDK
echo ""
echo "[2/5] 檢查 SkyWater 130nm PDK..."

# 自動偵測 PDK 路徑
if [ -z "$PDK_ROOT" ]; then
    # 按優先順序搜尋 PDK
    if [ -d "/opt/pdk" ]; then
        export PDK_ROOT="/opt/pdk"
    elif [ -d "$HOME/pdk" ]; then
        export PDK_ROOT="$HOME/pdk"
    elif [ -d "$HOME/.volare/volare/sky130" ]; then
        # 找到最新版本的 sky130
        PDK_VERSION=$(ls -t "$HOME/.volare/volare/sky130/versions/" 2>/dev/null | head -1)
        if [ -n "$PDK_VERSION" ]; then
            export PDK_ROOT="$HOME/.volare/volare/sky130/versions/$PDK_VERSION"
        fi
    fi
fi

# 檢查 PDK 是否存在
PDK_LIB="$PDK_ROOT/sky130A/libs.tech/ngspice/sky130.lib.spice"
if [ ! -f "$PDK_LIB" ]; then
    echo "❌ 錯誤: SkyWater PDK 未找到"
    echo "搜尋路徑: $PDK_ROOT"
    echo ""
    echo "請先安裝 SkyWater PDK 到以下任一位置:"
    echo "  • /opt/pdk/"
    echo "  • $HOME/pdk/"
    echo "  • 使用 volare (會自動安裝到 ~/.volare/)"
    echo ""
    echo "安裝指令:"
    echo "  方法1 (推薦):"
    echo "    pip3 install volare"
    echo "    volare enable --pdk sky130"
    echo ""
    echo "  方法2 (安裝到 /opt):"
    echo "    sudo mkdir -p /opt/pdk"
    echo "    cd /opt/pdk"
    echo "    sudo git clone https://github.com/google/skywater-pdk.git"
    echo "    cd skywater-pdk"
    echo "    sudo git submodule update --init libraries/sky130_fd_pr/latest"
    echo "    sudo ln -s \$(pwd)/libraries/sky130_fd_pr/latest /opt/pdk/sky130A"
    echo ""
    echo "或設定環境變數 PDK_ROOT:"
    echo "  export PDK_ROOT=/your/pdk/path"
    echo ""
    exit 1
fi

echo "✓ SkyWater PDK 已安裝"
echo "  路徑: $PDK_ROOT"
echo "  庫檔案: $PDK_LIB"
echo ""

# 執行基本模擬
echo "[3/5] 執行基本振盪器模擬..."
./run_sim.sh ring_oscillator.cir > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ 基本模擬完成"
else
    echo "❌ 基本模擬失敗"
    echo "提示: 檢查 ring_oscillator.cir 中的 PDK 路徑是否正確"
    echo "PDK_ROOT = $PDK_ROOT"
    exit 1
fi
echo ""

# 執行電壓掃描
echo "[4/5] 執行電壓掃描分析(1.2V ~ 2.0V)..."
./run_sim.sh vdd_sweep.cir > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ 電壓掃描完成"
    echo "  結果檔案: vdd_freq_results.csv"
else
    echo "❌ 電壓掃描失敗"
    exit 1
fi
echo ""

# 產生圖表
echo "[5/5] 產生分析圖表..."
python3 plot_vdd_freq.py > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ 圖表已產生: vdd_freq_plot.png"
else
    echo "❌ 圖表產生失敗"
    echo "提示: 如果出現中文亂碼，請安裝字型: sudo apt install fonts-noto-cjk"
    exit 1
fi
echo ""

# 顯示結果摘要
echo "=========================================="
echo "模擬結果摘要"
echo "=========================================="
echo ""
cat vdd_freq_results.csv | column -t -s','
echo ""
echo "=========================================="
echo "所有測試完成!"
echo "=========================================="
echo ""
echo "產生的檔案:"
echo "  - ring_oscillator.raw (波形數據)"
echo "  - vdd_freq_results.csv (電壓-頻率數據)"
echo "  - vdd_freq_plot.png (分析圖表)"
echo ""
echo "請查看 專案說明_繁體中文.md 了解更多細節"
