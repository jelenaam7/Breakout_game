
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:58 07/02/2024 
// Design Name: 
// Module Name:    breakout 
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
module breakout_display(
    input wire CLK,
    input wire RST,
    input wire LIJEVO,     // Ulaz za pomicanje plo�ice ulijevo
    input wire DESNO,      // Ulaz za pomicanje plo�ice udesno
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

    // Instanciranje debouncera za gumbe
    debounce debounce_LIJEVO (.CLK(CLK), .btn_in(LIJEVO), .btn_out(LIJEVO_debounced));
    debounce debounce_DESNO (.CLK(CLK), .btn_in(DESNO), .btn_out(DESNO_debounced));

    // Parametri za plo�icu
    reg [9:0] paddle_x = 320;
    reg [3:0] paddle_speed = 6;
	 
 

    // Broja� za usporavanje pomicanja plo�ice
    reg [19:0] paddle_counter = 0;
    wire paddle_enable = (paddle_counter == 0);

    // A�uriranje broja�a za usporavanje pomicanja plo�ice
    always @(posedge clk25) begin
        paddle_counter <= paddle_counter + 1;
    end
    // Pomicanje plo�ice
    always @(posedge clk25) begin
        if (paddle_enable) begin
            if (LIJEVO_debounced && paddle_x >= paddle_speed) // Pomicanje plo�ice ulijevo
                paddle_x <= paddle_x - paddle_speed;
            else if (DESNO_debounced && paddle_x <= H_DISPLAY - paddle_speed - 50) // Pomicanje plo�ice udesno
                paddle_x <= paddle_x + paddle_speed;
        end
    end
	 
	 
	 wire block_area0 = (h_counter >= 100 && h_counter < 150 && v_counter >= 50 && v_counter < 75);
    wire block_area1 = (h_counter >= 200 && h_counter < 250 && v_counter >= 50 && v_counter < 75);
    wire block_area2 = (h_counter >= 300 && h_counter < 350 && v_counter >= 50 && v_counter < 75);
    wire block_area3 = (h_counter >= 400 && h_counter < 450 && v_counter >= 50 && v_counter < 75);
    wire block_area4 = (h_counter >= 100 && h_counter < 150 && v_counter >= 100 && v_counter < 125);
    wire block_area5 = (h_counter >= 200 && h_counter < 250 && v_counter >= 100 && v_counter < 125);
    wire block_area6 = (h_counter >= 300 && h_counter < 350 && v_counter >= 100 && v_counter < 125);
    wire block_area7 = (h_counter >= 400 && h_counter < 450 && v_counter >= 100 && v_counter < 125);
	 wire block_area8 = (h_counter >= 100 && h_counter < 150 && v_counter >= 150 && v_counter < 175);
    wire block_area9 = (h_counter >= 200 && h_counter < 250 && v_counter >= 150 && v_counter < 175);
    wire block_area10 = (h_counter >= 300 && h_counter < 350 && v_counter >= 150 && v_counter < 175);
    wire block_area11 = (h_counter >= 400 && h_counter < 450 && v_counter >= 150 && v_counter < 175);
    wire block_area12 = (h_counter >= 100 && h_counter < 150 && v_counter >= 200 && v_counter < 225);
    wire block_area13 = (h_counter >= 200 && h_counter < 250 && v_counter >= 200 && v_counter < 225);
    wire block_area14 = (h_counter >= 300 && h_counter < 350 && v_counter >= 200 && v_counter < 225);
    wire block_area15 = (h_counter >= 400 && h_counter < 450 && v_counter >= 200 && v_counter < 225);
	 // registri za blokove
	 reg [2:0] blok0=0;
	 reg [2:0] blok1=0;
	 reg [2:0] blok2=0;
	 reg [2:0] blok3=0;
	 reg [2:0] blok4=0;
	 reg [2:0] blok5=0;
	 reg [2:0] blok6=0;
	 reg [2:0] blok7=0;
	 reg [2:0] blok8=0;
	 reg [2:0] blok9=0;
	 reg [2:0] blok10=0;
	 reg [2:0] blok11=0;
	 reg [2:0] blok12=0;
	 reg [2:0] blok13=0;
	 reg [2:0] blok14=0;
	 reg [2:0] blok15=0;
    // Parametri za lopticu
    reg [9:0] ball_x = 480; // Po�etna X pozicija loptice
    reg [9:0] ball_y = 240; // Po�etna Y pozicija loptice
    reg [3:0] ball_speed_x; // Brzina kretanja po X osi
    reg [3:0] ball_speed_y; // Brzina kretanja po Y osi
    reg ball_direction_x = 1; // Smjer kretanja po X osi (1: desno, 0: lijevo)
    reg ball_direction_y = 1; // Smjer kretanja po Y osi (1: dolje, 0: gore)
	 reg ball_moving=1;
	 //broj pobjeda
	 reg [1:0] br_winova=0;
	 
	 always @(posedge clk25)begin
		if(br_winova == 0)begin
			ball_speed_x <=3;
			ball_speed_y <=3;
		end
		else if(br_winova == 1)begin
			ball_speed_x<=6;
			ball_speed_y<=6;
		end
		else if(br_winova == 2)begin
			ball_speed_x<=12;
			ball_speed_y<=12;
		end
	
	 end

    // A�uriranje pozicije loptice zbog prebrzog micanja loptice
    reg [3:0] count = 0;

    always @(posedge clk25) begin
		if(RST)begin
			ball_x <= 480; 
         ball_y <= 240;
			blok0<=0;
			blok1<=0;
			blok2<=0;
			blok3<=0;
			blok4<=0; 
			blok5<=0;
			blok6<=0;
			blok7<=0;
			blok8<=0;
			blok9<=0;
			blok10<=0; 
			blok11<=0; 
			blok12<=0;
			blok13<=0;
			blok14<=0;
			blok15<=0;
			br_winova<=0;
		end 
		else begin	
			if (ball_moving) begin
            if (h_counter == H_TOTAL - 1) begin
                if (v_counter == V_TOTAL - 1) begin
							count <= count + 1;
                    if (count == 5) begin // A�uriraj svakih 5 ciklusa clk25
								if(br_winova == 0)begin
									if (ball_x <= 15 )  // Uklju�uju�i LIJEVI RUB
										ball_direction_x <= 1;
									if (ball_x >= 618 )  // Uklju�uju�i DESNI RUB
										ball_direction_x <= 0;
									if (ball_y >= 420 && ball_y <= 468 && ball_x >= (paddle_x - 6) && ball_x <= (paddle_x + 60))
										ball_direction_y <= 0; 
									if (ball_y <= 20 )  // Uklju�uju�i RUB GORNJI
										ball_direction_y <= 1;	
										

									if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 48 && ball_y < 78) && (blok0 == 3'b000 || blok0 == 3'b010 || blok0 == 3'b100)) begin
									blok0 <= blok0 + 1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 48 && ball_y < 78) && (blok1 == 3'b000 || blok1 == 3'b010 || blok1 == 3'b100)) begin
									blok1 <= blok1 + 1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 296 && ball_x <= 348 && ball_y >= 48 && ball_y < 78) && (blok2 == 3'b000 || blok2 == 3'b010 || blok2 == 3'b100)) begin
									blok2 <= blok2+1;
									if (ball_x == 296 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 48 && ball_y < 78) && (blok3 == 3'b000 || blok3 == 3'b010 || blok3 == 3'b100)) begin
									blok3 <= blok3+1;
									if (ball_x == 396 && ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 96 && ball_y < 132) && (blok4 == 3'b000 || blok4 == 3'b010 || blok4 == 3'b100)) begin
									blok4 <= blok4+1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 96 && ball_y < 132) && (blok5 == 3'b000 || blok5 == 3'b010 || blok5 == 3'b100)) begin
									blok5 <= blok5+1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 300 && ball_x <= 348 && ball_y >= 96 && ball_y < 132) && (blok6 == 3'b000 || blok6 == 3'b010 || blok6 == 3'b100)) begin
									blok6 <= blok6+1;
									if (ball_x == 294 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 96 && ball_y < 132) && (blok7 == 3'b000 || blok7 == 3'b010 || blok7 == 3'b100)) begin
									blok7 <= blok7 + 1;
									if (ball_x == 396 || ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 147 && ball_y < 180) && (blok8 == 3'b000 || blok8 == 3'b010 || blok8 == 3'b100)) begin
									blok8 <= blok8 + 1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 147 && ball_y < 180) && (blok9 == 3'b000 || blok9 == 3'b010 || blok9 == 3'b100)) begin
									blok9 <= blok9 + 1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 299 && ball_x <= 348 && ball_y >= 147 && ball_y < 180) && (blok10 == 3'b000 || blok10 == 3'b010 || blok10 == 3'b100)) begin
									blok10 <= blok10+1;
									if (ball_x == 299 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 147 && ball_y < 180) && (blok11 == 3'b000 ||blok11 == 3'b010 || blok11 == 3'b100)) begin
									blok11 <= blok11+1;
									if (ball_x == 396 && ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 195 && ball_y < 231) && (blok12 == 3'b000 || blok12 == 3'b010 || blok12 == 3'b100)) begin
									blok12 <= blok12 +1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 195 && ball_y < 231) && (blok13 == 3'b000 || blok13 == 3'b010 || blok13 == 3'b100)) begin
									blok13 <= blok13+1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 300 && ball_x <= 348 && ball_y >= 195 && ball_y < 231) && (blok14 == 3'b000 || blok14 == 3'b010 || blok14 == 3'b100)) begin
									blok14 <= blok14+1;
									if (ball_x == 294 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 195 && ball_y < 231) && (blok15 == 3'b000 || blok15 == 3'b010 || blok15 == 3'b100)) begin
									blok15 <= blok15 + 1;
									if (ball_x == 396 || ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								end
								else if(br_winova == 1)begin
									if (ball_x <= 18  ) begin // Uklju�uju�i LIJEVI RUB
										ball_direction_x <= 1;
									end
									if (ball_x >= 618 ) begin // Uklju�uju�i DESNI RUB
										ball_direction_x <= 0;
									end
									if (ball_y >= 414 && ball_y <= 468 && ball_x >= (paddle_x - 6) && ball_x <= (paddle_x + 60))
										ball_direction_y <= 0; 
									if (ball_y <= 24 ) begin // Uklju�uju�i RUB GORNJI
										ball_direction_y <= 1;
									end
									if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 48 && ball_y < 78) && (blok0 == 3'b000 || blok0 == 3'b010 || blok0 == 3'b100)) begin
									blok0 <= blok0 + 1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 48 && ball_y < 78) && (blok1 == 3'b000 || blok1 == 3'b010 || blok1 == 3'b100)) begin
									blok1 <= blok1 + 1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 299 && ball_x <= 348 && ball_y >= 48 && ball_y < 78) && (blok2 == 3'b000 || blok2 == 3'b010 || blok2 == 3'b100)) begin
									blok2 <= blok2+1;
									if (ball_x == 299 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 48 && ball_y < 78) && (blok3 == 3'b000 || blok3 == 3'b010 || blok3 == 3'b100)) begin
									blok3 <= blok3+1;
									if (ball_x == 396 && ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 96 && ball_y < 132) && (blok4 == 3'b000 || blok4 == 3'b010 || blok4 == 3'b100)) begin
									blok4 <= blok4+1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 96 && ball_y < 132) && (blok5 == 3'b000 || blok5 == 3'b010 || blok5 == 3'b100)) begin
									blok5 <= blok5+1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 300 && ball_x <= 348 && ball_y >= 96 && ball_y < 132) && (blok6 == 3'b000 || blok6 == 3'b010 || blok6 == 3'b100)) begin
									blok6 <= blok6+1;
									if (ball_x == 294 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 96 && ball_y < 132) && (blok7 == 3'b000 || blok7 == 3'b010 || blok7 == 3'b100)) begin
									blok7 <= blok7 + 1;
									if (ball_x == 396 || ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 147 && ball_y < 180) && (blok8 == 3'b000 || blok8 == 3'b010 || blok8 == 3'b100)) begin
									blok8 <= blok8 + 1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 147 && ball_y < 180) && (blok9 == 3'b000 || blok9 == 3'b010 || blok9 == 3'b100)) begin
									blok9 <= blok9 + 1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 299 && ball_x <= 348 && ball_y >= 147 && ball_y < 180) && (blok10 == 3'b000 || blok10 == 3'b010 || blok10 == 3'b100)) begin
									blok10 <= blok10+1;
									if (ball_x == 299 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 147 && ball_y < 180) && (blok11 == 3'b000 ||blok11 == 3'b010 || blok11 == 3'b100)) begin
									blok11 <= blok11+1;
									if (ball_x == 396 && ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 195 && ball_y < 231) && (blok12 == 3'b000 || blok12 == 3'b010 || blok12 == 3'b100)) begin
									blok12 <= blok12 +1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 195 && ball_y < 231) && (blok13 == 3'b000 || blok13 == 3'b010 || blok13 == 3'b100)) begin
									blok13 <= blok13+1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 300 && ball_x <= 348 && ball_y >= 195 && ball_y < 231) && (blok14 == 3'b000 || blok14 == 3'b010 || blok14 == 3'b100)) begin
									blok14 <= blok14+1;
									if (ball_x == 294 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 195 && ball_y < 231) && (blok15 == 3'b000 || blok15 == 3'b010 || blok15 == 3'b100)) begin
									blok15 <= blok15 + 1;
									if (ball_x == 396 || ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								end
								else if(br_winova == 2)begin
									if (ball_x <= 24 ) begin // Uklju�uju�i LIJEVI RUB
										ball_direction_x <= 1;
									end
									if (ball_x >= 605 ) begin // Uklju�uju�i DESNI RUB
										ball_direction_x <= 0;
									end
									if (ball_y >= 402 && ball_y <= 468 && ball_x >= (paddle_x - 6) && ball_x <= (paddle_x + 60))
										ball_direction_y <= 0; 
									if (ball_y <= 36 ) begin // Uklju�uju�i RUB GORNJI
										ball_direction_y <= 1;
									end
									if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 48 && ball_y < 78) && (blok0 == 3'b000 || blok0 == 3'b010 || blok0 == 3'b100)) begin
									blok0 <= blok0 + 1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 48 && ball_y < 78) && (blok1 == 3'b000 || blok1 == 3'b010 || blok1 == 3'b100)) begin
									blok1 <= blok1 + 1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 299 && ball_x <= 348 && ball_y >= 48 && ball_y < 78) && (blok2 == 3'b000 || blok2 == 3'b010 || blok2 == 3'b100)) begin
									blok2 <= blok2+1;
									if (ball_x == 299 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 48 && ball_y < 78) && (blok3 == 3'b000 || blok3 == 3'b010 || blok3 == 3'b100)) begin
									blok3 <= blok3+1;
									if (ball_x == 396 && ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 96 && ball_y < 132) && (blok4 == 3'b000 || blok4 == 3'b010 || blok4 == 3'b100)) begin
									blok4 <= blok4+1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 96 && ball_y < 132) && (blok5 == 3'b000 || blok5 == 3'b010 || blok5 == 3'b100)) begin
									blok5 <= blok5+1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 300 && ball_x <= 348 && ball_y >= 96 && ball_y < 132) && (blok6 == 3'b000 || blok6 == 3'b010 || blok6 == 3'b100)) begin
									blok6 <= blok6+1;
									if (ball_x == 294 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 96 && ball_y < 132) && (blok7 == 3'b000 || blok7 == 3'b010 || blok7 == 3'b100)) begin
									blok7 <= blok7 + 1;
									if (ball_x == 396 || ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 147 && ball_y < 180) && (blok8 == 3'b000 || blok8 == 3'b010 || blok8 == 3'b100)) begin
									blok8 <= blok8 + 1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 147 && ball_y < 180) && (blok9 == 3'b000 || blok9 == 3'b010 || blok9 == 3'b100)) begin
									blok9 <= blok9 + 1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 299 && ball_x <= 348 && ball_y >= 147 && ball_y < 180) && (blok10 == 3'b000 || blok10 == 3'b010 || blok10 == 3'b100)) begin
									blok10 <= blok10+1;
									if (ball_x == 299 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 147 && ball_y < 180) && (blok11 == 3'b000 ||blok11 == 3'b010 || blok11 == 3'b100)) begin
									blok11 <= blok11+1;
									if (ball_x == 396 && ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 96 && ball_x <= 156 && ball_y >= 195 && ball_y < 231) && (blok12 == 3'b000 || blok12 == 3'b010 || blok12 == 3'b100)) begin
									blok12 <= blok12 +1;
									if (ball_x == 96 || ball_x == 156) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 192 && ball_x <= 252 && ball_y >= 195 && ball_y < 231) && (blok13 == 3'b000 || blok13 == 3'b010 || blok13 == 3'b100)) begin
									blok13 <= blok13+1;
									if (ball_x == 192 || ball_x == 252) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 300 && ball_x <= 348 && ball_y >= 195 && ball_y < 231) && (blok14 == 3'b000 || blok14 == 3'b010 || blok14 == 3'b100)) begin
									blok14 <= blok14+1;
									if (ball_x == 294 || ball_x == 348) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								if ((ball_x >= 396 && ball_x <= 456 && ball_y >= 195 && ball_y < 231) && (blok15 == 3'b000 || blok15 == 3'b010 || blok15 == 3'b100)) begin
									blok15 <= blok15 + 1;
									if (ball_x == 396 || ball_x == 456) begin
										ball_direction_x <= ball_direction_x + 1;
									end 
									else begin
										ball_direction_y <= ball_direction_y + 1;
									end
								end
								end
								
								
								
								if(blok0 == 3'b001 && blok1==3'b001 && blok2==3'b001 && blok3==3'b001 && blok4==3'b001 && blok5==3'b001 && blok6==3'b001 && blok7==3'b001 && blok8==3'b001 && blok9==3'b001  && blok10==3'b001 && blok11==3'b001 && blok12==3'b001 && blok13==3'b001 && blok14==3'b001 && blok15==3'b001)begin
									blok0<=3'b010;
									blok1<=3'b010;
									blok2<=3'b010;
									blok3<=3'b010;
									blok4<=3'b010;
									blok5<=3'b010;
									blok6<=3'b010;
									blok7<=3'b010;
									blok8<=3'b010;
									blok9<=3'b010;
									blok10<=3'b010;
									blok11<=3'b010;
									blok12<=3'b010;
									blok13<=3'b010;
									blok14<=3'b010;
									blok15<=3'b010;
									br_winova<=2'b01;
									ball_x <= 480; 
									ball_y <= 240;
								end
								if(blok0 == 3'b011 && blok1==3'b011 && blok2==3'b011 && blok3==3'b011 && blok4==3'b011 && blok5==3'b011 && blok6==3'b011 && blok7==3'b011 && blok8==3'b011 && blok9==3'b011  && blok10==3'b011 && blok11==3'b011 && blok12==3'b011 && blok13==3'b011 && blok14==3'b011 && blok15==3'b011)begin
									blok0<=3'b100;
									blok1<=3'b100;
									blok2<=3'b100;
									blok3<=3'b100;
									blok4<=3'b100;
									blok5<=3'b100;
									blok6<=3'b100;
									blok7<=3'b100;
									blok8<=3'b100;
									blok9<=3'b100;
									blok10<=3'b100;
									blok11<=3'b100;
									blok12<=3'b100;
									blok13<=3'b100;
									blok14<=3'b100;
									blok15<=3'b100;
									br_winova<=2'b10;
									ball_x <= 480; 
									ball_y <= 240;
								end
								if(blok0 == 3'b101 && blok1==3'b101 && blok2==3'b101 && blok3==3'b101 && blok4==3'b101 && blok5==3'b101 && blok6==3'b101 && blok7==3'b101 && blok8==3'b101 && blok9==3'b101  && blok10==3'b101 && blok11==3'b101 && blok12==3'b101 && blok13==3'b101 && blok14==3'b101 && blok15==3'b101)begin
									br_winova<=2'b11;
								end
								 
                        // A�uriranje X pozicije loptice
                        if (ball_direction_x == 1)
                            ball_x <= ball_x + ball_speed_x;
                        else
                            ball_x <= ball_x - ball_speed_x;

                        // A�uriranje Y pozicije loptice
                        if (ball_direction_y == 1)
                            ball_y <= ball_y + ball_speed_y;
                        else
                            ball_y <= ball_y - ball_speed_y;
								count <= 0;
                           end
                    end
                end
            end
        end
    end
    // Generiranje clk25
    always @(posedge CLK) begin
        clk25 <= ~clk25;
    end

    // A�uriranje h_counter i v_counter
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
					hsync <= (h_counter >= (H_DISPLAY + H_FRONT_PORCH) && h_counter < (H_DISPLAY + H_FRONT_PORCH + H_SYNC_WIDTH));
					vsync <= (v_counter >= (V_DISPLAY + V_FRONT_PORCH) && v_counter < (V_DISPLAY + V_FRONT_PORCH + V_SYNC_WIDTH));
				end
     end
	  
	  
	  
    wire display_area = (h_counter < H_DISPLAY) && (v_counter < V_DISPLAY);
    wire ball_area = (h_counter >= (ball_x - 5) && h_counter < (ball_x + 5) && v_counter >= (ball_y - 5) && v_counter < (ball_y + 5));
    wire paddle_area = (h_counter >= paddle_x && h_counter < (paddle_x + 51) && v_counter >= 430 && v_counter < 440);
	 wire left_border = (h_counter >= 0 && h_counter < 10 && v_counter < V_DISPLAY);
    wire right_border = (h_counter >= (H_DISPLAY - 10) && h_counter < H_DISPLAY && v_counter < V_DISPLAY);
    wire top_border = (h_counter < H_DISPLAY && v_counter >= 0 && v_counter < 10);  
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
					if (  block_area0 && (blok0==3'b000 || blok0==3'b010 || blok0==3'b100) || block_area1 && (blok1==3'b000 || blok1==3'b010 || blok1==3'b100)   
						|| block_area2 && (blok2==3'b000 || blok2==3'b010 || blok2==3'b100) || block_area3 && (blok3==3'b000 || blok3==3'b010 || blok3==3'b100)
						|| block_area4 && (blok4==3'b000 || blok4==3'b010 || blok4==3'b100) || block_area5 && (blok5==3'b000 || blok5==3'b010 || blok5==3'b100) 
						|| block_area6 && (blok6==3'b000 || blok6==3'b010 || blok6==3'b100) || block_area7 && (blok7==3'b000 || blok7==3'b010 || blok7==3'b100)
						|| block_area8 && (blok8==3'b000 || blok8==3'b010 || blok8==3'b100) || block_area9 && (blok9==3'b000 || blok9==3'b010 || blok9==3'b100)
						|| block_area10 && (blok10==3'b000 || blok10==3'b010 || blok10==3'b100) || block_area11 && (blok11==3'b000 || blok11==3'b010 || blok11==3'b100)
						|| block_area12 && (blok12==3'b000 || blok12==3'b010 || blok12==3'b100) || block_area13 && (blok13==3'b000 || blok13==3'b010 || blok13==3'b100)
						|| block_area14 && (blok14==3'b000 || blok14==3'b010 || blok14==3'b100) || block_area15 && (blok15==3'b000 || blok15==3'b010 || blok15==3'b100)) begin
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
