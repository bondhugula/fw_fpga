//
// Copyright (C) 2005 Uday Bondhugula
// Copyright (C) 2005 Ananth Devulapalli
//
// Please see the LICENSE file for details.
//
`include "params.v"

module local_store(

	clk,
	we,
	a_r,
	a_w,
	di,

	dout,
);

parameter size = `B/`L;

input clk;
input we;
input [`ADDR_WIDTH-1: 0] a_r;
input [`ADDR_WIDTH-1: 0] a_w;
input [`L*`WIDTH-1: 0] di;

output [`L*`WIDTH-1: 0] dout;

reg [`L*`WIDTH-1: 0] ram[size-1: 0];
reg [`ADDR_WIDTH-1: 0] read_a;

always @(posedge clk)
begin
	if (we == 1'b1)
	begin
		ram[a_w] <= di;
	end
	read_a <= a_r;

end

assign dout = ram[read_a];

endmodule
