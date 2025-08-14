class router_module_env extends uvm_env;
    router_reference reference;
    router_scoreboard scoreboard;

    `uvm_component_utils(router_module_env)

    function new(string name = "router_module_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard = router_scoreboard::type_id::create("scoreboard", this);
        reference = router_reference::type_id::create("reference", this); 
    endfunction

    function void connect_phase(uvm_phase phase);
        reference.sb_add_out.connect(scoreboard.sb_yapp_in);
    endfunction
endclass