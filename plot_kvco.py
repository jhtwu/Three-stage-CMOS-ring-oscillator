#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
VCO KVCO Curve Plotter
繪製控制電壓 vs 頻率曲線 (KVCO特性曲線)
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import sys

# 設定中文字型
plt.rcParams["font.family"] = "Noto Serif CJK JP"

def plot_kvco_curve(csv_file='vco_kvco_results.csv', output_file='vco_kvco_plot.png'):
    """
    讀取KVCO掃描結果並繪製曲線圖

    Args:
        csv_file: 輸入的CSV檔案路徑
        output_file: 輸出的圖片檔案路徑
    """
    try:
        # 讀取CSV檔案
        df = pd.read_csv(csv_file)

        # 移除無效數據點 (頻率為0或NaN)
        df = df[df['Frequency(GHz)'] > 0]

        if len(df) == 0:
            print("錯誤: 沒有有效的數據點可以繪製")
            return False

        # 建立圖表
        plt.figure(figsize=(12, 8))

        # 繪製頻率 vs 控制電壓曲線
        plt.plot(df['Vctrl(V)'], df['Frequency(GHz)'],
                 'g-', linewidth=2, marker='o', markersize=4,
                 label='VCO頻率曲線')

        # 設定圖表標題和軸標籤
        plt.title('VCO特性量測 ~ KVCO曲線', fontsize=16, fontweight='bold', pad=20)
        plt.xlabel('控制電壓 Vctrl (V)', fontsize=13)
        plt.ylabel('振盪頻率 (GHz)', fontsize=13)

        # 設定網格
        plt.grid(True, alpha=0.3, linestyle='--')

        # 添加圖例
        plt.legend(fontsize=11, loc='best')

        # 添加數據統計資訊
        freq_min = df['Frequency(GHz)'].min()
        freq_max = df['Frequency(GHz)'].max()
        vctrl_min = df['Vctrl(V)'].min()
        vctrl_max = df['Vctrl(V)'].max()

        info_text = f'頻率範圍: {freq_min:.3f} - {freq_max:.3f} GHz\n'
        info_text += f'控制電壓範圍: {vctrl_min:.2f} - {vctrl_max:.2f} V'

        plt.text(0.02, 0.98, info_text,
                transform=plt.gca().transAxes,
                fontsize=10,
                verticalalignment='top',
                bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))

        # 調整佈局
        plt.tight_layout()

        # 儲存圖表
        plt.savefig(output_file, dpi=300, bbox_inches='tight')
        print(f"✓ KVCO曲線圖已儲存至: {output_file}")

        # 顯示統計資訊
        print("\n==================== 統計資訊 ====================")
        print(f"控制電壓範圍: {vctrl_min:.2f} V ~ {vctrl_max:.2f} V")
        print(f"頻率範圍: {freq_min:.3f} GHz ~ {freq_max:.3f} GHz")
        print(f"頻率變化: {freq_max - freq_min:.3f} GHz")
        print(f"數據點數量: {len(df)}")

        # 計算平均KVCO (dFreq/dVctrl)
        if len(df) > 1:
            # 使用線性擬合計算平均斜率
            z = np.polyfit(df['Vctrl(V)'], df['Frequency(GHz)'], 1)
            avg_kvco = z[0]
            print(f"平均 KVCO (線性區): {avg_kvco:.3f} GHz/V")

        print("=================================================\n")

        return True

    except FileNotFoundError:
        print(f"錯誤: 找不到檔案 {csv_file}")
        print("請先執行 KVCO 掃描模擬: ngspice vco_kvco_sweep.cir")
        return False
    except Exception as e:
        print(f"錯誤: {e}")
        return False

def main():
    """主程式"""
    # 檢查命令列參數
    csv_file = 'vco_kvco_results.csv'
    output_file = 'vco_kvco_plot.png'

    if len(sys.argv) > 1:
        csv_file = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]

    print("\n==================== VCO KVCO曲線繪製 ====================")
    print(f"輸入檔案: {csv_file}")
    print(f"輸出檔案: {output_file}")
    print("========================================================\n")

    success = plot_kvco_curve(csv_file, output_file)

    if success:
        print("繪製完成!")
    else:
        print("繪製失敗!")
        sys.exit(1)

if __name__ == '__main__':
    main()
