#!/usr/bin/env lua

local server = require("oasis.local.tool.server")

server.tool("wireguard_user_manual", {
    tool_desc   = "Read the instructions for setting up WireGuard.",
    call = function(args)
        local res = server.response({
            manual = {
                "Step 1: Use the tool named \"install_wireguard_package\" to install luci-proto-wireguard.\n" ..
                "Step 2: \n" ..
                "Step 3: \n" ..
                "Step 4: \n" ..
                "Step 5: \n" ..
                "Step 6: \n"
            },

            note = "If you're not aware of the tools required for each step, please ask the user to enable the relevant tools from the Tools tab."
        })
        return res
    end
})

server.tool("install_wireguard", {
    tool_desc = "Install luci-proto-wireguard package",
    exec_msg = "Installing WireGuard Package. Please Wait ...",
    download_msg = "Installing The WireGuard Package",
    call = function()
        local package = "luci-proto-wireguard"
        local mgr = require("oasis.local.tool.package.manager")

        if mgr.check_installed_pkg(package) then
            return server.response(
                { 
                    result = "The WireGuard package (" .. package .. ") is already installed.",
                })
        end

        if not mgr.update_pkg_info("ipk") then
            return server.response({ error = "Failed to update package information. Please check network status." })
        end

        if not mgr.install_pkg("luci-proto-wireguard") then
            return server.response({ error = "Failed to install " .. package .. " package." })
        end

        return server.response(
            {
                result = "The package has been installed successfully.",
                request = "Please inform the user that a system reboot is required after installing WireGuard.",
                reboot = true,
            }
        )
    end
})

server.tool("xxxxx", {
    args_desc   = { "xxxxxxxxxxxxxxxxx" },
    args        = { data = "xxxxxxxxx" },

    tool_desc   = "xxxxxxxxxx",
    call = function(args)
        local res = server.response({ result = "xxxxxxxx" })
        return res
    end
})

server.run(arg)
