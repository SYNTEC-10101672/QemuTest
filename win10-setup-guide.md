# Windows 10虛擬機開發環境設置指南

## 1. Windows 10基本設置

### 安裝後的初始設置
1. 完成Windows 10安裝和初始配置
2. 連接網路 (虛擬機會自動獲得IP)
3. 運行Windows Update確保系統最新
4. 啟用Windows Defender或安裝防毒軟體

### 基本系統優化
```powershell
# 在PowerShell (管理員模式) 中執行
# 啟用開發者模式
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1

# 啟用長路徑支援
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWord
```

## 2. 連接共享文件夾

### 連接Linux共享目錄
1. 開啟檔案總管
2. 在地址欄輸入: `\\10.0.2.2\QemuDev`
3. 輸入Linux用戶名和Samba密碼
4. 將共享資料夾映射為網路磁碟機 (建議使用Z:)

### 驗證檔案存取
- 確認可以看到QemuTest專案檔案
- 測試讀寫權限是否正常

## 3. 安裝.NET Framework 4.8.1

### 下載並安裝
1. 前往Microsoft官網下載.NET Framework 4.8.1
   - URL: https://dotnet.microsoft.com/download/dotnet-framework/net481
2. 下載 ".NET Framework 4.8.1 Developer Pack"
3. 執行安裝程式並重新啟動系統

### 驗證安裝
```cmd
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" /v Release
```
應該返回Release REG_DWORD 533320或更高版本

## 4. 安裝Visual Studio 2022

### 下載Visual Studio 2022
1. 前往 https://visualstudio.microsoft.com/downloads/
2. 下載Visual Studio 2022 Community (免費版) 或Professional版
3. 執行安裝程式

### 選擇工作負載
安裝時請選擇以下工作負載：
- ✅ .NET桌面開發
- ✅ ASP.NET和Web開發 (可選)
- ✅ Visual Studio擴展開發 (可選)

### 個別元件 (重要)
在"個別元件"標籤中確保選擇：
- ✅ .NET Framework 4.8.1 SDK
- ✅ .NET Framework 4.8.1 targeting pack
- ✅ Windows 10 SDK (最新版本)

## 5. 配置開發環境

### Visual Studio設置
1. 啟動Visual Studio 2022
2. 登入Microsoft帳戶 (可選但建議)
3. 選擇偏好的開發設定

### 開啟專案
1. 選擇 "開啟專案或解決方案"
2. 瀏覽到 `Z:\QemuTest.sln` (假設映射為Z槽)
3. 開啟解決方案

### 驗證專案設置
1. 檢查專案屬性中的目標Framework是否為4.8.1
2. 確認所有參考都正確載入
3. 嘗試建置專案

## 6. 建置和執行

### 第一次建置
```
建置 → 重建解決方案
```

### 執行專案
- 按F5執行除錯模式
- 按Ctrl+F5執行不除錯模式

## 7. 疑難排解

### 常見問題
1. **建置錯誤**: 確認.NET Framework 4.8.1已正確安裝
2. **檔案存取問題**: 檢查網路磁碟機連接狀態
3. **效能問題**: 考慮增加虛擬機RAM到8GB

### 效能優化建議
1. 關閉不必要的Windows服務
2. 設定Windows Update為手動
3. 關閉Windows搜尋索引
4. 使用SSD存儲虛擬機檔案 (在Linux主機端)

## 8. 開發工作流程

### 建議的工作流程
1. 在Linux端編輯程式碼 (使用VS Code等)
2. 檔案會自動同步到Win10虛擬機
3. 在Win10虛擬機中建置和測試
4. 使用Git在Linux端管理版本控制

### 備份建議
- 定期建立虛擬機快照
- 重要程式碼變更後建立備份
- 使用Git追蹤所有程式碼變更