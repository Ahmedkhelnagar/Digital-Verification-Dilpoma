module DSP(A, B, C, D, clk, rst_n, P);
parameter OPERATION = "ADD";
input  [17:0] A, B, D;
input  [47:0] C;
input clk, rst_n;
output reg  [47:0] P;

reg  [17:0] A_reg_stg1, A_reg_stg2, B_reg, D_reg, adder_out_reg;
reg  [47:0] C_reg, mult_out;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		 A_reg_stg1 <= 0;
		 A_reg_stg2 <= 0;
		 B_reg <= 0;
		 C_reg <= 0;
		 D_reg <= 0;
		 adder_out_reg <= 0; 
		 mult_out <= 0;
		 P <= 0;
	end
	else begin
		A_reg_stg1 <= A;
		A_reg_stg2 <= A_reg_stg1;
		B_reg <= B;
		C_reg <= C;
		D_reg <= D; 
		if (OPERATION == "ADD") begin
			adder_out_reg <= D_reg + B_reg;
			P <= mult_out + C_reg;
		end
		else if (OPERATION == "SUBTRACT") begin
			adder_out_reg <= D_reg - B_reg;
			P <= mult_out - C_reg;
		end
		mult_out <= A_reg_stg2 * adder_out_reg;
	end
end

endmodule