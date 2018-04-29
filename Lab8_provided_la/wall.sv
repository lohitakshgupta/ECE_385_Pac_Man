module  wall ( input Clk,
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [9:0]   Ball_X_Pos_out, Ball_Y_Pos_out,
               output logic  is_wall, is_wall_up, is_wall_down, is_wall_right, is_wall_left, inside_block // Whether current pixel belongs to ball or background
              );
				  
		
		//declaring maze
		reg [19:0] wall[0:14];
		
		//logic top_right_up, top_left_up, bottom_right_right, bottom_left_left;
		//logic top_right_right, top_left_left, bottom_right_down, bottom_left_down;

		//logic top_right, top_left, bottom_right, bottom_left;
		
		int X_coordinate, Y_coordinate, X_end, Y_end;
		
		//instantiating maze
		always_ff @(posedge Clk) begin
		
			for(int i = 0; i < 20; i++) begin
				wall[0][i] <= 1'b1;
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 0 || i == 5 || i == 14 || i == 19) begin
					wall[1][i] <= 1'b1;
				end
				else begin
					wall[1][i] <= 1'b0;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 1 || i == 4 || i == 6 || i == 13 || i == 15  || i == 18) begin
					wall[2][i] <= 1'b0;
				end
				else begin
					wall[2][i] <= 1'b1;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 0 || i == 2 || i == 17 || i == 19) begin
					wall[3][i] <= 1'b1;
				end
				else begin
					wall[3][i] <= 1'b0;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 1 || i == 3 || i == 6 || i == 9 || i == 10 || i == 13 || i == 16 || i == 18) begin
					wall[4][i] <= 1'b0;
				end
				else begin
					wall[4][i] <= 1'b1;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 0 || i == 7 || i == 12 || i == 19) begin
					wall[5][i] <= 1'b1;
				end
				else begin
					wall[5][i] <= 1'b0;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 1 || i == 3 || i == 6 || i == 13 || i == 16 || i == 18) begin
					wall[6][i] <= 1'b0;
				end
				else begin
					wall[6][i] <= 1'b1;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 0 || i == 2 || i == 17 || i == 19) begin
					wall[7][i] <= 1'b1;
				end
				else begin
					wall[7][i] <= 1'b0;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 1 || i == 4 || i == 6 || i == 13 || i == 15 || i == 18) begin
					wall[8][i] <= 1'b0;
				end
				else begin
					wall[8][i] <= 1'b1;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				if(i == 0 || i == 5 || i == 14 || i == 19) begin
					wall[9][i] <= 1'b1;
				end
				else begin
					wall[9][i] <= 1'b0;
				end
			end
			
			for(int i = 0; i < 20; i++) begin
				wall[10][i] <= 1'b1;
			end
			
			for(int i = 0; i < 20; i++) begin
				wall[11][i] <= 1'b1;
			end
			
			for(int i = 0; i < 20; i++) begin
				wall[12][i] <= 1'b1;
			end
			
			for(int i = 0; i < 20; i++) begin
				wall[13][i] <= 1'b1;
			end
			
			for(int i = 0; i < 20; i++) begin
				wall[14][i] <= 1'b1;
			end
		end
			
	assign is_wall = wall[DrawY>>5][DrawX>>5]; //using floor and block size of 32
//	assign is_wall_up = wall[(Ball_Y_Pos_out - 1)>>5][(Ball_X_Pos_out + 15)>>5]; //wall[(DrawY>>5)-1][DrawX>>5];
//	assign is_wall_down = wall[(Ball_Y_Pos_out + 32)>>5][(Ball_X_Pos_out + 15)>>5]; //wall[(DrawY>>5)+1][DrawX>>5];
//	assign is_wall_right = wall[(Ball_Y_Pos_out + 15)>>5][(Ball_X_Pos_out + 32)>>5]; //wall[DrawY>>5][(DrawX>>5)+1];
//	assign is_wall_left = wall[(Ball_Y_Pos_out + 15)>>5][(Ball_X_Pos_out - 1)>>5]; //wall[DrawY>>5][(DrawX>>5)-1];


	always_comb                         //GOLDEN!!!!
	begin
	
	is_wall_up = 1'b1;
	is_wall_down = 1'b1;
	is_wall_right = 1'b1;
	is_wall_left = 1'b1;
	inside_block = 1'b0;
	
	X_coordinate = Ball_X_Pos_out/32;
	Y_coordinate = Ball_Y_Pos_out/32;
	X_end = (Ball_X_Pos_out+25)/32;
	Y_end = (Ball_Y_Pos_out+25)/32;
	
	if ( ((X_coordinate-X_end)==0) && ((Y_coordinate-Y_end)==0) )//it is inside
		begin
		inside_block = 1'b1;
		is_wall_up = wall[Y_coordinate-1][X_coordinate];
		is_wall_down = wall[Y_coordinate+1][X_coordinate];
		is_wall_right = wall[Y_coordinate][X_coordinate+1];
		is_wall_left = wall[Y_coordinate][X_coordinate-1];
		end
//	else
//		begin
//		inside_block = 1'b0;
//		end
	end

/*
	always_ff @(posedge Clk) begin                        
	
//	is_wall_up = 1'b1;
//	is_wall_down = 1'b1;
//	is_wall_right = 1'b1;
//	is_wall_left = 1'b1;
	
	X_coordinate <= Ball_X_Pos_out/32;
	Y_coordinate <= Ball_Y_Pos_out/32;
	X_end <= (Ball_X_Pos_out+25)/32;
	Y_end <= (Ball_Y_Pos_out+25)/32;
	
	if ( ((X_coordinate-X_end)==0) && ((Y_coordinate-Y_end)==0) )
		begin
		is_wall_up = wall[Y_coordinate-1][X_coordinate];
		is_wall_down = wall[Y_coordinate+1][X_coordinate];
		is_wall_right = wall[Y_coordinate][X_coordinate+1];
		is_wall_left = wall[Y_coordinate][X_coordinate-1];
		end
	else
		begin
		is_wall_up = is_wall_up_previous;
		is_wall_down = wall[Y_coordinate+1][X_coordinate];
		is_wall_right = wall[Y_coordinate][X_coordinate+1];
		is_wall_left = wall[Y_coordinate][X_coordinate-1];
		end
	end
	
	assign 
*/

/*	assign top_left_up = wall[(Ball_Y_Pos_out>>5)-1][Ball_X_Pos_out>>5];
	assign top_left_left = wall[Ball_Y_Pos_out>>5][(Ball_X_Pos_out-1)>>5];
	
	assign top_right_up = wall[(Ball_Y_Pos_out>>5)-1][(Ball_X_Pos_out+25)>>5];
	assign top_right_right = wall[Ball_Y_Pos_out>>5][(Ball_X_Pos_out+26)>>5];				//doen't work!!!!
	
	assign bottom_left_down = wall[(Ball_Y_Pos_out+26)>>5][Ball_X_Pos_out>>5];
	assign bottom_left_left = wall[(Ball_Y_Pos_out+25)>>5][(Ball_X_Pos_out-1)>>5];
	
	assign bottom_right_down = wall[(Ball_Y_Pos_out+26)>>5][(Ball_X_Pos_out+25)>>5];
	assign bottom_right_right = wall[(Ball_Y_Pos_out+25)>>5][(Ball_X_Pos_out+26)>>5];
	
	assign is_wall_up = top_left_up | top_right_up;
	assign is_wall_down = bottom_left_down | bottom_right_down;
	assign is_wall_left = top_left_left | bottom_left_left;
	assign is_wall_right = top_right_right | bottom_right_right;
*/


	
/*	assign top_left = wall[(Ball_Y_Pos_out)>>5][(Ball_X_Pos_out)>>5];
	assign top_right = wall[(Ball_Y_Pos_out)>>5][(Ball_X_Pos_out+25)>>5];
	assign bottom_left = wall[(Ball_Y_Pos_out+25)>>5][(Ball_X_Pos_out)>>5];
	assign bottom_right = wall[(Ball_Y_Pos_out+25)>>5][(Ball_X_Pos_out+25)>>5];     //old golden

	assign is_wall_up = top_left | top_right;
	assign is_wall_down = bottom_left | bottom_right;
	assign is_wall_left = top_left | bottom_left;
	assign is_wall_right = top_right | bottom_right;
*/
	
endmodule
