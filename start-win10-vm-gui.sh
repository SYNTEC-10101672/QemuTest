#!/bin/bash

# Win10虛擬機啟動腳本 (圖形界面版本)
# 需要X11轉發支援

VM_NAME="Win10-Dev"
VM_DIR="$HOME/vm/win10"
SHARED_DIR="$HOME/vm/shared"
ISO_PATH="$VM_DIR/windows10.iso"
DISK_PATH="$VM_DIR/win10.qcow2"

# 檢查必要文件
if [ ! -f "$DISK_PATH" ]; then
    echo "錯誤: 虛擬硬碟不存在，請先執行 ./setup-qemu.sh"
    exit 1
fi

if [ ! -f "$ISO_PATH" ]; then
    echo "警告: Windows 10 ISO不存在於 $ISO_PATH"
    echo "請下載Windows 10 ISO並放置於該位置"
    read -p "是否繼續？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    ISO_OPTION=""
else
    ISO_OPTION="-cdrom $ISO_PATH"
fi

# 創建共享目錄
mkdir -p "$SHARED_DIR"

# 複製專案到共享目錄
echo "複製.NET專案到共享目錄..."
cp -r /home/s911335/QemuTest/* "$SHARED_DIR/" 2>/dev/null || true

echo "啟動Win10虛擬機 (圖形界面)..."
echo "虛擬機規格："
echo "- RAM: 4GB"
echo "- CPU: 2核心"
echo "- 硬碟: 40GB"
echo "- 網路: NAT"
echo "- 共享目錄: $SHARED_DIR"
echo "- 顯示: SDL/GTK圖形界面"
echo ""

# 啟動QEMU虛擬機 (圖形界面版本)
qemu-system-x86_64 \
    -name "$VM_NAME" \
    -m 4096 \
    -smp 2 \
    -cpu qemu64 \
    -hda "$DISK_PATH" \
    $ISO_OPTION \
    -netdev user,id=net0,smb="$SHARED_DIR" \
    -device rtl8139,netdev=net0 \
    -display gtk \
    -boot order=dc \
    -enable-kvm 2>/dev/null || \
qemu-system-x86_64 \
    -name "$VM_NAME" \
    -m 4096 \
    -smp 2 \
    -cpu qemu64 \
    -hda "$DISK_PATH" \
    $ISO_OPTION \
    -netdev user,id=net0,smb="$SHARED_DIR" \
    -device rtl8139,netdev=net0 \
    -display gtk \
    -boot order=dc

echo ""
echo "虛擬機已啟動"