/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here
typedef enum bit {BAD_PARITY, GOOD_PARITY} parity_t;
class yapp_packet extends uvm_sequence_item;

  rand bit [1:0] addr;
  rand bit [7:0] payload[];
  rand bit [5:0] length;
  bit       [7:0] parity;

  rand parity_t parity_type;
  rand int packet_delay;

  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(length, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
    `uvm_field_int(packet_delay, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
    `uvm_field_enum(parity_t, parity_type, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "yapp_packet");
    super.new(name);
  endfunction

  constraint c1 {length == payload.size();}  
  constraint c2 {length > 0; length < 64;}
  constraint c3 {packet_delay > 0; packet_delay < 20;}
  constraint c4 {parity_type dist {BAD_PARITY := 1, GOOD_PARITY := 5};}
  constraint c5 {addr != 'b11;}

  function bit [7:0] calc_parity();
    calc_parity = {length, addr};
    foreach(payload[i])
      calc_parity = calc_parity ^ payload[i];
  endfunction

  function void set_parity();
    parity = calc_parity();
    if(parity_type == BAD_PARITY)
      parity++;
  endfunction

  function void post_randomize();
    set_parity();
  endfunction

endclass: yapp_packet


class short_packet extends yapp_packet;
  `uvm_object_utils(short_packet)

  function new(string name = "short_packet");
    super.new(name);
  endfunction

  constraint c6 {length < 15;}
  //constraint c7 {addr != 'b10;}

endclass