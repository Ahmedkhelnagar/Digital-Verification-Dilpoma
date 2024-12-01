


package alsu_env_pkg;
import uvm_pkg::*;  
`include "uvm_macros.svh"

class alsu_env extends uvm_env;
    `uvm_component_utils(alsu_env);

    function new(string name = "alsu_env",uvm_component parent = null);
        super.new(name,parent);
    endfunction

endclass

endpackage