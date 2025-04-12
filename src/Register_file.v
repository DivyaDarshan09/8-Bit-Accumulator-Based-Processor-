module RegisterFile (
    input clk,
    input we,              // Write enable
    input [7:0] addr,      // 8-bit address (256 locations)
    input [7:0] data_in,   // Data input
    output reg [7:0] data_out // Data output
);
    reg [7:0] registers [0:255]; // 256x8-bit memory

    always @(posedge clk) begin
        if (we) 
            registers[addr] <= data_in; // Write operation (non-blocking)
        data_out <= registers[addr]; // Read operation (non-blocking)
    end
endmodule
s