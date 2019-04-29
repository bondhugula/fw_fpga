/*
 * An FW Processing element
 * 
 * $Id: pe.v,v 1.63 2005/10/07 17:08:31 osc0414 Exp $
 *
 * Copyright (C) 2005 Uday Bondhugula
 * Copyright (C) 2005 Ananth Devulapalli
 *
 * Please see the LICENSE file for details.
 *
 * FIXME: inhibit not taken care of yet.
 */

`include "params.v"

module pe(

	reset,
	clk,
	in,
	instr_in,

	out,
	out_valid,
	instr_out
);


// This PE's ID in the linear array
parameter id = `logB'b0;

input reset, clk;
input [`L*`WIDTH-1: 0] in;
input [`INSTR_WIDTH-1: 0]  instr_in;

output [`L*`WIDTH-1:0] out;
output out_valid;
output [`INSTR_WIDTH-1: 0] instr_out;


reg [`INSTR_WIDTH-1: 0] instr_out1;
reg [`INSTR_WIDTH-1: 0] instr_out2;
reg [`INSTR_WIDTH-1: 0] instr_out3;

wire [`OP_WIDTH-1: 0] command1;
reg [`OP_WIDTH-1: 0] command2;
reg [`OP_WIDTH-1: 0] command3;

wire [`L*`WIDTH-1: 0] in1;
reg [`L*`WIDTH-1: 0] in2;
reg [`L*`WIDTH-1: 0] in3;
wire [`L*`WIDTH-1: 0] out0;
reg [`L*`WIDTH-1: 0] d0;
reg [`L*`WIDTH-1: 0] d1;

reg [`L*`WIDTH-1: 0] out;
reg out_valid;

// addresses for local store read/writes 
reg [`ADDR_WIDTH-1: 0] ls0_raddr;
reg [`ADDR_WIDTH-1: 0] ls0_waddr;
reg [`ADDR_WIDTH-1: 0] ls1_raddr;
reg [`ADDR_WIDTH-1: 0] ls1_waddr;

// write enables for the local stores 
reg ls0_we;
reg ls1_we;

wire [`L*`WIDTH-1: 0] ls0_dOut;
reg [`L*`WIDTH-1: 0] ls0_dIn;
wire [`L*`WIDTH-1: 0] ls1_dOut;
reg [`L*`WIDTH-1: 0] ls1_dIn;
reg [`ADDR_WIDTH-1: 0] addr0;
wire [`ADDR_WIDTH-1: 0] addr1;

reg [`logL-1: 0] part_select;

// A 3 stage pipeline for the PE 
always @(posedge clk, posedge reset)
begin
	if (reset == 1'b1)
	begin
		ls0_waddr <= {`ADDR_WIDTH {1'b1}};
		ls1_waddr <= {`ADDR_WIDTH {1'b1}};

		addr0 <= 0;
		ls0_we <= 0;
		ls1_we <= 0;

		in2 <= `L*`WIDTH'b0;
		in3 <= `L*`WIDTH'b0;

		instr_out1 <= {`logB'b0, `IDLE};
		instr_out2 <= {`logB'b0, `IDLE};
		instr_out3 <= {`logB'b0, `IDLE};

		out <= {`L*`WIDTH{1'b1}};
		out_valid <= 1'b0;

	end
	else
	begin
		// First stage of the pipeline 
		// Decode instruction and generate read/write addresses 
		// local store 
		case(command1)
		`READ0:
		begin
			ls0_waddr <= ls0_waddr + 1'b1;
			ls0_we <= 1'b1;
			ls1_we <= 1'b0;
			ls0_dIn <= in1;
		end
		`READ1:
		begin
			ls1_waddr <= ls1_waddr + 1'b1;
			ls0_we <= 1'b0;
			ls1_we <= 1'b1;
			ls1_dIn <= in1;
		end
		`COMPUTE:
		begin
			ls0_we <= 1'b0;
			ls1_we <= 1'b0;
			addr0 <= addr0 + 1'b1;
			part_select <= instr_in[`OP_WIDTH + `logL - 1: `OP_WIDTH];
			in2 <= in1;
		end
		`FORWARD:
		begin
			ls0_we <= 1'b0;
			ls1_we <= 1'b0;
			in2 <= in1;
		end
		default:
		begin
			ls0_we <= 1'b0;
			ls1_we <= 1'b0;
			in2 <= in1;
		end
		endcase

		// Second stage of the pipeline 
		// read from local store 
		case(command2)
		`COMPUTE:
		begin
			d0 <= ls0_dOut;
			d1[1*`WIDTH-1: 0*`WIDTH] <= ls1_dOut[part_select*`WIDTH +: `WIDTH];
			d1[2*`WIDTH-1: 1*`WIDTH] <= ls1_dOut[part_select*`WIDTH +: `WIDTH];
			d1[3*`WIDTH-1: 2*`WIDTH] <= ls1_dOut[part_select*`WIDTH +: `WIDTH];
			d1[4*`WIDTH-1: 3*`WIDTH] <= ls1_dOut[part_select*`WIDTH +: `WIDTH];
			in3 <= in2;
		end
		default:
		begin
			d0 <= `L*`WIDTH'b0;
			d1 <= `L*`WIDTH'b0;
			in3 <= in2;
		end
		endcase


		// third stage of the pipeline 
		// perform the operation and get/send the result 
		case(command3)
		`COMPUTE:
		begin
			out <= out0;
			out_valid <= 1'b1;
		end
		`FORWARD:
		begin
			out <= in3;
			out_valid <= 1'b1;
		end
		default:
		begin
			out <= `L*`WIDTH'b0;
			out_valid <= 1'b0;
		end
		endcase
		instr_out1 <= instr_in;
		instr_out2 <= instr_out1;
		instr_out3 <= instr_out2;
		command2 <= command1;
		command3 <= command2;
	end
end


generate
genvar i;
for (i=0; i<`L; i=i+1)
begin: op_array
	op op_inst(
	.in0(in3[(i+1)*`WIDTH-1 : i*`WIDTH]),
	.in1(d0[(i+1)*`WIDTH-1 : i*`WIDTH]),
	.in2(d1[(i+1)*`WIDTH-1 : i*`WIDTH]),
	.out0(out0[(i+1)*`WIDTH-1 : i*`WIDTH]));
end
endgenerate

assign addr1 = instr_in[`INSTR_WIDTH-2: `OP_WIDTH + `logL];
always @(*)
begin
	if (command1 == `COMPUTE)
	begin
		ls0_raddr <= addr0;
		ls1_raddr <= addr1;
	end
	else
	begin
		ls0_raddr <= 0;
		ls1_raddr <= 0;
	end
end
assign instr_out = instr_out3;
assign in1 = in;

// Instantiate the local stores 
local_store #(`B*`B/`L/`B) ls0(
	.clk(clk),
	.we(ls0_we),
	.a_r(ls0_raddr),
	.a_w(ls0_waddr),
	.di(ls0_dIn),
	.dout(ls0_dOut)
);


local_store #(`B*`B/`L/`B) ls1(
	.clk(clk),
	.we(ls1_we),
	.a_r(ls1_raddr),
	.a_w(ls1_waddr),
	.di(ls1_dIn),
	.dout(ls1_dOut)
);


// Instantiate the instruction decoder 
pe_instr_decoder #id pe_instr_decoder_inst(
	.instr_in(instr_in),
	.command(command1)
);
endmodule
