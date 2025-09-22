#!/usr/bin/env lua

local server = require("oasis.local.tool.server")

server.tool("tool_test_A", {
    tool_desc = "This is Test A",
    call = function()
        return server.response({ message = "Executed Test A." })
    end
})

server.tool("tool_test_B", {
    tool_desc   = "This is Test B",
    exec_msg = "Test B Execute",
    call = function()
        return server.response({ message = "Executed Test B." })
    end
})

server.tool("tool_test_C", {
    tool_desc   = "This is Test C",
    download_msg = "Downloading Test ... ",
    call = function(args)
        local util = require("luci.util")
        util.exec("sleep 10")
        return server.response({ messasge = "Executed Test C." })
    end
})

server.tool("tool_test_D", {
    tool_desc   = "This is Test D",
    exec_msg = "Execute Test D",
    download_msg = "Downloading Test ... ",
    call = function()
        local util = require("luci.util")
        util.exec("sleep 10")
        return server.response({ messasge = "Executed Test D." })
    end
})

server.tool("tool_test_E", {
    tool_desc   = "This is Test E",
    reboot = true,
    call = function()
        local util = require("luci.util")
        util.exec("sleep 10")
        return server.response({ messasge = "Executed Test E." })
    end
})

server.tool("tool_test_F", {
    tool_desc   = "This is Test F",
    reboot = true,
    exec_msg = "Executed Test F",
    download_msg = "Downloading Test ...",
    call = function()
        local util = require("luci.util")
        util.exec("sleep 10")
        return server.response({ messasge = "Executed Test F." })
    end
})

server.tool("tool_test_G", {
    tool_desc   = "This is Test G",
    call = function()
        local util = require("luci.util")
        return server.response({ messasge = "Executed Test G.", user_only = "This is user only message." })
    end
})

server.run(arg)
