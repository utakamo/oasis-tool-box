'use strict';

let ubus = require('ubus').connect();
let server = require('oasis.local.tool.server');

// --- 引数なしテンプレート ---
server.tool("oasis.ucode.tool.template", "get_goodbye", {
    tool_desc: "Return a fixed goodbye message.",
    call: function() {
        return { message: "Goodbye! This is a template tool." };
    }
});

// --- 2引数数値計算テンプレート（引き算） ---
server.tool("oasis.ucode.tool.template", "subtract", {
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
        let a = Number(request.args.num1) || 0;
        let b = Number(request.args.num2) || 0;
        return { num1: a, num2: b, difference: a - b };
    }
});

// --- 2引数文字列テンプレート ---
server.tool("oasis.ucode.tool.template", "concat_strings", {
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
