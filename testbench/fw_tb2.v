//
//
// $Id: fw_tb2.v,v 1.4 2005/10/03 21:01:33 osc0414 Exp $
//
// FW Test bench 2
//
// Tests bubbles in the pipeline for an 8x8 matrix
//
// Uday Kumar Reddy Bondhugula
//
//
//

module fw_tb2;

reg reset;
wire clk;

reg [63:0] fw_in;
reg in_valid;
reg [1:0] phase;

clock   clock(.reset(reset), .clk(clk));

fw		fw_inst(
	.reset(reset),
	.clk(clk),
	.phase(phase),
	.inhibit(),

	.inD(fw_in),
	.in_valid(in_valid),

	.outD(),
	.out_valid()
);

initial
begin
	reset = 1;
	in_valid = 0;
	phase = 2'b00;
	#10 reset = 0;
	#30 reset=1;
	#10 reset = 0;
end

initial
begin: fw_input
	#65 in_valid = 1;

	// 8x8 matrix with bubbles in the pipeline


	fw_in = 64'h004e_0057_0054_0000;
	#10 fw_in = 64'h0057_0024_005e_0010;

	#10 in_valid = 0;
	#10 in_valid = 1;

	fw_in = 64'h0045_0040_005d_0000;
	#10 fw_in = 64'h0047_0016_0044_0044;

	#10 fw_in = 64'h0016_0032_0000_005d;
	#10 fw_in = 64'h003c_005b_001c_003f;

	#10 fw_in = 64'h0044_001b_0000_0054;
	#10 fw_in = 64'h000e_0014_005e_0024;

	#10 fw_in = 64'h0029_0000_001b_0040;
	#10 fw_in = 64'h000c_0025_0049_001b;

	#10 fw_in = 64'h001e_0000_0032_0057;
	#10 fw_in = 64'h001b_0055_0039_001e;

	#10 fw_in = 64'h0000_001e_0044_0045;
	#10 fw_in = 64'h0018_003f_001f_0053;

	#10 fw_in = 64'h0000_0029_0016_004e;
	#10 fw_in = 64'h005c_0026_000c_0003;

	#10 fw_in = 64'h0003_001e_0024_0044;
	#10 in_valid = 0;
	#10 in_valid = 1;
	fw_in = 64'h0046_003b_0017_0000;

	#10 fw_in = 64'h0053_001b_003f_0010;
	#10 fw_in = 64'h0051_0063_002b_0000;

	#10 fw_in = 64'h000c_0039_005e_0044;
	#10 fw_in = 64'h004a_001e_0000_002b;

	#10 fw_in = 64'h001f_0049_001c_005e;
	#10 fw_in = 64'h0039_0019_0000_0017;

	#10 fw_in = 64'h0026_0055_0014_0016;
	#10 fw_in = 64'h0010_0000_0019_0063;

	#10 fw_in = 64'h003f_0025_005b_0024;
	#10 fw_in = 64'h004a_0000_001e_003b;

	#10 fw_in = 64'h005c_001b_000e_0047;
	#10 fw_in = 64'h0000_004a_0039_0051;

	#10 in_valid = 0;
	#10 in_valid = 0;
	#10 in_valid = 0;
	#10 in_valid = 1;

	fw_in = 64'h0018_000c_003c_0057;
	#10 fw_in = 64'h0000_0010_004a_0046;

	#10 in_valid = 0;
end 
endmodule
