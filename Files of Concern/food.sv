module  food
(		input  Clk, Reset,                // 50 MHz clock
      input [9:0]   DrawX, DrawY, Ball_X_Pos_out, Ball_Y_Pos_out,      // Current pixel coordinates
		//input [4:0] data_In,
		input is_food_eaten,
		output logic is_food, is_food_big_no_color,
		output logic [7:0] score_out
);
//O means food
//1 means NO food
logic [7:0] previous_score, current_score;
logic flag;
// food has width of 1 bit and a total of 220 addresses
logic food [0:219];
logic food_temp [0:219];
logic [7:0] score [0:1];
logic [7:0] score_temp [0:1];
initial
begin
	 $readmemh("sprite_bytes/food.txt", food);
	 $readmemh("sprite_bytes/food.txt", food_temp);
	 $readmemh("sprite_bytes/score.txt", score);
	 $readmemh("sprite_bytes/score.txt", score_temp);
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
//int score_int;
//assign score = score_int;

//always_ff @ (posedge Clk) begin
//	if (Reset) begin
//		for(int i = 0; i < 220; i++) begin
//			food[i] <= food_temp[i];
//		end
//		current_score <= 8'h00;
//		flag <= 1'b0;
//	end	
//
//	else begin
//	if (is_food_eaten == 1'b1)begin
//		if(food[food_write_address] == 1'b0) begin
//			flag <= 1'b1;
//		end
//		else begin
//			flag <= 1'b0;
//		end
//		food[food_write_address] <= 1'b1;
//	end
//	
//	current_score <= previous_score;
//	
//	is_food_big_no_color <= food[food_read_address];
//	if((DrawX_limited >= 0) && (DrawX_limited < 5) && (DrawY_limited >= 0) && (DrawY_limited < 5))
//	begin
//		is_food <= food[food_read_address];
//	end
//	else begin
//		is_food <= 1'b1;
//	end
//	//score <= score - 8'd133;
//	end
//	//food_data_out<= food[food_read_address];
//end
//
//
//always_comb begin
//	if(flag == 1'b1) begin
//		previous_score = current_score + 8'h01;
//	end
//	else begin
//		previous_score = current_score;
//	end
//end

assign score_out = score[0];


always_ff @ (posedge Clk) begin
	if (Reset) begin
		for(int i = 0; i < 220; i++) begin
			food[i] <= food_temp[i];
		end
		score[0] <= score_temp[0];
	end	

	else begin
	if (is_food_eaten == 1'b1)begin
		if(food[food_write_address] == 1'b0) begin
			score[0] <= score[0] + 8'h01;
		end
		else begin
			score[0] <= score[0];
		end
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
	//score <= score - 8'd133;
	end
	//food_data_out<= food[food_read_address];
end

endmodule
