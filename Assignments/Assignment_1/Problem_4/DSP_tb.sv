

module DSP_tb;
    //Signal Declairation
    logic [17:0]A,B,D;
    logic [47:0]C;
    logic clk,rst_n;
    logic [47:0]P;
    
    //Internal Signals
    logic [17:0]adder_out;
    logic [47:0]multi_out,expected_P;
    integer error_count = 0;
    integer correct_count = 0;

    //module instantiations
    DSP DUT(.*);

    //clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    //Test stimulus generation
    initial begin
        A = 0;
        B = 0;
        C = 0;
        D = 0;
        assert_reset;
      
        for(integer i = 0 ; i< 10000;i = i + 1)begin
            A = $random();
            B = $random();
            C = $random();
            D = $random();
            check_result;
        end
        $display("error_count = 0d%0d,correct_count = 0d%0d",error_count,correct_count);
        $stop;
    end
    //Assign statments
    assign adder_out = B + D;
    assign multi_out = adder_out * A;
    assign expected_P = multi_out + C;
    /*********************************************
    *
    *           Tasks Implementation           
    *
    **********************************************/
    task check_result;
        repeat(4) @(negedge clk);
        if(P !== expected_P)begin
            $display("Error !!");
            error_count = error_count + 1;
            $stop;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask

    task assert_reset;
        rst_n = 1;
        @(negedge clk); //here the rst is toggled from 0 to 1 
        rst_n = 0;  //active reset
        check_out_equal_0;
        rst_n = 1;        //here the rst is toggled from 1 to 0
    endtask

    task check_out_equal_0;
        @(negedge clk);
        if(P !== 0)begin
            $display("Error !!");
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask
endmodule