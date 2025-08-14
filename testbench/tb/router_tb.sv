class router_tb extends uvm_env;

    yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5 yapp_rm;
    hbus_reg_adapter reg2hbus;

    `uvm_component_utils_begin(router_tb)
        `uvm_field_object(yapp_rm, UVM_ALL_ON)
    `uvm_component_utils_end

    clock_and_reset_env clock_and_reset;

    yapp_env yapp;

    channel_env channel0;
    channel_env channel1;
    channel_env channel2;

    hbus_env hbus;

    router_mcsequencer mcsequencer;

    //router_scoreboard router_sb;

    router_module_env router_mod;

    function new(string name = "router_tb", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"BUILD PHASE is executed", UVM_HIGH);

        clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
        yapp = yapp_env::type_id::create("yapp",this);

        uvm_config_int::set(this, "channel0","channel_id",0);
        uvm_config_int::set(this, "channel1","channel_id",1);
        uvm_config_int::set(this, "channel2","channel_id",2);
        channel0 = channel_env::type_id::create("channel0",this);
        channel1 = channel_env::type_id::create("channel1",this);
        channel2 = channel_env::type_id::create("channel2",this);

        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);
        hbus = hbus_env::type_id::create("hbus", this);
        mcsequencer = router_mcsequencer::type_id::create("mcsequencer", this);

        //router_sb = router_scoreboard::type_id::create("router_sb", this);

        router_mod = router_module_env::type_id::create("router_mod", this);

        yapp_rm = yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5::type_id::create("yapp_rm", this);
        yapp_rm.build();
        yapp_rm.lock_model();
        yapp_rm.set_hdl_path_root("hw_top.dut");
        yapp_rm.default_map.set_auto_predict(1);

        reg2hbus = hbus_reg_adapter::type_id::create("reg2hbus", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        mcsequencer.hbus_seqr = hbus.masters[0].sequencer;
        mcsequencer.yapp_seqr = yapp.agent.sequencer;

        yapp.agent.monitor.item_collected_port.connect(router_mod.reference.yapp_in);
        hbus.masters[0].monitor.item_collected_port.connect(router_mod.reference.hbus_in);
        channel0.rx_agent.monitor.item_collected_port.connect(router_mod.scoreboard.sb_channel0);
        channel1.rx_agent.monitor.item_collected_port.connect(router_mod.scoreboard.sb_channel1);
        channel2.rx_agent.monitor.item_collected_port.connect(router_mod.scoreboard.sb_channel2);

        yapp_rm.default_map.set_sequencer(hbus.masters[0].sequencer, reg2hbus);
    endfunction
endclass