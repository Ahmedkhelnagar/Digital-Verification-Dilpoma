

package FIFO_scoreboard;

import shared_pkg::*;
import transaction_pkg::*;

class fifo_scoreboard;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;


    logic [FIFO_WIDTH-1:0] fifo_queue[$];
    logic [FIFO_WIDTH-1:0]data_out_ref;

    function void reference_model(input FIFO_transaction txn);
        
        if(!txn.rst_n)begin
            fifo_queue.delete();
        end
        else begin
            if(txn.wr_en && fifo_queue.size() < FIFO_DEPTH)begin
                fifo_queue.push_front(txn.data_in);
            end
            else if(txn.rd_en && fifo_queue.size() != 0)begin
                data_out_ref = fifo_queue.pop_back();
            end
            else if(fifo_queue.size() == 0 && txn.wr_en && txn.rd_en)begin
                fifo_queue.push_front(txn.data_in);
            end
            else if(fifo_queue.size() == FIFO_DEPTH && txn.wr_en && txn.rd_en)begin
                data_out_ref = fifo_queue.pop_back();
            end
            else if(txn.wr_en && txn.rd_en && (fifo_queue.size() != FIFO_DEPTH) && (fifo_queue.size() != 0))begin
                fifo_queue.push_front(txn.data_in);
                data_out_ref = fifo_queue.pop_back();                
            end


            // if(txn.wr_en && txn.rd_en && txn.empty)begin
            //     fifo_queue.push_back(txn.data_in);
            // end
            // if(txn.wr_en && txn.rd_en && txn.full)begin
            //     data_out_ref = fifo_queue.pop_front;
            // end
            // if(txn.wr_en && !txn.full)begin
            //     fifo_queue.push_back(txn.data_in);
            // end
            // if(txn.rd_en && !txn.empty)begin
            //     data_out_ref = fifo_queue.pop_front;
            // end


        end

        // if((fifo_queue.size() < FIFO_DEPTH) && txn.wr_en)begin
        //     fifo_queue.push_back(txn.data_in);
        // end
        // else if((fifo_queue.size() != 0) && txn.rd_en)begin
        //     data_out_ref = fifo_queue.pop_front();
        // end
        // else if((fifo_queue.size() == 0) && txn.wr_en && txn.rd_en)begin
        //     fifo_queue.push_back(txn.data_in);  //write
        // end
        // else if((fifo_queue.size() == FIFO_DEPTH) && txn.wr_en && txn.rd_en)begin
        //     data_out_ref = fifo_queue.pop_front();  //read
        // end
        // else if(( (fifo_queue.size() != 0) && (fifo_queue.size() != FIFO_DEPTH) ) && txn.rd_en && txn.wr_en)begin
        //    fifo_queue.push_back(txn.data_in);
        //    data_out_ref = fifo_queue.pop_front();
        // end
       
        // else if((fifo_queue.size() == FIFO_DEPTH) && txn.wr_en)begin
        //     txn.overflow = 1;
        // end
        // else if((fifo_queue.size() == 0) && txn.rd_en)begin
        //     txn.underflow = 1;
        // end
    endfunction //reference_model

    function void check_data(input FIFO_transaction txn);
        // @(negedge txn.clk);
        reference_model(txn);
        //compare the reference outputs calculated with object outputs
        if(data_out_ref !== txn.data_out)begin
                $display("Error !!,Mismatch between expected and calculated");
                $display("Data_out = %0d,ref = %0d",txn.data_out,data_out_ref);
                shared_pkg_c::error_count++;
        end
        else begin
            $display("Correct,Data_out = %0d,ref =%0d",txn.data_out,data_out_ref);
            shared_pkg_c::correct_count++;
        end
    endfunction //check_data

endclass

endpackage