

module ram_tb;
    /***********Parameters***********/
    localparam TESTS = 100;

    /**************signal declaration****/
    //Inputs port
    bit clk,write,read;
    bit [7:0]data_in;
    bit [15:0]address;
    //output port
    logic [8:0]data_out;

    /*********Dynamic arrays************/
    bit [15:0]address_array[];
    bit [7:0]data_to_write_array[];
    //Associative arrays
    bit [8:0]data_read_expect_assoc[int];
    //Queues
    logic [8:0]data_read_queue[$];

    /************Variables*********/
    integer correct_count = 0;
    integer error_count = 0;

    /************module instantiation*********/
    my_mem DUT(.*);

    /***********clock generation*******/
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    /***********Test stimulus generation**********/
    initial begin
        write = 0;
        read = 0;

        address_array = new[TESTS];
        data_to_write_array = new[TESTS];

        /*prepare the address that will be written in the memory,
         as well as the data*/
        for(integer i = 0;i<TESTS;i++)begin
            address_array[i] =$random;
            data_to_write_array[i] =$random;
        end

        //recieve the data
        for(integer i = 0;i<TESTS;i++)begin
            data_read_expect_assoc[address_array[i]] = {^data_to_write_array[i],data_to_write_array[i]}; 
        end

        /***in the above we just prepare the address and the data that will be used in the test***/
        @(negedge clk);
        write = 1;
        for(integer i = 0;i<TESTS;i++)begin
            address = address_array[i];
            data_in = data_to_write_array[i];
            @(negedge clk);
        end

        write = 0;
        read  = 1;
        for(integer i = 0;i<TESTS;i++)begin
            address = address_array[i];
            check_dataOut(address);
            data_read_queue.push_back(data_out);
        end

        read = 0;
        @(negedge clk);
        $display("data in the queue are:");
        while(data_read_queue.size != 0)
            $display(data_read_queue.pop_front());

        $display("At the end of the test, correct_count = %0d,error_count = %0d",correct_count,error_count);
        $stop;
    end

    /****task to check the outputs*****/
    task check_dataOut(bit [15:0]address);
        @(negedge clk);
        if(data_read_expect_assoc[address] !== data_out)begin
            $$display("Error !!,address = %0h,expected_value = %0h,data_out =%0h",address,data_read_expect_assoc[address],data_out);
            error_count++;
        end
        else begin
            correct_count++;
        end
    endtask
endmodule