

package ALSU_pkg_driver;
import alsu_config_obj_pkj::*;
import uvm_pkg::*;  
`include "uvm_macros.svh"

class alsu_driver extends uvm_driver;
    `uvm_component_utils(alsu_driver);
    virtual ALSU_interface alsu_driver_vif;
    alsu_config_obj alsu_config_obj_driver;

    function new(string name = "alsu_driver",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(alsu_config_obj)::get(this,"","CFG",alsu_config_obj_driver))begin
            `uvm_fatal("Bulid_phase","Driver - unable to get configuration objects");
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        alsu_driver_vif = alsu_config_obj_driver. alsu_config_vif;
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

        @(negedge alsu_driver_vif.clk);
        alsu_driver_vif.rst = 0;

        forever begin
        @(negedge alsu_driver_vif.clk);
        alsu_driver_vif.cin = $random;
        alsu_driver_vif.red_op_A = $random0;
        alsu_driver_vif.red_op_B = $random;
        alsu_driver_vif.bypass_A = $random;
        alsu_driver_vif.bypass_B = $random;
        alsu_driver_vif.direction = $random;
        alsu_driver_vif.serial_in = $random;
        alsu_driver_vif.opcode = $randoms;
        end

    endtask


endclass

endpackage