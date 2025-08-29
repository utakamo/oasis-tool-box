#!/usr/bin/env lua

local server = require("oasis.local.tool.server")

server.tool("get_hello", {
    tool_desc = "Return a fixed greeting message.",
    call = function()
        local res = server.response({ message = "Hello, world!" })
        return res
    end
})

server.tool("get_weather", {
    -- args_desc: Description of parameters specified when invoking the tool.
    args_desc   = { "City and country e.g. Bogotá, Colombia" },
    args        = { location = "a_string" },

    -- tool_desc: Description of the tool's functionality.
    tool_desc   = "Get current temperature for a given location.",
    call = function(args)
        -- Mock: Returns a fake temperature for the given location
        local res = server.response({ location = args.location, temperature = "25°C", condition = "Sunny" })
        return res
    end
})

server.tool("add_numbers", {

    tool_desc   = "Add two numbers together and return the result.",

    args_desc   = { "First number", "Second number" },
    args        = { num1 = "a_number", num2 = "a_number" },

    call = function(args)
        local a = tonumber(args.num1) or 0
        local b = tonumber(args.num2) or 0
        local res = server.response({ num1 = a, num2 = b, sum = a + b })
        return res
    end
})

server.run(arg)