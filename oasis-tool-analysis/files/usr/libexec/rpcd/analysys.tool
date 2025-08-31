#!/usr/bin/env lua

local server = require("oasis.local.tool.server")

server.tool("xxxxxx", {
    tool_desc = "xxxxxxx",
    call = function()
        -- something process
        local res = server.response({ result = "xxxxxx" })
        return res
    end
})

server.tool("xxxxxx", {
    tool_desc = "xxxxxxx",

    args_desc = {
        "argument 1 description",
        "argument 2 description",
    },

    args = { arg1 = "a_string", arg2 = "a_string" },

    call = function(args)
        -- something process
        local res = server.response({ result = "xxxxxx" })
        return res
    end
})

server.run(arg)