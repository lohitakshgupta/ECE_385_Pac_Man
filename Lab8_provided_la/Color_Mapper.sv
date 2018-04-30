//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_ball, is_wall, is_red_evil, is_green_evil, is_blue_evil, is_food, is_score_all_letters,// Whether current pixel belongs to ball 
                       input 			[7:0] text_data,
							  input 			[10:0] score_x,							  //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input logic	[7:0] pac_man_cut_data_out_R, pac_man_cut_data_out_G, pac_man_cut_data_out_B,
							  input logic	[7:0] red_evil_data_out_R, red_evil_data_out_G, red_evil_data_out_B,
							  input logic	[7:0] green_evil_data_out_R, green_evil_data_out_G, green_evil_data_out_B,
							  input logic	[7:0] blue_evil_data_out_R, blue_evil_data_out_G, blue_evil_data_out_B,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
							 
							);
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_ball == 1'b1) 
        begin
            // Yellow ball
            Red = pac_man_cut_data_out_R;
            Green = pac_man_cut_data_out_G;
            Blue = pac_man_cut_data_out_B;
        end
		  else if (is_red_evil == 1'b1) 
        begin
            // Red Evil
            Red = red_evil_data_out_R;
            Green = red_evil_data_out_G;
            Blue = red_evil_data_out_B;
        end
		  else if (is_green_evil == 1'b1) 
        begin
            // Green Evil
            Red = green_evil_data_out_R;
            Green = green_evil_data_out_G;
            Blue = green_evil_data_out_B;
        end
		  else if (is_blue_evil == 1'b1) 
        begin
            // Blue Evil
            Red = blue_evil_data_out_R;
            Green = blue_evil_data_out_G;
            Blue = blue_evil_data_out_B;
        end
        else if((is_wall == 1'b1) && (DrawY < 352))
		  begin
				 // Blue Wall
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
		  end
		  
		  else if ((is_food == 1'b0 && (DrawY < 352)))// && is_ball != 1'b1) 
        begin
            // Yellow Food
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  
		  else if ((is_score_all_letters == 1'b1 && text_data[DrawX - score_x] == 1'b1))// && is_ball != 1'b1) 
        begin
            // White Text
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  
		  else
        begin
            // Background with nice color gradient
            Red = 8'h00;//8'h3f; 
            Green = 8'h00;//8'h00;
            Blue = 8'h00;//8'h7f; //- {1'b0, DrawX[9:3]};
        end
    end 
    
endmodule
