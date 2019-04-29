# i.MX Azure IoT Edge Setup Script
#
# See README for instructions on using this script.
#
# Copyright 2019 NXP
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

if [ ! -e $1/conf/local.conf.sample ]; then
    if [ "$MACHINE" = "" ]; then
        MACHINE=imx6qpsabresd
    fi
    EULA=$EULA DISTRO=$DISTRO MACHINE=$MACHINE . ./fsl-setup-release.sh -b $@

    echo "# layers for Azure IoT Edge" >> conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-iotedge\"" >> conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-rust\"" >> conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-virtualization\"" >> conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-imx-iotedge\"" >> conf/bblayers.conf
else
    . ./sources/base/setup-environment $@
fi

echo ""
echo "You can now create an i.MX Azure IoT Edge image:"
echo "    $ bitbake core-image-weston"
echo ""
