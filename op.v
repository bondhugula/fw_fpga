//
// Copyright (C) 2005 Uday Bondhugula
//
// Please see the LICENSE files for details.
//
`include "params.v"

module op(

	in0,
 	in1,
 	in2,
 
	out0,
);

input [`WIDTH-1: 0] in0;
input [`WIDTH-1: 0] in1;
input [`WIDTH-1: 0] in2;

output [`WIDTH-1: 0] out0;

assign out0 = in2;
endmodule
