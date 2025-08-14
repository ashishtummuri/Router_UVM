class yapp_tx_driver extends uvm_driver#(yapp_packet);
    int num_sent;

    `uvm_component_utils_begin(yapp_tx_driver)
        `uvm_field_int(num_sent, UVM_ALL_ON)
    `uvm_component_utils_end

    virtual interface yapp_if vif;
    yapp_packet pkt;
    
    function new(string name = "yapp_tx_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        pkt = yapp_packet::type_id::create("pkt");
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        if(!yapp_if_config::get(this,"","vif",vif))
            `uvm_error("NOVIF", {"Virtual Interface must be set for: ", get_full_name(),".vif"})
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH) 
    endfunction 

    virtual task run_phase(uvm_phase phase);
        fork 
            get_and_drive();
            reset_signals();
        join
    endtask

    task get_and_drive();
        @(posedge vif.reset);
        @(negedge vif.reset);

        `uvm_info(get_type_name(),"Reset Dropped", UVM_MEDIUM)

        forever begin
           seq_item_port.get_next_item(pkt);
            `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", pkt.sprint()), UVM_HIGH)

            fork
                begin
                    foreach(pkt.payload[i])
                        vif.payload_mem[i] = pkt.payload[i];
                        vif.send_to_dut(pkt.length,pkt.addr, pkt.parity, pkt.packet_delay);
                end
                @(posedge vif.drvstart) void'(begin_tr(pkt, "Driver_YAPP_PAcket"));
            join

            end_tr(pkt);
            num_sent++;
           seq_item_port.item_done();
        end
    endtask

    task reset_signals();
        forever begin
           vif.yapp_reset(); 
        end
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: YAPP Tx Driver Sent %0d Packets", num_sent), UVM_LOW)
    endfunction

endclass