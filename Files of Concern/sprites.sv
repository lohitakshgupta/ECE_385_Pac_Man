module  pac_man_cut
(
		//input [4:0] data_In,
		//input [18:0] write_address, 
		input [9:0] pac_man_cut_read_address,
		//input we, Clk,
		input Clk,
		
		output logic [23:0] pac_man_cut_data_out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] pac_man_cut_mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/pac_man_cut.txt", pac_man_cut_mem);
end


always_ff @ (posedge Clk) begin
	//if (we)
		//mem[write_address] <= data_In;
	pac_man_cut_data_out<= pac_man_cut_mem[pac_man_cut_read_address];
end

endmodule

module  pac_man_full
(
		//input [4:0] data_In,
		//input [18:0] write_address, 
		input [9:0] pac_man_full_read_address,
		//input we, Clk,
		input Clk,
		
		output logic [23:0] pac_man_full_data_out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] pac_man_full_mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/pac_man_full.txt", pac_man_full_mem);
end


always_ff @ (posedge Clk) begin
	//if (we)
		//mem[write_address] <= data_In;
	pac_man_full_data_out<= pac_man_full_mem[pac_man_full_read_address];
end

endmodule

module  red_evil
(
		//input [4:0] data_In,
		//input [18:0] write_address, 
		input [9:0] red_evil_read_address,
		//input we, Clk,
		input Clk,
		
		output logic [23:0] red_evil_data_out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] red_evil_mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/red_evil.txt", red_evil_mem);
end


always_ff @ (posedge Clk) begin
	//if (we)
		//mem[write_address] <= data_In;
	red_evil_data_out<= red_evil_mem[red_evil_read_address];
end

endmodule

module  blue_evil
(
		//input [4:0] data_In,
		//input [18:0] write_address, 
		input [9:0] blue_evil_read_address,
		//input we, Clk,
		input Clk,
		
		output logic [23:0] blue_evil_data_out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] blue_evil_mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/blue_evil.txt", blue_evil_mem);
end


always_ff @ (posedge Clk) begin
	//if (we)
		//mem[write_address] <= data_In;
	blue_evil_data_out<= blue_evil_mem[blue_evil_read_address];
end

endmodule

module  green_evil
(
		//input [4:0] data_In,
		//input [18:0] write_address, 
		input [9:0] green_evil_read_address,
		//input we, Clk,
		input Clk,
		
		output logic [23:0] green_evil_data_out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] green_evil_mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/green_evil.txt", green_evil_mem);
end


always_ff @ (posedge Clk) begin
	//if (we)
		//mem[write_address] <= data_In;
	green_evil_data_out<= green_evil_mem[green_evil_read_address];
end

endmodule
