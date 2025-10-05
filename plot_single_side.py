#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
VCO單邊控制比較圖
繪製PMOS-Only和NMOS-Only的KVCO曲線
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# 設定中文字型
plt.rcParams["font.family"] = "Noto Serif CJK JP"

def plot_single_side_comparison():
    """繪製單邊控制版本的KVCO曲線比較"""

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 7))

    # === 左圖：單邊控制比較 ===
    # 讀取並繪製PMOS-Only
    if os.path.exists('vco_kvco_pmos_only_results.csv'):
        df_pmos = pd.read_csv('vco_kvco_pmos_only_results.csv')
        df_pmos = df_pmos[df_pmos['Frequency(GHz)'] > 0]
        if len(df_pmos) > 0:
            ax1.plot(df_pmos['Vctrl(V)'], df_pmos['Frequency(GHz)'],
                    'b-o', linewidth=2, markersize=5,
                    label='PMOS-Only (Vctrl↑→頻率↓)', alpha=0.7)

    # 讀取並繪製NMOS-Only
    if os.path.exists('vco_kvco_nmos_only_results.csv'):
        df_nmos = pd.read_csv('vco_kvco_nmos_only_results.csv')
        df_nmos = df_nmos[df_nmos['Frequency(GHz)'] > 0]
        if len(df_nmos) > 0:
            ax1.plot(df_nmos['Vctrl(V)'], df_nmos['Frequency(GHz)'],
                    'r-s', linewidth=2, markersize=5,
                    label='NMOS-Only (Vctrl↑→頻率↑)', alpha=0.7)

    ax1.set_title('單邊控制VCO - KVCO曲線比較', fontsize=14, fontweight='bold', pad=15)
    ax1.set_xlabel('控制電壓 Vctrl (V)', fontsize=12)
    ax1.set_ylabel('振盪頻率 (GHz)', fontsize=12)
    ax1.grid(True, alpha=0.3, linestyle='--')
    ax1.legend(fontsize=10, loc='best')

    # === 右圖：與參考曲線比較 (PMOS-Only) ===
    if os.path.exists('vco_kvco_pmos_only_results.csv'):
        df_pmos = pd.read_csv('vco_kvco_pmos_only_results.csv')
        df_pmos = df_pmos[df_pmos['Frequency(GHz)'] > 0]
        if len(df_pmos) > 0:
            ax2.plot(df_pmos['Vctrl(V)'], df_pmos['Frequency(GHz)'],
                    'g-o', linewidth=2, markersize=5,
                    label='PMOS-Only VCO實測', alpha=0.7)

            # 添加說明
            info_text = '✓ 單調遞減曲線\n'
            info_text += f'控制範圍: {df_pmos["Vctrl(V)"].min():.2f}V - {df_pmos["Vctrl(V)"].max():.2f}V\n'
            info_text += f'頻率範圍: {df_pmos["Frequency(GHz)"].min():.3f} - {df_pmos["Frequency(GHz)"].max():.3f} GHz'

            ax2.text(0.02, 0.98, info_text,
                    transform=ax2.transAxes,
                    fontsize=10,
                    verticalalignment='top',
                    bbox=dict(boxstyle='round', facecolor='lightgreen', alpha=0.5))

    ax2.set_title('PMOS-Only控制 - 與參考曲線比較', fontsize=14, fontweight='bold', pad=15)
    ax2.set_xlabel('控制電壓 Vctrl (V)', fontsize=12)
    ax2.set_ylabel('振盪頻率 (GHz)', fontsize=12)
    ax2.grid(True, alpha=0.3, linestyle='--')
    ax2.legend(fontsize=10, loc='best')

    plt.tight_layout()
    plt.savefig('vco_single_side_comparison.png', dpi=300, bbox_inches='tight')
    print(f"✓ 單邊控制比較圖已儲存至: vco_single_side_comparison.png")

    # 繪製個別版本的圖表
    plot_individual_single_side()

def plot_individual_single_side():
    """繪製每個單邊控制版本的獨立圖表"""

    versions = [
        ('vco_kvco_pmos_only_results.csv', 'vco_kvco_pmos_only_plot.png',
         'PMOS-Only控制 (Vctrl高→頻率低)', 'blue'),
        ('vco_kvco_nmos_only_results.csv', 'vco_kvco_nmos_only_plot.png',
         'NMOS-Only控制 (Vctrl高→頻率高)', 'red')
    ]

    for csv_file, output_file, title, color in versions:
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
                    color=color, linestyle='-', linewidth=2,
                    marker='o', markersize=4)

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

            # 判斷是否單調
            is_monotonic = all(df['Frequency(GHz)'].diff().dropna() <= 0) or \
                          all(df['Frequency(GHz)'].diff().dropna() >= 0)
            monotonic_text = "✓ 單調曲線" if is_monotonic else "✗ 非單調曲線"

            info_text = f'{monotonic_text}\n'
            info_text += f'頻率範圍: {freq_min:.3f} - {freq_max:.3f} GHz\n'
            info_text += f'控制電壓範圍: {vctrl_min:.2f} - {vctrl_max:.2f} V'

            box_color = 'lightgreen' if is_monotonic else 'lightyellow'
            plt.text(0.02, 0.98, info_text,
                    transform=plt.gca().transAxes,
                    fontsize=10,
                    verticalalignment='top',
                    bbox=dict(boxstyle='round', facecolor=box_color, alpha=0.5))

            plt.tight_layout()
            plt.savefig(output_file, dpi=300, bbox_inches='tight')
            print(f"✓ {title} 圖表已儲存至: {output_file}")
            plt.close()

            # 打印統計
            print(f"\n{title}:")
            print(f"  控制電壓範圍: {vctrl_min:.2f} V ~ {vctrl_max:.2f} V")
            print(f"  頻率範圍: {freq_min:.3f} GHz ~ {freq_max:.3f} GHz")
            print(f"  數據點數量: {len(df)}")
            print(f"  曲線特性: {monotonic_text}")

        except Exception as e:
            print(f"處理 {csv_file} 時發生錯誤: {e}")

def main():
    print("\n==================== VCO單邊控制比較繪製 ====================")
    print("繪製PMOS-Only和NMOS-Only的KVCO曲線...")
    print("==========================================================\n")

    plot_single_side_comparison()

    print("\n==========================================================")
    print("繪製完成!")
    print("==========================================================\n")

if __name__ == '__main__':
    main()
