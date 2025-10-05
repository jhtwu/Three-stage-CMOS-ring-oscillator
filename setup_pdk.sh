#!/bin/bash
# PDK 安裝輔助腳本
# 協助將現有的 PDK 設定到建議的位置

echo "=========================================="
echo "SkyWater 130nm PDK 設定腳本"
echo "=========================================="
echo ""

# 檢查當前 PDK 位置
CURRENT_PDK="/home/jimmy/pdk/sky130A"

if [ ! -d "$CURRENT_PDK" ]; then
    echo "❌ 錯誤: 未在 $CURRENT_PDK 找到 PDK"
    echo "請先使用 volare 或手動安裝 PDK"
    exit 1
fi

echo "✓ 找到現有的 PDK: $CURRENT_PDK"
echo ""

# 選擇目標位置
echo "請選擇 PDK 設定位置:"
echo "  1) /opt/pdk (系統級，需要 sudo)"
echo "  2) ~/pdk (使用者級)"
echo "  3) 只設定環境變數 PDK_ROOT (不移動檔案)"
echo "  4) 取消"
echo ""
read -p "請選擇 [1-4]: " choice

case $choice in
    1)
        echo ""
        echo "將建立符號連結: /opt/pdk -> $CURRENT_PDK"
        sudo mkdir -p /opt/pdk
        sudo ln -sf $CURRENT_PDK /opt/pdk/sky130A

        if [ -L "/opt/pdk/sky130A" ]; then
            echo "✓ 符號連結建立成功"
            echo ""
            echo "建議: 將以下行加入 ~/.bashrc 或 ~/.zshrc:"
            echo "  export PDK_ROOT=/opt/pdk"
        else
            echo "❌ 建立符號連結失敗"
            exit 1
        fi
        ;;

    2)
        echo ""
        if [ "$CURRENT_PDK" = "$HOME/pdk/sky130A" ]; then
            echo "✓ PDK 已經在 ~/pdk，無需移動"
        else
            echo "將建立符號連結: ~/pdk/sky130A -> $CURRENT_PDK"
            mkdir -p ~/pdk
            ln -sf $CURRENT_PDK ~/pdk/sky130A
            echo "✓ 符號連結建立成功"
        fi

        echo ""
        echo "建議: 將以下行加入 ~/.bashrc 或 ~/.zshrc:"
        echo "  export PDK_ROOT=\$HOME/pdk"
        ;;

    3)
        echo ""
        echo "請將以下行加入 ~/.bashrc 或 ~/.zshrc:"
        echo "  export PDK_ROOT=$(dirname $CURRENT_PDK)"
        ;;

    4)
        echo "已取消"
        exit 0
        ;;

    *)
        echo "無效的選擇"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "設定完成"
echo "=========================================="
echo ""
echo "下一步:"
echo "1. 重新載入 shell 設定或執行: source ~/.bashrc"
echo "2. 驗證設定: echo \$PDK_ROOT"
echo "3. 執行測試: ./run_all.sh"
