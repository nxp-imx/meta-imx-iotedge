# Copyright 2019-2020 NXP
# Released under the MIT license (see COPYING.MIT for the terms)
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://Fix-build-break-on-rust-1.37.0.postpatch"

POST_PATCHS = "Fix-build-break-on-rust-1.37.0.postpatch \
"

do_patch[postfuncs] += "add_workload_patch"

add_workload_patch () {
    cd ${WORKDIR}/iotedge-${PV}
    for extra_patch in ${POST_PATCHS} ; do
        if [ -e ${WORKDIR}/${extra_patch} ]; then
            patch -p1 < ${WORKDIR}/${extra_patch}
        fi
    done

    cd ${S}
}
# Add patch to apply workaround to use arm32 edgeAgent for ARM64 platforms
do_install_append_mx8 () {
    # Add patch here
    sed -i -e 's,azureiotedge-agent:1.0,azureiotedge-agent:1.0.6-linux-arm32v7,g' ${D}${sysconfdir}/iotedge/config.yaml

}
