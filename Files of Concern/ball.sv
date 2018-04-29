//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  pac_man ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  is_wall, is_wall_up, is_wall_down, is_wall_right, is_wall_left,
									  is_food, is_food_big_no_color, inside_block,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]   key,               // The currently pressed keys
					output logic [9:0] pac_man_cut_read_address,
					//output logic [9:0] pac_man_full_read_address,
               output logic  is_ball, is_food_eaten,            // Whether current pixel belongs to ball or background
					output logic [9:0] Ball_X_Pos_out, Ball_Y_Pos_out,
					output logic led1, led2, led3, led4, led5, led6,
					output logic [2:0] direction
					);
    
    parameter [9:0] Ball_X_Center = 320;//320 - 16;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 224;//240 - 16;  // Center position on the Y axis
//    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
//    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
//    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
//    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 26;        // Ball size
    
     // Invert the values of the steps
     
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 //reg reset_flag_once;
	 
	 logic [2:0] previous_direction, current_direction; 
	 
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
	 
	 assign direction = current_direction;
	 
	 assign Ball_X_Pos_out = Ball_X_Pos;
	 assign Ball_Y_Pos_out = Ball_Y_Pos;
	 
  
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
			  
          led1 = 1'b0;
			 led2 = 1'b0;
			 led3 = 1'b0;
			 led4 = 1'b0;
			 led5 = 1'b0;
			 led6 = 1'b0;
			 		 
			 //previous_direction = 3'b111;
			 
          if((key == 8'h04) && (is_wall_left != 1'b1)) begin			//GOLDEN!!!!
                Ball_X_Motion_in = Ball_X_Step_inv;
                Ball_Y_Motion_in = 10'd0;
					 previous_direction = 3'b000;
					 led1 = 1'b1;
          end
          else if((key == 8'h16) && (is_wall_down != 1'b1)) begin
                Ball_X_Motion_in = 10'd0; 
                Ball_Y_Motion_in = Ball_Y_Step;
					 previous_direction = 3'b001;
					 led2 = 1'b1;
          end
          else if((key == 8'h07) && (is_wall_right != 1'b1))
			 begin
                Ball_X_Motion_in = Ball_X_Step;
                Ball_Y_Motion_in = 10'd0;
					 previous_direction = 3'b010;
					 led3 = 1'b1;
			 end
			 else if((key == 8'h1A) && (is_wall_up != 1'b1)) begin    
                Ball_X_Motion_in = 10'd0;
                Ball_Y_Motion_in = Ball_Y_Step_inv;
					 previous_direction = 3'b011;
					 led4 = 1'b1;
          end
//			 else begin
//					previous_direction = 3'b111;
//			 end
			 
			 if((previous_direction != 3'b111) && (inside_block == 1'b1))
			 begin
			   if(((previous_direction == 3'b000) && (is_wall_left == 1'b1)) || ((previous_direction == 3'b010) && (is_wall_right == 1'b1)))
				begin
					Ball_X_Motion_in = 10'd0;
					led5 = 1'b1;
				end
			  else if(((previous_direction == 3'b011) && (is_wall_up == 1'b1)) || ((previous_direction == 3'b001) && (is_wall_down == 1'b1)))
				begin
					Ball_Y_Motion_in = 10'd0;
					led6 = 1'b1;
				end
			 end
//        if((key == 8'h1A) && (is_wall_up != 1'b1)) begin         //old golden
//                Ball_X_Motion_in = 10'd0;
//                Ball_Y_Motion_in = Ball_Y_Step_inv;
//          end
//          else if((key == 8'h04) && (is_wall_left != 1'b1)) begin
//                Ball_X_Motion_in = Ball_X_Step_inv;
//                Ball_Y_Motion_in = 10'd0;
//          end
//          else if((key == 8'h16) && (is_wall_down != 1'b1)) begin
//                Ball_X_Motion_in = 10'd0; 
//                Ball_Y_Motion_in = Ball_Y_Step;
//          end
//          else if((key == 8'h07) && (is_wall_right != 1'b1))
//			 begin
//                Ball_X_Motion_in = Ball_X_Step;
//                Ball_Y_Motion_in = 10'd0;
//			 end

			
//			if(key == 8'h1A) 
//		    begin
//				if (is_wall_up == 1'b0) //no wall above, pacman can move up
//					 begin
//                Ball_X_Motion_in = 10'd0;
//                Ball_Y_Motion_in = Ball_Y_Step_inv;
//					 //flag = 1'b1;
//					 end
//				else 
//					 begin
//					 //Ball_X_Motion_in = 10'd0; //wall above, pacman stay at current location
//                Ball_Y_Motion_in = 10'd0;
//					 end
//          end
//			 
//          else if(key == 8'h04) 
//			 begin
//				if (is_wall_left == 1'b0) //no wall left, pacman can move left
//					 begin
//                Ball_X_Motion_in = Ball_X_Step_inv;
//                Ball_Y_Motion_in = 10'd0;
//					 //flag = 1'b1;
//					 end
//				else 
//					 begin
//					 Ball_X_Motion_in = 10'd0; //wall left, pacman stay at current location
//                //Ball_Y_Motion_in = 10'd0;
//					 end
//          end
//			 
//          else if(key == 8'h16) 
//			 begin
//				if (is_wall_down == 1'b0) //no wall below, pacman can move down
//					 begin
//                Ball_X_Motion_in = 10'd0;
//                Ball_Y_Motion_in = Ball_Y_Step;
//					 //flag = 1'b1;
//					 end
//				else 
//					 begin
//					 //Ball_X_Motion_in = 10'd0; //wall below, pacman stay at current location
//                Ball_Y_Motion_in = 10'd0;
//					 end
//          end
//			 
//          else if(key == 8'h07)
//			 begin
//				if (is_wall_right == 1'b0) //no wall right, pacman can move right
//					 begin
//                Ball_X_Motion_in = Ball_X_Step;
//                Ball_Y_Motion_in = 10'd0;
//					 //flag = 1'b1;
//					 end
//				else 
//					 begin
//					 Ball_X_Motion_in = 10'd0; //wall right, pacman stay at current location
//                //Ball_Y_Motion_in = 10'd0;
//					 end
//			  end
			            
        // Be careful when using comparators with "logic" datatype because compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
        // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
    
	 if( (0 <= DistX) && (DistX < (Size)) && (0 <= DistY) && (DistY < (Size)))begin
				pac_man_cut_read_address = DistY*(Size) + DistX;
            is_ball = 1'b1;
				is_food_eaten = 1'b1;
			end
        else begin
				pac_man_cut_read_address = 10'b0000000000;
            is_ball = 1'b0;
				is_food_eaten = 1'b0;
        end      
   end
    
endmodule

/*
module  pac_man ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  is_wall,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]   key,               // The currently pressed keys
					output logic [9:0] pac_man_cut_read_address,
               output logic  is_ball             // Whether current pixel belongs to ball or background
              );
    /*
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Ball_Size= 16;        // Ball size
    
     // Invert the values of the steps
     logic [9:0] Ball_X_Step_inv, Ball_Y_Step_inv;
     assign Ball_X_Step_inv = (~(Ball_X_Step) + 1'b1);
     assign Ball_Y_Step_inv = (~(Ball_Y_Step) + 1'b1);
     
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 //reg flag;
    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
         
     /* Personal Variable Explanation
      * DrawX/Y                 - the coordinates of the current pixel
      * DistX/Y                 - the range where the ball lies in pixel values
      * Ball_X/Y_Pos            - the current position of the ball
      * Ball_X/Y_Pos_in         - the position of the ball to set Ball_X/Y_Pos to on the next clock cycle
      * Ball_X/Y_Motion     - how many pixels per clock cycle the ball moves in this direction
      * Ball_X/Y_Motion_in  - the momentum of the ball to set Ball_X/Y_Motion to on the next clock cycle
      */
    /*  
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update ball position and motion
    /*always_ff @ (posedge Clk)
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
				end*/
			
       
          
          /*
           * W - 0x1A
           * A - 0x04
           * S - 0x16
           * D - 0x07
           */
       /* if(key == 8'h1A) begin
                Ball_X_Motion_in = 10'd0;
                Ball_Y_Motion_in = Ball_Y_Step_inv;
					 //flag = 1'b1;
          end
          else if(key == 8'h04) begin
                Ball_X_Motion_in = Ball_X_Step_inv;
                Ball_Y_Motion_in = 10'd0;
					 //flag = 1'b1;
          end
          else if(key == 8'h16) begin
                Ball_X_Motion_in = 10'd0;
                Ball_Y_Motion_in = Ball_Y_Step;
					// flag = 1'b1;
          end
          else if(key == 8'h07)
			 begin
                Ball_X_Motion_in = Ball_X_Step;
                Ball_Y_Motion_in = 10'd0;
					 //flag = 1'b1;
          end
         if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
            Ball_Y_Motion_in = Ball_Y_Step_inv;
        else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
            Ball_Y_Motion_in = Ball_Y_Step;
          else if ( Ball_X_Pos + Ball_Size >= Ball_X_Max )   // Ball is at right edge, BOUNCE!
				Ball_X_Motion_in = Ball_X_Step_inv;
        else if ( Ball_X_Pos <= Ball_X_Min + Ball_Size )  // Ball is at the left edge, BOUNCE!
            Ball_X_Motion_in = Ball_X_Step;
           
          
        // Be careful when using comparators with "logic" datatype because compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
        // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
        
          
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #2/2:
          Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
          Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
          What is the difference between writing
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
            "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
          How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
          Give an answer in your Post-Lab.
    **************************************************************************************/
        
        // Compute whether the pixel corresponds to ball or background
       //if ( (( (DistX + (2*Size))*(DistY + (2*Size))) <= (4 * Size * Size)))begin
	/*	 if( (0 <= DistX) & (DistX <= (2*Size)) & (0 <= DistY) & (DistY <= (2*Size)))begin
				pac_man_cut_read_address = DistY*(2*Size) + DistX;
            is_ball = 1'b1;
			end
        else begin
				pac_man_cut_read_address = 10'b0000000000;
            is_ball = 1'b0;
        end
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
        
  /* end
    
endmodule
*/