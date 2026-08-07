# Oasis Tool Box
This repository manages a collection of AI tool packages designed for use with Oasis, an AI assistant tool I’m developing specifically for OpenWrt.    

Oasis introduces a framework that allows AI to access tools via UBUS, the core messaging system of the OpenWrt ecosystem.
By writing scripts that follow the framework’s defined rules, developers can make tool definitions understandable and usable by AI through Oasis

Detail: https://github.com/utakamo/oasis/tree/main/oasis-mod-tool

# 🚀Prerequisite: Install an Oasis Development Build with Manifest Support

The latest `oasis-tool-box` source is not compatible with the released Oasis
v3.2.6.

It requires an unreleased build from the current Oasis main branch, including
the matching `oasis-mod-tool` Manifest support.

The Manifest recognition implementation is available in the current Oasis
source tree, but the corresponding Oasis software release has not yet been
published.

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
7. `user@user:~/openwrt$ scp ./bin/packages/<target architecture>/tools/oasis-tool-template_1.0.0-r3_all.ipk root@192.168.1.1:/root`

## Install:  
```
root@OpenWrt:~# opkg install oasis-tool-template_1.0.0-r3_all.ipk
root@OpenWrt:~# reboot
```

## Manifest Management

Each package ships its generated Manifest files under
`files/etc/oasis/tool-manifest.d/`. Installing a package places its tool
implementation and Manifest on the device, but does not apply the Manifest
automatically.

After installing a package, restart `rpcd` or reboot so that its rpcd server is
available. Then open the Oasis Tools page, select **Refresh**, review the
newly detected Manifest and its tools, and select **Apply** to register it.
Newly registered tools are disabled by default; enable the required tools from
the Oasis Tools page.

Regenerate a Manifest whenever its Lua or ucode tool definition changes. Pass
an absolute source path so Oasis records the corresponding runtime path:

```sh
oasis manifest build \
  /absolute/path/oasis-tool-template/files/usr/libexec/rpcd/oasis.lua.template.tool \
  > oasis-tool-template/files/etc/oasis/tool-manifest.d/lua.oasis.lua.template.tool.json
```

Rebuild the package after regenerating its Manifest.
## Template Tools
<img width="947" height="439" alt="image" src="https://github.com/user-attachments/assets/64dc5250-266f-4e4f-b0f6-f89a987b0e90" />
<img width="947" height="439" alt="image" src="https://github.com/user-attachments/assets/3af40cee-db26-4ae3-9621-4d40f966470e" />

# Tool Use
<img width="944" height="438" alt="image" src="https://github.com/user-attachments/assets/610b94b8-3adf-4580-9a77-3e955c8ba7af" />

# 🛠️oasis-tool-test
AI Tool Test For Oasis  

# 🛠️oasis-tool-analysis
To analyze OpenWrt devices, the AI performs operations on MTD devices, controls GPIOs, and more.  
under development ...

# 🛠️oasis-tool-wireguard
WireGuard Auto Setup Tool
under development ...
