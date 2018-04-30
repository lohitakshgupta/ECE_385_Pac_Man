module  blue_evil_move ( input     Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  is_wall_up_blue, is_wall_down_blue, is_wall_right_blue, is_wall_left_blue,
									  inside_block_blue,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]   key,               // The currently pressed keys
					output logic [9:0] blue_evil_read_address,
					output logic [9:0] Blue_X_Pos_out, Blue_Y_Pos_out,
					//output logic [9:0] pac_man_full_read_address,
               output logic  is_blue_evil             // Whether current pixel belongs to ball or background
//					output logic led1, led2, led3, led4, 
//					output logic [2:0] direction
              );
    
    parameter [9:0] Ball_X_Center= 320 - 16 + 16;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center= 240 - 16 - 64;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639 - 32;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479 - 32;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Ball_Size= 26;        // Ball size
    
     // Invert the values of the steps
     
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 
	 logic [2:0] previous_direction, current_direction; 
	 
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    
	 logic [9:0] Ball_X_Step_inv, Ball_Y_Step_inv;
    assign Ball_X_Step_inv = (~(Ball_X_Step) + 1'b1);
    assign Ball_Y_Step_inv = (~(Ball_Y_Step) + 1'b1);
	 
	 assign Blue_X_Pos_out = Ball_X_Pos;
	 assign Blue_Y_Pos_out = Ball_Y_Pos;
    
	 //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update ball position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
				current_direction <=3'b111;
				//flag <= 1'b0;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
				current_direction <= previous_direction;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
        // Update the ball's position with its motion; by default, continue moving in same direction
        Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
        Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
		  Ball_X_Motion_in = Ball_X_Motion;
		  Ball_Y_Motion_in = Ball_Y_Motion;
		  previous_direction = current_direction;
		  
//			 led1 = 1'b0;
//			 led2 = 1'b0;
//			 led3 = 1'b0;
//			 led4 = 1'b0;
		  
		  if((inside_block_blue == 1'b1) && (is_wall_up_blue != 1'b1) && (previous_direction != 3'b001)) begin    
                Ball_X_Motion_in = 10'd0;
                Ball_Y_Motion_in = Ball_Y_Step_inv;
					 previous_direction = 3'b011;
//					 led4 = 1'b1;
		   end
		  else if((inside_block_blue == 1'b1) && (is_wall_left_blue != 1'b1) && (previous_direction != 3'b010)) begin			//GOLDEN!!!!
                Ball_X_Motion_in = Ball_X_Step_inv;
                Ball_Y_Motion_in = 10'd0;
					 previous_direction = 3'b000;
//					 led1 = 1'b1;
         end
        else if((inside_block_blue == 1'b1) && (is_wall_down_blue != 1'b1) && (previous_direction != 3'b011)) begin
                Ball_X_Motion_in = 10'd0; 
                Ball_Y_Motion_in = Ball_Y_Step;
					 previous_direction = 3'b001;
//					 led2 = 1'b1;
          end
         else if((inside_block_blue == 1'b1) && (is_wall_right_blue != 1'b1) && (previous_direction = 3'b000))
			 begin
                Ball_X_Motion_in = Ball_X_Step;
                Ball_Y_Motion_in = 10'd0;
					 previous_direction = 3'b010;
//					 led3 = 1'b1;
			 end
		  
        // By default, keep motion unchanged
			/*if(flag == 1'b1)
				begin
					Ball_X_Motion_in = Ball_X_Motion;
					Ball_Y_Motion_in = Ball_Y_Motion;
				end
			else if(flag == 1'b0)
				begin
					Ball_X_Motion_in = 10'd0;
					Ball_Y_Motion_in = 10'd0;
				end
			else
				begin
				   Ball_X_Motion_in = 10'bZZZZZZZZZZ;
					Ball_Y_Motion_in = 10'bZZZZZZZZZZ;
				end
			
       */
          
          /*
           * W - 0x1A
           * A - 0x04
           * S - 0x16
           * D - 0x07
           */
//        if(key == 8'h1A) begin
//                Ball_X_Motion_in = 10'd0;
//                Ball_Y_Motion_in = 10'd0;//Ball_Y_Step_inv;
//          end
//          else if(key == 8'h04) begin
//                Ball_X_Motion_in = 10'd0;//Ball_X_Step_inv;
//                Ball_Y_Motion_in = 10'd0;
//          end
//          else if(key == 8'h16) begin
//                Ball_X_Motion_in = 10'd0;
//                Ball_Y_Motion_in = 10'd0;//Ball_Y_Step;
//          end
//          else if(key == 8'h07)
//			 begin
//                Ball_X_Motion_in = 10'd0;//Ball_X_Step;
//                Ball_Y_Motion_in = 10'd0;
//			 end
			  
			 
          
        // Be careful when using comparators with "logic" datatype because compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
        // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
        

    
	 if( (0 <= DistX) & (DistX < (Size)) & (0 <= DistY) & (DistY < (Size)))begin
				blue_evil_read_address = DistY*(Size) + DistX;
            is_blue_evil = 1'b1;
			end
        else begin
				blue_evil_read_address = 10'b0000000000;
            is_blue_evil = 1'b0;
        end      
   end
    
endmodule

