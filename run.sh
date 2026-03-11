#!/bin/bash
PROGRAM="main.py"

echo "Stopping lightdm to free GPU (if running)..."
sudo systemctl stop lightdm

echo "Setting EGLFS environment variables..."
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms        # 使用 KMS/DRM 直连
export QT_QPA_EGLFS_KMS_ATOMIC=1                 # 原子模式更稳定
export QT_QPA_EGLFS_KMS_CONFIG=/home/linaro/.config/kms.json
# export QT_QPA_EGLFS_KMS_CONFIG=/dev/dri/card0
export QT_QPA_EGLFS_WIDTH=1080
export QT_QPA_EGLFS_HEIGHT=1080
export QT_QPA_EGLFS_PHYSICAL_WIDTH=128          # mm，根据屏幕实际尺寸
export QT_QPA_EGLFS_PHYSICAL_HEIGHT=128
export QT_QPA_EGLFS_CURSOR=1                     # 显示鼠标
# export QT_QPA_EVDEV_TOUCHSCREEN=/dev/input/event2 # 触摸设备，根据实际 event 编号


# 确保当前用户可以访问 GPU 和输入设备
echo "Ensuring access to /dev/dri and /dev/input..."
# 当前用户必须在 video 和 input 组，否则使用 sudo 会丢掉 DISPLAY
ls -l /dev/dri /dev/input

echo "Running $PROGRAM..."
# 不使用 sudo，直接运行
export QSG_INFO=1
python3 "$PROGRAM"

echo "Program exited. You may restart lightdm manually if needed."