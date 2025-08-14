class router_simple_mcseq extends uvm_sequence;
    `uvm_object_utils(router_simple_mcseq)
    `uvm_declare_p_sequencer(router_mcsequencer)

    yapp_incr_payload_seq rand_yapp;
    yapp_012_seq yapp_012;

    hbus_small_packet_seq hbus_small_pkt;
    hbus_read_max_pkt_seq hbus_rd_max_pkt;
    hbus_set_default_regs_seq hbus_larger_pkt;

    function new(string name = "router_simple_mcseq");
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


    virtual task body();
        `uvm_info("Router_simple_mcseq", "Executing router_simple_mcseq", UVM_LOW)
        `uvm_do_on(hbus_small_pkt, p_sequencer.hbus_seqr)
        `uvm_do_on(hbus_rd_max_pkt, p_sequencer.hbus_seqr)
        
        `uvm_info(get_type_name(), $sformatf("router MAX PKT SIZE = %0h", hbus_rd_max_pkt.max_pkt_reg), UVM_LOW)

        `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
        `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)

        `uvm_do_on(hbus_larger_pkt, p_sequencer.hbus_seqr)
        `uvm_do_on(hbus_rd_max_pkt, p_sequencer.hbus_seqr)

        `uvm_info(get_type_name(), $sformatf("Router MAX PKT SIZE register read= %0h", hbus_rd_max_pkt.max_pkt_reg), UVM_LOW)

        `uvm_do_on(rand_yapp, p_sequencer.yapp_seqr)

    endtask





endclass