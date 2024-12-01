module priority_enc (
input  clk,
input  rst,
input  [3:0] D,	
output reg [1:0] Y,	
output reg valid
);

always @(posedge clk) begin
  if (rst)
     Y <= 2'b0;
  else
  	casex (D)/**Valid = 1 **/
  		4'b1000: Y <= 0;
  		4'bX100: Y <= 1;
  		4'bXX10: Y <= 2;
  		4'bXXX1: Y <= 3;
  	endcase
  	valid <= (~|D)? 1'b0: 1'b1;
end
endmodule