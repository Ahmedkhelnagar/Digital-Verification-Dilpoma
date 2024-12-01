

package fifo_coverage_collector_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    
    import fifo_seq_item_pkg::*;

    class fifo_coverage_collector extends uvm_component;
        `uvm_component_utils(fifo_coverage_collector);
        uvm_analysis_export #(fifo_seq_item)cov_export;
        uvm_tlm_analysis_fifo#(fifo_seq_item)cov_fifo;
        fifo_seq_item cov_seq_item;

        //Autogenerate for all Signals except the output data_out
        covergroup cov;
            data_in_cvp: coverpoint cov_seq_item.data_in;
            rst_n_cvp: coverpoint cov_seq_item.rst_n;
            wr_en_cvp: coverpoint cov_seq_item.wr_en;
            rd_en_cvp: coverpoint cov_seq_item.rd_en;
            wr_ack_cvp: coverpoint cov_seq_item.wr_ack;
            overflow_cvp: coverpoint cov_seq_item.overflow;
            full_cvp: coverpoint cov_seq_item.full;
            empty_cvp: coverpoint cov_seq_item.empty;
            almostfull_cvp: coverpoint cov_seq_item.almostfull;
            almostempty_cvp: coverpoint cov_seq_item.almostempty;
            underflow_cvp: coverpoint cov_seq_item.underflow;

            CR_full:cross wr_en_cvp,rd_en_cvp,full_cvp;
            CR_almostfull:cross wr_en_cvp,rd_en_cvp,almostfull_cvp;
            CR_almostempty:cross wr_en_cvp,rd_en_cvp,almostempty_cvp;
            CR_empty:cross wr_en_cvp,rd_en_cvp,empty_cvp;
            CR_overflow:cross wr_en_cvp,rd_en_cvp,overflow_cvp;
            CR_underflow:cross wr_en_cvp,rd_en_cvp,underflow_cvp;
            CR_wr_ack:cross wr_en_cvp,rd_en_cvp,wr_ack_cvp;
        endgroup

        function new(string name = "fifo_coverage_collector",uvm_component parent = null);
            super.new(name,parent);
            cov = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //connect the analysis export of the coverage with the analysis export of the fifo(internally the coverage)
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                //get the next item from the fifo
                cov_fifo.get(cov_seq_item);
                cov.sample();
            end
        endtask
    endclass

endpackage