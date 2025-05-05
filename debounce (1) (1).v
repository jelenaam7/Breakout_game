`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:46:13 07/02/2024 
// Design Name: 
// Module Name:    debounce 
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
module debounce (
    input wire CLK,       // Clock signal
    input wire btn_in,    // Input button signal
    output reg btn_out    // Debounced output button signal
);

    // Internal debounce parameters
    parameter DEBOUNCE_TIME = 100; // Debounce time in clock cycles
    
    // Internal state variables
    reg [16:0] counter;  // Counter for debounce
    reg btn_sync_0, btn_sync_1; // Synchronization flip-flops

    // Synchronize button input to clock
    always @(posedge CLK) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end

    // Debounce logic
    always @(posedge CLK) begin
        if (btn_sync_1 == btn_out) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter >= DEBOUNCE_TIME) begin
                counter <= 0;
                btn_out <= btn_sync_1;
            end
        end
    end
endmodule
