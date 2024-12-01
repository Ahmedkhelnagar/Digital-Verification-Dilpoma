

module priority_enc_tb;
    //Signal declaration
    logic clk;
    logic rst;
    logic [3:0]D;
    logic [1:0]Y;   //output
    logic valid;    //output

    integer error_count = 0;
    integer correct_count = 0;

    integer i;

    //module instantiation
    priority_enc DUT(.*);

    //clock generation
    initial begin
        clk = 0;
        forever 
           #1 clk = ~clk;
    end

    //Test stimulus generation
    initial begin
        assert_reset;
        check_normal_operation;
        $stop;
    end
    /*********************************************
    *
    *           Tasks Implementation           
    *
    **********************************************/
    task check_result(input [1:0]expected_result,input expected_valid);
        @(negedge clk);
        if( (Y != expected_result) || (valid != expected_valid))begin
            $display("Error !!,Y = %b,expected_result = %b,valid = %b,expected_valid = %b",Y,expected_result,valid,expected_valid);
            error_count = error_count + 1;
            $stop;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask

    task assert_reset;
        rst = 0;
        @(negedge clk); //here the rst is toggled from 0 to 1 
        rst = 1;
        check_result(0,0);
        rst = 0;        //here the rst is toggled from 1 to 0
    endtask

    task check_normal_operation;
        for(i = 0;i<16;i = i + 1)begin
            D = i;
            case(D)
                4'b0000:check_result(Y,1'b0);
                4'b1000:check_result(2'b00,1'b1);   //0000 -> y = 00
                4'b0100:check_result(2'b01,1'b1);   //X100 -> y = 01
                4'b1100:check_result(2'b01,1'b1);
                4'b0010:check_result(2'b10,1'b1);   //XX10 -> y = 10
                4'b0110:check_result(2'b10,1'b1);
                4'b1010:check_result(2'b10,1'b1);
                4'b1110:check_result(2'b10,1'b1);
                4'b0001:check_result(2'b11,1'b1);   //XXX1 -> y = 11
                4'b0011:check_result(2'b11,1'b1);
                4'b0101:check_result(2'b11,1'b1);
                4'b0111:check_result(2'b11,1'b1);
                4'b1001:check_result(2'b11,1'b1);
                4'b1011:check_result(2'b11,1'b1);
                4'b1101:check_result(2'b11,1'b1);
                4'b1111:check_result(2'b11,1'b1);
                default:check_result(2'b00,1'b0);
            endcase
            $display("error_count = %0d,correct_count = %0d",error_count,correct_count);
        end
        D[3] = 1;
        check_result(2'b11,1);
        D[3] = 0;
        check_result(2'b11,1);
        D = 0;
        check_result(Y,0);
    endtask

endmodule