class yapp_tx_agent extends uvm_agent;

    `uvm_component_utils_begin(yapp_tx_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    //uvm_active_passive_enum is_active = UVM_ACTIVE;

    yapp_tx_driver driver;
    yapp_tx_monitor monitor;
    yapp_tx_sequencer sequencer;

    function new(string name = "yapp_tx_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);   
        // if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active)) begin
        //     `uvm_info(get_type_name(), "Using default is_active value", UVM_LOW)
        // end

        monitor = yapp_tx_monitor::type_id::create("monitor",this);
        if(is_active == UVM_ACTIVE) begin
            driver = yapp_tx_driver::type_id::create("driver",this);
            sequencer = yapp_tx_sequencer::type_id::create("sequencer",this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH) 
    endfunction 

    function void assign_vi(virtual interface yapp_if vif);
        monitor.vif = vif;
        if (is_active == UVM_ACTIVE) 
            driver.vif = vif;
    endfunction 

endclass