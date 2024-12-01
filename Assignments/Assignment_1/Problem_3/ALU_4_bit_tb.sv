

module ALU_4_bit_tb;
    //Signal Declairation
    logic clk;
    logic reset;
    logic [1:0] Opcode;
    logic signed[3:0] A;
    logic signed[3:0] B;
    logic signed [4:0] C;

    //Internal signal
    logic signed [4:0] ALu_out;
    integer error_count = 0;
    integer correct_count = 0;
    
    //Parameters
    localparam Add = 2'b00; //A+B
    localparam Sub = 2'b01; //A-B
    localparam Not_A = 2'b10;   //~A
    localparam ReductionOR_B = 2'b11;   // |B
    

    localparam MAXPOS = 7;
    localparam MAXNEG = -8;
    localparam ZERO = 0;
    //Module instantiation
    ALU_4_bit DUT(.*);

    //Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    //Test stimulus generation
    initial begin
        A = 0;
        B = 0;
        assert_reset;
        /****check add/sub opcode****/
        //A = Neg
        A = MAXNEG; B=MAXNEG;
        Opcode = Add;
        check_result(Add,A,B,-16);
        Opcode = Sub;
        check_result(Sub,A,B,ZERO);

        A = MAXNEG; B=ZERO;
        Opcode = Add;
        check_result(Add,A,B,MAXNEG);
        Opcode = Sub;
        check_result(Sub,A,B,MAXNEG);

        A = MAXNEG; B=MAXPOS;
        Opcode = Add;
        check_result(Add,A,B,-1);
        Opcode = Sub;
        check_result(Sub,A,B,-15);

        //A = Zero
        A = ZERO; B=MAXNEG;
        Opcode = Add;
        check_result(Add,A,B,MAXNEG);
        Opcode = Sub;
        check_result(Sub,A,B,8);
        
        A = ZERO; B=ZERO;
        Opcode = Add;
        check_result(Add,A,B,ZERO);
        Opcode = Sub;
        check_result(Sub,A,B,ZERO);

        A = ZERO; B=MAXPOS;
        Opcode = Add;
        check_result(Add,A,B,MAXPOS);
        Opcode = Sub;
        check_result(Sub,A,B,-7);
       
        //A = Pos
        A = MAXPOS; B=MAXNEG;
        Opcode = Add;
        check_result(Add,A,B,-1);
        Opcode = Sub;
        check_result(Sub,A,B,15);
        
        A = MAXPOS; B=ZERO;
        Opcode = Add;
        check_result(Add,A,B,MAXPOS);
        Opcode = Sub;
        check_result(Sub,A,B,MAXPOS);

        A = MAXPOS; B=MAXPOS;
        Opcode = Add;
        check_result(Add,A,B,14);
        Opcode = Sub;
        check_result(Sub,A,B,ZERO);

        /*****check NOT_A opcode****/
        Opcode = Not_A;
        A = 4'b0000;B = 4'b1010;
        check_result(Not_A,A,B,5'b11111);
        A = 4'b1111;B = 4'b1010;
        check_result(Not_A,A,B,5'b00000);

        /****Check ReductionOR_B opcode****/
        Opcode = ReductionOR_B;
        A = 4'b0000;B = 4'b0000;
        check_result(ReductionOR_B,A,B,0);
        A = 4'b1111;B = 4'b1111;
        check_result(ReductionOR_B,A,B,1);

        /*To cover opcode[1] toggle from 1 to 0**/
        A = MAXPOS; B=MAXPOS;
        Opcode = Add;
        check_result(Add,A,B,14);

        $display("error_count = %0d,correct_count = %0d",error_count,correct_count);
        $stop;
    end

    /*********************************************
    *
    *           Tasks Implementation           
    *
    **********************************************/
    task check_result(input [1:0]Opcode,input signed[3:0] A,B,input signed[4:0]expected_result);
        @(negedge clk);
        if(C !== expected_result)begin
            $display("%t:Error !!,A = %0d,B = %0d,opcode = %0d,expected_result = %0d,C = %0d,",$time,A,B,Opcode,expected_result,C);
            error_count = error_count + 1;
            $stop;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask

    task check_out(input signed [4:0]expected_c);
        @(negedge clk);
        if(C !== expected_c)begin
            $display("%t:Error !!, C = %b,expected_c = %b",$time,C,expected_c);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask

    task assert_reset;
        reset = 0;
        @(negedge clk); //here the rst is toggled from 0 to 1 
        reset = 1;
        check_out(5'b0);       
        reset = 0;        //here the rst is toggled from 1 to 0
    endtask
endmodule