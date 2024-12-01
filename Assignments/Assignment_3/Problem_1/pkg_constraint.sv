

package pkg_constraint;
    parameter WIDTH = 4;
    parameter MAXPOS = 16; //(1<<WIDTH) //(1<<4) -> 10000 = 16 // 16
    class constraints;
        bit clk;
        rand bit rst_n,ce,load_n,up_down;
        rand bit [WIDTH - 1:0]data_load,count_out;
        constraint rst_cons
        {
            rst_n dist {0:= 2,1:= 98};
        }
        constraint load_cons
        { 
            load_n dist {0:= 70,1:=30};
        }
        constraint enable_cons
        { 
            ce dist {1:= 70,0:= 30};
        }

        
        /***Functional coverage***/
        covergroup counter_covgroup@(posedge clk);
            DL:coverpoint data_load iff(!load_n)
            {
                bins load_values[] = {[0: MAXPOS-1]};
            }
            CO_all_up:coverpoint count_out iff(rst_n && ce && up_down)
            {
                bins count_all_up[] = {[0: MAXPOS-1]};
            }
            //Transition coverpoint, overflow from max to zero
            CO_Tra_up:coverpoint count_out iff(rst_n && ce && up_down)
            {
                bins overflow[] = ((MAXPOS-1) => 0);
            }
            CO_all_down:coverpoint count_out iff(rst_n && ce && !up_down)
            {
                bins count_all_down[] = {[0 : MAXPOS-1]};
            }
            //Tramsition from 0 to max
            CO_tra_down:coverpoint count_out iff(rst_n && ce && !up_down)
            {
                bins underflow[] = (0 => (MAXPOS-1));
            }           
        endgroup

        //Constructor
        function new();
            counter_covgroup = new();
        endfunction
    endclass    
endpackage