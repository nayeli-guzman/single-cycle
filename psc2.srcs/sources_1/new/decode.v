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
	Post,
	wePostPre
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
	output wire wePostPre;
	
	reg [11:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 13'b0000101001000;
				else
					controls = 13'b0000001001000;
			2'b01: // MEMORY
				if (Funct[0]) // LOAD
					controls = 13'b0001111000000;
				else begin// STORE
				    if (Funct[5]) // store con registro
				        controls = 12'b0001010100100;
                    else // store con imm
					    controls = 13'b1001110100000;
					if (~Funct[1] && ~Funct[4]) begin
					   controls[0] = 1;
					   controls[1] = 1; 
					   controls[7] = 0;
					   controls[6] = 1;
					end
					else if (Funct[1] && Funct[4]) begin
					   controls[0] = 1;
					   controls[7] = 0;
					   controls[6] = 1;
					end
			     end
			2'b10: controls = 13'b0110100010000;
			default: controls = 13'bxxxxxxxxxxxxx;
		endcase
		
		// 2 2 1 
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, Read3, Post, wePostPre} = controls;
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