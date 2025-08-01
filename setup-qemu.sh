#!/bin/bash

# QEMU Win10開發環境設置腳本
# 適用於WSL2 Linux環境

echo "=== QEMU Win10開發環境設置 ==="

# 更新套件列表
echo "1. 更新套件列表..."
sudo apt update

# 安裝QEMU和相關工具
echo "2. 安裝QEMU和相關套件..."
sudo apt install -y \
    qemu-system-x86 \
    qemu-utils \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    virt-manager \
    ovmf \
    samba \
    samba-common-bin

# 創建虛擬機目錄
echo "3. 創建虛擬機目錄..."
mkdir -p ~/vm/win10
mkdir -p ~/vm/shared

# 創建虛擬硬碟
echo "4. 創建Win10虛擬硬碟 (40GB)..."
if [ ! -f ~/vm/win10/win10.qcow2 ]; then
    qemu-img create -f qcow2 ~/vm/win10/win10.qcow2 40G
    echo "虛擬硬碟已創建: ~/vm/win10/win10.qcow2"
else
    echo "虛擬硬碟已存在，跳過創建"
fi

# 檢查UEFI固件
echo "5. 檢查UEFI固件..."
if [ -f /usr/share/OVMF/OVMF_CODE.fd ]; then
    echo "UEFI固件已安裝"
else
    echo "警告: UEFI固件未找到，將使用BIOS模式"
fi

echo "=== 基本設置完成 ==="
echo ""
echo "接下來步驟："
echo "1. 下載Windows 10 ISO文件到 ~/vm/win10/windows10.iso"
echo "2. 執行 ./start-win10-vm.sh 來啟動虛擬機"
echo "3. 配置文件共享 (執行 ./setup-samba.sh)"
echo ""