module Accumulator_CPU (
    input clk, reset,
    input we,                  // Write Enable for instruction loading
    input [3:0] instr_addr,     // Address to write instruction
    input [11:0] instr_in,      // Instruction input (4-bit opcode + 8-bit operand)
    output reg [7:0] AC,        // Accumulator
    output reg [3:0] PC         // Program Counter
);

    reg [11:0] instruction_mem [0:9]; // 10 instructions (modifiable via we)
    reg [3:0] opcode;
    reg [7:0] operand;
    reg [1:0] state; // FSM State
    
    // FSM States
    parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            AC <= 0;
            state <= FETCH;
        end else if (we) begin
            instruction_mem[instr_addr] <= instr_in; // Manual Instruction Loading
        end else begin
            case (state)
                FETCH: begin
                    {opcode, operand} <= instruction_mem[PC]; // Fetch instruction
                    PC <= PC + 1; // Increment PC
                    state <= DECODE;
                end
                DECODE: begin
                    state <= EXECUTE;
                end
                EXECUTE: begin
                    case (opcode)
                        4'b0001: AC <= operand;       // LOAD
                        4'b0010: AC <= AC + operand; // ADD
                        4'b0011: AC <= AC - operand; // SUB
                        4'b0100: AC <= AC & operand; // AND
                        4'b0101: AC <= AC | operand; // OR
                        4'b0110: AC <= AC ^ operand; // XOR
                        4'b0111: AC <= ~AC;          // NOT
                        4'b1000: AC <= AC << 1;      // SHL (Shift Left)
                        4'b1001: AC <= AC >> 1;      // SHR (Shift Right)
                        4'b1010: PC <= PC;           // HALT
                        default: ;
                    endcase
                    state <= (opcode == 4'b1010) ? FETCH : FETCH;
                end
            endcase
        end
    end
endmodule

