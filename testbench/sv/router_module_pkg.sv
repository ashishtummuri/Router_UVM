package router_module_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import yapp_pkg::*;
    import channel_pkg::*;
    import hbus_pkg::*;

    `include "../sv/router_scoreboard.sv"
    `include "../sv/router_reference.sv"
    `include "../sv/router_module_env.sv"

endpackage