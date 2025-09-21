'use strict';

let ubus = require('ubus').connect();
let server = require('oasis.local.tool.server');

server.tool("oasis.ucode.test.tool", "tool_test_G", {
    tool_desc: "This is test G.",
    call: function() {
        return { message: "Execute Test G." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_H", {
    tool_desc: "This is test H.",
    exec_msg: "Execute Test H",
    call: function() {
        return { message: "Execute Test H." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_I", {
    tool_desc: "This is test I.",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test I." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_J", {
    tool_desc: "This is test J.",
    exec_msg: "Execute Test J",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test J." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_K", {
    tool_desc: "This is test K.",
    reboot: true,
    call: function() {
        return { message: "Execute Test K." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_M", {
    tool_desc: "This is test M.",
    reboot: true,
    exec_msg: "Execute Test M",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test M." };
    }
});

return server.submit();
