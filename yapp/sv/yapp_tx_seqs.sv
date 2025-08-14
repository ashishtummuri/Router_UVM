/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)
  yapp_packet pkt;

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(pkt)
      // start_item(pkt);
      // pkt.randomize();
      // finish_item(pkt);
  endtask
endclass


class yapp_1_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq", UVM_LOW)
    `uvm_do_with(pkt, {pkt.addr == 2'b01;})
  endtask
endclass


class yapp_012_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction
 
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq", UVM_LOW)
    `uvm_do_with(pkt, {pkt.addr == 2'b00;})
    `uvm_do_with(pkt, {pkt.addr == 2'b01;})
    `uvm_do_with(pkt, {pkt.addr == 2'b10;})
  endtask
endclass


class yapp_111_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_111_seq)

  function new(string name = "yapp_111_seq");
    super.new(name);
  endfunction

  yapp_1_seq addr_1_seq;
 
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq", UVM_LOW)
    repeat(3)
      `uvm_do(addr_1_seq);
  endtask
endclass


class yapp_random_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_random_seq)

  function new(string name = "yapp_random_seq");
    super.new(name);
  endfunction

  rand bit [1:0] addr;
  constraint c_addr {addr != 3;}

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_random_seq", UVM_LOW)
    repeat(2)
      `uvm_do_with(pkt,{pkt.addr == addr;})
  endtask
endclass

class yapp_rnd_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_rnd_seq)

  rand int count;

  constraint count_limit { count inside {[1:10]}; }

  function new(string name="yapp_rnd_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Executing YAPP_RND_SEQ %0d times...", count), UVM_LOW)
    repeat (count) begin
      `uvm_do(req)
    end
  endtask

endclass


class yapp_incr_payload_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_incr_payload_seq)

  function new(string name = "yapp_incr_payload_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq", UVM_LOW)
    `uvm_create(pkt)
    repeat(3) begin
      assert(pkt.randomize());
      for(int i = 0 ; i <pkt.length ; i++)
        pkt.payload[i] = i;
      pkt.set_parity();
      `uvm_send(pkt);
    end
  endtask
endclass


class yapp_exhaustive_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_exhaustive_seq)

  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction

  yapp_1_seq y1;
  yapp_012_seq y012;
  yapp_111_seq y111;
  yapp_incr_payload_seq yincr;
  yapp_exhaustive_seq yexh;

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq", UVM_LOW)
    `uvm_do(y1)
    `uvm_do(y012)
    `uvm_do(y111)
    `uvm_do(yincr)
    `uvm_do(yexh)
  endtask
endclass
