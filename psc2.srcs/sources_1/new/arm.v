module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	DataAdr,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] DataAdr;
//	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire Read3;
	wire wePostPre;
	
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [1:0] ALUControl;
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.Read3(Read3),
		.Post(Post),
		.wePostPre(wePostPre)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.Instr(Instr),
		.DataAdr(DataAdr),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.Read3(Read3),
		.Post(Post),
		.wePostPre(wePostPre)
	);
endmodule