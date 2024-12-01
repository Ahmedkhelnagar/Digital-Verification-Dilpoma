

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


        property p1;
            @(posedge clk) disable iff (rst)  $onehot(D)|=>valid;
        endproperty

        property p2;
            @(posedge clk) disable iff (rst)  (D[3:0] == 4'b1000)|=>(Y ==2'b00);
        endproperty

        property p3;
            @(posedge clk) disable iff (rst)  (D[2:0] == 3'b100)|=>(Y ==2'b01);
        endproperty

        property p4;
            @(posedge clk) disable iff (rst)  (D[1:0] == 2'b10)|=>(Y ==2'b10);
        endproperty

        property p5;
            @(posedge clk)  disable iff (rst) (D[0] == 1'b1)|=>(Y ==2'b11);
        endproperty

        property p6;
            @(posedge clk) (rst) |=> ((Y == 2'b00) && (valid == 1'b0));
        endproperty

        p6_pro:assert property(p6) else $display("p6 is failing,D = %0d,Y = %0d,valid = %0d",D,Y,valid);
        p1_pro:assert property(p1) else $display("p1 is failing,D = %0d,Y = %0d",D,Y);
        p2_pro:assert property(p2) else $display("p2 is failing,D = %0d,Y = %0d",D,Y);
        p3_pro:assert property(p3) else $display("p3 is failing,D = %0d,Y = %0d",D,Y);
        p4_pro:assert property(p4) else $display("p4 is failing,D = %0d,Y = %0d",D,Y);
        p5_pro:assert property(p5) else $display("p5 is failing,D = %0d,Y = %0d",D,Y);

        p6_cov:cover property(p6);
        p1_cov:cover property(p1);
        p2_cov:cover property(p2);
        p3_cov:cover property(p3);
        p4_cov:cover property(p4);
        p5_cov:cover property(p5);
    //Test stimulus generation
    initial begin
        assert_reset;
        repeat(100)begin
            D = $random();
            @(negedge clk);
        end
        assert_reset;
        $stop;
    end

    task assert_reset; 
        rst = 1;
        D = 0;
        @(negedge clk); //here the rst is toggled from 0 to 1 
        rst = 0;        //here the rst is toggled from 1 to 0
    endtask
endmodule