'use strict';

let ubus = require('ubus').connect();
let server = require('oasis.local.tool.server');

server.tool("oasis.ucode.test.tool", "tool_test_I", {
    tool_desc: "This is test I.",
    call: function() {
        return { message: "Execute Test I." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_J", {
    tool_desc: "This is test J.",
    exec_msg: "Execute Test J",
    call: function() {
        return { message: "Execute Test J." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_K", {
    tool_desc: "This is test K.",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test K." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_L", {
    tool_desc: "This is test L.",
    exec_msg: "Execute Test L",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test L." };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_M", {
    tool_desc: "This is test M.",
    call: function() {
        return { message: "Execute Test M.", reboot: true };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_N", {
    tool_desc: "This is test N.",
    exec_msg: "Execute Test N",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test N.", reboot: true };
    }
});


server.tool("oasis.ucode.test.tool", "tool_test_O", {
    tool_desc: "This is test O.",
    exec_msg: "Execute Test O",
    download_msg: "Downloading Test ...",
    call: function() {
        return { message: "Execute Test O.", user_only: "This is user only message.", reboot: true };
    }
});

server.tool("oasis.ucode.test.tool", "tool_test_P", {
    tool_desc: "This is test P (restart_service).",
    call: function() {
        return { message: "Execute Test P.", prepare_service_restart: "network" };
    }
});

return server.submit();
