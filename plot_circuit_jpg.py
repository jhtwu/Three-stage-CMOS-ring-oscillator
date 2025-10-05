#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
VCO Circuit.jpg KVCO 曲線繪圖工具
繪製基於 circuit.jpg 的 VCO KVCO 曲線 (Vctrl 只控制 PMOS)
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# 設定中文字型
plt.rcParams["font.family"] = "Noto Serif CJK JP"

def plot_circuit_jpg_kvco(csv_file='vco_kvco_circuit_jpg_results.csv', output_file='vco_circuit_jpg_plot.png'):
    """
    繪製 circuit.jpg VCO 的 KVCO 曲線
    """
    # 讀取數據
    df = pd.read_csv(csv_file)

    # 過濾掉無效數據 (Frequency = 0 or NaN)
    df = df[df['Frequency(GHz)'].notna()]
    df = df[df['Frequency(GHz)'] > 0]

    if df.empty:
        print("錯誤：沒有有效的數據！")
        return

    # 檢查是否為單調曲線
    freq_diff = df['Frequency(GHz)'].diff().dropna()
    is_monotonic_inc = all(freq_diff >= 0)
    is_monotonic_dec = all(freq_diff <= 0)

    if is_monotonic_inc:
        monotonic_text = "✓ 單調遞增曲線"
        curve_color = 'green'
    elif is_monotonic_dec:
        monotonic_text = "✓ 單調遞減曲線"
        curve_color = 'blue'
    else:
        monotonic_text = "部分單調（高電壓段遞減）"
        curve_color = 'orange'

    # 找出最大值
    max_idx = df['Frequency(GHz)'].idxmax()
    max_freq = df.loc[max_idx, 'Frequency(GHz)']
    max_vctrl = df.loc[max_idx, 'Vctrl(V)']

    # 繪製圖表
    plt.figure(figsize=(12, 8))

    # 主曲線
    plt.plot(df['Vctrl(V)'], df['Frequency(GHz)'],
             color=curve_color, linewidth=2, marker='o', markersize=6,
             label=f'KVCO 曲線 ({monotonic_text})')

    # 標記最大值點
    plt.plot(max_vctrl, max_freq, 'r*', markersize=15,
             label=f'最大值: {max_freq:.2f} GHz @ {max_vctrl} V')

    # 標題和標籤
    plt.title('VCO 特性量測 (circuit.jpg) ~ KVCO 曲線\nVctrl 只控制 PMOS', fontsize=16, pad=20)
    plt.xlabel('控制電壓 Vctrl (V)', fontsize=13)
    plt.ylabel('振盪頻率 (GHz)', fontsize=13)

    # 網格
    plt.grid(True, alpha=0.3, linestyle='--')

    # 圖例
    plt.legend(fontsize=11, loc='best')

    # 添加統計資訊
    info_text = f"""
控制方式: Vctrl → PMOS only
頻率範圍: {df['Frequency(GHz)'].min():.2f} ~ {df['Frequency(GHz)'].max():.2f} GHz
控制範圍: {df['Vctrl(V)'].min()} ~ {df['Vctrl(V)'].max()} V
最大頻率: {max_freq:.2f} GHz @ {max_vctrl} V
{monotonic_text}
"""
    plt.text(0.02, 0.98, info_text.strip(),
             transform=plt.gca().transAxes,
             fontsize=10, verticalalignment='top',
             bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))

    # 調整佈局
    plt.tight_layout()

    # 儲存圖片
    plt.savefig(output_file, dpi=150, bbox_inches='tight')
    print(f"\n圖表已儲存至: {output_file}")

    # 輸出數據摘要
    print("\n=== KVCO 曲線分析 (circuit.jpg) ===")
    print(f"控制方式: Vctrl 只控制 PMOS")
    print(f"頻率範圍: {df['Frequency(GHz)'].min():.3f} ~ {df['Frequency(GHz)'].max():.3f} GHz")
    print(f"控制範圍: {df['Vctrl(V)'].min()} ~ {df['Vctrl(V)'].max()} V")
    print(f"最大頻率: {max_freq:.3f} GHz @ Vctrl = {max_vctrl} V")
    print(f"曲線特性: {monotonic_text}")

    # 分析高電壓段 (Vctrl > 0.7V)
    df_high = df[df['Vctrl(V)'] >= 0.7]
    if len(df_high) > 1:
        high_diff = df_high['Frequency(GHz)'].diff().dropna()
        if all(high_diff <= 0):
            print(f"\n高電壓段 (≥0.7V): ✓ 單調遞減")
            print(f"  範圍: {df_high['Vctrl(V)'].min()}V ~ {df_high['Vctrl(V)'].max()}V")
            print(f"  頻率: {df_high['Frequency(GHz)'].max():.2f} ~ {df_high['Frequency(GHz)'].min():.2f} GHz")

    print("=====================================\n")

if __name__ == "__main__":
    plot_circuit_jpg_kvco()
