module ClockDivider (
	input clk_in,
	input reset,
	output reg clk_out
);
	reg [25:0] div_count = 26'd0;
	parameter D = 26'd50000000;

	always @(posedge clk_in or posedge reset) begin

		if (reset) begin

			div_count <= 26'd0;
			clk_out <= 1'b0;

		end else begin

			if (div_count >= (D - 1)/2) begin
				
					div_count <= 26'd0;
					clk_out <= ~clk_out;

			end else begin

				div_count <= div_count + 1;

			end

		end

	end
	
endmodule



module finalProject (
	input [4:0] pins, 
	input top_button, // used to go to next state
	input bottom_button, // used to save values
	input reset,
	input clk,
	output reg[6:0] hex_5,
	output reg[6:0] hex_4,
	output reg[6:0] hex_3,
	output reg[6:0] hex_2,
	output reg[6:0] hex_1,
	output reg[6:0] hex_0,
	output reg dp // 0 = encode / 1 = decode

);

	parameter STATE_1 = 4'b0000; 
	parameter STATE_2 = 4'b0001;
	parameter STATE_3 = 4'b0010;
	parameter ENTER_LETTER = 4'b0011;
	parameter ENTER_WORD = 4'b0100;
	parameter STATE_4 = 4'b0101;
	parameter STATE_5 = 4'b0110;

	reg [5:0] word_display [0:5];
	reg [4:0] shift_amount;
	reg [2:0] current_state;
	reg [2:0] next_state;
	reg [4:0] shift_amount_out;
	reg mode;
	reg mode_out;
	reg [5:0] alphabet [0:25]; // maximum of 16 words held
	reg [4:0] letter;
	reg [4:0] word [5:0];
	reg [2:0] letter_index;
	reg [2:0] letter_out_index;
	reg [4:0] word_out [5:0];
	reg [4:0] letter_out;
    reg [5:0] position;
    reg[5:0] position_out;
	integer i,j,location, k;
	task ssd; 
	
		input [5:0] first_letter;
		input [5:0] second_letter;
		input [5:0] third_letter;
		input [5:0] fourth_letter;
		input [5:0] fifth_letter;
		input [5:0] sixth_letter;
		
		output reg[6:0] hex_5;
		output reg[6:0] hex_4;
		output reg[6:0] hex_3;
		output reg[6:0] hex_2;
		output reg[6:0] hex_1;
		output reg[6:0] hex_0;
		
		case(sixth_letter)
			default: hex_0 = 7'b1111111; // Blank Display		
			6'b000001: hex_0 = 7'b0001000; // A		
			6'b000010: hex_0 = 7'b0000011; // B		
			6'b000011: hex_0 = 7'b0100111; // C
			6'b000100: hex_0 = 7'b0100001; // D		
			6'b000101: hex_0 = 7'b0000100; // E		
			6'b000110: hex_0 = 7'b0001110; // F		
			6'b000111: hex_0 = 7'b0000010; // G		
			6'b001000: hex_0 = 7'b0001011; // H		
			6'b001001: hex_0 = 7'b1111011; // I
			6'b001010: hex_0 = 7'b1100001; // J		
			6'b001011: hex_0 = 7'b0001001; // K 		
			6'b001100: hex_0 = 7'b1111001; // L		
			6'b001101: hex_0 = 7'b0000110; // M
			6'b001110: hex_0 = 7'b0101011; // N 		
			6'b001111: hex_0 = 7'b1000000; // O		
			6'b010000: hex_0 = 7'b0001100; // P		
			6'b010001: hex_0 = 7'b0011000; // Q		
			6'b010010: hex_0 = 7'b0101111; // R
			6'b010011: hex_0 = 7'b0010010; // S		
			6'b010100: hex_0 = 7'b0111001; // T		
			6'b010101: hex_0 = 7'b0011101; // U		
			6'b010110: hex_0 = 7'b1000001; // V		
			6'b010111: hex_0 = 7'b0110000; // W		
			6'b011000: hex_0 = 7'b0001111; // X		
			6'b011001: hex_0 = 7'b0010001; // Y		
			6'b011010: hex_0 = 7'b0100100; // Z	
			6'b011011: hex_0 = 7'b1000000; // 0
			6'b011100: hex_0 = 7'b1111001; // 1
			6'b011101: hex_0 = 7'b0100100; // 2
			6'b011110: hex_0 = 7'b0110000; // 3
			6'b011111: hex_0 = 7'b0011001; // 4
			6'b100000: hex_0 = 7'b0010010; // 5
			6'b100001: hex_0 = 7'b0000010; // 6
			6'b100010: hex_0 = 7'b1111000; // 7
			6'b100011: hex_0 = 7'b0000000; // 8
			6'b100100: hex_0 = 7'b0010000; // 9
		endcase		
		
		case(fifth_letter)		
			default: hex_1 = 7'b1111111; // Blank Display		
			6'b000001: hex_1 = 7'b0001000; // A		
			6'b000010: hex_1 = 7'b0000011; // B		
			6'b000011: hex_1 = 7'b0100111; // C
			6'b000100: hex_1 = 7'b0100001; // D		
			6'b000101: hex_1 = 7'b0000100; // E		
			6'b000110: hex_1 = 7'b0001110; // F		
			6'b000111: hex_1 = 7'b0000010; // G		
			6'b001000: hex_1 = 7'b0001011; // H		
			6'b001001: hex_1 = 7'b1111011; // I
			6'b001010: hex_1 = 7'b1100001; // J		
			6'b001011: hex_1 = 7'b0001001; // K 		
			6'b001100: hex_1 = 7'b1111001; // L		
			6'b001101: hex_1 = 7'b0000110; // M
			6'b001110: hex_1 = 7'b0101011; // N 		
			6'b001111: hex_1 = 7'b1000000; // O		
			6'b010000: hex_1 = 7'b0001100; // P		
			6'b010001: hex_1 = 7'b0011000; // Q		
			6'b010010: hex_1 = 7'b0101111; // R
			6'b010011: hex_1 = 7'b0010010; // S		
			6'b010100: hex_1 = 7'b0111001; // T		
			6'b010101: hex_1 = 7'b0011101; // U		
			6'b010110: hex_1 = 7'b1000001; // V		
			6'b010111: hex_1 = 7'b0110000; // W		
			6'b011000: hex_1 = 7'b0001111; // X		
			6'b011001: hex_1 = 7'b0010001; // Y		
			6'b011010: hex_1 = 7'b0100100; // Z	
			6'b011011: hex_1 = 7'b1000000; // 0
			6'b011100: hex_1 = 7'b1111001; // 1
			6'b011101: hex_1 = 7'b0100100; // 2
			6'b011110: hex_1 = 7'b0110000; // 3
			6'b011111: hex_1 = 7'b0011001; // 4
			6'b100000: hex_1 = 7'b0010010; // 5
			6'b100001: hex_1 = 7'b0000010; // 6
			6'b100010: hex_1 = 7'b1111000; // 7
			6'b100011: hex_1 = 7'b0000000; // 8
			6'b100100: hex_1 = 7'b0010000; // 9
		endcase										
			
		case(fourth_letter)		
			default: hex_2 = 7'b1111111; // Blank Display		
			6'b000001: hex_2 = 7'b0001000; // A		
			6'b000010: hex_2 = 7'b0000011; // B		
			6'b000011: hex_2 = 7'b0100111; // C
			6'b000100: hex_2 = 7'b0100001; // D		
			6'b000101: hex_2 = 7'b0000100; // E		
			6'b000110: hex_2 = 7'b0001110; // F		
			6'b000111: hex_2 = 7'b0000010; // G		
			6'b001000: hex_2 = 7'b0001011; // H		
			6'b001001: hex_2 = 7'b1111011; // I
			6'b001010: hex_2 = 7'b1100001; // J		
			6'b001011: hex_2 = 7'b0001001; // K 		
			6'b001100: hex_2 = 7'b1111001; // L		
			6'b001101: hex_2 = 7'b0000110; // M
			6'b001110: hex_2 = 7'b0101011; // N 		
			6'b001111: hex_2 = 7'b1000000; // O		
			6'b010000: hex_2 = 7'b0001100; // P		
			6'b010001: hex_2 = 7'b0011000; // Q		
			6'b010010: hex_2 = 7'b0101111; // R
			6'b010011: hex_2 = 7'b0010010; // S		
			6'b010100: hex_2 = 7'b0111001; // T		
			6'b010101: hex_2 = 7'b0011101; // U		
			6'b010110: hex_2 = 7'b1000001; // V		
			6'b010111: hex_2 = 7'b0110000; // W		
			6'b011000: hex_2 = 7'b0001111; // X		
			6'b011001: hex_2 = 7'b0010001; // Y		
			6'b011010: hex_2 = 7'b0100100; // Z	
			6'b011011: hex_2 = 7'b1000000; // 0
			6'b011100: hex_2 = 7'b1111001; // 1
			6'b011101: hex_2 = 7'b0100100; // 2
			6'b011110: hex_2 = 7'b0110000; // 3
			6'b011111: hex_2 = 7'b0011001; // 4
			6'b100000: hex_2 = 7'b0010010; // 5
			6'b100001: hex_2 = 7'b0000010; // 6
			6'b100010: hex_2 = 7'b1111000; // 7
			6'b100011: hex_2 = 7'b0000000; // 8
			6'b100100: hex_2 = 7'b0010000; // 9
		endcase					
				
		case(third_letter)		
			default: hex_3 = 7'b1111111; // Blank Display		
			6'b000001: hex_3 = 7'b0001000; // A		
			6'b000010: hex_3 = 7'b0000011; // B		
			6'b000011: hex_3 = 7'b0100111; // C
			6'b000100: hex_3 = 7'b0100001; // D		
			6'b000101: hex_3 = 7'b0000100; // E		
			6'b000110: hex_3 = 7'b0001110; // F		
			6'b000111: hex_3 = 7'b0000010; // G		
			6'b001000: hex_3 = 7'b0001011; // H		
			6'b001001: hex_3 = 7'b1111011; // I
			6'b001010: hex_3 = 7'b1100001; // J		
			6'b001011: hex_3 = 7'b0001001; // K 		
			6'b001100: hex_3 = 7'b1111001; // L		
			6'b001101: hex_3 = 7'b0000110; // M
			6'b001110: hex_3 = 7'b0101011; // N 		
			6'b001111: hex_3 = 7'b1000000; // O		
			6'b010000: hex_3 = 7'b0001100; // P		
			6'b010001: hex_3 = 7'b0011000; // Q		
			6'b010010: hex_3 = 7'b0101111; // R
			6'b010011: hex_3 = 7'b0010010; // S		
			6'b010100: hex_3 = 7'b0111001; // T		
			6'b010101: hex_3 = 7'b0011101; // U		
			6'b010110: hex_3 = 7'b1000001; // V		
			6'b010111: hex_3 = 7'b0110000; // W		
			6'b011000: hex_3 = 7'b0001111; // X		
			6'b011001: hex_3 = 7'b0010001; // Y		
			6'b011010: hex_3 = 7'b0100100; // Z	
			6'b011011: hex_3 = 7'b1000000; // 0
			6'b011100: hex_3 = 7'b1111001; // 1
			6'b011101: hex_3 = 7'b0100100; // 2
			6'b011110: hex_3 = 7'b0110000; // 3
			6'b011111: hex_3 = 7'b0011001; // 4
			6'b100000: hex_3 = 7'b0010010; // 5
			6'b100001: hex_3 = 7'b0000010; // 6
			6'b100010: hex_3 = 7'b1111000; // 7
			6'b100011: hex_3 = 7'b0000000; // 8
			6'b100100: hex_3 = 7'b0010000; // 9
		endcase		
			
		case(second_letter)		
			default: hex_4 = 7'b1111111; // Blank Display		
			6'b000001: hex_4 = 7'b0001000; // A		
			6'b000010: hex_4 = 7'b0000011; // B		
			6'b000011: hex_4 = 7'b0100111; // C
			6'b000100: hex_4 = 7'b0100001; // D		
			6'b000101: hex_4 = 7'b0000100; // E		
			6'b000110: hex_4 = 7'b0001110; // F		
			6'b000111: hex_4 = 7'b0000010; // G		
			6'b001000: hex_4 = 7'b0001011; // H		
			6'b001001: hex_4 = 7'b1111011; // I
			6'b001010: hex_4 = 7'b1100001; // J		
			6'b001011: hex_4 = 7'b0001001; // K 		
			6'b001100: hex_4 = 7'b1111001; // L		
			6'b001101: hex_4 = 7'b0000110; // M
			6'b001110: hex_4 = 7'b0101011; // N 		
			6'b001111: hex_4 = 7'b1000000; // O		
			6'b010000: hex_4 = 7'b0001100; // P		
			6'b010001: hex_4 = 7'b0011000; // Q		
			6'b010010: hex_4 = 7'b0101111; // R
			6'b010011: hex_4 = 7'b0010010; // S		
			6'b010100: hex_4 = 7'b0111001; // T		
			6'b010101: hex_4 = 7'b0011101; // U		
			6'b010110: hex_4 = 7'b1000001; // V		
			6'b010111: hex_4 = 7'b0110000; // W		
			6'b011000: hex_4 = 7'b0001111; // X		
			6'b011001: hex_4 = 7'b0010001; // Y		
			6'b011010: hex_4 = 7'b0100100; // Z	
			6'b011011: hex_4 = 7'b1000000; // 0
			6'b011100: hex_4 = 7'b1111001; // 1
			6'b011101: hex_4 = 7'b0100100; // 2
			6'b011110: hex_4 = 7'b0110000; // 3
			6'b011111: hex_4 = 7'b0011001; // 4
			6'b100000: hex_4 = 7'b0010010; // 5
			6'b100001: hex_4 = 7'b0000010; // 6
			6'b100010: hex_4 = 7'b1111000; // 7
			6'b100011: hex_4 = 7'b0000000; // 8
			6'b100100: hex_4 = 7'b0010000; // 9
		endcase				
			
		case(first_letter)		
			default: hex_5 = 7'b1111111; // Blank Display		
			6'b000001: hex_5 = 7'b0001000; // A		
			6'b000010: hex_5 = 7'b0000011; // B		
			6'b000011: hex_5 = 7'b0100111; // C
			6'b000100: hex_5 = 7'b0100001; // D		
			6'b000101: hex_5 = 7'b0000100; // E		
			6'b000110: hex_5 = 7'b0001110; // F		
			6'b000111: hex_5 = 7'b0000010; // G		
			6'b001000: hex_5 = 7'b0001011; // H		
			6'b001001: hex_5 = 7'b1111011; // I
			6'b001010: hex_5 = 7'b1100001; // J		
			6'b001011: hex_5 = 7'b0001001; // K 		
			6'b001100: hex_5 = 7'b1111001; // L		
			6'b001101: hex_5 = 7'b0000110; // M
			6'b001110: hex_5 = 7'b0101011; // N 		
			6'b001111: hex_5 = 7'b1000000; // O		
			6'b010000: hex_5 = 7'b0001100; // P		
			6'b010001: hex_5 = 7'b0011000; // Q		
			6'b010010: hex_5 = 7'b0101111; // R
			6'b010011: hex_5 = 7'b0010010; // S		
			6'b010100: hex_5 = 7'b0111001; // T		
			6'b010101: hex_5 = 7'b0011101; // U		
			6'b010110: hex_5 = 7'b1000001; // V		
			6'b010111: hex_5 = 7'b0110000; // W		
			6'b011000: hex_5 = 7'b0001111; // X		
			6'b011001: hex_5 = 7'b0010001; // Y		
			6'b011010: hex_5 = 7'b0100100; // Z	
			6'b011011: hex_5 = 7'b1000000; // 0
			6'b011100: hex_5 = 7'b1111001; // 1
			6'b011101: hex_5 = 7'b0100100; // 2
			6'b011110: hex_5 = 7'b0110000; // 3
			6'b011111: hex_5 = 7'b0011001; // 4
			6'b100000: hex_5 = 7'b0010010; // 5
			6'b100001: hex_5 = 7'b0000010; // 6
			6'b100010: hex_5 = 7'b1111000; // 7
			6'b100011: hex_5 = 7'b0000000; // 8
			6'b100100: hex_5 = 7'b0010000; // 9
			
		endcase							
	endtask
	
	wire clk_out;
	ClockDivider cd (clk, reset, clk_out);
		
		always @(posedge clk_out or posedge reset) begin
		if (reset == 1) begin
			current_state = STATE_1;
			word_out[0] = 5'b00000;
			word_out[1] = 5'b00000;
			word_out[2] = 5'b00000;
			word_out[3] = 5'b00000;
			word_out[4] = 5'b00000;
			word_out[5] = 5'b00000;
			letter_out = 5'b00000;
			mode_out = 1'b0;
			shift_amount_out = 5'b00000;
			letter_out_index = 3'b000;
		end
		else begin
				word_out[0] = word[0];
				word_out[1] = word[1];
				word_out[2] = word[2];
				word_out[3] = word[3];
				word_out[4] = word[4];
				word_out[5] = word[5];
				letter_out = letter;	
				current_state = next_state;
				mode_out = mode;
				shift_amount_out = shift_amount;
				letter_out_index = letter_index;
		end
        position_out = 6'b000000;
	end
	always @(*) begin 
		next_state = current_state;
		alphabet[0] = 6'b000001;
		alphabet[1] = 6'b000010;
		alphabet[2] = 6'b000011;
		alphabet[3] = 6'b000100;
		alphabet[4] = 6'b000101;
		alphabet[5] = 6'b000110;
		alphabet[6] = 6'b000111;
		alphabet[7] = 6'b001000;
		alphabet[8] = 6'b001001;
		alphabet[9] = 6'b001010;
		alphabet[10] = 6'b001011;
		alphabet[11] = 6'b001100;
		alphabet[12] = 6'b001101;
		alphabet[13] = 6'b001110;
		alphabet[14] = 6'b001111;
		alphabet[15] = 6'b010000;
		alphabet[16] = 6'b010001;
		alphabet[17] = 6'b010010;
		alphabet[18] = 6'b010011;
		alphabet[19] = 6'b010100;
		alphabet[20] = 6'b010101;
		alphabet[21] = 6'b010110;
		alphabet[22] = 6'b010111;
		alphabet[23] = 6'b011000;
		alphabet[24] = 6'b011001;
		alphabet[25] = 6'b011010;

		word_display[0] = 6'b000000;
		word_display[1] = 6'b000000;
		word_display[2] = 6'b000000;
		word_display[3] = 6'b000000;
		word_display[4] = 6'b000000;
		word_display[5] = 6'b000000;
		word[0] = word_out[0];
		word[1] = word_out[1];
		word[2] = word_out[2];
		word[3] = word_out[3];
		word[4] = word_out[4];
		word[5] = word_out[5];
		letter = letter_out;
		shift_amount = shift_amount_out;
		mode = mode_out;
		letter_index = letter_out_index;
        position = position_out;
		dp = 1'b1;
		case (current_state)
			STATE_1: begin // encode / decode selection
				if (pins[0]) begin
					word_display[0] = 6'b000101;
					word_display[1] = 6'b001110;
					word_display[2] = 6'b000011;
					word_display[3] = 6'b001111;
					word_display[4] = 6'b000100;
					word_display[5] = 6'b000101;
					mode = 1'b1; 
					if (!top_button) begin
						next_state = STATE_2;
								
					end
				end
				if (!pins[0]) begin
					word_display[0] = 6'b000100;
					word_display[1] = 6'b000101;
					word_display[2] = 6'b000011;
					word_display[3] = 6'b001111;
					word_display[4] = 6'b000100;
					word_display[5] = 6'b000101;
					mode = 1'b0; 
					if (!top_button) begin
						next_state = STATE_2; 
						
					end
				end
			end
			
			
			STATE_2: begin // enter shift amount 
				next_state = current_state;
				word_display[0] = 6'b0000000;
				word_display[1] = 6'b0000000;
				word_display[2] = 6'b0000000;
				word_display[3] = 6'b0000000;
				word_display[4] = 6'b0000000;
				word_display[5] = 6'b0000000;
				if(pins <= 5'b11001 && pins != 0)begin
					word_display[0] = ( (pins / 10) + 27);
					word_display[1] = (pins != 0) ? ((pins % 10) + 27): 6'b011011;
					shift_amount = pins;
					if (!top_button)begin
						next_state = ENTER_LETTER; 			  
					end
				end
			end

			ENTER_LETTER: begin
				next_state = current_state;
				word_display[0] = pins;
				word_display[1] = 0;
				word_display[2] = 0;
				word_display[3] = 0;
				word_display[4] = 0;
				word_display[5] = 0;
				if(!top_button) begin
					next_state = ENTER_WORD;
					letter = pins;
				end
			end

			ENTER_WORD: begin
				dp = 1'b0;
				word[letter_index] = letter;
				word_display[0] = word[0];
				word_display[1] = word[1];
				word_display[2] = word[2];
				word_display[3] = word[3];
				word_display[4] = word[4];
				word_display[5] = word[5];
				if(!top_button) begin
					next_state = STATE_4;
				end
				if(!bottom_button && letter_index < 5) begin
					letter_index = letter_index + 3'b001;
					letter = 5'b00000;
					next_state = ENTER_LETTER;
				end

			end

			STATE_4: begin // encrypt
            integer f;
				if(mode) begin
					for (i = 0; i < 5; i = i + 1) begin
						location = 0;
                        if(word[i] != 6'b000000) begin
							for (k = 0; k < 25; k = k + 1)begin
								if(word[i] == alphabet[k]) begin
									position = location;
								end
                                else begin
								    location = location + 1;
                                end
							end
                            f = position;
							if((shift_amount + position)> 25) begin
								position = (shift_amount + f) - 26;
							end
							else begin
								position = shift_amount + f;
							end
							word[i] = alphabet[position];
                        end
					end
				end
				if(!mode)begin 
					for (i = 0; i < 5; i = i + 1)begin
						location = 0;
                        if(word[i] != 6'b000000) begin
							for (k = 0; k < 25; k = k + 1)begin
								if(word[i] == alphabet[k]) begin
									position = location;
								end
                                else begin
								    location = location + 1;
                                end
							end
                            f = position;
							if(shift_amount > f) begin
								position = (f - shift_amount) + 26;
							end
							else begin
								position = f - shift_amount;
							end
							word[i] = alphabet[position];
                        end
					end
				end
				next_state = STATE_5;
			end
	
			STATE_5: begin // display
			integer place;
				next_state = current_state;                             
				word_display[0] = word[0];
				word_display[1] = word[1];
				word_display[2] = word[2];
				word_display[3] = word[3];
				word_display[4] = word[4];
				word_display[5] = word[5];	       
			end	
		endcase
		ssd(word_display[0], word_display[1], word_display[2], word_display[3], word_display[4], word_display[5], hex_5, hex_4, hex_3, hex_2, hex_1, hex_0);	
	end
	
endmodule