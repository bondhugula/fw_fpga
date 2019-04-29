//
//
// $Id: fw_dd.v,v 1.1 2005/10/06 20:24:49 osc0414 Exp $
//
// FW Test bench
//
// Tests functionality under ideal conditions
//
// Uday Kumar Reddy Bondhugula
//
//
//

module fw_dd;

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
	phase = 2'b11;
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
   #10 fw_in = 64'h0006_0025_0000_001c;
   #10 fw_in = 64'h003a_000e_001e_002f;
   #10 fw_in = 64'h0053_0000_0060_0019;
   #10 fw_in = 64'h0023_0044_000f_002e;
   #10 fw_in = 64'h0000_0033_002c_0041;
   #10 fw_in = 64'h004f_004d_0009_0058;
   #10 fw_in = 64'h0034_0004_0055_0059;
   #10 fw_in = 64'h0021_0064_0037_0000;
   #10 fw_in = 64'h0028_0045_004d_003d;
   #10 fw_in = 64'h0057_001b_0000_000d;
   #10 fw_in = 64'h0047_0060_0028_005f;
   #10 fw_in = 64'h0044_0000_004f_0023;
   #10 fw_in = 64'h0012_0003_0062_0002;
   #10 fw_in = 64'h0000_0039_0035_005d;

   #10 fw_in = 64'h0036_0052_0014_0000;
   #10 fw_in = 64'h0059_0013_0045_001d;
   #10 fw_in = 64'h0057_004c_0000_0002;
   #10 fw_in = 64'h0041_002e_0009_0048;
   #10 fw_in = 64'h0042_0000_0029_0051;
   #10 fw_in = 64'h001d_002f_0010_0021;
   #10 fw_in = 64'h0000_000a_001e_0057;
   #10 fw_in = 64'h002a_0034_0029_001e;
   #10 fw_in = 64'h0007_001c_0020_002a;
   #10 fw_in = 64'h0033_0016_0032_0000;
   #10 fw_in = 64'h0054_0044_0012_0042;
   #10 fw_in = 64'h005e_0038_0000_0004;
   #10 fw_in = 64'h0014_0039_0062_005a;
   #10 fw_in = 64'h0001_0000_0061_0014;
   #10 fw_in = 64'h0019_0062_0048_002d;
   #10 fw_in = 64'h0000_0050_0018_0047;

   #10 fw_in = 64'h004e_0057_0054_0000;
   #10 fw_in = 64'h0057_0024_005e_0010;
   #10 fw_in = 64'h0016_0032_0000_005d;
   #10 fw_in = 64'h003c_005b_001c_003f;
   #10 fw_in = 64'h0029_0000_001b_0040;
   #10 fw_in = 64'h000c_0025_0049_001b;
   #10 fw_in = 64'h0000_001e_0044_0045;
   #10 fw_in = 64'h0018_003f_001f_0053;
   #10 fw_in = 64'h0003_001e_0024_0044;
   #10 fw_in = 64'h0046_003b_0017_0000;
   #10 fw_in = 64'h000c_0039_005e_0044;
   #10 fw_in = 64'h004a_001e_0000_002b;
   #10 fw_in = 64'h0026_0055_0014_0016;
   #10 fw_in = 64'h0010_0000_0019_0063;
   #10 fw_in = 64'h005c_001b_000e_0047;
   #10 fw_in = 64'h0000_004a_0039_0051;


   #10 in_valid = 0;
end 
endmodule
