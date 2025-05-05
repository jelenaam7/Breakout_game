
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    6.7v2
// Design Name: 
// Module Name:    breakoutv2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module breakout(
    input wire CLK,
    input wire RST,
    input wire LIJEVO,     // Ulaz za pomicanje ploèice ulijevo
    input wire DESNO,      // Ulaz za pomicanje ploèice udesno
    output wire VGA_HSYNC, // Horizontal sync output
    output wire VGA_VSYNC, // Vertical sync output
    output wire VGA_R,     // Red output
    output wire VGA_G,     // Green output
    output wire VGA_B      // Blue output
); 

    // Parametri za VGA sinkronizaciju
    localparam H_DISPLAY = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC_WIDTH = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_TOTAL = 800;
    
    localparam V_DISPLAY = 480;
    localparam V_FRONT_PORCH = 10; 
    localparam V_SYNC_WIDTH = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_TOTAL = 525;

    // VGA sinkronizacijski i boji signali
    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;
    reg hsync, vsync;
    reg clk25 = 0;
    reg red = 0;  
    reg green = 0;
    reg blue = 0; 

    // Signali za debouncer
    wire LIJEVO_debounced;
    wire DESNO_debounced;
	 wire RST_debounced;

    // Instanciranje debouncera za gumbe
    debounce debounce_LIJEVO (.CLK(CLK), .btn_in(LIJEVO), .btn_out(LIJEVO_debounced));
    debounce debounce_DESNO (.CLK(CLK), .btn_in(DESNO), .btn_out(DESNO_debounced));
	 debounce debounce_RST (.CLK(CLK), .btn_in(RST), .btn_out(RST_debounced));
		
		
    // Parametri za ploèicu
    reg [9:0] paddle_x = 320;
    reg [3:0] paddle_speed = 6;
	 


    // Brojaè za usporavanje pomicanja ploèice
    reg [19:0] paddle_counter = 0;
    wire paddle_enable = (paddle_counter == 0);

    // Ažuriranje brojaèa za usporavanje pomicanja ploèice
    always @(posedge clk25) begin
        paddle_counter <= paddle_counter + 1;
    end
    // Pomicanje ploèice
    always @(posedge clk25) begin
        if (paddle_enable) begin
            if (LIJEVO_debounced && paddle_x >= paddle_speed) // Pomicanje ploèice ulijevo
                paddle_x <= paddle_x - paddle_speed;
            else if (DESNO_debounced && paddle_x <= H_DISPLAY - paddle_speed - 50) // Pomicanje ploèice udesno
                paddle_x <= paddle_x + paddle_speed;
        end
    end
	 
	 
	 //wire block_area0 = (h_counter >= 100 && h_counter < 150 && v_counter >= 50 && v_counter < 75);
    wire block_area1 = (h_counter >= 150 && h_counter < 250 && v_counter >= 50 && v_counter < 75);
    wire block_area2 = (h_counter >= 300 && h_counter < 400 && v_counter >= 50 && v_counter < 75);
    wire block_area3 = (h_counter >= 450 && h_counter < 550 && v_counter >= 50 && v_counter < 75);
    //wire block_area4 = (h_counter >= 100 && h_counter < 150 && v_counter >= 100 && v_counter < 125);
    //wire block_area5 = (h_counter >= 200 && h_counter < 250 && v_counter >= 100 && v_counter < 125);
    //wire block_area6 = (h_counter >= 300 && h_counter < 350 && v_counter >= 100 && v_counter < 125);
    //wire block_area7 = (h_counter >= 400 && h_counter < 450 && v_counter >= 100 && v_counter < 125);
	 // registri za blokove
	 //reg [2:0] blok0=0;
	 reg [2:0] blok1=0;
	 reg [2:0] blok2=0;
	 reg [2:0] blok3=0;
//	 reg [2:0] blok4=0;
//	 reg [2:0] blok5=0;
//	 reg [2:0] blok6=0;
//	 reg [2:0] blok7=0;
    // Parametri za lopticu
    reg [9:0] ball_x = 480; // Poèetna X pozicija loptice
    reg [9:0] ball_y = 240; // Poèetna Y pozicija loptice
    reg [3:0] ball_speed_x; // Brzina kretanja po X osi
    reg [3:0] ball_speed_y; // Brzina kretanja po Y osi
    reg ball_direction_x = 1; // Smjer kretanja po X osi (1: desno, 0: lijevo)
    reg ball_direction_y = 1; // Smjer kretanja po Y osi (1: dolje, 0: gore)
	 //broj pobjeda
	 reg [1:0] br_winova=0;
	 reg level_change;
	 always @(posedge clk25)begin
		if(br_winova == 0)begin
			ball_speed_x <=6;
			ball_speed_y <=6;
		end
		else if(br_winova == 1)begin
			ball_speed_x<=9;
			ball_speed_y<=9;
		end
		else if(br_winova == 2)begin
			ball_speed_x<=12;
			ball_speed_y<=12;
		end
	
	 end

    // Ažuriranje pozicije loptice
    reg [3:0] count = 0;

    always @(posedge clk25) begin
		if(RST_debounced )begin
			ball_x <= 480; 
         ball_y <= 240;
			//blok0<=0;
			blok1<=0;
			blok2<=0;
			blok3<=0;
//			blok4<=0; 
//			blok5<=0;
//			blok6<=0;
//			blok7<=0;
			br_winova<=0;
		end 
		else begin	
            if (h_counter == H_TOTAL - 1) begin
                if (v_counter == V_TOTAL - 1) begin
							count <= count + 1;
                    if (count == 5) begin // Ažuriraj svakih 5 ciklusa clk25
						  
								if(br_winova == 0)begin //prvi level
									if (ball_x == 24 )  // Ukljuèujuæi LIJEVI RUB 
										ball_direction_x <= 1;
									if (ball_x >= 618 )  // Ukljuèujuæi DESNI RUB
										ball_direction_x <= 0;
									if (ball_y ==420 && ball_x >= (paddle_x - 6) && ball_x <= (paddle_x + 60)) //odbijanje od ploèicu
										ball_direction_y <= 0; 
									if (ball_y == 24 )  // Ukljuèujuæi RUB GORNJI
										ball_direction_y <= 1;
										
										//ODBIJANJE OD BLOKOVE
									if ((ball_x >= 144 && ball_x <= 258 && ball_y >= 42 && ball_y < 87) && (blok1 == 3'b000)) begin
										blok1 <= blok1 + 1;
										if (ball_x == 144 || ball_x == 258) begin
											ball_direction_x <= ball_direction_x + 1;
										end 
										else begin
											ball_direction_y <= ball_direction_y + 1;
										end
									end
									
									if ((ball_x >= 294 && ball_x <= 408 && ball_y >= 42 && ball_y < 87) && (blok2 == 3'b000)) begin
										blok2 <= blok2+1;
										if (ball_x == 294 || ball_x == 408) begin
											ball_direction_x <= ball_direction_x + 1;
										end 
										else begin
											ball_direction_y <= ball_direction_y + 1;
										end
									end
									
									if ((ball_x >= 438 && ball_x <= 546 && ball_y >= 42 && ball_y < 87) && (blok3 == 3'b000)) begin
										blok3 <= blok3+1;
										if (ball_x == 438 && ball_x == 546) begin
											ball_direction_x <= ball_direction_x + 1;
										end 
										else begin
											ball_direction_y <= ball_direction_y + 1;
										end
									end
								end
								
								
								else if(br_winova == 1)begin //drugi level
									if (ball_x <= 30  ) begin // Ukljuèujuæi LIJEVI RUB
										ball_direction_x <= 1;
									end
									if (ball_x >= 615 ) begin // Ukljuèujuæi DESNI RUB
										ball_direction_x <= 0;
									end
									if (ball_y == 411 && ball_x >= (paddle_x - 6) && ball_x <= (paddle_x + 60))//odbijanje od ploèicu
										ball_direction_y <= 0; 
									if (ball_y <= 30 ) begin // Ukljuèujuæi RUB GORNJI
										ball_direction_y <= 1;
									end
									if ((ball_x >= 138 && ball_x <= 255 && ball_y >= 33 && ball_y < 96) && (blok1 == 3'b010)) begin
										blok1 <= blok1 + 1;
										if (ball_x == 138 || ball_x == 255) begin
											ball_direction_x <= ball_direction_x + 1;
										end 
										else begin
											ball_direction_y <= ball_direction_y + 1;
										end
									end
										if ((ball_x >= 291 && ball_x <= 390 && ball_y >= 33 && ball_y < 96) && (blok2 == 3'b010)) begin
											blok2 <= blok2+1;
										if (ball_x == 291 || ball_x == 390) begin
											ball_direction_x <= ball_direction_x + 1;
										end 
										else begin
											ball_direction_y <= ball_direction_y + 1;
										end
									end
										if ((ball_x >= 462 && ball_x <= 543 && ball_y >= 33 && ball_y < 96) && (blok3 == 3'b010)) begin
											blok3 <= blok3+1;
											if (ball_x == 462 && ball_x == 543) begin
												ball_direction_x <= ball_direction_x + 1;
											end 
											else begin
												ball_direction_y <= ball_direction_y + 1;
											end
										end
								end
								
								
								else if(br_winova == 2)begin //treci level
									if (ball_x <= 36 ) begin // Ukljuèujuæi LIJEVI RUB
										ball_direction_x <= 1;
									end
									if (ball_x >= 605 ) begin // Ukljuèujuæi DESNI RUB
										ball_direction_x <= 0;
									end
									if (ball_y == 408 && ball_x >= (paddle_x - 6) && ball_x <= (paddle_x + 60))//odbijanje od ploèicu
										ball_direction_y <= 0; 
									if (ball_y <= 36 ) begin // Ukljuèujuæi RUB GORNJI
										ball_direction_y <= 1;
									end
									
									if ((ball_x >= 144 && ball_x <= 264 && ball_y >= 36 && ball_y < 96) && (blok1 == 3'b100)) begin
									blok1 <= blok1 + 1;
									if (ball_x == 144 || ball_x == 264) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
									end
									if ((ball_x >= 288 && ball_x <= 420 && ball_y >= 36 && ball_y < 96) && (blok2 == 3'b100)) begin
										blok2 <= blok2+1;
										if (ball_x == 288 || ball_x == 420) begin
											ball_direction_x <= ball_direction_x + 1;
										end 
										else begin
											ball_direction_y <= ball_direction_y + 1;
										end
									end
									if ((ball_x >= 432 && ball_x <= 552 && ball_y >= 36 && ball_y < 96) && (blok3 == 3'b100)) begin
										blok3 <= blok3+1;
										if (ball_x == 444 && ball_x == 552) begin
											ball_direction_x <= ball_direction_x + 1;
										end 
										else begin
											ball_direction_y <= ball_direction_y + 1;
										end
									end
								end
								
								// Ažuriranje X pozicije loptice
                        if (ball_direction_x == 1)
                            ball_x <= ball_x + ball_speed_x;
								else if(blok1==3'b001 && blok2==3'b001 && blok3==3'b001)begin
									ball_x <= 480; 
								end
								else if(blok1==3'b011 && blok2==3'b011 && blok3==3'b011)begin
									ball_x <= 480; 
								end
                        else
                            ball_x <= ball_x - ball_speed_x;

                        // Ažuriranje Y pozicije loptice
                        if (ball_direction_y == 1)
                            ball_y <= ball_y + ball_speed_y;
								else if(blok1==3'b001 && blok2==3'b001 && blok3==3'b001)begin
									ball_y <= 240; 
								end
								else if(blok1==3'b011 && blok2==3'b011 && blok3==3'b011)begin
									ball_y <= 240; 
								end
                        else
                            ball_y <= ball_y - ball_speed_y;
								
								//odbijanje od blokove, sve i livo i desno i gore i dole. promjena smjera 
//								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 48 && ball_y < 78) && (blok0 == 3'b000 || blok0 == 3'b010 || blok0 == 3'b100)) begin
//									blok0 <= blok0 + 1;
//									if (ball_x == 96 || ball_x == 156) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
//								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 48 && ball_y < 78) && (blok1 == 3'b000 || blok1 == 3'b010 || blok1 == 3'b100)) begin
//									blok1 <= blok1 + 1;
//									if (ball_x == 192 || ball_x == 252) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
//								if ((ball_x >= 299 && ball_x <= 348 && ball_y >= 48 && ball_y < 78) && (blok2 == 3'b000 || blok2 == 3'b010 || blok2 == 3'b100)) begin
//									blok2 <= blok2+1;
//									if (ball_x == 299 || ball_x == 348) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
//								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 48 && ball_y < 78) && (blok3 == 3'b000 || blok3 == 3'b010 || blok3 == 3'b100)) begin
//									blok3 <= blok3+1;
//									if (ball_x == 396 && ball_x == 456) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
//								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 96 && ball_y < 132) && (blok4 == 3'b000 || blok4 == 3'b010 || blok4 == 3'b100)) begin
//									blok4 <= blok4+1;
//									if (ball_x == 96 || ball_x == 156) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
//								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 96 && ball_y < 132) && (blok5 == 3'b000 || blok5 == 3'b010 || blok5 == 3'b100)) begin
//									blok5 <= blok5+1;
//									if (ball_x == 192 || ball_x == 252) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
//								if ((ball_x >= 300 && ball_x <= 348 && ball_y >= 96 && ball_y < 132) && (blok6 == 3'b000 || blok6 == 3'b010 || blok6 == 3'b100)) begin
//									blok6 <= blok6+1;
//									if (ball_x == 294 || ball_x == 348) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
//								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 96 && ball_y < 132) && (blok7 == 3'b000 || blok7 == 3'b010 || blok7 == 3'b100)) begin
//									blok7 <= blok7 + 1;
//									if (ball_x == 396 || ball_x == 456) begin
//										ball_direction_x <= ball_direction_x + 1;
//									end 
//									else begin
//										ball_direction_y <= ball_direction_y + 1;
//									end
//								end
								
								if(blok1==3'b001 && blok2==3'b001 && blok3==3'b001)begin
									//blok0<=3'b010;
									blok1<=3'b010;
									blok2<=3'b010;
									blok3<=3'b010;
//									blok4<=3'b010;
//									blok5<=3'b010;
//									blok6<=3'b010;
//									blok7<=3'b010;
									br_winova<=2'b01;
									
								end
								
								if(blok1==3'b011 && blok2==3'b011 && blok3==3'b011)begin
									//blok0<=3'b100;
									blok1<=3'b100;
									blok2<=3'b100;
									blok3<=3'b100;
//									blok4<=3'b100;
//									blok5<=3'b100;
//									blok6<=3'b100;
//									blok7<=3'b100;
									br_winova<=2'b10;
									
								end
								if(blok1==3'b101 && blok2==3'b101 && blok3==3'b101)begin
									br_winova<=2'b11;
								end
								if(level_change)begin
									ball_y <= 240; 
									ball_x <= 480;
								end
								
                        
								count <= 0;
                      end
                    end
                
            end
        end
    end
	

	

	always @(posedge CLK) begin
    if (blok1==3'b001 && blok2==3'b001 && blok3==3'b001 || blok1==3'b011 && blok2==3'b011 && blok3==3'b011) begin
        level_change <= 1;
    end else begin
        level_change <= 0;
    end
	 end
    // Generiranje clk25
    always @(posedge CLK) begin
        clk25 <= ~clk25;
    end

    // Ažuriranje h_counter i v_counter
    always @(posedge clk25) begin
        if (h_counter == H_TOTAL - 1)
            h_counter <= 0;
        else
            h_counter <= h_counter + 1;   
    end

    always @(posedge clk25) begin
        if (h_counter == H_TOTAL - 1) begin
            if (v_counter == V_TOTAL - 1)
                v_counter <= 0;
            else
                v_counter <= v_counter + 1;
        end
    end

    // Generiranje sync signala
    always @(posedge clk25) begin
            if(RST)begin
               hsync <=0;
               vsync <=0; 
            end
            else begin
					hsync <= (h_counter >= H_DISPLAY + H_FRONT_PORCH  && h_counter < H_DISPLAY + H_FRONT_PORCH + H_SYNC_WIDTH);
					vsync <= (v_counter >= V_DISPLAY + V_FRONT_PORCH  && v_counter < V_DISPLAY + V_FRONT_PORCH + V_SYNC_WIDTH);
				end
    end
    // Definiranje podruèja za prikaz
    wire display_area = (h_counter < H_DISPLAY) && (v_counter < V_DISPLAY);
    wire ball_area = (h_counter >= (ball_x - 5) && h_counter < (ball_x + 5) && v_counter >= (ball_y - 5) && v_counter < (ball_y + 5));
    wire paddle_area = (h_counter >= paddle_x && h_counter < (paddle_x + 51) && v_counter >= 430 && v_counter < 440);
	 wire left_border = (h_counter < 10 &&  v_counter < V_DISPLAY);
    wire right_border = (h_counter >= 630 && v_counter < V_DISPLAY);
    wire top_border = (h_counter < H_DISPLAY &&v_counter < 10);  
	 
	 wire w_area = (h_counter >= 160 && h_counter < 180 && v_counter >= 200 && v_counter < 240) ||
						(h_counter >= 180 && h_counter < 200 && v_counter >= 240 && v_counter < 260) ||
						(h_counter >= 200 && h_counter < 220 && v_counter >= 215 && v_counter < 240) ||
						(h_counter >= 220 && h_counter < 240 && v_counter >= 240 && v_counter < 260) ||
						(h_counter >= 240 && h_counter < 260 && v_counter >= 200 && v_counter < 240);
	 wire i_area = (h_counter >= 280 && h_counter < 300 && v_counter >= 200 && v_counter < 260);
	 wire n_area = (h_counter >= 320 && h_counter < 340 && v_counter >= 200 && v_counter < 260) ||
						(h_counter >= 340 && h_counter < 360 && v_counter >= 200 && v_counter < 220) ||
						(h_counter >= 360 && h_counter < 380 && v_counter >= 200 && v_counter < 260);

	 wire win_condition = (br_winova==2'b11);
	 wire lose = ball_y >= V_DISPLAY;
	 
    always @(posedge clk25) begin 
        if (display_area) begin
					if ( block_area1 && (blok1==3'b000 || blok1==3'b010 || blok1==3'b100)   
						|| block_area2 && (blok2==3'b000 || blok2==3'b010 || blok2==3'b100)
						|| block_area3 && (blok3==3'b000 || blok3==3'b010 || blok3==3'b100)) begin
								red <= 1;
								green <= 0;
								blue <= 1;
					end
					else if (ball_area) begin 
						red <= 0;
						green <= 1;
						blue <= 1;
               end
                 else if (win_condition)begin
                 	if (w_area || i_area || n_area) begin
							red <= 1;
							green <= 1;
							blue <= 1;
						end 
						else begin
							red <= 0;
							green <= 1;
							blue <= 1;
						end
          		end
                 else if (left_border || right_border || top_border) begin 
						red <= 1;
						green <= 1;
						blue <= 1;
					end
					else if (paddle_area) begin 
						red <= 1;
						green <= 1;
						blue <= 0;
					end
              	 else if(lose)begin
                 	red <= 0;
						green <= 0;
						blue <= 1;
            		end
					else begin
						red <= 0;
						green <= 0;
						blue <= 0;
					end
        end 
		 
		  else begin
            red <= 0;
            green <= 0;
            blue <= 0;
        end
    end

    assign VGA_HSYNC = hsync;
    assign VGA_VSYNC = vsync;
    assign VGA_R = red;
    assign VGA_G = green;
    assign VGA_B = blue;

endmodule
