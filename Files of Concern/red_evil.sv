module  red_evil_move ( input     Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  is_wall,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]   key,               // The currently pressed keys
					output logic [9:0] red_evil_read_address,
					//output logic [9:0] pac_man_full_read_address,
               output logic  is_red_evil             // Whether current pixel belongs to ball or background
              );
    
    parameter [9:0] Ball_X_Center= 320 - 16 - 16;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center= 240 - 16 - 64;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639 - 32;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479 - 32;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Ball_Size= 32;        // Ball size
    
     // Invert the values of the steps
     
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    
	 logic [9:0] Ball_X_Step_inv, Ball_Y_Step_inv;
    assign Ball_X_Step_inv = (~(Ball_X_Step) + 1'b1);
    assign Ball_Y_Step_inv = (~(Ball_Y_Step) + 1'b1);
    
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
				//flag <= 1'b0;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
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
        if(key == 8'h1A) begin
                Ball_X_Motion_in = 10'd0;
                Ball_Y_Motion_in = 10'd0;//Ball_Y_Step_inv;
          end
          else if(key == 8'h04) begin
                Ball_X_Motion_in = 10'd0;//Ball_X_Step_inv;
                Ball_Y_Motion_in = 10'd0;
          end
          else if(key == 8'h16) begin
                Ball_X_Motion_in = 10'd0;
                Ball_Y_Motion_in = 10'd0;//Ball_Y_Step;
          end
          else if(key == 8'h07)
			 begin
                Ball_X_Motion_in = 10'd0;//Ball_X_Step;
                Ball_Y_Motion_in = 10'd0;
			 end
			  
			 
          
        // Be careful when using comparators with "logic" datatype because compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
        // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
        

    
	 if( (0 <= DistX) & (DistX < (Size)) & (0 <= DistY) & (DistY < (Size)))begin
				red_evil_read_address = DistY*(Size) + DistX;
            is_red_evil = 1'b1;
			end
        else begin
				red_evil_read_address = 10'b0000000000;
            is_red_evil = 1'b0;
        end      
   end
    
endmodule

