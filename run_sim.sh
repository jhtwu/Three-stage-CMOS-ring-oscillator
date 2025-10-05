#!/bin/bash
# ngspice 執行包裝腳本
# 用於展開環境變數並執行模擬

if [ -z "$PDK_ROOT" ]; then
    echo "錯誤: PDK_ROOT 環境變數未設定"
    exit 1
fi

# 展開環境變數並建立臨時檔案
CIRCUIT_FILE="$1"
TEMP_FILE="${CIRCUIT_FILE}.tmp"

# 將 $PDK_ROOT 替換為實際路徑
sed "s|\$PDK_ROOT|$PDK_ROOT|g" "$CIRCUIT_FILE" > "$TEMP_FILE"

# 執行 ngspice
ngspice -b "$TEMP_FILE" "${@:2}"
EXIT_CODE=$?

# 清理臨時檔案
rm -f "$TEMP_FILE"

exit $EXIT_CODE
