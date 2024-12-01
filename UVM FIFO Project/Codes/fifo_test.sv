

package fifo_test_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import fifo_env_pkg::*;
    import fifo_config_obj_pkg::*;
    import fifo_main_sequence_pkg::*;
    import fifo_reset_sequence_pkg::*;

    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test);
        fifo_env env;
        fifo_config_obj fifo_CFG;
        virtual fifo_interface fifo_vif;
        fifo_main_sequence main_seq;
        fifo_reset_sequence rst_seq;

        function new(string name = "fifo_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = fifo_env::type_id::create("env",this);
            fifo_CFG = fifo_config_obj::type_id::create("fifo_CFG",this);
            main_seq = fifo_main_sequence::type_id::create("main_seq",this);
            rst_seq = fifo_reset_sequence::type_id::create("rst_seq",this);

            if(!uvm_config_db #(virtual fifo_interface)::get(this,"","FIFO_IF",fifo_CFG.fifo_vif))begin
                `uvm_fatal("bulid phase","Unable to get the virtual interface from the configuration database from the top");
            end
            
            uvm_config_db #(fifo_config_obj)::set(this,"*","CFG",fifo_CFG);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            //Reset sequence
            `uvm_info("run_phase","Reset Asserted",UVM_LOW)
            rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
            //Main sequence
            `uvm_info("run_phase","Stimulus Generation Started",UVM_LOW)
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus Generation Ended",UVM_LOW)
            
            phase.drop_objection(this);
        endtask

    endclass

endpackage