
module top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import yapp_pkg::*;
    import hbus_pkg::*;
    import channel_pkg::*;
    import clock_and_reset_pkg::*;
    import router_module_pkg::*;

    `include "router_mcsequencer.sv"
    `include "router_mcseqs_lib.sv"
    //`include "../sv/router_scoreboard.sv"
    import yapp_router_reg_pkg::*;
    
    `include "router_tb.sv"
    `include "router_test_lib.sv"

    initial begin
        yapp_if_config::set(null,"*.tb.yapp.agent.*", "vif", hw_top.in0);
        hbus_vif_config::set(null, "*.tb.hbus.*", "vif", hw_top.hif);
        channel_vif_config::set(null, "*.tb.channel0.*", "vif", hw_top.ch0);
        channel_vif_config::set(null, "*.tb.channel1.*", "vif", hw_top.ch1);
        channel_vif_config::set(null, "*.tb.channel2.*", "vif", hw_top.ch2);
        clock_and_reset_vif_config::set(null, "*.tb.clock_and_reset*" ,"vif", hw_top.clk_rst_if);

        run_test();
    end
endmodule 
