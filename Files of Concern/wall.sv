module  wall ( input Clk,
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_wall, is_wall_up, is_wall_down, is_wall_right, is_wall_left // Whether current pixel belongs to ball or background
              );
				  
		
		//declaring maze
		reg [19:0] wall[0:14];
		
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
	assign is_wall_up = wall[(DrawY>>5)-1][DrawX>>5];
	assign is_wall_down = wall[(DrawY>>5)+1][DrawX>>5];
	assign is_wall_right = wall[DrawY>>5][(DrawX>>5)+1];
	assign is_wall_left = wall[DrawY>>5][(DrawX>>5)-1];

	
endmodule
