#!/usr/bin/env lua

local server = require("oasis.local.tool.server")

-- This AI tool facilitates the installation and configuration of WireGuard VPN.
-- Its implementation is based on the official OpenWrt documentation referenced below.
-- URL: https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn
server.tool("wireguard_user_manual", {
    tool_desc   = "Read the instructions for setting up WireGuard.",
    call = function()
        return server.response({
            install_and_setup_manual = {
                -- Preparation
                "Step 1: \nUse the tool named \"install_wireguard_package\" to install wireguard package.\n\n" ..
                -- Key Management
                "Step 2: \nUse the tool named \"generate_wireguard_keys\" to generate wireguard private, public, and pre-shared keys.\n\n" ..
                -- Firewall
                "Step 3: \nUse the tool named \"setup_firewall_for_wireguard\" to configure the firewall so that UDP traffic to the WireGuard port is accepted and the virtual interface is included in the LAN zone.\n\n" ..
                -- Network
                "Step 4: \nUse the tool named \"setup_wireguard_network\" to create the WireGuard network interface (VPN_IF) with IPv4 (VPN_ADDR) and IPv6 (VPN_ADDR6) addresses, and register the peer configuration (public key, preshared key, allowed IPs).\n\n"
            },

            note = "If you're not aware of the tools required for each step, please ask the user to enable the relevant tools from the Tools tab."
        })
    end
})

-- Preparation
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn#preparation
server.tool("install_wireguard", {
    tool_desc = "Install wireguard package (wireguard-tools or luci-proto-wireguard package)",
    args_desc = {
        "Set package type value [CLI Type (wireguard-tools) value: '0', WebUI Type (luci-proto-wireguard) value: '1']",
    },
    args = { pkg_type = "a_string"},
    exec_msg = "Installing WireGuard Package. Please Wait ...",
    download_msg = "Installing The WireGuard Package",
    call = function(args)
        local mgr = require("oasis.local.tool.package.manager")

        local package   = ""
        local request   = nil
        local reboot    = nil

        if args.pkg_type == "0" then
            package = "wireguard-tools"
        elseif args.pkg_type == "1" then
            package = "luci-proto-wireguard"
            request = "Please inform the user that a system reboot is required after installing WireGuard."
            reboot = true
        else
            return server.response(
                {
                    error = "Invalid pkg_type value.",
                    caution = "You must select CLI Ver:'0' or WebUI Ver:'1'. ",
                }
            )
        end

        if mgr.check_installed_pkg(package) then
            return server.response(
                { 
                    result = "The WireGuard package (" .. package .. ") is already installed.",
                })
        end

        if not mgr.update_pkg_info("ipk") then
            return server.response({ error = "Failed to update package information. Please check network status." })
        end

        if not mgr.install_pkg(package) then
            return server.response({ error = "Failed to install " .. package .. " package." })
        end

        return server.response(
            {
                result = "The " .. package .. " package has been installed successfully.",
                request = request,
                reboot = reboot,
            }
        )
    end
})

-- Key Management
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn#key_management
server.tool("generate_wireguard_keys", {
    tool_desc   = "Generate and setup wireguard private and pre-shared, public key.",

    call = function(args)
        local util  = require("luci.util")
        local misc  = require("oasis.chat.misc")
        local mgr   = require("oasis.local.tool.package.manager")

        if mgr.check_pkg_reboot_required("luci-proto-wireguard") then
            return server.response(
                {
                    error = "It appears that luci-proto-wireguard was installed during the previous operation.A system reboot is required after installing this package, and the tool cannot be executed at this time. Please restart the system.",
                    reboot = true,
                }
            )
        end

        local server_private_key = util.exec("wg genkey"):gsub("\n$", "")
        local server_public_key  = util.exec("echo " .. server_private_key .. " | wg pubkey"):gsub("\n$", "")

        local client_private_key = util.exec("wg genkey"):gsub("\n$", "")
        local client_public_key  = util.exec("echo " .. client_private_key .. " | wg pubkey"):gsub("\n$", "")

        local pre_shared_key = util.exec("wg genpsk"):gsub("\n$", "")

        local user_only = "Generate Key Success\n\n"
        user_only = user_only .. "Memo below keys.\n"
        user_only = user_only .. "- WireGuard Server Public Key\n"
        user_only = user_only .. "```\n" .. server_public_key .. "\n```"
        user_only = user_only .. "- WireGuard Client Public Key\n"
        user_only = user_only .. "```\n" .. client_public_key .. "\n```" 
        user_only = user_only .. "- WireGuard Pre-shared Key\n"
        user_only = user_only .. "```\n" .. pre_shared_key .. "\n```" 

        -- generate key file for other tool use

        -- Public Key
        misc.write_file("/tmp/oasis/wireguard_server_public_key", server_public_key)
        misc.write_file("/tmp/oasis/wireguard_client_public_key", client_public_key)

        -- Private Key
        misc.write_file("/tmp/oasis/wireguard_server_private_key", server_private_key)
        misc.write_file("/tmp/oasis/wireguard_client_private_key", client_private_key)

        -- Pre-Shared Key
        misc.write_file("/tmp/oasis/wireguard_pre_shared_key", pre_shared_key)

        -- permission: 600
        os.execute("chmod 600 /tmp/oasis/wireguard_server_public_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_client_public_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_pre_shared_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_server_private_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_client_private_key")

        return server.response(
            {
                result = "The public keys and pre-shared key for the WireGuard server and client have been successfully created and configured.",
                request = "The public keys and pre-shared key have not been shared with me, as the AI. Please make sure the user checks the key information displayed in the UI and takes notes if necessary. This message must be communicated to the user.",
                user_only = user_only,
            }
        )
    end
})

-- Firewall
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn#firewall
server.tool("setup_firewall_for_wireguard", {

    tool_desc   = "Set up WireGuard firewall rules",

    args_desc   = {
        "Set virtual Interface name (ex: 'vpn')",
        "Set Wireguard Port (ex: '51820')",
    },

    args = {
        vif = "a_string",
        port = "a_string",
    },

    call = function(args)
        local uci = require("luci.model.uci").cursor()

        local port = tonumber(args.port)

        if (port == nil) or (type(port) ~= "number") then
            return server.response(
                {
                    error = "Invalid Port: " .. args.port
                }
            )
        end

        os.execute("uci rename firewall.@zone[0]=lan")
        os.execute("uci rename firewall.@zone[1]=wan")

        -- del_list
        local lan_list = uci:get_list("firewall", "lan", "network")

        for idx, val in ipairs(lan_list) do
            if val == args.vpn then
                table.remove(lan_list, idx)
            end
        end

        -- add_list
        lan_list[#lan_list + 1] = args.vpn

        -- del_list and add_list process
        uci:set_list("firewall", "lan", "network", lan_list)

        uci:delete("firewall", "wg")
        uci:set("firewall", "wg", "rule")
        uci:set("firewall", "wg", "name", "Allow-WireGuard")
        uci:set("firewall", "wg", "src", "wan")
        uci:set("firewall", "wg", "dest_port", port)
        uci:set("firewall", "wg", "proto", "udp")
        uci:set("firewall", "wg", "target", "ACCEPT")
        uci:commit("firewall")

        -- cmd.restart_service("firewall")
        os.execute("/etc/init.d/firewall restart")

        return server.response(
            {
                result = "The firewall configuration for WireGuard has been completed.",
                request = "As the next step, please prompt the user to specify the VPN Interface name, IPv4 address and IPv6 address.",
                note = "If the tool setup_wireguard_network is enabled, you as the AI should be able to apply the VPN settings sepecified by user through executing this tool.",
            }
        )
    end
})

-- Network
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server#network
server.tool("setup_wireguard_network", {
    tool_desc   = "Configure WireGuard network interface and peer using system-generated keys",

    args_desc   = {
        "VPN interface name (ex: 'wg0')",
        "VPN IPv4 address (ex: '10.0.0.1/24')",
        "VPN IPv6 address (ex: 'fd00:10::1/64')"
    },

    args = {
        vpn_if   = "a_string",
        vpn_addr = "a_string",
        vpn_addr6 = "a_string"
    },

    call = function(args)
        local uci  = require("luci.model.uci").cursor()
        local misc = require("oasis.chat.misc")

        local server_private_key_file = "/tmp/oasis/wireguard_server_private_key"
        local client_public_key_file  = "/tmp/oasis/wireguard_client_public_key"
        local pre_shared_key_file     = "/tmp/oasis/wireguard_pre_shared_key"

        local private_key = misc.read_file(server_private_key_file)
        local peer_pubkey = misc.read_file(client_public_key_file)
        local peer_psk    = misc.read_file(pre_shared_key_file)

        if not private_key or private_key == "" then
            return server.response({ error = "Private key not found: " .. server_private_key_file })
        end
        if not peer_pubkey or peer_pubkey == "" then
            return server.response({ error = "Peer public key not found: " .. client_public_key_file })
        end
        if not peer_psk or peer_psk == "" then
            return server.response({ error = "Peer preshared key not found: " .. pre_shared_key_file })
        end

        local listen_port = uci:get("firewall", "wg", "dest_port", port)

        -- IPv4 Client Address Calculation (e.g., 10.0.0.1/24 → 10.0.0.2/32)
        local client_ipv4 = args.vpn_addr:gsub("(%d+)%.(%d+)%.(%d+)%.(%d+)(/%d+)", "%1.%2.%3.2/32")

        -- IPv6 Client Address Calculation (e.g., fd00:10::1/64 → fd00:10::2/128)
        local client_ipv6 = args.vpn_addr6:gsub("::%x+/%d+", "::2/128")

        -- VPN Interface
        uci:delete("network", args.vpn_if)
        uci:set("network", args.vpn_if, "interface")
        uci:set("network", args.vpn_if, "proto", "wireguard")
        uci:set("network", args.vpn_if, "private_key", private_key)
        uci:set("network", args.vpn_if, "listen_port", tonumber(listen_port))
        uci:add_list("network", args.vpn_if, "addresses", args.vpn_addr)
        uci:add_list("network", args.vpn_if, "addresses", args.vpn_addr6)

        -- Peer
        uci:delete("network", "wgclient")
        uci:set("network", "wgclient", "wireguard_" .. args.vpn_if)
        uci:set("network", "wgclient", "public_key", peer_pubkey)
        uci:set("network", "wgclient", "preshared_key", peer_psk)
        uci:add_list("network", "wgclient", "allowed_ips", client_ipv4)
        uci:add_list("network", "wgclient", "allowed_ips", client_ipv6)

        uci:commit("network")

        -- cmd.restart_service_after_10s("network")
        os.execute("/etc/init.d/network restart")

        return server.response({
            result = "WireGuard interface '" .. args.vpn_if .. "' configured successfully with IPv4 " .. args.vpn_addr .. " and IPv6 " .. args.vpn_addr6 .. ".",
            request = "Please verify peer connectivity and ensure firewall rules are configured."
        })
    end
})

server.run(arg)
