

package alsu_test_pkg;

import alsu_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_test extends uvm_test;
    `uvm_component_utils(alsu_test);
    alsu_env env;
    virtual ALSU_interface alsu_test_vif;

    function new(string name = "alsu_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    //Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alsu_env::type_id::create("env",this);

        if(!uvm_config_db #(virtual ALSU_interface)::get(this,"","ALSU_interface",alsu_test_vif))
            `uvm_fatal("bulid_phase","Test - unable to get the virtual interface of the shift reg from the uvm_config_db");

         uvm_config_db #(virtual ALSU_interface)::set(this,"*","CFG",alsu_test_vif);
    endfunction

    //Run Phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        #100;`uvm_info("run_phase","Inside the ALSU test.",UVM_MEDIUM);
        phase.drop_objection(this);
    endtask
endclass
endpackage