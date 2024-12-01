


package alsu_env_pkg;
import ALSU_pkg_driver::*;  
import uvm_pkg::*;  
`include "uvm_macros.svh"

class alsu_env extends uvm_env;
    `uvm_component_utils(alsu_env);
     alsu_driver driver;

    function new(string name = "alsu_env",uvm_component parent = null);
        super.new(name,parent);
        driver = alsu_driver::type_id::create("driver",this);
    endfunction

endclass

endpackage