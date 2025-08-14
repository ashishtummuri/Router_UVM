class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    router_tb tb;

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tb = router_tb::type_id::create("tb", this);
        `uvm_info(get_type_name(), "BUILD PHASE of TEST is executed", UVM_HIGH)
        uvm_config_int::set(this, "*", "recording_detail", 1);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask : run_phase

    function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction

endclass


class short_packet_test extends base_test;
    `uvm_component_utils(short_packet_test)

    function new(string name = "short_packet_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        //set_type_override_by_type(yapp_packet::get_type(), short_packet::get_type());
        yapp_packet::type_id::set_type_override(short_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase", "default_sequence", yapp_5_packets::get_type());
        super.build_phase(phase);
    endfunction
endclass

class short_packet_012__test extends base_test;
    `uvm_component_utils(short_packet_012__test)

    function new(string name = "short_packet_012__test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        //set_type_override_by_type(yapp_packet::get_type(), short_packet::get_type());
        yapp_packet::type_id::set_type_override(short_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase", "default_sequence", yapp_012_seq::get_type());
        super.build_phase(phase);
    endfunction
endclass

class set_config_test extends base_test;
    `uvm_component_utils(set_config_test)

    function new(string name = "set_config_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        uvm_config_int::set(this,"tb.env.agent","is_active",UVM_PASSIVE);
        super.build_phase(phase);
    endfunction 
endclass

class incr_payload_test extends base_test;
    `uvm_component_utils(incr_payload_test)

    function new(string name = "incr_payload_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        yapp_packet::type_id::set_type_override(short_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase","default_sequence", yapp_incr_payload_seq::get_type());
        super.build_phase(phase);
    endfunction

    // task run_phase(uvm_phase phase);
    //     yapp_incr_payload_seq pkt1;
    //     phase.raise_objection(this);
    //     pkt1 = yapp_incr_payload_seq::type_id::create("pkt1");
    //     pkt1.start(tb.env.agent.sequencer);
    //     phase.drop_objection(this);
    // endtask
endclass

class exh_payload_test extends base_test;
    `uvm_component_utils(exh_payload_test)

    function new(string name = "exh_payload_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        yapp_packet::type_id::set_type_override(short_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase","default_sequence", exh_payload_test::get_type());
        super.build_phase(phase);
    endfunction

    // task run_phase(uvm_phase phase);
    //     yapp_incr_payload_seq pkt1;
    //     phase.raise_objection(this);
    //     pkt1 = yapp_incr_payload_seq::type_id::create("pkt1");
    //     pkt1.start(tb.env.agent.sequencer);
    //     phase.drop_objection(this);
    // endtask
endclass

class short_yapp_012 extends base_test;
    `uvm_component_utils(short_yapp_012)

    function new(string name = "short_yapp_012", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        yapp_packet::type_id::set_type_override(short_packet::get_type());
        uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase", "default_sequence", yapp_111_seq::get_type());
        super.build_phase(phase);
    endfunction

endclass

class simple_test extends base_test;
    `uvm_component_utils(simple_test)

    function new(string name = "simple_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_packet::get_type());
        uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase", "default_sequence", yapp_012_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.channel?.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::type_id::get());
        super.build_phase(phase);
    endfunction
endclass

class test_mc extends base_test;
    `uvm_component_utils(test_mc)

    function new(string name = "test_mc", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        set_type_override_by_type(yapp_packet::get_type(), short_packet::get_type());
        uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.channel?.rx_agent.sequencer.run_phase","default_sequence", channel_rx_resp_seq::type_id::get());
        uvm_config_wrapper::set(this, "tb.mcsequencer.run_phase", "default_sequence", router_simple_mcseq::type_id::get());
        super.build_phase(phase);
    endfunction
endclass

class  uvm_reset_test extends base_test;
    uvm_reg_hw_reset_seq reset_seq;

  `uvm_component_utils(uvm_reset_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                            "default_sequence",
                            clk10_rst5_seq::get_type());
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, {"Raising Objection ",get_type_name()});
     reset_seq.model = tb.yapp_rm;
     reset_seq.start(null);
     phase.drop_objection(this,{"Dropping Objection ",get_type_name()});
  endtask
endclass