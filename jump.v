module jump(input clk, input button, output reg [7:0] row, output reg [15:0] col);

wire new_clk1,new_clk2,new_clk3;
reg button_pressed = 0;
//wire [7:0] row1,col1;
reg flag = 0;
reg [2:0] count = 3'b000;
reg [5:0] count_rev = 0;
reg fresh = 0;

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

clock_divider #(4166666) slowclock(clk,new_clk1); //6 Hz
clock_divider #(249999) slowclock1(clk,new_clk3); 
reg new_clk;
 
parameter freq2 = 2499999; 

clock_divider #(freq2) slowclock2(clk,new_clk2); //Clock frequency = 10 Hz
clock_divider #(24999999) slowclock3(clk,switch_clk);
reg [31:0] counter_clk = 0;
always @ (posedge switch_clk)
begin
	counter_clk <= counter_clk +1;
end

always @ (*)
begin
	if (counter_clk == 20)
		new_clk = new_clk2 ;
	else 
		new_clk = new_clk1;
end

always @ (posedge new_clk1)
begin


if (count ==0 && flag == 0 && button_pressed == 1)
count <= count + 1;
else if (count !=3 && flag == 0 && count>0)
count <= count + 1;
else if (count == 3 && flag ==0) 
begin
count <=4;
flag <= 1;
end
else if (flag ==1 && count !=0 ) count = count-1;
else if (flag ==1 && count ==0) flag = 0;
end
//end
always @ (*)
begin
		col [15:0] = Cs(2);
		case(count)
		0: row [7:0] = Rs(0); 
		1: row [7:0] = Rs(1);
		2: row [7:0] = Rs(2);
		3: row [7:0] = Rs(3);
		endcase
end

always @ (posedge new_clk3)
begin
//revolutionary 
if (button == 0)  fresh = 1;
	case (fresh)
	
	0 :
	count_rev <= 0;
	
	1 :
	begin
		button_pressed = 1;
		count_rev <= count_rev + 1;
		if (count_rev > 13)
		begin
			button_pressed = 0;
			fresh = 0;
		end
	
	end
	endcase
end

endmodule
