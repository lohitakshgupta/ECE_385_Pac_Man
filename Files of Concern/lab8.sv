//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,HEX2,HEX3,
				 output logic [8:0]  LEDG,
				 output logic [5:0]  LEDR, 
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 logic is_ball, is_wall, is_wall_up, is_wall_down, is_wall_right, is_wall_left;
	 logic is_wall_up_blue, is_wall_down_blue, is_wall_right_blue, is_wall_left_blue;
	 logic is_wall_up_red, is_wall_down_red, is_wall_right_red, is_wall_left_red;
	 logic is_wall_up_green, is_wall_down_green, is_wall_right_green, is_wall_left_green;
	 logic is_red_evil, is_green_evil, is_blue_evil;
	 logic is_food_eaten, is_food, is_food_big_no_color, is_score_all_letters, is_zoom;
	 logic [9:0] DrawX, DrawY;
	 logic [9:0] Ball_X_Pos_out, Ball_Y_Pos_out;
	 logic [9:0] Blue_X_Pos_out, Blue_Y_Pos_out;
	 logic [9:0] Red_X_Pos_out, Red_Y_Pos_out;
	 logic [9:0] Green_X_Pos_out, Green_Y_Pos_out;
	 logic led1, led2, led3, led4, led5, led6, led7, led8, inside_block, inside_block_blue, inside_block_red, inside_block_green;
	 logic [2:0] direction;
	 logic is_collision_red, is_collision_green, is_collision_blue;
	 
	 assign LEDG[0] = is_collision_red;
	 assign LEDG[1] = is_collision_blue;
	 assign LEDG[2] = is_collision_green;
	 assign LEDG[3] = 1'b0;
	 assign LEDG[4] = 1'b0; //led4;
	 assign LEDG[5] = 1'b0; //led2;
	 assign LEDG[6] = 1'b0; //led3;
	 assign LEDG[7] = 1'b0; //led1;
	 assign LEDG[8] = 1'b0;
	 
	 assign LEDR[0] = 1'b0; //led8;
	 assign LEDR[1] = 1'b0; //led6;
	 assign LEDR[2] = 1'b0; //led7;
	 assign LEDR[3] = 1'b0; //led5;
	 assign LEDR[4] = 1'b0;
	 assign LEDR[5] = 1'b0;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_provided_la nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
	 logic [23:0] pac_man_cut_data_out, red_evil_data_out, green_evil_data_out, blue_evil_data_out;
	 logic [9:0]  pac_man_cut_read_address, red_evil_read_address, green_evil_read_address, blue_evil_read_address, pac_man_full_read_address_special;
	 
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk(Clk), .Reset(Reset_h), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK), .VGA_BLANK_N(VGA_BLANK_N),
                                           .VGA_SYNC_N(VGA_SYNC_N), .DrawX(DrawX), .DrawY(DrawY));
    
    // Which signal should be frame_clk?
    pac_man pac_man(.Clk(Clk), .Reset(Reset_h), .key(keycode), .frame_clk(VGA_VS), .DrawX(DrawX), .DrawY(DrawY), .pac_man_cut_read_address(pac_man_cut_read_address), .is_ball(is_ball), .is_wall(is_wall),
							.is_wall_up(is_wall_up), .is_wall_down(is_wall_down), .is_wall_right(is_wall_right), .is_wall_left(is_wall_left),
							.Ball_X_Pos_out(Ball_X_Pos_out), .Ball_Y_Pos_out(Ball_Y_Pos_out), .is_food_eaten(is_food_eaten),
							.direction(direction), .inside_block(inside_block),.is_collision_blue(is_collision_blue), .is_collision_red(is_collision_red), .is_collision_green(is_collision_green),
							.is_food(is_food), .is_food_big_no_color(is_food_big_no_color), .pac_man_full_read_address_special(pac_man_full_read_address_special));
    
	 red_evil_move red_evil_move(.Clk(Clk), .Reset(Reset_h), .key(keycode), .frame_clk(VGA_VS), .DrawX(DrawX), .DrawY(DrawY), .red_evil_read_address(red_evil_read_address), .is_red_evil(is_red_evil), 
										  .is_wall_up_red(is_wall_up_red), .is_wall_down_red(is_wall_down_red), .is_wall_right_red(is_wall_right_red), .is_wall_left_red(is_wall_left_red),
										  .inside_block_red(inside_block_red), .Red_X_Pos_out(Red_X_Pos_out), .Red_Y_Pos_out(Red_Y_Pos_out), .Ball_X_Pos_out(Ball_X_Pos_out), .Ball_Y_Pos_out(Ball_Y_Pos_out),
										  .is_collision_blue(is_collision_blue), .is_collision_red(is_collision_red), .is_collision_green(is_collision_green));

	 green_evil_move green_evil_move(.Clk(Clk), .Reset(Reset_h), .key(keycode), .frame_clk(VGA_VS), .DrawX(DrawX), .DrawY(DrawY), .green_evil_read_address(green_evil_read_address), .is_green_evil(is_green_evil),
												.is_wall_up_green(is_wall_up_green), .is_wall_down_green(is_wall_down_green), .is_wall_right_green(is_wall_right_green), .is_wall_left_green(is_wall_left_green),
												.inside_block_green(inside_block_green), .Green_X_Pos_out(Green_X_Pos_out), .Green_Y_Pos_out(Green_Y_Pos_out),
												.is_collision_blue(is_collision_blue), .is_collision_red(is_collision_red), .is_collision_green(is_collision_green), .Ball_X_Pos_out(Ball_X_Pos_out), .Ball_Y_Pos_out(Ball_Y_Pos_out));
	 
	 blue_evil_move blue_evil_move(.Clk(Clk), .Reset(Reset_h), .key(keycode), .frame_clk(VGA_VS), .DrawX(DrawX), .DrawY(DrawY), .blue_evil_read_address(blue_evil_read_address), .is_blue_evil(is_blue_evil),
											.is_wall_up_blue(is_wall_up_blue), .is_wall_down_blue(is_wall_down_blue), .is_wall_right_blue(is_wall_right_blue), .is_wall_left_blue(is_wall_left_blue),
											.inside_block_blue(inside_block_blue), .Blue_X_Pos_out(Blue_X_Pos_out), .Blue_Y_Pos_out(Blue_Y_Pos_out),
											.Ball_X_Pos_out(Ball_X_Pos_out), .Ball_Y_Pos_out(Ball_Y_Pos_out), /*, .led1(led1), .led2(led2), .led3(led3), .led4(led4), .led5(led5), .led6(led6), .led7(led7), .led8(led8)*/
											.is_collision_blue(is_collision_blue), .is_collision_red(is_collision_red), .is_collision_green(is_collision_green));
	 
	 wall wall_instance(.Clk(Clk), .DrawX(DrawX), .DrawY(DrawY), .is_wall(is_wall), .is_wall_up(is_wall_up), .is_wall_down(is_wall_down), .is_wall_right(is_wall_right), .is_wall_left(is_wall_left),
								.Ball_X_Pos_out(Ball_X_Pos_out), .Ball_Y_Pos_out(Ball_Y_Pos_out),
								.inside_block(inside_block), .Blue_X_Pos_out(Blue_X_Pos_out), .Blue_Y_Pos_out(Blue_Y_Pos_out),
								.is_wall_up_blue(is_wall_up_blue), .is_wall_down_blue(is_wall_down_blue), .is_wall_right_blue(is_wall_right_blue), .is_wall_left_blue(is_wall_left_blue),
								.inside_block_blue(inside_block_blue),
								.Red_X_Pos_out(Red_X_Pos_out), .Red_Y_Pos_out(Red_Y_Pos_out),
								.is_wall_up_red(is_wall_up_red), .is_wall_down_red(is_wall_down_red), .is_wall_right_red(is_wall_right_red), .is_wall_left_red(is_wall_left_red),
								.inside_block_red(inside_block_red),
								.Green_X_Pos_out(Green_X_Pos_out), .Green_Y_Pos_out(Green_Y_Pos_out),
								.is_wall_up_green(is_wall_up_green), .is_wall_down_green(is_wall_down_green), .is_wall_right_green(is_wall_right_green), .is_wall_left_green(is_wall_left_green),
								.inside_block_green(inside_block_green));
	 
    color_mapper color_instance(.is_ball(is_ball), .is_wall(is_wall), .is_red_evil(is_red_evil), .is_green_evil(is_green_evil), .is_blue_evil(is_blue_evil), .DrawX(DrawX), .DrawY(DrawY), 
											.VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
											.pac_man_cut_data_out_R(pac_man_cut_data_out[23:16]), .pac_man_cut_data_out_G(pac_man_cut_data_out[15:8]), .pac_man_cut_data_out_B(pac_man_cut_data_out[7:0]),	
											.red_evil_data_out_R(red_evil_data_out[23:16]), .red_evil_data_out_G(red_evil_data_out[15:8]), .red_evil_data_out_B(red_evil_data_out[7:0]),
											.green_evil_data_out_R(green_evil_data_out[23:16]), .green_evil_data_out_G(green_evil_data_out[15:8]), .green_evil_data_out_B(green_evil_data_out[7:0]),
											.blue_evil_data_out_R(blue_evil_data_out[23:16]), .blue_evil_data_out_G(blue_evil_data_out[15:8]), .blue_evil_data_out_B(blue_evil_data_out[7:0]),
											.is_food(is_food), .data_16(data_16), .is_zoom(is_zoom),
											.text_data(text_data), .score_x(score_x), .is_score_all_letters(is_score_all_letters),
											.is_collision_blue(is_collision_blue), .is_collision_red(is_collision_red), .is_collision_green(is_collision_green), .is_game_over(is_game_over));
											
	 pac_man_cut pac_man_cut_sprite(.Clk(Clk), .pac_man_cut_read_address(pac_man_cut_read_address), .pac_man_cut_data_out(pac_man_cut_data_out), .direction(direction), .pac_man_full_read_address_special(pac_man_full_read_address_special));
	 
	 food food_display(.Clk(Clk), .Reset(Reset_h), .DrawX(DrawX), .DrawY(DrawY), .Ball_X_Pos_out(Ball_X_Pos_out), .Ball_Y_Pos_out(Ball_Y_Pos_out), .is_food_eaten(is_food_eaten), .is_food(is_food), .is_food_big_no_color(is_food_big_no_color), .score_out(score_score));
 	 
	 red_evil red_evil_sprite(.Clk(Clk), .red_evil_read_address(red_evil_read_address), .red_evil_data_out(red_evil_data_out));

	 green_evil green_evil_sprite(.Clk(Clk), .green_evil_read_address(green_evil_read_address), .green_evil_data_out(green_evil_data_out));
		 
	 blue_evil blue_evil_sprite(.Clk(Clk), .blue_evil_read_address(blue_evil_read_address), .blue_evil_data_out(blue_evil_data_out));
    	 
	 font_rom font_rom(.addr(score_addr), .data(text_data), .is_zoom(is_zoom), .data_16(data_16));
	 
	 display_letters score(.DrawX(DrawX), .DrawY(DrawY), .is_score_all_letters(is_score_all_letters), .score_addr(score_addr), .score_x(score_x), .is_zoom(is_zoom), .score(score_score), .is_game_over(is_game_over));
    
	 logic [15:0] data_16;
	 logic [10:0] score_addr, score_x;
	 logic [7:0]  text_data, score_score;
	 
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
	 HexDriver hex_inst_2 (score[3:0], HEX2);
	 HexDriver hex_inst_3 (score[7:4], HEX3);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule

