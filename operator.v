/*
 * $Id: operator.v,v 1.5 2005/09/26 07:21:16 osc0414 Exp $
 *
 * Author: Uday Kumar Reddy Bondhugula
 *
 * Each operator comprises an adder and a multiplier
 *
 * Copyright (C) 2005 Uday Bondhugula
 *
 * Please see the LICENSE files for details.
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
