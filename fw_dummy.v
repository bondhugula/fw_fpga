/**
 *
 * fw.v 
 *
 * $Id: fw_dummy.v,v 1.1 2005/10/03 15:07:09 ananth Exp $
 *
 * Dummy top level module for the Floyd-Warshall Compute kernel
 *
 * Author: Uday Kumar Reddy Bondhugula
 *
 * Copyright (C) 2005 Uday Bondhugula
 *
 * Please see the LICENSE file for details.
 *
 */

`include "params.v"

module fw(

	clk,
	reset,
	enable,
	inhibit,
	phase,

	inD,
	in_valid,

	outD,
	out_valid
);


input clk, reset, enable, in_valid, inhibit;
input [`L*`WIDTH-1 : 0] inD;
input [1:0] phase;

output [`L*`WIDTH-1 : 0] outD;
output out_valid;

reg [`L*`WIDTH-1 : 0] outD;
reg [`L*`WIDTH-1 : 0] outD1;
reg [`L*`WIDTH-1 : 0] outD2;
reg [`L*`WIDTH-1 : 0] outD3;
reg [`L*`WIDTH-1 : 0] outD4;
reg [`L*`WIDTH-1 : 0] outD5;
reg [`L*`WIDTH-1 : 0] outD6;
reg [`L*`WIDTH-1 : 0] outD7;
reg out_valid = 1'b0;
reg out_valid1 = 1'b0;
reg out_valid2 = 1'b0;
reg out_valid3 = 1'b0;
reg out_valid4 = 1'b0;
reg out_valid5 = 1'b0;
reg out_valid6 = 1'b0;
reg out_valid7 = 1'b0;


always @(posedge clk)
begin
	if (reset)
	begin
		out_valid <= 0;
	end
	else
	begin
		outD1 <= inD;
		outD2 <= outD1;
		outD3 <= outD2;
		outD4 <= outD3;
		outD5 <= outD4;
		outD6 <= outD5;
		outD7 <= outD6;
		outD  <= outD7;
		out_valid1 <= in_valid;
		out_valid2 <= out_valid1;
		out_valid3 <= out_valid2;
		out_valid4 <= out_valid3;
		out_valid5 <= out_valid4;
		out_valid6 <= out_valid5;
		out_valid7 <= out_valid6;
		out_valid  <= out_valid7;
	end
end

endmodule
