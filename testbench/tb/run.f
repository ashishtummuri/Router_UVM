/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

 -uvmhome $UVMHOME
-timescale 1ns/1ns

+UVM_TESTNAME=uvm_reset_test
+UVM_VERBOSITY=UVM_HIGH

// include directories
-incdir ../../yapp/sv
../../yapp/sv/yapp_pkg.sv
../../yapp/sv/yapp_if.sv

-incdir ../../channel/sv
../../channel/sv/channel_pkg.sv
../../channel/sv/channel_if.sv

-incdir ../../hbus/sv
../../hbus/sv/hbus_pkg.sv
../../hbus/sv/hbus_if.sv

-incdir ../../clock_and_reset/sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../clock_and_reset/sv/clock_and_reset_if.sv

cdns_uvmreg_utils_pkg.sv
yapp_router_regs_rdb.sv

../sv/router_module_pkg.sv

clkgen.sv
//uvm_test
tb_top.sv 
//uvm_top
hw_top.sv
//DUT
../../router_rtl/yapp_router.sv

