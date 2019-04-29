/*
 *
 * $Id: pivot_ram.v,v 1.5 2005/09/27 21:54:39 osc0414 Exp $
 *
 * BRAM for the pivot row or pivot column
 *
 * Author: Uday Kumar Reddy Bondhugula
 *
 * Copyright (C) 2005 Uday Bondhugula
 *
 * Please see the LICENSE file for details.
 *
 * FIXME: inhibit not taken care of yet.
 *
*/

`include "params.v"

module pivot_ram (
	clk, 
	we, 
	a_r, 
	a_w,
	di, 
	dout
);

input clk, we;
input [`ADDR_WIDTH-1: 0] a_r, a_w;
input [`L*`WIDTH-1:0] di;

output [`L*`WIDTH-1:0] dout;

reg [`L*`WIDTH-1:0] ram [0:`B/`L-1];
reg [`ADDR_WIDTH-1: 0] read_a;

always @(posedge clk) begin
	if (we)
		ram[a_w] <= di;
	read_a <= a_r;
end

assign dout = ram[read_a];

endmodule
