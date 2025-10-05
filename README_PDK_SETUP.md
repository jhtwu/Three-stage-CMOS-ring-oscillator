# PDK 路徑設定說明

## 概述

本專案使用**環境變數 `PDK_ROOT`** 來指定 SkyWater 130nm PDK 的位置，這樣可以：
- ✅ 避免將大型 PDK 檔案提交到 GitHub
- ✅ 支援不同使用者的不同 PDK 安裝位置
- ✅ 符合業界標準做法（如 OpenLane、Magic 等工具）

## 快速開始

### 步驟 1: 設定環境變數

根據你的 PDK 安裝位置，選擇以下其中一種方式：

#### 選項 A: 臨時設定（單次使用）
```bash
export PDK_ROOT=/home/jimmy/pdk
./run_all.sh
```

#### 選項 B: 永久設定（推薦）
將以下行加入 `~/.bashrc` 或 `~/.zshrc`:
```bash
export PDK_ROOT=/home/jimmy/pdk
```

然後重新載入：
```bash
source ~/.bashrc
```

#### 選項 C: 使用 .env 檔案
```bash
# 複製範例檔案
cp .env.example .env

# 編輯 .env，設定你的 PDK_ROOT
nano .env

# 每次執行前先 source
source .env
./run_all.sh
```

### 步驟 2: 驗證設定

```bash
echo $PDK_ROOT
# 應該顯示你的 PDK 路徑，例如: /home/jimmy/pdk

ls $PDK_ROOT/sky130A/libs.tech/ngspice/sky130.lib.spice
# 應該能找到此檔案
```

### 步驟 3: 執行模擬

```bash
./run_all.sh
```

## 支援的 PDK 位置

腳本會按以下順序自動搜尋 PDK：

1. **環境變數 PDK_ROOT**（最高優先）
   ```bash
   export PDK_ROOT=/your/custom/path
   ```

2. **/opt/pdk**（系統級安裝）
   ```bash
   sudo mkdir -p /opt/pdk
   # 將 PDK 安裝或連結到這裡
   ```

3. **~/pdk**（使用者級安裝）
   ```bash
   mkdir -p ~/pdk
   # 將 PDK 安裝或連結到這裡
   ```

4. **~/.volare/volare/sky130**（volare 自動安裝）
   ```bash
   pip3 install volare
   volare enable --pdk sky130
   # 自動安裝到 ~/.volare/
   ```

## PDK 安裝方法

### 方法 1: 使用 volare（最簡單）

```bash
pip3 install volare
volare enable --pdk sky130
export PDK_ROOT=$HOME/.volare/volare/sky130/versions/$(volare ls-remote | grep sky130 | head -1 | awk '{print $1}')
```

### 方法 2: 安裝到 /opt（系統級）

```bash
sudo mkdir -p /opt/pdk
cd /opt/pdk
sudo git clone https://github.com/google/skywater-pdk.git
cd skywater-pdk
sudo git submodule update --init libraries/sky130_fd_pr/latest
sudo ln -s $(pwd)/libraries/sky130_fd_pr/latest /opt/pdk/sky130A

# 設定環境變數
export PDK_ROOT=/opt/pdk
```

### 方法 3: 使用現有 PDK

如果你已經有 PDK 在 `/home/jimmy/pdk/sky130A`，直接設定環境變數：

```bash
export PDK_ROOT=/home/jimmy/pdk
```

或使用輔助腳本：

```bash
./setup_pdk.sh
# 選擇選項 3（只設定環境變數）
```

## GitHub 工作流程

### Clone 專案後的設定

```bash
# 1. Clone 專案
git clone <your-repo-url>
cd Three-stage-CMOS-ring-oscillator

# 2. 安裝 PDK（選擇一種方法）
pip3 install volare
volare enable --pdk sky130

# 3. 設定環境變數
export PDK_ROOT=$HOME/.volare/volare/sky130/versions/$(ls -t $HOME/.volare/volare/sky130/versions/ | head -1)

# 或永久設定
echo "export PDK_ROOT=\$HOME/.volare/volare/sky130/versions/\$(ls -t \$HOME/.volare/volare/sky130/versions/ | head -1)" >> ~/.bashrc
source ~/.bashrc

# 4. 執行模擬
./run_all.sh
```

## 檔案說明

- **ring_oscillator.cir** - 使用 `$PDK_ROOT` 變數
- **vdd_sweep.cir** - 使用 `$PDK_ROOT` 變數
- **run_sim.sh** - 展開環境變數並執行 ngspice
- **run_all.sh** - 自動檢測 PDK 位置並執行完整測試
- **setup_pdk.sh** - 輔助設定 PDK 路徑
- **.env.example** - 環境變數範例檔
- **.gitignore** - 確保 PDK 不被提交到 Git

## 常見問題

### Q: 為什麼不直接把 PDK 路徑寫死在電路檔案中？
**A**: 寫死路徑會導致：
- 其他使用者無法執行（路徑不同）
- 無法靈活切換不同版本的 PDK
- 不符合開源專案的可移植性原則

### Q: 錯誤訊息 "Could not find library file $PDK_ROOT/..."
**A**: 環境變數未設定或未正確傳遞。解決方法：
```bash
export PDK_ROOT=/your/pdk/path
./run_all.sh
```

### Q: 我想使用不同的 PDK 位置怎麼辦？
**A**: 只需設定 `PDK_ROOT` 環境變數：
```bash
export PDK_ROOT=/my/custom/pdk/location
```

### Q: 能否直接修改電路檔案改成固定路徑？
**A**: 可以，但不建議。如果真的需要：
```spice
# 將這行:
.lib $PDK_ROOT/sky130A/libs.tech/ngspice/sky130.lib.spice tt

# 改為:
.lib /your/fixed/path/sky130A/libs.tech/ngspice/sky130.lib.spice tt
```

## 建議的 .bashrc 設定

將以下內容加入你的 `~/.bashrc`:

```bash
# SkyWater PDK 設定
export PDK_ROOT=/opt/pdk  # 或你的 PDK 位置

# 或動態偵測 volare 安裝的最新版本
if [ -d "$HOME/.volare/volare/sky130" ]; then
    export PDK_ROOT="$HOME/.volare/volare/sky130/versions/$(ls -t $HOME/.volare/volare/sky130/versions/ | head -1)"
fi
```

---

**總結**: 使用環境變數 `PDK_ROOT` 讓專案更靈活、可移植，適合開源分享！
