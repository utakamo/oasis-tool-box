'use strict';

let ubus = require('ubus').connect();
let server = require('oasis.local.tool.server');

server.tool("oasis.ucode.template.tool1", "say_goodbye", {
    tool_desc: "Return a simple goodbye. No inputs.",
    call: function() {
        return { message: "Goodbye! This is a template tool." };
    }
});

server.tool("oasis.ucode.template.tool1", "subtract", {
    tool_desc: "Subtract the second number from the first and return the result.",
    args_desc: [
        "First number (integer)",
        "Second number (integer)"
    ],
    args: {
        num1: 0,
        num2: 0
    },
    call: function(request) {
        let a = request.args.num1;
        let b = request.args.num2;
        return { num1: a, num2: b, difference: a - b };
    }
});

server.tool("oasis.ucode.template.tool2", "concat_strings", {
    tool_desc: "Concatenate two strings and return the result.",
    args_desc: [
        "First string",
        "Second string"
    ],
    args: {
        str1: "",
        str2: ""
    },
    call: function(request) {
        return { str1: request.args.str1, str2: request.args.str2, result: request.args.str1 + request.args.str2 };
    }
});

return server.submit();
