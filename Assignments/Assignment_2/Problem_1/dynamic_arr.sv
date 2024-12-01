

module dynamic_arr;
    int dyn_arr1[];
    int dyn_arr2[] = '{9,1,8,3,4,4};

    initial begin
        dyn_arr1 = new[6];
        dyn_arr1 = '{0,1,2,3,4,5};

        $display("Expected_out = %p,ArraySize = %0d",dyn_arr1,$size(dyn_arr1));
        dyn_arr1.delete();

        //Reverse arr2
        dyn_arr2.reverse;
        $display("Expected_out = %p",dyn_arr2);
        dyn_arr2.sort;
        $display("Expected_out = %p",dyn_arr2);
        dyn_arr2.rsort;
        $display("Expected_out = %p",dyn_arr2);
        dyn_arr2.shuffle;
        $display("Expected_out = %p",dyn_arr2);
    end
endmodule