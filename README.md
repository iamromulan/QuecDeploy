# QuecDeploy: Quickly Install/Deploy Quectel Software/Firmware
![Screenshot 2024-07-31 130755](https://github.com/user-attachments/assets/dc351b48-3682-4181-b33c-843136221d1c)

## Changelog V1.0.3 (Nov 19th 2024):
- Added RM520N-GL firmware:
  - Stock: RM520NGLAAR01A08M4G_01.205.01.205 (2024-10-09)

## Changelog V1.0.2 (Sept 11th 2024):
- Added RM551E-GL firmware:
  - Stock: RM551EGL00AAR01A01M8G_01.001.01.001 (2024-08-05) (first non-beta firmware!!)

## Changelog V1.0.1 (Sept 4th 2024):
- Added RM520N-GL firmware:
  - Stock: RM520NGLAAR01A08M4G_01.204.01.204 (2024-06-20)
  - Certified: RM520NGLAAR03A04M4G_01.202.01.202 (2024-08-09)

## Changelog V1.0 (Aug 1st 2024):
- Fixed firmware not downloading to the correct directory
- When the firmware download completes you are returned to firmware selection instead of the main menu
- No longer alpha/pre-release status

## Features: 
- Megatools.exe integrated for downloads from mega.nz
- Download and install the following drivers easily:
     - NDIS Driver 2.7 (For AT+QCFG="usbnet",0 mode)
     - ECM Driver 1.0 (For AT+QCFG="usbnet",1 mode)
          - Note: After installing driver must be manually selected in Device Manager
          - Note: NDIS Driver must also be installed to access ports
     - MBIM Driver 1.3 (For AT+QCFG="usbnet",2 mode)
     - RNDIS Driver 1.1 (For AT+QCFG="usbnet",3 mode)

- Download and install Qflash 7.1 to C:\Quectel\Qflash\
    - adb and fastboot are included with Qflash 7.1 and automatically added to the system path
    - Desktop and Start Menu shortcuts are automatically created for Qflash 7.1
 
- Download and install Qnavigator 1.6.10 to C:\Quectel\Qflash\
    - Desktop and Start Menu shortcuts are automatically created for Qnavigator

- Download and Unzip firmware (Saves to C:\Quectel\firmware\<modem>\<type>\<firmware_version>\) for the following modems:
     - RM502Q-AE
     - RM520N-GL
     - RM521F-GL
     - RM551E-GL

- View AT Command Docs and other resources for: 
- (Opens up your web browser to https://github.com/iamromulan/<modem>/)
     - RM502Q-AE
     - RM520N-GL
     - RM521F-GL
     - RM551E-GL
 ## Planed additions for future versions:

- Integrate adb and fastboot binaries for quick management of modems via adb
- Integrate a COM port communication method for direct AT commands from QuecDeploy
- Automatic modem detection, AT commands, and modem setup wizard.
