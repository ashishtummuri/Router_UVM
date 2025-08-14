class router_reference extends uvm_component;
    `uvm_analysis_imp_decl(_hbus)
    `uvm_analysis_imp_decl(_yapp)

    uvm_analysis_imp_hbus#(hbus_transaction, router_reference) hbus_in;
    uvm_analysis_imp_yapp#(yapp_packet, router_reference) yapp_in;

    uvm_analysis_port#(yapp_packet) sb_add_out;

    bit [7:0] max_pktsize_reg = 8'h3F;
    bit [7:0] router_enable_reg = 1'b1;

    int packets_dropped = 0;
    int packets_forwarded = 0;
    int jumbo_packets = 0;
    int bad_addr_packets = 0;

    `uvm_component_utils(router_reference)

    function new(string name = "router_reference", uvm_component parent);
        super.new(name, parent);
        hbus_in = new("hbus_in", this);
        yapp_in = new("yapp_in", this);
        sb_add_out = new("sb_add_out", this);
    endfunction 

    function void write_hbus(hbus_transaction hbus_cmd);
        `uvm_info(get_type_name(), $sformatf("Received HBUS Transaction: \n%s", hbus_cmd.sprint()), UVM_MEDIUM)

        if(hbus_cmd.hwr_rd == HBUS_WRITE)
            case(hbus_cmd.haddr)
                'h1000: max_pktsize_reg = hbus_cmd.hdata;
                'h1001: router_enable_reg = hbus_cmd.hdata;
            endcase
    endfunction

    function void write_yapp(yapp_packet packet);
        `uvm_info(get_type_name(), $sformatf("Received yapp Transaction: \n%s", packet.sprint()), UVM_MEDIUM)
    if (packet.addr == 3) begin
      bad_addr_packets++;
      packets_dropped++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
    end
    else if ((router_enable_reg != 0) && (packet.length <= max_pktsize_reg)) begin
      sb_add_out.write(packet);
      packets_forwarded++;
      `uvm_info(get_type_name(), "Sent YAPP Packet to Scoreboard", UVM_LOW)
    end
    else if ((router_enable_reg != 0) && (packet.length > max_pktsize_reg)) begin
      jumbo_packets++;
      packets_dropped++;
      `uvm_info(get_type_name(), $sformatf("YAPP Packet Dropped [OVERSIZED] - pkt size %h max size %h",packet.length, max_pktsize_reg), UVM_LOW)
    end
    else if (router_enable_reg == 0) begin
      packets_dropped++;
      `uvm_info(get_type_name(), "YAPP Packet Dropped [DISABLED]", UVM_LOW)
    end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report:\n   Router Reference: Packet Statistics \n     Packets Dropped:   %0d\n     Packets Forwarded: %0d\n     Oversized Packets: %0d\n", packets_dropped, packets_forwarded, jumbo_packets ), UVM_LOW)
    endfunction




endclass