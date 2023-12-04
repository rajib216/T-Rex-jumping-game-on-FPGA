module top(clk,button,row,col,HEX0,HEX1,HEX2,HEX3);

input clk,button;
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;

output reg [7:0] row;
output reg [15:0] col;

clock_divider #(24999) selector(clk,new_clk); // 1 KHz
reg counter = 0;
wire new_clk;
reg flag_over=0;
reg flag_restart = 0;
reg flag = 0;

wire[3:0] digit1,digit2,digit3,digit4;

always @ (posedge new_clk)  // 1 KHz
begin
	counter <= counter + 1;
	//counter1 <= counter1 + 1;
end

wire [7:0] row1,row2,row3;
wire [15:0] col1, col2,col3;

//for use of the always block that displays "over"


///////////////////////////////////////////////////////////
wire [7:0] ob1,ob2,ob3;

obstacle path(clk,flag_restart,row1,col1,ob1,ob2,ob3);
jump t_rex(clk,button,row2,col2);
game_over loser(clk,flag_over,flag, row3,col3);

always @ (*) // showing legit dino and obstacles
begin
	if(flag == 0 || flag_over == 0)
		begin
			case(counter)
			0 :
			begin
			row = row1;
			col = col1;
			end
			1:
			begin
			row = row2;
			col = col2;
			end
			endcase
		end
	else if(flag == 1)
		begin
			row = row3;
			col = col3;
		end
 end

always @ (*) // checking collisions
begin
	if((row2 [0] == 1) && (ob1 == 2))
	begin
		flag_over = 1;
		flag = 1;
	end
	if((row2 [1] == 1) && (ob1 == 1))
	begin
		flag_over = 1;
		flag = 1;
	end
	else if((row2 [0] == 1) && (ob2 == 2))
	begin
		flag_over = 1;
		flag = 1;
	end
	else if((row2 [1] == 1) && (ob2 == 2))
	begin
		flag_over = 1;
		flag = 1;
	end
	else if((row2[3] == 1) && (ob3 == 2))
	begin
		flag_over = 1;
		flag = 1;
	end
	else if((row2[3] == 1) && (ob3 == 1)) 
	begin
		flag_over = 1;
		flag = 1;
	end
	
	if (flag == 1)
	begin
		if (flag_restart ==1)
		begin
			flag_over = 0;
			flag = 0;
		end
	end
	else
	begin
		flag_over = 0;
		flag = 0;
	end
end

always @ (posedge button)
begin
		if(flag_over == 1)
			flag_restart = 1;
		else flag_restart = 0;
end

counter digits(clk,flag_over,flag_restart,digit4,digit3,digit2,digit1);

digit_display demonstrate1(digit1,HEX0);
digit_display demonstrate2(digit2,HEX1);
digit_display demonstrate3(digit3,HEX2);
digit_display demonstrate4(digit4,HEX3);


endmodule 
