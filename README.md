# QemuTest - Linux環境下的.NET Framework開發方案

本專案提供在Linux環境 (WSL2) 下通過QEMU虛擬機運行Windows 10來開發.NET Framework 4.8.1應用程式的完整解決方案。

## 專案概述

- **專案類型**: Windows Forms應用程式
- **目標框架**: .NET Framework 4.8.1
- **開發環境**: Linux (WSL2) + QEMU Win10 + Visual Studio 2022
- **文件共享**: Samba網路共享

## 快速開始

### 步驟1: 設置QEMU虛擬化環境
```bash
chmod +x setup-qemu.sh
./setup-qemu.sh
```

### 步驟2: 設置文件共享
```bash
chmod +x setup-samba.sh
./setup-samba.sh
```

### 步驟3: 下載Windows 10 ISO
下載Windows 10 ISO檔案並放置於 `~/vm/win10/windows10.iso`

### 步驟4: 啟動虛擬機
```bash
chmod +x start-win10-vm.sh
./start-win10-vm.sh
```

### 步驟5: 在Windows 10中設置開發環境
請參閱 [win10-setup-guide.md](win10-setup-guide.md) 獲取詳細指南

## 文件結構

```
QemuTest/
├── QemuTest.sln                    # 解決方案文件
├── QemuTest/
│   ├── QemuTest.csproj             # 專案文件 (.NET Framework 4.8.1)
│   ├── App.config                  # 應用程式配置
│   ├── Program.cs                  # 程式進入點
│   ├── Form1.cs                    # 主窗體
│   └── Form1.Designer.cs           # 窗體設計器
├── setup-qemu.sh                   # QEMU環境設置腳本
├── start-win10-vm.sh               # 虛擬機啟動腳本
├── setup-samba.sh                  # Samba共享設置腳本
├── win10-setup-guide.md            # Windows 10設置指南
└── README.md                       # 本文件
```

## 系統需求

### Linux主機 (WSL2)
- Ubuntu 20.04+ 或其他相容發行版
- 至少8GB RAM (建議16GB)
- 至少50GB可用磁碟空間
- 穩定的網路連接

### Windows 10虛擬機
- 配置: 4GB RAM, 2 CPU核心, 40GB硬碟
- .NET Framework 4.8.1 Developer Pack
- Visual Studio 2022 Community或Professional

## 詳細設置指南

### 1. QEMU虛擬機配置

虛擬機使用以下規格：
- **記憶體**: 4GB (可在start-win10-vm.sh中調整)
- **CPU**: 2核心
- **存儲**: 40GB QCOW2格式虛擬硬碟
- **網路**: NAT模式，支援SMB共享
- **顯示**: VNC (localhost:5901)

### 2. 文件共享機制

使用Samba實現Linux和Windows之間的文件共享：
- **共享名**: QemuDev
- **Linux路徑**: `~/vm/shared/`
- **Windows存取**: `\\10.0.2.2\QemuDev`

### 3. 開發工作流程

1. **程式碼編輯**: 在Linux端使用偏好的編輯器
2. **檔案同步**: 通過Samba自動同步到Windows
3. **建置測試**: 在Windows虛擬機中使用VS2022
4. **版本控制**: 在Linux端使用Git管理

## 常用命令

### 虛擬機管理
```bash
# 啟動虛擬機
./start-win10-vm.sh

# 檢查虛擬機狀態 (在QEMU monitor中)
info status

# 優雅關機 (在QEMU monitor中)
system_powerdown
```

### 文件共享管理
```bash
# 重啟Samba服務
sudo systemctl restart smbd

# 檢查Samba狀態
sudo systemctl status smbd

# 查看共享列表
smbclient -L localhost -U $USER
```

## 疑難排解

### 常見問題

1. **虛擬機啟動失敗**
   - 檢查ISO檔案路徑是否正確
   - 確認虛擬硬碟已創建

2. **檔案共享無法連接**
   - 檢查Samba服務狀態
   - 驗證防火牆設置
   - 確認用戶密碼正確

3. **編譯錯誤**
   - 確認.NET Framework 4.8.1已安裝
   - 檢查專案參考是否完整

### 效能優化

1. **增加虛擬機記憶體**
   編輯 `start-win10-vm.sh`，修改 `-m 4096` 為更大值

2. **使用SSD存儲**
   將虛擬機檔案存放在SSD上

3. **關閉不必要的Windows服務**
   在虛擬機中停用不需要的服務

## 進階配置

### 啟用硬體加速 (如果可用)
如果您的系統支援KVM，可以啟用硬體加速：
```bash
# 檢查KVM支援
lsmod | grep kvm

# 修改啟動腳本，確保-enable-kvm參數生效
```

### 快照管理
```bash
# 創建快照
qemu-img snapshot -c snapshot_name ~/vm/win10/win10.qcow2

# 恢復快照
qemu-img snapshot -a snapshot_name ~/vm/win10/win10.qcow2

# 查看快照列表
qemu-img snapshot -l ~/vm/win10/win10.qcow2
```

## 貢獻與支援

如遇問題或有改進建議，請：
1. 檢查疑難排解章節
2. 查看相關日誌檔案
3. 建立Issue或Pull Request

## 授權

本專案採用MIT授權條款。