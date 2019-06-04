meta-imx-iotedge
===========

This layer provides support for building Azure [IoT Edge](https://github.com/azure/iotedge)
on NXP i.MX platforms.

Recently, it has been built only with the xwayland backend.

Build instructions
===========

Install the `repo` utility:

$: mkdir ~/bin
$: curl http://commondatastorage.googleapis.com/git-repo-downloads/repo  > ~/bin/repo
$: chmod a+x ~/bin/repo
$: PATH=${PATH}:~/bin

Download the i.MX BSP Yocto Project Environment

$: mkdir imx-yocto-bsp
$: cd imx-yocto-bsp
$: repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-sumo -m imx-4.14.98-2.0.0_demo_azure-iotedge.xml
$: repo sync

Setup and Build for XWayland

  Build for i.MX 6QP SDB platform
    $: MACHINE=imx6qpsabresd DISTRO=fsl-imx-xwayland source ./imx-azure-setup.sh bld-azure

  Build for i.MX 8MM EVK platform
    $: MACHINE=imx8mmevk DISTRO=fsl-imx-xwayland source ./imx-azure-setup.sh bld-azure

Build the rootfs with Azure IoT Edge

  $: bitbake nxp-image-azure-iotedge

Connect i.MX device to IoT Edge Hub
===========

1. Burn the built SD Card image and boot up your i.MX device .

2. Configure the Azure IoT Edge Security Daemon
   Open the configuration file
   $: vi /etc/iotedge/config.yaml

 - Manually provision your device with Connection String (primary key)
   Find the provisioning section of the file and un-comment the manual provisioning mode.
   Update the value of device_connection_string with the Connection String from your IoT Edge device.

 - Update the Edge Agent image config
   Find the Edge Agent module spec section of the file and find the field "agent –> config –> image"
   Update the value of image with "mcr.microsoft.com/azureiotedge-agent:1.0.6-linux-arm32v7".

 - Input the Edge device hostname
   Find the Edge device hostname section of the file and update the value of hostname with the unique string, for example "imx8mmevk-sha001".

3. Setup the device local time and enable Ethernet
   Before restart IoT Edge Security Daemon, 2 important things should be done
   1. Update local device time
   $: date -s <yyyy-mm-dd>
   $: date -s <hh:mm:ss>

   2. Enable the ethernet
   $: udhcpc

   Restart the daemon:
   $: systemctl restart iotedge

4. Verify successful installation
   After followed the steps above, the IoT Edge runtime should be successfully provisioned and running on your device.
   You can check the status of the IoT Edge Daemon, you may find that the docker image "edgeAgent" are downloaded automatically:
   $: systemctl status iotedge

   Need wait several minutes for edgeAgent downloading and run in the docker container.
   Check docker container status using:
   $: docker ps

   And, list running modules with:
   $: iotedge list
   edgeAgent can be found in the module list

5. Deploy tempSenor module from Azure portal
   tempSenor is a demo module of the temperature sensor app. Now start to deploy this module to i.MX Device.

   Select your device
     1. Sign in to the Azure portal and navigate to your IoT hub.
     2. Select IoT Edge from the menu.
     3. Click on the ID of the target device from the list of devices.
     4. Select "Set Modules".

   Configure a deployment
     1. In the "Deployment Modules" section of the page, select "+ Add".
       And in the pop-up list, select the "IoT Edge Module".

     2. In the page "IoT Edge Custom Modules", fill in the fields:
       - Set Name wth tempSenor
       - Set Image URI with mcr.microsoft.com/azureiotedge-simulated-temperature-sensor:1.0.6-linux-arm32v7
       Click "Save"

     3. Configure the Edge runtime setting
       Click the “Configure advanced Edge runtime settings” button:
       - Set Edge Hub’s Image with mcr.microsoft.com/azureiotedge-hub:1.0.6-linux-arm32v7
       - Set Edge Agent’s Image with mcr.microsoft.com/azureiotedge-agent:1.0.6-linux-arm32v7
       Click "Next" -> "Summit"

   View the module on your device
     Wait for several minutes until tempSenor deploy and runs on the i.MX Device
     Find the module "tempSenor" by:
     $: iotedge list

