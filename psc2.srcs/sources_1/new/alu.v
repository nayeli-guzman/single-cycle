`timescale 1ns / 1ps

module alu(
    input  [31:0] a, b,
    input  [1:0] AluControl,
    output reg [31:0] Result,
    output wire [3:0] ALUFlags
);

    wire [31:0] condinvb;
    wire [32:0] sum;

    // Si ALUControl[0] es 1, invertimos b para hacer SUB (a + ~b + 1)
    assign condinvb = AluControl[0] ? ~b : b;

    // Suma con acarreo de un bit extra
    assign sum = a + condinvb + AluControl[0];

    always @(*) begin
        case (AluControl)
            2'b00, 3'b01: Result = sum[31:0];   // ADD o SUB
            2'b10:        Result = a & b;       // AND
            2'b11:        Result = a | b;       // OR
            //3'b100:        Result = a ^ b;       // EOR
            //3'b101:        Result = b;           // MOV
            default:      Result = 32'b0;
        endcase
    end

    // Flags
    wire neg      = Result[31];                   // negativo (bit más significativo)
    wire zero     = (Result == 32'b0);            // cero
    wire carry    = (AluControl[1] == 1'b0) && sum[32];  // acarreo solo para suma/resta (cuando ALUControl[1]==0)
    wire overflow = (AluControl[1] == 1'b0) &&
                    ~(a[31] ^ condinvb[31]) &&
                    (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};

endmodule