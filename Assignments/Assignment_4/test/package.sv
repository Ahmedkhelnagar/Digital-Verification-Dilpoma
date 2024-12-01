

package alsu_pkg;
    typedef enum bit[2:0]{OR,XOR,ADD,MULTI,SHIFT,ROTATE,INVALID_6,INVALID_7}opcode_e;
    typedef enum {MAXPOS = 3,MAXNEG = -4,ZER0 = 0}reg_e;

    class alsu_class;
        rand logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand logic signed [2:0]A,B;
        rand opcode_e opcode;
        rand reg_e A_limit,B_limit;
        rand logic [3:0]A_others,B_others;
        bit [2:0]ones[] = '{3'b100,3'b010,3'b001};
        rand bit[2:0]ones_t,ones_f;

        rand opcode_e array_opcode[6];
        /********************************************
        * 
        *               Constraints
        *       
        ********************************************/
        constraint rst_cons
        {
            rst dist{1:= 2 ,0:= 98};
        }

        constraint A_B_cons
        {
            //preparing the values of the variables
            A_others != (MAXPOS || MAXNEG || ZER0); 
            B_others != (MAXPOS || MAXNEG || ZER0); 
            ones_t inside {ones};
            !(ones_f inside {ones});

            //constraint A and B with differenet opcodes
            if(opcode == OR || opcode == XOR)
            {
                if(red_op_A == 1)
                {
                    B == 0;
                    A dist{ones_t:=80,ones_f:=20};
                }
                else if(red_op_B == 1)
                {
                    A == 0;
                    B dist{ones_t:=80,ones_f:=20};
                }
            }
            /*here the opcode -> ADD , MULTI
            so must the invaid cases occur less frequent than the valid cases,
            so we increase the probability during ADD , MULTI opcodes*/
            else
            {
                red_op_A dist {1:=20,0:=80};
                red_op_B dist {1:=20,0:=80};
                if(opcode == ADD || opcode == MULTI)
                {
                    A dist {A_limit:=80,A_others:=20};
                    B dist {B_limit:=80,B_others:=20};
                }
            }
        }

        constraint opcode_cons
        {
            opcode dist {[OR:ROTATE]:=80,[INVALID_6:INVALID_7]:=20};
        }

        constraint bypass_cons
        {
            bypass_A dist{1:=2,0:=98};
            bypass_B dist{1:=2,0:=98};
        }

        //the 8 constraint
        constraint unique_valid_opcodes
        {
          foreach(array_opcode[i])
            foreach(array_opcode[j])
            {
                if(i != j)
                {
                    array_opcode[i] != array_opcode[j];
                    array_opcode[i] inside {[OR:ROTATE]};
                }
            }
        } 
        /********************************************
        * 
        *           Function coverage
        *       
        ********************************************/
        covergroup cvr_gp;
            //coverpoint for ports A ,B
            A_cp0:coverpoint A
            {
               bins A_data_0 = {0};
               bins A_data_max = {MAXPOS};
               bins A_data_min = {MAXNEG};
               bins A_data_default = {A_others};
            }
            A_cp1:coverpoint A iff(red_op_A)
            {
               bins A_data_walkingones[] = {1,2,-4}; 
            }
            B_cp0:coverpoint B
            {
                bins B_data_0 = {0};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = {B_others};
            }
            B_cp1:coverpoint B iff(red_op_B && (!red_op_A))
            {
                bins B_data_walkingones[] = {1,2,-4};
            }
            ALU_cp:coverpoint opcode
            {
                bins Bins_shift[] = {SHIFT,ROTATE};
                bins Bins_arith[] = {ADD,MULTI};
                bins Bins_bitwise[] = {OR,XOR};
                illegal_bins Bins_invalid = {INVALID_6,INVALID_7};
                bins Bins_trans = (OR=>XOR=>ADD=>MULTI=>SHIFT=>ROTATE); 
            }
            /************Cross coverage*************/ 
            /**Cross 0**/
            //cross between opcode and A
            CR0:cross ALU_cp , A_cp0
            {
                option.cross_auto_bin_max = 0;
                bins bin1 = binsof(ALU_cp.Bins_arith) && binsof(A_cp0.A_data_0);
                bins bin2 = binsof(ALU_cp.Bins_arith) && binsof(A_cp0.A_data_max);
                bins bin3 = binsof(ALU_cp.Bins_arith) && binsof(A_cp0.A_data_min);
            }
            /**Cross 1**/
            //cross between opcode and B
            CR1:cross ALU_cp , B_cp0
            {
                option.cross_auto_bin_max = 0;
                bins bin4 = binsof(ALU_cp.Bins_arith) && binsof(B_cp0.B_data_0);
                bins bin5 = binsof(ALU_cp.Bins_arith) && binsof(B_cp0.B_data_max);
                bins bin6 = binsof(ALU_cp.Bins_arith) && binsof(B_cp0.B_data_min);
            }
            /**Cross 2**/
            c_in_cp:coverpoint cin
            {
                bins c_in_0 = {0};
                bins c_in_1 = {1};
            }
            CR2:cross ALU_cp , c_in_cp
            {
                option.cross_auto_bin_max = 0;
                bins bin7 = binsof(ALU_cp.Bins_arith) intersect {ADD} && binsof(c_in_cp.c_in_0);
                bins bin8 = binsof(ALU_cp.Bins_arith) intersect {ADD} && binsof(c_in_cp.c_in_1);
            }
            /**Cross 3**/
            serial_in_cp:coverpoint serial_in
            {
                bins serial_in_0 = {0};
                bins serial_in_1 = {1};
            }
            CR3:cross ALU_cp , serial_in_cp
            {
                option.cross_auto_bin_max = 0;
                bins bin9 = binsof(ALU_cp.Bins_shift) intersect {SHIFT} && binsof(serial_in_cp.serial_in_0);
                bins bin10 = binsof(ALU_cp.Bins_shift) intersect {SHIFT} && binsof(serial_in_cp.serial_in_1);
            }
            /**Cross 4**/
            dir_cp:coverpoint direction
            {
                bins dir_0 = {0};
                bins dir_1 = {1};
            }
            CR4:cross ALU_cp , dir_cp
            {
                option.cross_auto_bin_max = 0;
                bins bins11 = binsof(ALU_cp.Bins_shift) && binsof(dir_cp.dir_0);
                bins bins12 = binsof(ALU_cp.Bins_shift) && binsof(dir_cp.dir_1);
            }
            /**Cross 5**/
            red_op_A_cp:coverpoint red_op_A
            {
                bins red_op_A_HIGH = {1};
            }
            CR5:cross ALU_cp , A_cp1 ,red_op_A_cp , B_cp0
            {
                option.cross_auto_bin_max = 0;
                bins bin13 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_HIGH) && binsof(A_cp1.A_data_walkingones) && binsof(B_cp0.B_data_0);
            }
            /**Cross 6**/
            red_op_B_cp:coverpoint red_op_B
            {
                bins red_op_B_HIGH = {1};
            }
            CR6:cross ALU_cp , red_op_B_cp, B_cp1 , A_cp0
            {
                option.cross_auto_bin_max = 0;
                bins bin14 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_HIGH) && binsof(B_cp1.B_data_walkingones) && binsof(A_cp0.A_data_0);
            }
            /**Cross 7 -> Covered invalid cases**/
            CR7:cross ALU_cp , red_op_A_cp , red_op_B_cp
            {
                option.cross_auto_bin_max = 0;
                bins bin15 = binsof(ALU_cp) intersect{[ADD:ROTATE]} && binsof(red_op_A_cp.red_op_A_HIGH);
                bins bin16 = binsof(ALU_cp) intersect{[ADD:ROTATE]} && binsof(red_op_B_cp.red_op_B_HIGH);
            }
        endgroup

        //constructor
        function new();
            cvr_gp = new();
        endfunction 
    endclass
endpackage
