

package fifo_scoreboard_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import fifo_seq_item_pkg::*;

    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard);
        uvm_analysis_export #(fifo_seq_item)sb_export;
        uvm_tlm_analysis_fifo#(fifo_seq_item)sb_fifo;
        fifo_seq_item sb_seq_item;

        /*Related to ref model*/
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        logic [FIFO_WIDTH-1:0]fifo_queue[$];
        logic [FIFO_WIDTH-1:0]data_out_ref;

        integer correct_count = 0;
        integer error_count = 0;

        function new(string name = "fifo_scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("cov_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction

         function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //connect the analysis export of the coverage with the analysis export of the fifo(internally the coverage)
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_seq_item);
                ref_model(sb_seq_item);
                if(sb_seq_item.data_out != data_out_ref)begin
                    `uvm_error("Run_phase",$sformatf("Failed,Data_out = %0d while data_out_ref = %0d",sb_seq_item.data_out,data_out_ref));
                    error_count++;
                end
                else if (sb_seq_item.data_out === data_out_ref)begin
                    `uvm_info("Run_phase",$sformatf("Correct,Data_out = %0d while data_out_ref = %0d",sb_seq_item.data_out,data_out_ref),UVM_LOW);
                    correct_count++;
                end
            end
        endtask

        task ref_model(fifo_seq_item chk_seq_item);
            if(!chk_seq_item.rst_n)begin
                fifo_queue.delete();
            end
            else begin
                if(chk_seq_item.wr_en && chk_seq_item.rd_en && fifo_queue.size() != 0 && fifo_queue.size() != FIFO_DEPTH)begin
                   data_out_ref = fifo_queue.pop_back();
                   fifo_queue.push_front(chk_seq_item.data_in);
                end
                else if(chk_seq_item.wr_en && chk_seq_item.rd_en &&  fifo_queue.size() == FIFO_DEPTH)begin
                    data_out_ref = fifo_queue.pop_back();
                end
                else if(chk_seq_item.wr_en && chk_seq_item.rd_en &&  fifo_queue.size() == 0)begin
                    fifo_queue.push_front(chk_seq_item.data_in);
                end
                else if(chk_seq_item.wr_en && fifo_queue.size() < FIFO_DEPTH)begin
                    fifo_queue.push_front(chk_seq_item.data_in);
                end
                else if(chk_seq_item.rd_en &&  fifo_queue.size() != 0)begin
                    data_out_ref = fifo_queue.pop_back();
                end
            end
        endtask


        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("Report_phase",$sformatf("Succseeful checks : %0d",correct_count),UVM_MEDIUM);
            `uvm_info("Report_phase",$sformatf("Unsuccseeful checks : %0d",error_count),UVM_MEDIUM);
        endfunction

    endclass


endpackage