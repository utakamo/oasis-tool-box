'use strict';

let ubus = require('ubus').connect();
let server = require('oasis.local.tool.server');

server.tool("oasis.ucode.test.tool", "tool_test_H", {
    tool_desc: "This is test H.",
    call: function() {
        return { message: "Execute Test H." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_I", {
    tool_desc: "This is test I.",
    exec_msg: "Execute Test I",
    call: function() {
        return { message: "Execute Test I." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_J", {
    tool_desc: "This is test J.",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test J." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_K", {
    tool_desc: "This is test K.",
    exec_msg: "Execute Test K",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test K." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_L", {
    tool_desc: "This is test L.",
    call: function() {
        return { message: "Execute Test L.", reboot: true };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_M", {
    tool_desc: "This is test M.",
    exec_msg: "Execute Test M",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test L.", reboot: true };
    }
});


server.tool("oasis.ucode.test.tool", "tool_test_N", {
    tool_desc: "This is test N.",
    exec_msg: "Execute Test N",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test N.", user_only: "This is user only message.", reboot: true };
    }
});

return server.submit();
