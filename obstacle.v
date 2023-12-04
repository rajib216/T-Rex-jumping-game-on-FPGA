module obstacle(clk,flag_restart,row,col,ob1,ob2,ob3);
input clk; 
input flag_restart; 
output reg [7:0] row;
output reg [15:0] col;
output reg [7:0] ob1 = 13; // square box
output reg [7:0] ob2 = 22; // vertical line
output reg [7:0] ob3 = 34; // bird at higher position
//reg [4:0] ob4 = 39; // pyramid
//reg [4:0] ob5 = 46; // bird at lower position
//reg [4:0] ob6 = 55; // pass through

wire new_clk2;
wire new_clk1;
parameter length = 51;

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

reg new_clk; 
clock_divider #(6249999) slowclock(clk,new_clk1); // Clock frequency = 4 Hz
clock_divider #(4999999) slowclock1(clk,new_clk2); //Clock frequency = 5 Hz
clock_divider #(24999999) slowclock2(clk,switch_clk);
reg [3:0] counter_clk = 0;
reg counter_bird = 0;
always @ (posedge switch_clk)
begin
	if(flag_restart == 1)
		counter_clk <= 0;
	else
	counter_clk <= counter_clk +1;
end
clock_divider #(249) selector(clk,new_clk_bird); // 100 KHz
wire new_clk_bird;
always @ (posedge new_clk_bird)
begin
	counter_bird <= counter_bird + 1;
end
always @ (*)
begin
	if (counter_clk >= 10)
		new_clk = new_clk2 ;
	else 
		new_clk = new_clk1;
end
always @ (posedge new_clk)
begin
	//if(flag_restart == 0)
	//begin
			if(ob1==0 || ob2==0 || ob3==0)
			begin
				if(ob1==0)
				begin
					ob1 <= length - 1;
					ob2 <= ob2-1;
					ob3 <= ob3-1;
				end
				else if(ob2==0)
				begin
					ob1 <= ob1-1;
					ob2 <= length - 1; // length of the array
					ob3 <= ob3-1;
				end
				else
				begin
					ob1 <= ob1-1;
					ob2 <= ob2-1;
					ob3 <= length - 1;
				end 
			end
			else
			begin
					ob1 <= ob1-1;
					ob2 <= ob2-1;
					ob3 <= ob3-1;
					//ob4 <= ob4-1;
					//ob5 <= ob5-1;
					//ob6 <= ob6-1;
			end
	//end
	if (flag_restart == 1) 
		begin
			ob1 <= 13;
			ob2 <= 22;
			ob3 <= 34;
			//ob4 <= 39;
			//ob5 <= 46;
			//ob6 <= 55;
		end
end

always @ (*)
begin
		if ((ob1 >= 0 && ob1 <= 14) && (ob2 >= 0 && ob2 <= 15)) //1 and 2 in range
		begin
			col [15:0] = Cs(ob1) & Cs(ob1+1) & Cs(ob2);
			row [7:0] = Rs(0) | Rs(1);
		end
			
		else if ((ob1 >= 0 && ob1 <= 14) && ~(ob2 >= 0 && ob2 <= 15)) // only 1 in range
		begin
			col [15:0] = Cs(ob1) & Cs(ob1+1);
			row [7:0] = Rs(0) | Rs(1);
		end
		else if (~(ob1 >= 0 && ob1 <= 14) && (ob2 >= 0 && ob2 <= 15)) // only 2 in range
		begin
			col [15:0] = Cs(ob2);
			row [7:0] = Rs(0) | Rs(1);
		end
			
		else if (ob1 == 15) // left edge of 1 in range
		begin
			col [15:0] = Cs(ob1);
			row [7:0] = Rs(0) | Rs(1);
		end
		
		else if ((ob1 == (length-1)) && (ob2 >= 0 && ob2 <= 15)) // right edge of 1 and 2 in range
		begin
			col [15:0] = Cs(0) & Cs(ob2);
			row [7:0] = Rs(0) | Rs(1);
		end
		
		else if ((ob1 == (length-1)) && ~(ob2 >= 0 && ob2 <= 15)) // right edge of 1 only
		begin
			col [15:0] = Cs(0);	
			row [7:0] = Rs(0) | Rs(1);
		end
		
		
		else if ((ob3 == 15) && (ob2 >= 0 && ob2 <= 15)) // left edge of ob3 in range along with ob2
		begin
			case (counter_bird)
				0:
				begin
					col = Cs(ob3);
					row = Rs(3);
				end
				1:
				begin
				col = Cs(ob2);
				row = Rs(0) | Rs(1);
				end
				endcase
		end
		
		else if ((ob2 >= 0 && ob2 <= 15) && (ob3 >= 0 && ob3 <= 14)) // 2 and 3 in range
		begin
			case (counter_bird)
				0:
				begin
					col = Cs(ob3) & Cs (ob3+1);
					row = Rs(3);
				end
				1:
				begin
				col = Cs(ob2);
				row = Rs(0) | Rs(1);
				end
				endcase
		end
		
		
		else if (~(ob2 >= 0 && ob2 <= 15) && (ob3 >= 0 && ob3 <= 14)) // only 3 in range
		begin
			col[15:0] = Cs(ob3) & Cs(ob3+1);
			row[7:0] = Rs(3);
		end
		
		
		else if (ob3 == (length-1)) // right edge of ob3 in range
		begin
				col[15:0] = Cs(0);
				row[7:0] = Rs(3);
		end
		else
		begin
			col [15:0] = Cs(20);
			row [7:0] = Rs(10);
		end
end
/*
always @ (*)
case (counter_bird)
0:
begin
col = Cs(ob3) & Cs (ob3+1);
row = Rs(3);
end
1:
begin
col = Cs(ob2);
row = Rs(0) | Rs(1);
end
endcase*/
endmodule 
