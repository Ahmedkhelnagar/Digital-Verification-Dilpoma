

package coverage_pkg;

    //import the transction package
    import transaction_pkg::*;
    class FIFO_coverage;
        //object of the class FIFO_tranction
        FIFO_transaction F_cvg_txn = new();
        //coverage group to cross coverage
        covergroup cvr_gp;
            //Auto generation
            wr_en_c:coverpoint F_cvg_txn.wr_en;
            rd_rn_c:coverpoint F_cvg_txn.rd_en;
            full_c:coverpoint F_cvg_txn.full;
            almostfull_c:coverpoint F_cvg_txn.almostfull;
            almostempty_c:coverpoint F_cvg_txn.almostempty;
            empty_c:coverpoint F_cvg_txn.empty;
            overflow_c:coverpoint F_cvg_txn.overflow;
            underflow_c:coverpoint F_cvg_txn.underflow;
            wr_ack_c:coverpoint F_cvg_txn.wr_ack;

            CR0:cross wr_en_c, rd_rn_c, full_c;
            CR1:cross wr_en_c, rd_rn_c, almostfull_c;
            CR2:cross wr_en_c, rd_rn_c, almostempty_c;
            CR3:cross wr_en_c, rd_rn_c, empty_c;
            CR4:cross wr_en_c, rd_rn_c, overflow_c;
            CR5:cross wr_en_c, rd_rn_c, underflow_c;
            CR6:cross wr_en_c, rd_rn_c, wr_ack_c;
            
        endgroup

        function new();
            cvr_gp = new();
            cvr_gp.start();
        endfunction

        function void sample_data(input FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            cvr_gp.sample();
        endfunction
    endclass
endpackage