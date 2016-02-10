#!/bin/sh

TMP_MOUNT_POINT=/tmp/img_mount_point

IMG_FILE=$1
STORAGE_DIR=$2
VER=$3
PARTITION_NUM=$4

function usage {
    echo "Usage: $0 <path_to_image_file> <storage_directory> <version> <rootfs_partition>"
}

if [ -z $IMG_FILE ]; then
    echo "ERROR: No image file specified."
    usage
    exit 1
fi

if [ -z $STORAGE_DIR ]; then
    echo "ERROR: No storage directory specified"
    usage
    exit 1
fi

if [ -z $VER ]; then
    echo "ERROR: No version specified"
    usage
    exit 1
fi

if [ -z $PARTITION_NUM ]; then
    echo "ERROR: No partition number specified. You can find the number corresponding"
    echo "       to the rootfs partition in the file"
    echo "       meta-ostro/recipes-image/images/files/iot-cfg/disk-layout-<MACHINE>.json"
    usage
    exit 1
fi

OS_CORE_DIR=${STORAGE_DIR}/image/${VER}/os-core

LOOPDEV=`losetup -f`

mkdir -p $TMP_MOUNT_POINT
losetup $LOOPDEV $IMG_FILE
partprobe $LOOPDEV
mount ${LOOPDEV}p${PARTITION_NUM} $TMP_MOUNT_POINT
mkdir -p $OS_CORE_DIR
cp -a $TMP_MOUNT_POINT/* $OS_CORE_DIR
umount $TMP_MOUNT_POINT
losetup -d $LOOPDEV
rm -r ${OS_CORE_DIR}/lost+found