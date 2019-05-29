# Copyright 2019 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "This is the demo image for Azure IoT Edge"

inherit core-image

IMAGE_FEATURES += " \
    debug-tweaks \
    splash \
    ssh-server-dropbear \
    package-management \
    hwcodecs \
"

IMAGE_INSTALL += " \
    packagegroup-core-basic \
    kernel-modules \
    iotedge-cli iotedge-daemon \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', ' weston weston-examples weston-init','', d)} \
"

# Enlarge free space in rootfs partition for docker images, such as edgeAgent
IMAGE_ROOTFS_EXTRA_SPACE_append = " + 1024000 "

export IMAGE_BASENAME = "nxp-image-azure-iotedge"
