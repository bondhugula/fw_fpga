/**
 *
 * fw.v 
 *
 * $Id: fw.v,v 1.21 2005/10/06 20:22:42 osc0414 Exp $
 *
 * Top level module for the Floyd-Warshall Compute kernel
 *
 * Author: Uday Kumar Reddy Bondhugula
 *
 * Copyright (C) 2005 Uday Bondhugula
 *
 * Please see the LICENSE files for details.
 *
 */

`include "params.v"

module fw(

	clk,
	reset,

	inD,
	in_valid,

	outD,
	out_valid
);


input clk, reset, in_valid;
input [`L*`WIDTH-1 : 0] inD;

output [`L*`WIDTH-1 : 0] outD;
output out_valid;

wire [`L*`WIDTH-1:0] pe_connect[`B:0];
wire pe_out_valid[0:`B-1];
wire [`INSTR_WIDTH-1: 0] instr[0:`B]; 
wire [`INSTR_WIDTH-1: 0] instr_out;
wire [`L*`WIDTH-1:0] fw_control_dOut;

assign pe_connect[0] = fw_control_dOut;
assign instr[0] = instr_out;

assign outD = pe_connect[`B];
assign out_valid = pe_out_valid[`B-1];

fw_control fw_control_inst(
	.reset(reset),
	.clk(clk),
	.in_valid(in_valid),
	.inD(inD),
	.dOut(fw_control_dOut),
	.instr_out(instr_out)
);

generate
genvar i;
for (i=0; i<`B; i=i+1)
begin: pe_loop
	pe #i pe_inst(.reset(reset), 
		.clk(clk), 
		.instr_in(instr[i]),
		.in(pe_connect[i]), 
		.out(pe_connect[i+1]), 
		.out_valid(pe_out_valid[i]),
		.instr_out(instr[i+1]));
end
endgenerate

endmodule
