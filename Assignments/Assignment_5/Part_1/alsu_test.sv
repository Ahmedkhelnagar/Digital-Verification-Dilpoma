

package alsu_test_pkg;
import alsu_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_test extends uvm_test;
    `uvm_component_utils(alsu_test);
    alsu_env env;

    function new(string name = "alsu_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alsu_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        #100;`uvm_info("run_phase","Welcome to the UVM env.",UVM_MEDIUM);
        phase.drop_objection(this);
    endtask
endclass
endpackage