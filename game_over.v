module game_over(input clk, input flag_over, input flag, output reg [7:0] row3, output reg [15:0] col3);


clock_divider #(2499) selector(clk,new_clk); // 10 KHz
reg [3:0]counter1 = 4'b0000;
always @ (posedge new_clk)  // 10 KHz
begin
	//counter <= counter + 1;
	counter1 <= counter1 + 1;
	if (counter1 == 9)
	 counter1 <= 0; 
end

function [7:0] Rs;
input [4:0] r_id;
begin
	case(r_id)
		0: Rs = 8'b00000001;
		1: Rs = 8'b00000010;
		2: Rs = 8'b00000100;
		3: Rs = 8'b00001000;
		4: Rs = 8'b00010000;
		5: Rs = 8'b00100000;
		6: Rs = 8'b01000000;
		7: Rs = 8'b10000000;
		default: Rs = 8'b00000000;
	endcase
end
endfunction 

function [15:0] Cs;
input [4:0] c_id;
begin
	case(c_id)
		0: Cs = ~16'b0000000000000001;
		1: Cs = ~16'b0000000000000010;
		2: Cs = ~16'b0000000000000100;
		3: Cs = ~16'b0000000000001000;
		4: Cs = ~16'b0000000000010000;
		5: Cs = ~16'b0000000000100000;
		6: Cs = ~16'b0000000001000000;
		7: Cs = ~16'b0000000010000000;
		8: Cs = ~16'b0000000100000000;
		9: Cs = ~16'b0000001000000000;
	  10: Cs = ~16'b0000010000000000;
	  11: Cs = ~16'b0000100000000000;
	  12: Cs = ~16'b0001000000000000;
	  13: Cs = ~16'b0010000000000000;
	  14: Cs = ~16'b0100000000000000;
	  15: Cs =  16'b0111111111111111;
	  default: Cs = 16'b1111111111111111;
	endcase
end
endfunction


always @ (*) // block that shows "over"
begin
	if(flag_over == 1 )
		begin
				case(counter1)
				0: 
				begin
					row3 = Rs(2) | Rs(3) | Rs(4) | Rs(5) | Rs(1);
					col3 = Cs(1) & Cs(3);
				end
				1:
				begin
					row3 = Rs(1) | Rs(5);
					col3 = Cs(2);
				end
				2: 
				begin
					row3 = Rs(2) | Rs(3) | Rs(4) | Rs(5);
					col3 = Cs(5) & Cs(7);
				end
				3:
				begin
					row3 = Rs(1);
					col3 = Cs(6);
				end
				4: 
				begin 
					row3 = Rs(1) | Rs(3) | Rs(5);
					col3 = Cs(9) & Cs(10) & Cs(11);
				end
				5: 
				begin 
					row3 = Rs(2) | Rs(4);
					col3 = Cs(9);
				end
				6: 
				begin 
					row3 = Rs(3) | Rs(5);
					col3 = Cs(15) & Cs(13) & Cs(14);
				end
				7:
				begin
					row3 = Rs(3) | Rs(4) | Rs(5);
					col3 = Cs(13) & Cs(15);
				end
				8:
				begin
					row3 = Rs(2);
					col3 = Cs(14) & Cs(13);
				end
				9:
				begin
					row3 = Rs(1);
					col3 = Cs(13) & Cs(15);
				end
				endcase
		end
	 	
end 
endmodule 