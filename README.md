# Oasis Tool Box
This repository manages a collection of AI tool packages designed for use with Oasis, an AI assistant tool I’m developing specifically for OpenWrt.    

Oasis introduces a framework that allows AI to access tools via UBUS, the core messaging system of the OpenWrt ecosystem.
By writing scripts that follow the framework’s defined rules, developers can make tool definitions understandable and usable by AI through Oasis

Detail: https://github.com/utakamo/oasis/tree/main/oasis-mod-tool

# 🚀Prerequisite: Install oasis (Latest Ver: v3.1.2)

|  Detail  |         description       |
| :---: | :---  |
|  OpenWrt Version Support    |   24.x   |
|  Hardware Support |   All  |
|  Install Size |  1.44MiB  |

```
wget -O - https://raw.githubusercontent.com/utakamo/oasis/refs/heads/main/oasis_installer.sh | sh
```
> [!NOTE]
> If an SSL certificate error occurs when running the above installer script, run the `date` command to check the current time. If the displayed time is incorrect, run `/etc/init.d/sysntpd restart`.
> ```
> root@OpenWrt:~# date
> root@OpenWrt:~# /etc/init.d/sysntpd restart
> ```

# 🛠️oasis-tool-template
This tool package serves as a template for defining AI tools used with Oasis

## How to build & Upload 
develop enviroment ex: `Ubuntu / OpenWrt Buildroot`
1. `user@user:~/openwrt$ echo "src-git tools https://github.com/utakamo/oasis-tool-box.git" >> feeds.conf`
2. `user@user:~/openwrt$ ./scripts/feeds update tools`
3. `user@user:~/openwrt$ ./scripts/feeds install -a -p tools`
4. `user@user:~/openwrt$ make menuconfig`
5. Check oasis-tool-template [Category: utakamo]
6. `user@user:~/openwrt$ make package/oasis-tool-template/compile`
7. `user@user:~/openwrt$ scp ./bin/packages/<target architecture>/tools/oasis-tool-template_1.0.0-r1_all.ipk root@192.168.1.1:/root`

## Install:  
```
root@OpenWrt:~# opkg install oasis-tool-template_1.0.0-r1_all.ipk
root@OpenWrt:~# reboot
```
## Template Tools
<img width="947" height="439" alt="image" src="https://github.com/user-attachments/assets/64dc5250-266f-4e4f-b0f6-f89a987b0e90" />
<img width="947" height="439" alt="image" src="https://github.com/user-attachments/assets/3af40cee-db26-4ae3-9621-4d40f966470e" />

# Tool Use
<img width="944" height="438" alt="image" src="https://github.com/user-attachments/assets/610b94b8-3adf-4580-9a77-3e955c8ba7af" />

# 🛠️oasis-tool-analysis
To analyze OpenWrt devices, the AI performs operations on MTD devices, controls GPIOs, and more.  
under development ...

