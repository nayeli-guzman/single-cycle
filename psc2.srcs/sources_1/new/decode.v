module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl,
	Read3,
	Post
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [1:0] ALUControl;
	output wire Read3;
	output wire Post;
	
	reg [11:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 12'b000010100100;
				else
					controls = 12'b000000100100;
			2'b01: // MEMORY
				if (Funct[0]) // LOAD
					controls = 12'b000111100000;
				else begin// STORE
				    if (Funct[5]) // store con registro
				        controls = 12'b000101010010;
                    else // store con imm
					    controls = 12'b100111010000;
					if (~Funct[1] && ~Funct[4]) begin
					   controls[0] = 1; 
					   controls[6] = 0;
					   controls[5] = 1;
					end
			     end
			2'b10: controls = 12'b011010001000;
			default: controls = 12'bxxxxxxxxxxxx;
		endcase
		
		// 2 2 1 
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, Read3, Post} = controls;
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 2'b00;
				4'b0010: ALUControl = 2'b01;
				4'b0000: ALUControl = 2'b10;
				4'b1100: ALUControl = 2'b11;
				default: ALUControl = 2'bxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 2'b00) | (ALUControl == 2'b01));
		end
		else begin
			ALUControl = 2'b00;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule