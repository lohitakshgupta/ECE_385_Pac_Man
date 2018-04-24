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
