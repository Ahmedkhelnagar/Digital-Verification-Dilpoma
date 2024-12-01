

module adder_tb;

    //Parameters
    //Range : 2^(n-1) -> -2^n
    localparam MAXPOS = 7 ; 
    localparam MAXNEG = -8 ;
    //Signals Declairation
    logic clk;
    logic reset;
    logic signed [3:0] A;
    logic signed [3:0] B;
    logic signed [4:0] C;
    
    integer error_count;
    integer correct_count;

    //Module instantiations
    adder DUT(clk,reset,A,B,C);
    // adder DUT(.*); if same variables with same names in design and test bench

    //Clock generation
    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end

    initial begin
        A = 0;
        B = 0;
        error_count = 0;correct_count = 0;

        // toggle_reset;
        assert_reset;

        A = MAXNEG ; B = MAXNEG;
        check_result(-16);

        A = MAXNEG ; B = 0;
        check_result(-8);

        A = MAXNEG ; B = MAXPOS;
        check_result(-1);
        
        A = 0 ; B = MAXNEG;
        check_result(-8);

        A = 0 ; B = MAXPOS;
        check_result(7);

        A = 0 ; B = 0;
        check_result(0);
      
        A = MAXPOS ; B = MAXNEG;
        check_result(-1);
        
        A = MAXPOS ; B = 0;
        check_result(7);

        A = MAXPOS ; B = MAXPOS;
        check_result(14);

        //Added test vectors to achieve toggle coverage %100
        for (int i = MAXNEG; i <= MAXPOS; i++) begin
            for (int j = MAXNEG; j <= MAXPOS; j++) begin
                A = i;
                B = j;
                check_result(A + B);

                //check reset to achieve the toggle coverage %100
                if(i == 0 && j ==0)begin
                    assert_reset;
                end
            end
        end

        $display("Error_count = %0d,Correct_count = %0d",error_count,correct_count);
        $stop;
    end

    task check_result(input signed[4:0] expected_result);
        @(negedge clk);

        if(expected_result != C)begin
            $display("Incorrec result");
            error_count = error_count + 1 ;
        end
        else
            correct_count = correct_count + 1;

    endtask

    task assert_reset ;
        reset = 1;
        check_result(0);
        reset = 0;
    endtask
endmodule