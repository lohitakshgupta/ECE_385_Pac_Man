module  food
(		input  Clk, Reset,                // 50 MHz clock
      input [9:0]   DrawX, DrawY, Ball_X_Pos_out, Ball_Y_Pos_out,      // Current pixel coordinates
		//input [4:0] data_In,
		input is_food_eaten,
		output logic is_food, is_food_big_no_color 
);
//O means food
//1 means NO food

// food has width of 1 bit and a total of 220 addresses
logic food [0:219];
logic food_temp [0:219];

initial
begin
	 $readmemh("sprite_bytes/food.txt", food);
	 $readmemh("sprite_bytes/food.txt", food_temp);
end


int food_read_address, food_write_address, DrawX_limited, DrawY_limited;

assign food_read_address = (DrawY>>5)*20 + (DrawX>>5);
assign food_write_address = (Ball_Y_Pos_out>>5)*20 + (Ball_X_Pos_out>>5);

assign DrawX_limited =  DrawX - ((((DrawX>>5))*32) + 16);
assign DrawY_limited =  DrawY - ((((DrawY>>5))*32) + 16);

/*always_ff @ (posedge Clk) begin
	is_food_big_no_color <= food[food_read_address];
	if((DrawX_limited >= 0) && (DrawX_limited < 5) && (DrawY_limited >= 0) && (DrawY_limited < 5))
	begin
		is_food <= food[food_read_address];
	end
	else begin
		is_food <= 1'b1;
	end
end
*/
//always_ff @ (posedge Reset) begin
//	food <= food_temp;
//	//{>>{food}} <= {>>{food_temp}};
//end


always_ff @ (posedge Clk) begin
	if (Reset) begin
		for(int i = 0; i < 220; i++) begin
			food[i] <= food_temp[i];
		end
	end	
	
	else
	begin
	if (is_food_eaten == 1'b1)begin
		food[food_write_address] <= 1'b1;
	end
	is_food_big_no_color <= food[food_read_address];
	if((DrawX_limited >= 0) && (DrawX_limited < 5) && (DrawY_limited >= 0) && (DrawY_limited < 5))
	begin
		is_food <= food[food_read_address];
	end
	else begin
		is_food <= 1'b1;
	end
	end
	//food_data_out<= food[food_read_address];
end

endmodule
