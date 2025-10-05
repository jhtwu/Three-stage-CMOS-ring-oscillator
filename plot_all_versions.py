#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
VCO版本比較圖
繪製所有尺寸調整版本的KVCO曲線進行比較
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# 設定中文字型
plt.rcParams["font.family"] = "Noto Serif CJK JP"

def plot_version_comparison():
    """繪製所有版本的KVCO曲線比較"""

    plt.figure(figsize=(14, 10))

    # 讀取並繪製原始版本
    if os.path.exists('vco_kvco_results.csv'):
        df_orig = pd.read_csv('vco_kvco_results.csv')
        df_orig = df_orig[df_orig['Frequency(GHz)'] > 0]
        if len(df_orig) > 0:
            plt.plot(df_orig['Vctrl(V)'], df_orig['Frequency(GHz)'],
                    'o-', linewidth=2, markersize=6, label='原始版本 (W=1.0/0.5)', alpha=0.7)

    # 讀取並繪製V1
    if os.path.exists('vco_kvco_v1_results.csv'):
        df_v1 = pd.read_csv('vco_kvco_v1_results.csv')
        df_v1 = df_v1[df_v1['Frequency(GHz)'] > 0]
        if len(df_v1) > 0:
            plt.plot(df_v1['Vctrl(V)'], df_v1['Frequency(GHz)'],
                    's-', linewidth=2, markersize=6, label='V1: PMOS主導 (W=3.0/0.2)', alpha=0.7)

    # 讀取並繪製V2
    if os.path.exists('vco_kvco_v2_results.csv'):
        df_v2 = pd.read_csv('vco_kvco_v2_results.csv')
        df_v2 = df_v2[df_v2['Frequency(GHz)'] > 0]
        if len(df_v2) > 0:
            plt.plot(df_v2['Vctrl(V)'], df_v2['Frequency(GHz)'],
                    '^-', linewidth=2, markersize=6, label='V2: NMOS主導 (W=0.2/3.0)', alpha=0.7)

    # 讀取並繪製V3
    if os.path.exists('vco_kvco_v3_results.csv'):
        df_v3 = pd.read_csv('vco_kvco_v3_results.csv')
        df_v3 = df_v3[df_v3['Frequency(GHz)'] > 0]
        if len(df_v3) > 0:
            plt.plot(df_v3['Vctrl(V)'], df_v3['Frequency(GHz)'],
                    'd-', linewidth=2, markersize=6, label='V3: 極端PMOS (W=5.0/0.1)', alpha=0.7)

    # 設定圖表
    plt.title('VCO版本比較 - KVCO曲線', fontsize=16, fontweight='bold', pad=20)
    plt.xlabel('控制電壓 Vctrl (V)', fontsize=13)
    plt.ylabel('振盪頻率 (GHz)', fontsize=13)
    plt.grid(True, alpha=0.3, linestyle='--')
    plt.legend(fontsize=11, loc='best')

    # 添加說明文字
    info_text = '目標: 尋找單調遞減的曲線形狀\n'
    info_text += '(類似參考文件中的綠色曲線)'

    plt.text(0.02, 0.98, info_text,
            transform=plt.gca().transAxes,
            fontsize=10,
            verticalalignment='top',
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))

    plt.tight_layout()
    plt.savefig('vco_versions_comparison.png', dpi=300, bbox_inches='tight')
    print(f"✓ 版本比較圖已儲存至: vco_versions_comparison.png")

    # 繪製個別版本的圖表
    plot_individual_versions()

def plot_individual_versions():
    """繪製每個版本的獨立圖表"""

    versions = [
        ('vco_kvco_v1_results.csv', 'vco_kvco_v1_plot.png', 'V1: PMOS主導 (W=3.0/0.2)'),
        ('vco_kvco_v2_results.csv', 'vco_kvco_v2_plot.png', 'V2: NMOS主導 (W=0.2/3.0)'),
        ('vco_kvco_v3_results.csv', 'vco_kvco_v3_plot.png', 'V3: 極端PMOS主導 (W=5.0/0.1)')
    ]

    for csv_file, output_file, title in versions:
        if not os.path.exists(csv_file):
            continue

        try:
            df = pd.read_csv(csv_file)
            df = df[df['Frequency(GHz)'] > 0]

            if len(df) == 0:
                print(f"警告: {csv_file} 沒有有效數據")
                continue

            plt.figure(figsize=(12, 8))
            plt.plot(df['Vctrl(V)'], df['Frequency(GHz)'],
                    'g-', linewidth=2, marker='o', markersize=4)

            plt.title(f'VCO特性量測 ~ KVCO曲線\n{title}',
                     fontsize=16, fontweight='bold', pad=20)
            plt.xlabel('控制電壓 Vctrl (V)', fontsize=13)
            plt.ylabel('振盪頻率 (GHz)', fontsize=13)
            plt.grid(True, alpha=0.3, linestyle='--')

            # 統計資訊
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

            plt.tight_layout()
            plt.savefig(output_file, dpi=300, bbox_inches='tight')
            print(f"✓ {title} 圖表已儲存至: {output_file}")
            plt.close()

            # 打印統計
            print(f"\n{title}:")
            print(f"  控制電壓範圍: {vctrl_min:.2f} V ~ {vctrl_max:.2f} V")
            print(f"  頻率範圍: {freq_min:.3f} GHz ~ {freq_max:.3f} GHz")
            print(f"  數據點數量: {len(df)}")

        except Exception as e:
            print(f"處理 {csv_file} 時發生錯誤: {e}")

def main():
    print("\n==================== VCO版本比較繪製 ====================")
    print("繪製所有尺寸調整版本的KVCO曲線...")
    print("========================================================\n")

    plot_version_comparison()

    print("\n========================================================")
    print("繪製完成!")
    print("========================================================\n")

if __name__ == '__main__':
    main()
