

package alsu_pkg;
    typedef enum bit[2:0]{OR,XOR,ADD,MULTI,SHIFT,ROTATE,INVALID_6,INVALID_7}opcode_e;
    typedef enum {MAXPOS = 3,MAXNEG = -4,ZER0 = 0}reg_e;

    class alsu_class;
        rand logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand opcode_e opcode;
        rand logic [2:0]A,B;
        rand reg_e A_limit,B_limit;
        rand logic [3:0]A_others,B_others;
        bit [2:0]ones[] = '{3'b100,3'b010,3'b001};
        rand bit[2:0]ones_t,ones_f;

        /**Constraints**/
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
    endclass
endpackage
