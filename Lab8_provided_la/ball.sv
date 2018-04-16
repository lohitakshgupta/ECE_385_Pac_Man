//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------

/*
module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [7:0]	  key,
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_ball             // Whether current pixel belongs to ball or background
              );
    
    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd4;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        if(Reset)
			begin
				Ball_X_Pos_in = Ball_X_Pos;
				Ball_Y_Pos_in = Ball_Y_Pos;
				Ball_X_Motion_in = Ball_X_Motion;
				Ball_Y_Motion_in = Ball_Y_Motion;
			end
		  else
			begin
				Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
				Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
				Ball_X_Motion_in = Ball_X_Motion;
				Ball_Y_Motion_in = Ball_Y_Motion;
			end
        
        // Update position and motion only at rising edge of frame clock
        //if (frame_clk_rising_edge)
        //begin
				if(key == 8'h04)
					begin
						Ball_X_Motion_in = (~Ball_X_Step) + 1'b1;
						Ball_Y_Motion_in = 10'd0;
					end
				else if(key == 8'h07)
					begin
						Ball_X_Motion_in = (Ball_X_Step);
						Ball_Y_Motion_in = 10'd0;
					end
				else if(key == 8'h1A)
					begin
						Ball_X_Motion_in = 10'd0;
						Ball_Y_Motion_in = (~Ball_Y_Step) + 1'b1;
					end
				else if(key == 8'h16)
					begin
						Ball_X_Motion_in = 10'd0;
						Ball_Y_Motion_in = (Ball_Y_Step);
					end
				
				
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
            if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
            else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
                Ball_Y_Motion_in = Ball_Y_Step;
            // TODO: Add other boundary detections and handle keypress here.
				else if( Ball_X_Pos + Ball_Size >= Ball_X_Max )  // Ball is at the bottom edge, BOUNCE!
                Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.  
            else if ( Ball_X_Pos <= Ball_X_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
                Ball_X_Motion_in = Ball_X_Step;
        
            // Update the ball's position with its motion
            //Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            //Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        //end
        
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
    //end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    /*int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
   // end
    
//endmodule


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


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [7:0]   key,               // The currently pressed keys
               output logic  is_ball             // Whether current pixel belongs to ball or background
              );
    
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Ball_Size=4;        // Ball size
    
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
				end*/
			
       
          
          /*
           * W - 0x1A
           * A - 0x04
           * S - 0x16
           * D - 0x07
           */
        if(key == 8'h1A) begin
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
       if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
        
   end
    
endmodule
