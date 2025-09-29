## Changelog V1.0.7 (September 20th 2025):
![v1.0.7.png](https://raw.githubusercontent.com/iamromulan/QuecDeploy/refs/heads/main/images/v1.0.7.png)

- Replaced bad RM551EGL00AAR02A01M8G_2025_9_19_iamromulan_basic_eth (Custom) firmware with RM551EGL00AAR02A01M8G_2025_9_25_iamromulan_basic_eth (Custom)


## Changelog V1.0.6 (September 20th 2025):
![v1.0.6.png](https://raw.githubusercontent.com/iamromulan/QuecDeploy/refs/heads/main/images/v1.0.6.png)

- Updated embedded base64 megatools exe to megatools-1.11.5.20250706
  - Source: [https://xff.cz/megatools/builds/builds/megatools-1.11.5.20250706-win64.zip](https://xff.cz/megatools/builds/builds/megatools-1.11.5.20250706-win64.zip)
- Replaced NDIS Driver 2.7 with NDIS Driver 2.8
- Replaced Qflash 7.4 with Qflash 7.5 and included the latest platform-tools from [https://developer.android.com/tools/releases/platform-tools](https://developer.android.com/tools/releases/platform-tools)
- Added QWinLog 1.8
  - QWinLog allows the capture of an QXDM log via the DM port over USB.
  - Select USB port ---> DM COM port then click start.
  - An initial log is captured, then it continues to record module behavior to the log path until you click stop.
  - Quectel support will usually ask you to capture a QXDM log and reproduce the issue. (Start recording and then stop after the issue happens)
  - The AT command AT+QCFG="dbgctl",0 must be sent to the module to enable full QXDM capture before starting the capture
- Renamed RM520N-GL firmware categories. Stock has always been R01 firmware and Cert has always been R03. I am still unsure of each of their purpose. R01 seems better than R03 to me.
- Added 2 New RM520NGL R03 firmware:
  - RM520NGLAAR03A03M4G_2025_06_12
  - RM520NGLAAR03A03M4G_2025_04_28
- Added 1 new stock and 2 custom R01 RM551E-GL firmware
   - RM551EGL00AAR01A04M8G_2025_07_15 (Stock)
   - RM551EGL00AAR01A04M8G_2025_8_2_iamromulan_basic_eth (Custom)
   - RM551EGL00AAR01A04M8G_adb_2025_07_15 (Custom, closer to Stock though so kept same date)
- Added 1 new Stock and Custom R02 RM551E-GL firmware
  - RM551EGL00AAR02A01M8G_2025_08_13 (Stock)
  - RM551EGL00AAR02A01M8G_2025_9_19_iamromulan_basic_eth (Custom)
- Separated RM551E-GL firmware into R02 and R01, with Stock and Custom subcategories
  - Flashing from/to/between R01 and R02 requires an XQCN backup using QPST, an erase all flash using QFIL, and finally an XQCN restore using QPST . I plan to make a YouTube video demonstrating this with the R02 Custom firmware.
- Added a Web link to my YouTube Channel
  - https://www.youtube.com/@iamromulan

## Changelog V1.0.5 (May 4th 2025):

![v1.0.5.png](https://raw.githubusercontent.com/iamromulan/QuecDeploy/refs/heads/main/images/v1.0.5.png)

- Updated embedded base64 megatools exe to megatools-1.11.4.20250411
  - Source: [https://xff.cz/megatools/builds/builds/megatools-1.11.4.20250411-win64.zip](https://xff.cz/megatools/builds/builds/megatools-1.11.4.20250411-win64.zip)
- Replaced Qflash 7.3 with Qflash 7.4
	- Shortcut updates are now working
- Added modem: RM550V-GL both AA and AB version firmware:
     - Stock AA: [RM550VGL01AAR01A02M8G_01.001.01.001 (2024-06-06)](https://mega.nz/file/XQFSiLJB#qq4ImzXWOMGrTj7s0l7F-Qh0EgEQdq7tQuzmEpMP8jo)
     - Stock AB: [RM550VGL01ABR01A02M4G_01.001.01.001 (2024-11-28)](https://mega.nz/file/TVdRVYiK#4uYulUXAtYPtIKzrXopy97SY-vH0ynzkYVmnxxLUSF4)
     - Custom AA: [RM550VGL01AAR01A01M8G_iamromulan_mix-mod (2025-04-12)](https://mega.nz/file/yUdDEQBI#YpDN0CAhwPkQmDTOEImY5hmcYSmQlgsk15mEc-EqdsQ)
          - In an effort to bring firmware improvements and functions over from the RM551 firmware I mixed 550 firmware with 551 firmware. The majority of this firmware is RM551EGL00AAR01A01M8G (2024-08-05). However, NON-HLOS.ubi is from RM550VGL01AAR01A02M8G (2024-06-06) and ./update/firehose/rawprogram_nand_p4K_b256K_update.xml has been updated for flashing `RM550VGL01AA_VA` . `AT+QCFG="pcie/mode",1` works; so Ethernet works. For those that are not using an ethernet sled you may or may not have a better time with this . I am not sure. Probably better.
     - Custom AB: [RM550VGL00ABR01A02M8G_iamromulan_mix-mod (2025-04-12)](https://mega.nz/file/zQVREI7b#Vo6zTpn8JJbFf39llEJ3dAO9Bw-f03arLVj1eKORCqE)
          - In an effort to bring firmware improvements and functions over from the RM551 firmware I mixed 550 firmware with 551 firmware. The majority of this firmware is RM551EGL00AAR01A02M8G (2024-12-23). However, NON-HLOS.ubi is from RM550VGL01ABR01A02M4G (2024-11-28) and ./update/firehose/rawprogram_nand_p4K_b256K_update.xml has been updated for flashing `RM550VGL01AB_VB`. 
❗⚠️ **_This is untested. I do not have an AB to test with. Flash at your own risk._** ⚠️ ❗
- Added new firmware for the RM551E-GL:
     - Custom: [RM551EGL00AAR01A02M8G_iamromulan_basic_eth (2025-4-21)](https://mega.nz/file/GUkk0RpD#7JsFymzKBBKplxLs5tqc5-m7rBmrB2QPfTfMtf1ZQ4g)
          - Flash this if you plan to use the RM551E-GL in an ethernet sled. Once the flash completes wait for the ports to come back up in device manager. Once they come back, wait about 30 seconds +/- for the second reboot to occur. `AT+QCFG="pcie/mode",1` and `AT+QCFG="usbnet",1` are sent then it reboots. Once the second reboot occurs ethernet will be working with Luci and SSH access at `192.168.224.1`. Pre-set root password is `iamromulan`. Based on Stock firmware: RM551EGL00AAR01A02M8G (2024-12-23)
- Renamed `View AT Commands and other resources` section to `Useful Web Links`
     - Updated links 
- Added Qualcomm Tools section. Includes a combo installer that will get QPST 2.7.496.1 and QFIL 2.0.3.5 installed along with desktop icons.
- Uploaded to Microsoft:
![v1.0.5_comments.png](https://raw.githubusercontent.com/iamromulan/QuecDeploy/refs/heads/main/images/v1.0.5_comments.png)
![v1.0.5_scan.png](https://raw.githubusercontent.com/iamromulan/QuecDeploy/refs/heads/main/images/v1.0.5_scan.png)


## Changelog V1.0.4 (Feb 17th 2025):

- Updated embedded base64 megatools exe to megatools-1.11.3.20250203
  - Source: [https://xff.cz/megatools/builds/builds/megatools-1.11.3.20250203-win64.zip](https://xff.cz/megatools/builds/builds/megatools-1.11.3.20250203-win64.zip)
- Replaced Qflash 7.1 with Qflash 7.3
	- Note that when upgrading, the old Qflash 7.1 shortcuts are not removed (To be fixed)
- Added RM520N-GL firmware:
  - Stock: RM520NGLAAR01A08M4G_01.206.01.206 (2025-01-08)
  - Certified: RM520NGLAAR03A03M4G_01.204.01.204 (2024-12-09)
  - Certified: RM520NGLAAR03A04M4G_01.204.01.204 (2024-10-22)
- Added RM551E-GL firmware:
  -  Stock: RM551EGL00AAR01A02M8G_01.001.01.001 (2024-12-23)
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
