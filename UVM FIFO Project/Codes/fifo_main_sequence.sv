

package fifo_main_sequence_pkg;
     import uvm_pkg::*;
    `include "uvm_macros.svh"
     import fifo_seq_item_pkg::*;

    class fifo_main_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(fifo_main_sequence);
        fifo_seq_item seq_item;

        function new(string name = "fifo_main_sequence");
            super.new(name);
        endfunction

        task body;
            //write_only_sequence 
            repeat(1000)begin
                seq_item = fifo_seq_item::type_id::create("seq_item");
                start_item(seq_item);

                //disable the all constarints
                seq_item.constraint_mode(0);    

                /*here only enable the reset constraint and keep the others disabled,
                cus here i want to write only and no need to the distribution of the write constraint..
                i want the write operation 100 % */
                seq_item.rst_n_cons.constraint_mode(1); 
                assert(seq_item.randomize() with{wr_en == 1;rd_en == 0;});  //soft constraint 
                finish_item(seq_item);
            end
            //read_only_sequence 
            repeat(1000)begin
                seq_item = fifo_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.constraint_mode(0);
                seq_item.rst_n_cons.constraint_mode(1);
                assert(seq_item.randomize() with{wr_en == 0;rd_en == 1;});
                finish_item(seq_item);
            end
            // //write_read_sequence 
            repeat(1000)begin
                seq_item = fifo_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                //here write & read together so i need to the constraints of wr and rd.
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass    

endpackage