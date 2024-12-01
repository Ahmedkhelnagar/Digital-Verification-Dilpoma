

package ALSU_pkg_driver;
import uvm_pkg::*;  
`include "uvm_macros.svh"

class alsu_driver extends uvm_driver;
    `uvm_component_utils(alsu_driver);
    virtual ALSU_interface alsu_driver_vif;

    function new(string name = "alsu_driver",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(virtual ALSU_interface)::get(this,"","CFG",alsu_driver_vif))begin
            `uvm_fatal("Bulid_phase","Driver - unable to get configuration objects");
        end
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        alsu_driver_vif.rst = 1;
        alsu_driver_vif.cin = 0;
        alsu_driver_vif.red_op_A = 0;
        alsu_driver_vif.red_op_B = 0;
        alsu_driver_vif.bypass_A = 0;
        alsu_driver_vif.bypass_B = 0;
        alsu_driver_vif.direction = 0;
        alsu_driver_vif.serial_in = 0;
        alsu_driver_vif.opcode = 0;
        alsu_driver_vif.A = 0;
        alsu_driver_vif.B = 0;

        @(negedge alsu_driver_vif.clk);
        alsu_driver_vif.rst = 0;

        forever begin
        @(negedge alsu_driver_vif.clk);
         alsu_driver_vif.cin = $random;
        alsu_driver_vif.red_op_A = $random;
        alsu_driver_vif.red_op_B = $random;
        alsu_driver_vif.bypass_A = $random;
        alsu_driver_vif.bypass_B = $random;
        alsu_driver_vif.direction = $random;
        alsu_driver_vif.serial_in = $random;
        alsu_driver_vif.opcode = $randoms;
        alsu_driver_vif.A = $randoms;
        alsu_driver_vif.B = $randoms;
        end

    endtask


endclass

endpackage