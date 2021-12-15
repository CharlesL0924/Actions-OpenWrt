#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

cat > package/base-files/files/etc/banner <<EOF
——————————————————————————
OpenWrt
——————————————————————————
EOF

# Modify default IP
sed -i 's/192.168.1.1/192.168.200.254/g' package/base-files/files/bin/config_generate
sed -i "s/timezone='UTC'/timezone='CST-8'/" package/base-files/files/bin/config_generate
sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

git clone https://github.com/openwrt/packages /tmp/packages
cp -rf /tmp/packages/utils/podman package/utils/podman
cp -rf /tmp/packages/utils/cni package/utils/cni
cp -rf /tmp/packages/utils/conmon package/utils/conmon
cp -rf /tmp/packages/utils/runc package/utils/runc
cp -rf /tmp/packages/utils/containerd package/utils/containerd
cp -rf /tmp/packages/utils/cni-plugins package/utils/cni-plugins
cp -rf /tmp/packages/utils/gnupg2 package/utils/gnupg2
cp -rf /tmp/packages/libs/gpgme package/libs/gpgme
cp -rf /tmp/packages/libs/libassuan package/libs/libassuan
cp -rf /tmp/packages/libs/libgpg-error package/libs/libgpg-error
cp -rf /tmp/packages/libs/libksba package/libs/libksba
cp -rf /tmp/packages/libs/npth package/libs/npth
mkdir package/lang
cp -rf /tmp/packages/lang/golang package/lang/golang

sed -i "s/+btrfs-progs//g" package/utils/podman/Makefile
# sed -i "s/+conmon//g" package/utils/podman/Makefile
sed -i "/^GO_PKG_TAGS/c GO_PKG_TAGS=seccomp,exclude_graphdriver_devicemapper,exclude_graphdriver_btrfs,btrfs_noversion" package/utils/podman/Makefile

echo "src-git small https://github.com/kenzok8/small" >> feeds.conf.default
echo "src-git others https://github.com/kenzok8/openwrt-packages" >> feeds.conf.default