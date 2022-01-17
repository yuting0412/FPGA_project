module Breakout(output reg [7:0] RED, GREEN, BLUE, output reg [3:0] COMM, output reg [6:0] seg, output reg [1:0]COM, output [2:0] life, input CLK, Left, Right, start, restart, pause, keepBoard, input [1:0]	level);
	reg [7:0] ball [7:0];
	reg [7:0] board [7:0];
	reg [7:0] gameOver [7:0];
	reg [7:0] block [7:0];
	integer col, row, upDown, balltype, leftRight, lastRow, lastCol;
	integer boardMid, boardLeft, boardRight;
	integer stop, countLife, playLevel, score;
	//integer keepBoard;
	bit [2:0] count;
	divfreq F0(CLK, CLK_div);
	ballfreq F1(CLK, CLK_ball);

	initial
		begin
			RED <= 8'b11111111;
			GREEN <= 8'b11111111;
			BLUE <= 8'b11111111;
			COMM <= 4'b1000;
			COM <= 2'b10;
			
			ball[0] = 8'b11111111;
			ball[1] = 8'b11111111;
			ball[2] = 8'b11111111;
			ball[3] = 8'b11111111;
			ball[4] = 8'b11111111;
			ball[5] = 8'b11111111;
			ball[6] = 8'b11111111;
			ball[7] = 8'b11111111;
			
			board[0] = 8'b11111111;
			board[1] = 8'b11111111;
			board[2] = 8'b11111111;
			board[3] = 8'b11111111;
			board[4] = 8'b11111111;
			board[5] = 8'b11111111;
			board[6] = 8'b11111111;
			board[7] = 8'b11111111;
			
			block[0] = 8'b11111111;
			block[1] = 8'b11111111;
			block[2] = 8'b11111111;
			block[3] = 8'b11111111;
			block[4] = 8'b11111111;
			block[5] = 8'b11111111;
			block[6] = 8'b11111111;
			block[7] = 8'b11111111;
			
			gameOver[0] = 8'b11111111;
			gameOver[1] = 8'b11111111;
			gameOver[2] = 8'b11111111;
			gameOver[3] = 8'b11111111;
			gameOver[4] = 8'b11111111;
			gameOver[5] = 8'b11111111;
			gameOver[6] = 8'b11111111;
			gameOver[7] = 8'b11111111;
			
			countLife = 3;
			stop = 1;
			score = 0;
			playLevel = 0;

		end


	always @(posedge CLK_div) //print
		begin
			ball[0][0] = ball[0][0]; //????
			if(count >= 7)
				count = 0;
			else
				count = count + 1;
			if (countLife == 3) // life LED
				life <= 3'b111;
			else if(countLife == 2)
				life <= 3'b011;
			else if(countLife == 1)
				life <= 3'b010;
			else if(countLife == 0)
				life <= 3'b000;
			if (level == 2'b00) //block level
				playLevel = 0;
			else if (level == 2'b10)
				playLevel = 1;
			else if (level == 2'b01)
				playLevel = 2;
			else if (level == 2'b11)
				playLevel = 3;
			
			if (COM == 2'b10) // score 
				begin
					if (score%10 == 0) //digit
						seg = 7'b1000000;
					else if (score%10 == 1) 
						seg = 7'b1111001;
					else if (score%10 == 2)
						seg = 7'b0100100;
					else if (score%10 == 3)
						seg = 7'b0110000;
					else if (score%10 == 4)
						seg = 7'b0011001;
					else if (score%10 == 5)
						seg = 7'b0010010;
					else if (score%10 == 6)
						seg = 7'b0000010;
					else if (score%10 == 7)
						seg = 7'b1111000;
					else if (score%10 == 8)
						seg = 7'b0000000;
					else if (score%10 == 9)
						seg = 7'b0010000;
					COM = ~COM;
					COM = 2'b01;
				end
			else if (COM == 2'b01) //tendigit
				begin
					if (score/10 == 0)
						seg = 7'b1000000;
					else if (score/10 == 1) 
						seg = 7'b1111001;
					else if (score/10 == 2)
						seg = 7'b0100100;
					else if (score/10 == 3)
						seg = 7'b0110000;
					else if (score/10 == 4)
						seg = 7'b0011001;
					else if (score/10 == 5)
						seg = 7'b0010010;
					else if (score/10 == 6)
						seg = 7'b0000010;
					else if (score/10 == 7)
						seg = 7'b1111000;
					else if (score/10 == 8)
						seg = 7'b0000000;
					else if (score/10 == 9)
						seg = 7'b0010000;
					COM = ~COM;
					COM = 2'b10;
				end
			
			COMM = {1'b1, count};
			RED = block[count] ~^ gameOver[count];
			BLUE = ball[count] ~^ block[count];
			GREEN = board[count] ~^ block[count];

			//RED = gameOver[count];
		end
		
	always @(posedge CLK_ball) // ball & borad
		begin	
			if (countLife == 0 ) // game over
				begin
					if (gameOver[0] > 0)
						gameOver[0] = gameOver[0]/2;
					if (gameOver[1] > 0)
						gameOver[1] = gameOver[1]/4;
					if (gameOver[2] > 0)
						gameOver[2] = gameOver[0] - 1'b1;
					if (gameOver[3] > 0)
						gameOver[3] = gameOver[2]/2;
					if (gameOver[4] > 0)
						gameOver[4] = gameOver[0] - 1'b1;
					if (gameOver[5] > 0)
						gameOver[5] = gameOver[0];
					if (gameOver[6] > 0)
						gameOver[6] = gameOver[4]/2;
					if (gameOver[7] > 0)
						gameOver[7] = gameOver[3]/2;
				if (restart == 1) // reset
					begin
						countLife = 3;
						stop = 1;
						score = 0;
						// playLevel = 0;
						lastRow = 2;
						lastCol = 6;
						row = 2;
						col = 6;
						upDown = -1; // down : 1, up : -1
						balltype = 1;
						leftRight = 1; //right : 1, left : -1
						boardLeft = 5;
						boardMid = 2;
						boardRight = 3;
						stop = 0;
						gameOver[0] = 8'b11111111;
						gameOver[1] = 8'b11111111;
						gameOver[2] = 8'b11111111;
						gameOver[3] = 8'b11111111;
						gameOver[4] = 8'b11111111;
						gameOver[5] = 8'b11111111;
						gameOver[6] = 8'b11111111;
						gameOver[7] = 8'b11111111;
					end
				end
			if (stop == 1) //ball
				begin
					boardMid = 0;
					boardLeft = 0;
					boardRight = 7;
					if (start == 1 && countLife > 0)
						begin
							lastRow = 2;
							lastCol = 6;
							row = 2;
							col = 6;
							upDown = -1; // down : 1, up : -1
							balltype = 1;
							leftRight = 1; //right : 1, left : -1
							boardLeft = 5;
							boardMid = 2;
							boardRight = 3;
							stop = 0;	
						end
				end
			if (countLife > 0 && stop == 0 && pause == 0) //start play
				begin
					if (col == 6) // check touch board
						begin
							if (row == boardMid)
								begin
									ball[lastRow][lastCol] = 1'b1;
									balltype = 1;
									upDown = -1; 
								end
							else if(row == boardLeft)
								begin
									ball[lastRow][lastCol] = 1'b1;
									balltype = 2;
									leftRight = -1;
									upDown = -1;
								end
							else if(row == boardRight)
								begin
									ball[lastRow][lastCol] = 1'b1;
									balltype = 2;
									leftRight = 1;
									upDown = -1;
								end
						end
					if (block[row][col] == 1'b0) // check touch block
						begin
							block[row][col] = 1'b1;
							score= score + 1;
							ball[lastRow][lastCol] = 1'b1;
							upDown = 1;
						end
					if (col == 7) // ball drop
						begin
							ball[lastRow][lastCol] = 1'b1;
							countLife = countLife-1;
							stop = 1;
						end
					else
						begin
							if (balltype == 1) // straight
								begin
									if (col == 0) // turn down
										begin
											ball[row][col-upDown] = 1'b1;
											upDown = 1;
										end
									else // turn up
										begin
											ball[row][col-upDown] = 1'b1;
										end
									ball[row][col] = 1'b0;
									lastRow = row;
									lastCol = col;
									if (col != 7)
										col = col + upDown;
								end
							else if (balltype == 2) //rightUp
								begin
									if (leftRight == 1)
										begin
											if (row == 4)
												ball[1][col-upDown] = 1'b1;
											else if (row == 2)
												ball[5][col-upDown] = 1'b1;
											else if (row == 6)
												ball[3][col-upDown] = 1'b1;
											else
												ball[row-leftRight][col-upDown] = 1'b1;
										end
									else if (leftRight == -1)
										begin
											if (row == 3)
												ball[6][col-upDown] = 1'b1;
											else if (row == 5)
												ball[2][col-upDown] = 1'b1;
											else if (row == 1)
												ball[4][col-upDown] = 1'b1;
											else
												ball[row-leftRight][col-upDown] = 1'b1;
										end
									ball[row][col] = 1'b0;
									if (col == 0) // turn down
										upDown = 1;
									if (row == 7) //turn left
										leftRight = -1;
									else if (row == 0)// turn right
										leftRight = 1;
									lastRow = row;
									lastCol = col;
									if (col != 7)
										begin
											col = col + upDown;
											row = row + leftRight;
										end
									if (leftRight == 1)
										begin
											if (row == 2)
												row = 4;
											else if (row == 6)
												row = 2;
											else if (row == 4)
												row = 6;
										end
									else if (leftRight == -1)
										begin
											if (row == 5)
												row = 3;
											else if (row == 1)
												row = 5;
											else if (row == 3)
												row = 1;
										end
								end
						end	
					
				end
			if (stop != 1) //board
				begin
					if (Left == 1 && boardMid > 0) //shift left
							boardMid = boardLeft;
					else if (Right == 1 && boardMid < 7) // shift Right
							boardMid = boardRight;
					if (boardMid == 1)
						begin
							boardLeft = 0;
							boardRight = 4;
						end
					else if (boardMid == 4)
						begin
							boardLeft = 1;
							boardRight = 5;	
						end
					else if (boardMid == 5)
						begin
							boardLeft = 4;
							boardRight = 2;
						end
					else if (boardMid == 2)
						begin
							boardLeft = 5;
							boardRight = 3;
						end
					else if (boardMid == 3)
						begin
							boardLeft = 2;
							boardRight = 6;
						end
					else if (boardMid == 6)
						begin
							boardLeft = 3;
							boardRight = 7;
						end
					if (boardMid == 1)
						begin
							board[0] = 8'b01111111;
							board[1] = 8'b01111111;
							board[4] = 8'b01111111;
							board[5] = 8'b11111111;
							board[2] = 8'b11111111;
							board[3] = 8'b11111111;
							board[6] = 8'b11111111;
							board[7] = 8'b11111111;
						end
					else if (boardMid == 2)
						begin
							board[0] = 8'b11111111;
							board[1] = 8'b11111111;
							board[4] = 8'b11111111;
							board[5] = 8'b01111111;
							board[2] = 8'b01111111;
							board[3] = 8'b01111111;
							board[6] = 8'b11111111;
							board[7] = 8'b11111111;
						end
					else if (boardMid == 3)
						begin
							board[0] = 8'b11111111;
							board[1] = 8'b11111111;
							board[4] = 8'b11111111;
							board[5] = 8'b11111111;
							board[2] = 8'b01111111;
							board[3] = 8'b01111111;
							board[6] = 8'b01111111;
							board[7] = 8'b11111111;
						end
					else if (boardMid == 4)
						begin
							board[0] = 8'b11111111;
							board[1] = 8'b01111111;
							board[4] = 8'b01111111;
							board[5] = 8'b01111111;
							board[2] = 8'b11111111;
							board[3] = 8'b11111111;
							board[6] = 8'b11111111;
							board[7] = 8'b11111111;
						end
					else if (boardMid == 5)
						begin
							board[0] = 8'b11111111;
							board[1] = 8'b11111111;
							board[4] = 8'b01111111;
							board[5] = 8'b01111111;
							board[2] = 8'b01111111;
							board[3] = 8'b11111111;
							board[6] = 8'b11111111;
							board[7] = 8'b11111111;
						end
					else if (boardMid == 6)
						begin
							board[0] = 8'b11111111;
							board[1] = 8'b11111111;
							board[4] = 8'b11111111;
							board[5] = 8'b11111111;
							board[2] = 8'b11111111;
							board[3] = 8'b01111111;
							board[6] = 8'b01111111;
							board[7] = 8'b01111111;
						end
				end
			else if (stop == 1) // reset board
				begin
					board[0] = 8'b11111111;
					board[1] = 8'b11111111;
					board[4] = 8'b11111111;
					board[5] = 8'b11111111;
					board[2] = 8'b11111111;
					board[3] = 8'b11111111;
					board[6] = 8'b11111111;
					board[7] = 8'b11111111;
				end
			
			if (countLife > 0 && keepBoard == 0) //block
				begin
					if (start == 1 && playLevel == 0)
						begin
							block[0] = 8'b11111111;
							block[1] = 8'b11111111;
							block[2] = 8'b11111000;
							block[3] = 8'b11111111;
							block[4] = 8'b11111111;
							block[5] = 8'b11111111;
							block[6] = 8'b11111111;
							block[7] = 8'b11111111;
						end
					else if (start == 1 && playLevel == 1)
						begin
							block[0] = 8'b11111100;
							block[1] = 8'b11111100;
							block[2] = 8'b11111100;
							block[3] = 8'b11111100;
							block[4] = 8'b11111100;
							block[5] = 8'b11111100;
							block[6] = 8'b11111100;
							block[7] = 8'b11111100;
						end
					else if (start == 1 && playLevel == 2)
						begin
							block[0] = 8'b11111000;
							block[1] = 8'b11110000;
							block[2] = 8'b11111000;
							block[3] = 8'b11101100;
							block[4] = 8'b11110000;
							block[5] = 8'b11101100;
							block[6] = 8'b11111000;
							block[7] = 8'b11111100;
						end
					else if (start == 1 && playLevel == 3)
						begin
							block[0] = 8'b11111111;
							block[1] = 8'b11110001;
							block[2] = 8'b11000011;
							block[3] = 8'b11000001;
							block[4] = 8'b11100000;
							block[5] = 8'b11000001;
							block[6] = 8'b11100000;
							block[7] = 8'b11110001;
						end
				end
			else if (countLife == 0)
				begin
					block[0] = 8'b11111111;
					block[1] = 8'b11111111;
					block[2] = 8'b11111111;
					block[3] = 8'b11111111;
					block[4] = 8'b11111111;
					block[5] = 8'b11111111;
					block[6] = 8'b11111111;
					block[7] = 8'b11111111;
				end
				
			
		end

endmodule

module divfreq(input CLK, output reg CLK_div);
reg [24:0] Count;
always @(posedge CLK)
	begin
		if(Count > 25000)
			begin
				Count <= 25'b0;
				CLK_div <= ~CLK_div;
			end
		else
			Count <= Count + 1'b1;
	end
endmodule

module ballfreq(input CLK, output reg CLK_ball);
reg [24:0] Count;
always @(posedge CLK)
	begin
		if(Count > 7000000)
			begin
				Count <= 25'b0;
				CLK_ball <= ~CLK_ball;
			end
		else
			Count <= Count + 1'b1;
	end
endmodule
