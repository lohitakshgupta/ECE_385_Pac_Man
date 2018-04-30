module display_letters(
		input [9:0]   DrawX, DrawY,
		output is_score_all_letters,
		output [10:0]	score_addr,
		output [10:0]	score_x
		);
		
	//for all the lettes associated with scores: SCORE:###
	
	logic [10:0] score_x_S = 290;
	logic [10:0] score_y_S = 360;
	
	logic [10:0] letter_size_x = 8;
	logic [10:0] letter_size_y = 16;
	
	always_comb
	begin
		if((DrawX >= score_x_S + 8*0) && (DrawX < score_x_S + 8*0 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h53);//S
			score_x = score_x_S + 8*0;
		end
		
		else if((DrawX >= score_x_S + 8*1) && (DrawX < score_x_S + 8*1 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h43);//C
			score_x = score_x_S + 8*1;
		end
		
		else if((DrawX >= score_x_S + 8*2) && (DrawX < score_x_S + 8*2 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h4f);//O
			score_x = score_x_S + 8*2;
		end
		
		else if((DrawX >= score_x_S + 8*3) && (DrawX < score_x_S + 8*3 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h52);//R
			score_x = score_x_S + 8*3;
		end
		
		else if((DrawX >= score_x_S + 8*4) && (DrawX < score_x_S + 8*4 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h45);//E
			score_x = score_x_S + 8*4;
		end
		
		else if((DrawX >= score_x_S + 8*5) && (DrawX < score_x_S + 8*5 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h10);//:
			score_x = score_x_S + 8*5;
		end
		
		else if((DrawX >= score_x_S + 8*6) && (DrawX < score_x_S + 8*6 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h30);//0 -> Will change
			score_x = score_x_S + 8*6;
		end
		
		else if((DrawX >= score_x_S + 8*7) && (DrawX < score_x_S + 8*7 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h30);//0 -> Will change
			score_x = score_x_S + 8*7;
		end
		
		else if((DrawX >= score_x_S + 8*8) && (DrawX < score_x_S + 8*8 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h30);//0 -> Will change
			score_x = score_x_S + 8*8;
		end
		
		else if((DrawX >= score_x_S + 8*9) && (DrawX < score_x_S + 8*9 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h30);//0 -> Will NOT change
			score_x = score_x_S + 8*9;
		end
		
		else if((DrawX >= score_x_S + 8*10) && (DrawX < score_x_S + 8*10 + letter_size_x) && 
			(DrawY >= score_y_S + 16*0) && (DrawY < score_y_S + 16*0 + letter_size_y)) begin
			is_score_all_letters = 1'b1;
			score_addr = (DrawY - (score_y_S + 16*0) + 16*'h30);//0 -> Will NOT change
			score_x = score_x_S + 8*10;
		end
		
		else begin
			is_score_all_letters = 1'b0;
			score_addr = 10'b0000000000;
			score_x = 10'b0000000000;;
		end
		
	end
	
endmodule
