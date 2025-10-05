#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
三級 CMOS 環形振盪器 - 電壓與頻率關係圖
繪製供應電壓(VDD)對振盪頻率的影響
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# 設定中文字型
plt.rcParams["font.family"] = "Noto Serif CJK JP"

# 讀取模擬結果
data = pd.read_csv('vdd_freq_results.csv')

# 建立圖形
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))

# 圖1: 電壓 vs 頻率
ax1.plot(data['VDD(V)'], data['Frequency(GHz)'], 'bo-', linewidth=2, markersize=8)
ax1.grid(True, alpha=0.3)
ax1.set_xlabel('供應電壓 VDD (V)', fontsize=12, fontweight='bold')
ax1.set_ylabel('振盪頻率 (GHz)', fontsize=12, fontweight='bold')
ax1.set_title('三級 CMOS 環形振盪器: 供應電壓 vs 振盪頻率', fontsize=14, fontweight='bold')
ax1.set_xlim(1.1, 2.1)

# 在圖上標註數據點
for i, row in data.iterrows():
    ax1.annotate(f'{row["Frequency(GHz)"]:.2f} GHz',
                xy=(row['VDD(V)'], row['Frequency(GHz)']),
                xytext=(5, 5), textcoords='offset points',
                fontsize=9, alpha=0.7)

# 圖2: 電壓 vs 週期
ax2.plot(data['VDD(V)'], data['Period(ns)'], 'ro-', linewidth=2, markersize=8)
ax2.grid(True, alpha=0.3)
ax2.set_xlabel('供應電壓 VDD (V)', fontsize=12, fontweight='bold')
ax2.set_ylabel('振盪週期 (ns)', fontsize=12, fontweight='bold')
ax2.set_title('三級 CMOS 環形振盪器: 供應電壓 vs 振盪週期', fontsize=14, fontweight='bold')
ax2.set_xlim(1.1, 2.1)

# 在圖上標註數據點
for i, row in data.iterrows():
    ax2.annotate(f'{row["Period(ns)"]:.3f} ns',
                xy=(row['VDD(V)'], row['Period(ns)']),
                xytext=(5, 5), textcoords='offset points',
                fontsize=9, alpha=0.7)

plt.tight_layout()
plt.savefig('vdd_freq_plot.png', dpi=300, bbox_inches='tight')
print("圖形已儲存至: vdd_freq_plot.png")

# 顯示統計資料
print("\n========== 模擬結果統計 ==========")
print(f"電壓範圍: {data['VDD(V)'].min():.1f}V - {data['VDD(V)'].max():.1f}V")
print(f"頻率範圍: {data['Frequency(GHz)'].min():.2f} GHz - {data['Frequency(GHz)'].max():.2f} GHz")
print(f"週期範圍: {data['Period(ns)'].min():.3f} ns - {data['Period(ns)'].max():.3f} ns")
print(f"\n在標準電壓 1.8V 下:")
vdd_18 = data[data['VDD(V)'] == 1.8]
if not vdd_18.empty:
    print(f"  頻率: {vdd_18['Frequency(GHz)'].values[0]:.2f} GHz")
    print(f"  週期: {vdd_18['Period(ns)'].values[0]:.3f} ns")
print("==================================\n")

plt.show()
