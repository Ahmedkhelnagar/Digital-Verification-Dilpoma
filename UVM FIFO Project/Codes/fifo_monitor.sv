

package fifo_monitor_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import fifo_seq_item_pkg::*;

    class fifo_monitor extends uvm_monitor;
        `uvm_component_utils(fifo_monitor);
        virtual fifo_interface fifo_vif;
        fifo_seq_item mon_seq_item;
        uvm_analysis_port #(fifo_seq_item)mon_ap;

        function new(string name = "fifo_monitor",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                mon_seq_item = fifo_seq_item::type_id::create("mon_seq_item");
                @(negedge fifo_vif.clk);

                mon_seq_item.rst_n = fifo_vif.rst_n;
                mon_seq_item.data_in = fifo_vif.data_in;
                mon_seq_item.wr_en = fifo_vif.wr_en;
                mon_seq_item.rd_en = fifo_vif.rd_en;
                //outputs
                mon_seq_item.wr_ack = fifo_vif.wr_ack;
                mon_seq_item.overflow = fifo_vif.overflow;
                mon_seq_item.full = fifo_vif.full;
                mon_seq_item.empty = fifo_vif.empty;
                mon_seq_item.almostfull = fifo_vif.almostfull;
                mon_seq_item.almostempty = fifo_vif.almostempty;
                mon_seq_item.underflow = fifo_vif.underflow;
                mon_seq_item.data_out = fifo_vif.data_out;
                
                mon_ap.write(mon_seq_item);
                `uvm_info("Run_phase",mon_seq_item.convert2string(),UVM_HIGH);
            end
        endtask
    endclass
endpackage