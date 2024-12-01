

package pkg_constraint;
    parameter WIDTH = 4; 
    class constraints;
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
    endclass    
endpackage