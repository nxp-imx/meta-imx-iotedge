meta-imx-iotedge
===========

This layer provides support for building Azure [IoT Edge](https://github.com/azure/iotedge)
on NXP i.MX platforms.

Recently, it has been built only with the xwayland backend.
This is not tested and not supported. It is a Demo only.

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
$: repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-zeus -m imx-5.4.3-1.0.0_demo-azure-iotedge.xml
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

 - Input the Edge device hostname
   Find the Edge device hostname section of the file and update the value of hostname with the unique string, for example "imx8mmevk-sha003".

3. Setup the device local time and enable Ethernet
   Before restart IoT Edge Security Daemon, 1 important thing should be done
   1. Update local device time
   $: date -s <yyyy-mm-dd>
   $: date -s <hh:mm:ss>

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
     1. In the "Modules -> IoT Edge Modules" section of the page, select "+ Add".
       And in the pop-up list, select the "Marketplace Module".

     2. In the page "IoT Edge Module Marketplace", search the module:
       - Input "Temperature" in the search bar
       - Find the module "Simulated Temperature Sensor" from Microsoft
       Click the icon

     3. Save the configure
       Click the “Review + Create” button:
       - Check the module "SimulatedTemperatureSensor" is added to "modules"
         And its image field is "mcr.microsoft.com/azureiotedge-simulated-temperature-sensor:1.0"
       Click "Create"

   View the module on your device
     Wait for several minutes until SimulatedTemperatureSensor deploy and runs on the i.MX Device
     Find the module "SimulatedTemperatureSensor" by:
     $: iotedge list

     As default, SimulatedTemperatureSensor will send 500 messages, at an interval of 5 seconds.
     The message is like:
        04/15/2020 14:05:16> Sending message: 1, Body: [{"machine":{"temperature":22.033405139941443,"pressure":1.1177296994869999},"ambient":{"temperature":21.073038873995205,"humidity":24},"timeCreated]
     Check log by:
     $: iotedge logs SimulatedTemperatureSensor
