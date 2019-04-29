
//
//
// $Id: fw_rd.v,v 1.2 2005/10/24 06:41:25 osc0414 Exp $
//
// FW Test bench
//
// Tests functionality under ideal conditions
//
// Uday Kumar Reddy Bondhugula
//
//
//

module fw_rd;

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
	phase = 2'b01;
	#10 reset = 0;
end

initial
begin: fw_input
	#25 in_valid = 1;

	// Input an 8x8 matrix
	//

	/* Verilog Test Bench */
   fw_in = 64'h0061_0047_003f_0000;
   #10 fw_in = 64'h0055_001a_0006_0052;
   #10 fw_in = 64'h0045_0040_005d_0000;
   #10 fw_in = 64'h0047_0016_0044_0044;
   #10 fw_in = 64'h0006_0025_0000_001c;
   #10 fw_in = 64'h003a_000e_001e_002f;
   #10 fw_in = 64'h0044_001b_0000_0054;
   #10 fw_in = 64'h000e_0014_005e_0024;
   #10 fw_in = 64'h0053_0000_0060_0019;
   #10 fw_in = 64'h0023_0044_000f_002e;
   #10 fw_in = 64'h001e_0000_0032_0057;
   #10 fw_in = 64'h001b_0055_0039_001e;
   #10 fw_in = 64'h0000_0033_002c_0041;
   #10 fw_in = 64'h004f_004d_0009_0058;
   #10 fw_in = 64'h0000_0029_0016_004e;
   #10 fw_in = 64'h005c_0026_000c_0003;
   #10 fw_in = 64'h0034_0004_0055_0059;
   #10 fw_in = 64'h0021_0064_0037_0000;
   #10 fw_in = 64'h0053_001b_003f_0010;
   #10 fw_in = 64'h0051_0063_002b_0000;
   #10 fw_in = 64'h0028_0045_004d_003d;
   #10 fw_in = 64'h0057_001b_0000_000d;
   #10 fw_in = 64'h001f_0049_001c_005e;
   #10 fw_in = 64'h0039_0019_0000_0017;
   #10 fw_in = 64'h0047_0060_0028_005f;
   #10 fw_in = 64'h0044_0000_004f_0023;
   #10 fw_in = 64'h003f_0025_005b_0024;
   #10 fw_in = 64'h004a_0000_001e_003b;
   #10 fw_in = 64'h0012_0003_0062_0002;
   #10 fw_in = 64'h0000_0039_0035_005d;
   #10 fw_in = 64'h0018_000c_003c_0057;
   #10 fw_in = 64'h0000_0010_004a_0046;

   #170 in_valid = 0;
end 
endmodule
