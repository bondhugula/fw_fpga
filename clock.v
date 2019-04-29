//
// $Id: clock.v,v 1.3 2005/09/26 22:04:17 osc0414 Exp $
//
// clock.v
// This module defines a clock (not synthesiable)
//
// Copyright (C) 2005 Uday Bondhugula
// Copyright (C) 2005 Ananth Devulapalli
//
// Please see the LICENSE file for details.
//

`include	"params.v"

module clock( reset, clk );
parameter	half_period	= 5;

input	reset;
output	clk;
reg		clk;

initial
	clk	= 0;

always @(reset)
	if( reset )
		clk	= 0;

always
	#half_period	clk	= ~clk;

endmodule

