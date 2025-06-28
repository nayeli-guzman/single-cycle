module regfile (
	clk,
	we3,
	ra1,
	ra2,
	wa3,
	wd3,
	r15,
	rd1,
	rd2,
	rd3,
	wePostPre
);
	input wire clk;
	input wire we3;
	input wire [3:0] ra1;
	input wire [3:0] ra2;
	input wire [3:0] wa3;
	input wire wePostPre;
	
	input wire [31:0] wd3;
	input wire [31:0] r15;
	output wire [31:0] rd1;
	output wire [31:0] rd2;
	output wire [31:0] rd3;

	reg [31:0] rf [14:0];
	always @(posedge clk)
		if (we3) begin	
		  if(wePostPre)
		      rf[ra1] <= wd3;
		  else
       		  rf[wa3] <= wd3;
		end
	assign rd1 = (ra1 == 4'b1111 ? r15 : rf[ra1]);
	assign rd2 = (ra2 == 4'b1111 ? r15 : rf[ra2]);
	assign rd3 = (wa3 == 4'b1111 ? r15 : rf[wa3]);
endmodule

