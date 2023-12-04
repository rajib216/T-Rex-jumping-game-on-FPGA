module clock_divider #(parameter div_value=1249) (clk,new_clk);
 input clk;// 25 MHz
 output reg new_clk=0;
 reg [31:0]counter=0;
 always@(posedge clk)
  begin
	if(counter==div_value)
	 begin
		counter<=0;
		new_clk<=~new_clk;
	 end
	 else
		begin
		 counter<=counter+1;
		 new_clk<=new_clk;
		end
	end
endmodule
