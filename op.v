/*
 * $Id: operator.v,v 1.5 2005/09/26 07:21:16 osc0414 Exp $
 *
 * Each operator comprises an adder and a multiplier
 *
 * Copyright (C) 2005 Uday Bondhugula
 * Copyright (C) 2005 Ananth Devulapalli
 *
 * Please see the LICENSE file for details.
 *
 */

`include "params.v"

module operator(

	inA,
	b,
	c,

	outA
);

input [`WIDTH-1:0] inA, b, c;
output [`WIDTH-1:0] outA;

assign outA = (b + c < inA)? (b + c): inA;

endmodule
