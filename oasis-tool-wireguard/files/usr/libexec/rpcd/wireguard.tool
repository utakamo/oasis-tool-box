#!/usr/bin/env lua

local server = require("oasis.local.tool.server")

-- This AI tool facilitates the installation and configuration of WireGuard VPN.
-- Its implementation is based on the official OpenWrt documentation referenced below.
-- URL: https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn
server.tool("wireguard_manual_for_ai", {
    tool_desc   = "Read the instructions for setting up WireGuard. If the user asks about introduction or configuration of WireGuard, please read this first.",
    call = function()
        return server.response({
            install_and_setup_manual = {
                "Step 1: Install the WireGuard package.\n\n" ..
                "Step 2: Generate the WireGuard private key, public key, and pre-shared key.\n\n" ..
                "Step 3: Configure the firewall to allow UDP traffic to the WireGuard port and include the virtual interface in the LAN zone.\n\n" ..
                "Step 4: Create the WireGuard network interface with IPv4 and IPv6 addresses, and register the peer configuration (public key, preshared key, allowed IPs).\n\n"
            },
            note = "Do not mention tool names to the user. Always guide the user by describing the required action or information needed.",
            caution = "If you are unsure about the required steps, ask the user to enable the relevant tools from the Tools tab."
        })
    end
})

-- Preparation
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn#preparation
server.tool("install_wireguard", {
    tool_desc = "Install the WireGuard package (wireguard-tools or luci-proto-wireguard package) [Step 1]",
    args_desc = {
        "Set package type value [CLI version (wireguard-tools): '0', WebUI version (luci-proto-wireguard): '1']",
    },
    args = { pkg_type = "a_string"},
    exec_msg = "Please Wait ...",
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
            request = "Please inform the user that a system reboot is required after installing WireGuard. AI should tell the user to reboot the system before proceeding."
            reboot = true
        else
            return server.response({
                error = "Invalid pkg_type value.",
                caution = "You must select CLI version: '0' or WebUI version: '1'. Please tell the user to select the correct version.",
            })
        end

        if mgr.check_installed_pkg(package) then
            return server.response({
                result = "The WireGuard package (" .. package .. ") is already installed.",
            })
        end

        if not mgr.update_pkg_info("ipk") then
            return server.response({ error = "Failed to update package information. Please check network status and inform the user if necessary." })
        end

        if not mgr.install_pkg(package) then
            return server.response({ error = "Failed to install " .. package .. " package. Please inform the user of this error." })
        end

        return server.response({
            result = "The " .. package .. " package has been installed successfully.",
            request = request,
            reboot = reboot,
        })
    end
})

-- Key Management
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn#key_management
server.tool("generate_wireguard_keys", {
    tool_desc   = "Generate and set up WireGuard private, public, and pre-shared keys. [Step 2]",

    call = function(args)
        local util  = require("luci.util")
        local misc  = require("oasis.chat.misc")
        local mgr   = require("oasis.local.tool.package.manager")
        local mkd   = require("oasis.chat.markdown")

        local function run_wg(cmd)
            local raw = util.exec(cmd .. " 2>/dev/null; printf '\\n__OASIS_RC__:%d' $?")
            if type(raw) ~= "string" then
                return nil, "Failed to execute command: " .. cmd
            end

            local body, rc = raw:match("^(.*)\n__OASIS_RC__:(%d+)$")
            if not body or not rc then
                return nil, "Failed to parse command result: " .. cmd
            end

            if tonumber(rc) ~= 0 then
                return nil, "Command failed: " .. cmd
            end

            body = body:gsub("%s+$", "")
            if body == "" then
                return nil, "Command returned empty output: " .. cmd
            end

            return body
        end

        if mgr.check_pkg_reboot_required("luci-proto-wireguard") then
            return server.response({
                error = "A system reboot is required after installing luci-proto-wireguard. Please tell the user to reboot the system before proceeding.",
                reboot = true,
            })
        end

        local server_private_key, err = run_wg("wg genkey")
        if not server_private_key then
            return server.response({ error = err })
        end

        local server_public_key
        server_public_key, err = run_wg("echo " .. server_private_key .. " | wg pubkey")
        if not server_public_key then
            return server.response({ error = err })
        end

        local client_private_key
        client_private_key, err = run_wg("wg genkey")
        if not client_private_key then
            return server.response({ error = err })
        end

        local client_public_key
        client_public_key, err = run_wg("echo " .. client_private_key .. " | wg pubkey")
        if not client_public_key then
            return server.response({ error = err })
        end

        local pre_shared_key
        pre_shared_key, err = run_wg("wg genpsk")
        if not pre_shared_key then
            return server.response({ error = err })
        end

        local user_only = "Key generation successful.\n\n"
        user_only = user_only .. "Please make a note of the following keys.\n"
        user_only = user_only .. mkd.h3("WireGuard Server Public Key\n")
        user_only = user_only .. mkd.codeblock(server_public_key)
        user_only = user_only .. mkd.h3("WireGuard Client Public Key\n")
        user_only = user_only .. mkd.codeblock(client_public_key) 
        user_only = user_only .. mkd.h3("WireGuard Pre-shared Key\n")
        user_only = user_only .. mkd.codeblock(pre_shared_key)

        -- generate key file for other tool use
        misc.write_file("/tmp/oasis/wireguard_server_public_key", server_public_key)
        misc.write_file("/tmp/oasis/wireguard_client_public_key", client_public_key)
        misc.write_file("/tmp/oasis/wireguard_server_private_key", server_private_key)
        misc.write_file("/tmp/oasis/wireguard_client_private_key", client_private_key)
        misc.write_file("/tmp/oasis/wireguard_pre_shared_key", pre_shared_key)

        os.execute("chmod 600 /tmp/oasis/wireguard_server_public_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_client_public_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_pre_shared_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_server_private_key")
        os.execute("chmod 600 /tmp/oasis/wireguard_client_private_key")

        return server.response({
            result = "The public keys and pre-shared key for the WireGuard server and client have been successfully created and configured.",
            request = "AI must inform the user that the public keys and pre-shared key are not shared with the AI. The user should check the key information displayed in the UI and make a note of it.",
            user_only = user_only,
        })
    end
})

-- Firewall
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server?s%5B%5D=wireguard&s%5B%5D=vpn#firewall
server.tool("setup_firewall_for_wireguard", {

    tool_desc   = "Set up WireGuard firewall rules [Step 3]",
    args_desc   = {
        "Set the virtual interface name (e.g., 'vpn')",
        "Set the WireGuard port (e.g., '51820')",
    },

    args = {
        vif = "a_string",
        port = "a_string",
    },

    call = function(args)
        local uci = require("luci.model.uci").cursor()
        local vif = args.vif

        if type(vif) ~= "string" or vif:match("^%s*$") then
            return server.response({
                error = "Invalid virtual interface name. Please provide a non-empty interface name (e.g., 'wg0').",
            })
        end

        local port = tonumber(args.port)

        if (port == nil) or (type(port) ~= "number") then
            return server.response({
                error = "Invalid port: " .. args.port .. ". Please tell the user to provide a valid port number.",
            })
        end

        os.execute("uci rename firewall.@zone[0]=lan")
        os.execute("uci rename firewall.@zone[1]=wan")

        local lan_list = uci:get_list("firewall", "lan", "network") or {}
        for i = #lan_list, 1, -1 do
            if lan_list[i] == vif then
                table.remove(lan_list, i)
            end
        end
        lan_list[#lan_list + 1] = vif
        uci:set_list("firewall", "lan", "network", lan_list)

        uci:delete("firewall", "wg")
        uci:set("firewall", "wg", "rule")
        uci:set("firewall", "wg", "name", "Allow-WireGuard")
        uci:set("firewall", "wg", "src", "wan")
        uci:set("firewall", "wg", "dest_port", port)
        uci:set("firewall", "wg", "proto", "udp")
        uci:set("firewall", "wg", "target", "ACCEPT")
        uci:commit("firewall")

        return server.response({
            result = "The firewall configuration for WireGuard has been completed.",
            request = "AI must prompt the user to specify the VPN interface name, IPv4 address, and IPv6 address for the next step. Do not mention tool names.",
            note = "If the tool for configuring the WireGuard network is enabled, AI should apply the VPN settings provided by the user.",
            prepare_service_restart = "firewall",
        })
    end
})

-- Network
-- Reference URL:
-- https://openwrt.org/docs/guide-user/services/vpn/wireguard/server#network
server.tool("setup_wireguard_network", {
    tool_desc   = "Configure the WireGuard network interface and peer using system-generated keys [Step 4]",
    args_desc   = {
        "VPN interface name (e.g., 'wg0')",
        "VPN IPv4 address (e.g., '10.0.0.1/24')",
        "VPN IPv6 address (e.g., 'fd00:10::1/64')"
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
            return server.response({ error = "Private key not found: " .. server_private_key_file .. ". Please tell the user to generate the keys first." })
        end
        if not peer_pubkey or peer_pubkey == "" then
            return server.response({ error = "Peer public key not found: " .. client_public_key_file .. ". Please tell the user to generate the keys first." })
        end
        if not peer_psk or peer_psk == "" then
            return server.response({ error = "Peer pre-shared key not found: " .. pre_shared_key_file .. ". Please tell the user to generate the keys first." })
        end

        local listen_port = tonumber(uci:get("firewall", "wg", "dest_port"))
        if not listen_port then
            return server.response({
                error = "WireGuard listen port is not set. Please run firewall setup first.",
                request = "AI must ask the user to run the WireGuard firewall setup step before configuring the network.",
            })
        end

        local client_ipv4 = args.vpn_addr:gsub("(%d+)%.(%d+)%.(%d+)%.(%d+)(/%d+)", "%1.%2.%3.2/32")
        local client_ipv6 = args.vpn_addr6:gsub("::%x+/%d+", "::2/128")

        uci:delete("network", args.vpn_if)
        uci:set("network", args.vpn_if, "interface")
        uci:set("network", args.vpn_if, "proto", "wireguard")
        uci:set("network", args.vpn_if, "private_key", private_key)
        uci:set("network", args.vpn_if, "listen_port", listen_port)
        -- manage addresses list (uci:add_list equivalent)
        local addr_list = uci:get_list("network", args.vpn_if, "addresses") or {}
        -- remove duplicates if present
        for i = #addr_list, 1, -1 do
            if addr_list[i] == args.vpn_addr or addr_list[i] == args.vpn_addr6 then
                table.remove(addr_list, i)
            end
        end
        addr_list[#addr_list + 1] = args.vpn_addr
        addr_list[#addr_list + 1] = args.vpn_addr6
        uci:set_list("network", args.vpn_if, "addresses", addr_list)

        uci:delete("network", "wgclient")
        uci:set("network", "wgclient", "wireguard_" .. args.vpn_if)
        uci:set("network", "wgclient", "public_key", peer_pubkey)
        uci:set("network", "wgclient", "preshared_key", peer_psk)
        -- manage allowed_ips list (uci:add_list equivalent)
        local allowed = uci:get_list("network", "wgclient", "allowed_ips") or {}
        for i = #allowed, 1, -1 do
            if allowed[i] == client_ipv4 or allowed[i] == client_ipv6 then
                table.remove(allowed, i)
            end
        end
        allowed[#allowed + 1] = client_ipv4
        allowed[#allowed + 1] = client_ipv6
        uci:set_list("network", "wgclient", "allowed_ips", allowed)

        uci:commit("network")

        return server.response({
            result = "WireGuard interface '" .. args.vpn_if .. "' configured successfully with IPv4 " .. args.vpn_addr .. " and IPv6 " .. args.vpn_addr6 .. ".",
            request = "AI must instruct the user to verify peer connectivity and ensure firewall rules are properly configured. Do not mention tool names.",
            prepare_service_restart = "network",
        })
    end
})

server.run(arg)
