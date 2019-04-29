
//
//
// $Id: fw_cd.v,v 1.2 2005/10/24 06:41:28 osc0414 Exp $
//
// FW Test bench
//
// Tests functionality under ideal conditions
//
// Uday Kumar Reddy Bondhugula
//
//
//

module fw_cd;

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
	phase = 2'b10;
	#10 reset = 0;
end

initial
begin: fw_input
	#25 in_valid = 1;

	// Input an 8x8 matrix
	//

/* Verilog Test Bench */
#10 fw_in = 64'h004e_0057_0054_0000;
#10 fw_in = 64'h0057_0024_005e_0010;
#10 fw_in = 64'h0041_0019_001c_0000;
#10 fw_in = 64'h0002_005f_003d_0059;
#10 fw_in = 64'h0016_0032_0000_005d;
#10 fw_in = 64'h003c_005b_001c_003f;
#10 fw_in = 64'h002c_0060_0000_003f;
#10 fw_in = 64'h0062_0028_004d_0055;
#10 fw_in = 64'h0029_0000_001b_0040;
#10 fw_in = 64'h000c_0025_0049_001b;
#10 fw_in = 64'h0033_0000_0025_0047;
#10 fw_in = 64'h0003_0060_0045_0004;
#10 fw_in = 64'h0000_001e_0044_0045;
#10 fw_in = 64'h0018_003f_001f_0053;
#10 fw_in = 64'h0000_0053_0006_0061;
#10 fw_in = 64'h0012_0047_0028_0034;
#10 fw_in = 64'h0003_001e_0024_0044;
#10 fw_in = 64'h0046_003b_0017_0000;
#10 fw_in = 64'h0058_002e_002f_0052;
#10 fw_in = 64'h005d_0023_000d_0000;
#10 fw_in = 64'h000c_0039_005e_0044;
#10 fw_in = 64'h004a_001e_0000_002b;
#10 fw_in = 64'h0009_000f_001e_0006;
#10 fw_in = 64'h0035_004f_0000_0037;
#10 fw_in = 64'h0026_0055_0014_0016;
#10 fw_in = 64'h0010_0000_0019_0063;
#10 fw_in = 64'h004d_0044_000e_001a;
#10 fw_in = 64'h0039_0000_001b_0064;
#10 fw_in = 64'h005c_001b_000e_0047;
#10 fw_in = 64'h0000_004a_0039_0051;
#10 fw_in = 64'h004f_0023_003a_0055;
#10 fw_in = 64'h0000_0044_0057_0021;

#10 in_valid = 0;
end 

endmodule











