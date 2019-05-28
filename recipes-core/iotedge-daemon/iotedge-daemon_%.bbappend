# Copyright 2019 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

# Add patch to apply workaround to use arm32 edgeAgent for ARM64 platforms
do_install_append_mx8 () {
    # Add patch here
    sed -i -e 's,azureiotedge-agent:1.0,azureiotedge-agent:1.0.6-linux-arm32v7,g' ${D}${sysconfdir}/iotedge/config.yaml

}
