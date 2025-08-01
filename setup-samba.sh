#!/bin/bash

# Samba文件共享設置腳本
# 用於在Win10虛擬機中存取Linux檔案

echo "=== 設置Samba文件共享 ==="

# 確保samba已安裝
if ! command -v smbpasswd &> /dev/null; then
    echo "安裝Samba..."
    sudo apt update
    sudo apt install -y samba samba-common-bin
fi

# 創建共享目錄
SHARED_DIR="$HOME/vm/shared"
mkdir -p "$SHARED_DIR"

# 設置目錄權限
chmod 755 "$SHARED_DIR"

# 備份原始samba配置
if [ ! -f /etc/samba/smb.conf.backup ]; then
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup
fi

# 創建samba配置
echo "配置Samba共享..."
sudo tee -a /etc/samba/smb.conf > /dev/null << EOF

[QemuDev]
    comment = QEMU Development Shared Folder
    path = $SHARED_DIR
    browseable = yes
    writable = yes
    guest ok = no
    read only = no
    create mask = 0644
    directory mask = 0755
    valid users = $USER
EOF

# 創建samba用戶
echo "創建Samba用戶..."
echo "請為用戶 $USER 設置Samba密碼："
sudo smbpasswd -a $USER

# 重啟samba服務
echo "重啟Samba服務..."
sudo systemctl restart smbd
sudo systemctl enable smbd

# 顯示共享資訊
echo ""
echo "=== Samba設置完成 ==="
echo "共享名稱: QemuDev"
echo "共享路徑: $SHARED_DIR"
echo "用戶名: $USER"
echo ""
echo "在Windows中連接方式："
echo "1. 開啟檔案總管"
echo "2. 在地址欄輸入: \\\\10.0.2.2\\QemuDev"
echo "3. 使用用戶名 '$USER' 和剛才設置的密碼登入"
echo ""
echo "注意: 10.0.2.2 是QEMU預設的主機IP"