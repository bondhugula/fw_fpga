//
// Copyright (C) 2005 Uday Bondhugula
//
// Please see the LICENSE file for details.
//
// Decodes the instruction and gives a command to the PE.
//
`include "params.v"

module pe_instr_decoder(
	instr_in,

	command,
);

parameter my_id = `logB'b0;

input [`INSTR_WIDTH-1: 0] instr_in;

output [`OP_WIDTH-1: 0] command;

reg [`OP_WIDTH-1: 0] command;
wire [`OP_WIDTH-1: 0] op;
wire [`logB-1: 0] id;

assign id = instr_in[`INSTR_WIDTH-2: `OP_WIDTH];
assign op = instr_in[`OP_WIDTH-1:0];
assign fwd = instr_in[`INSTR_WIDTH-1];

always @(*)
begin
	if (my_id < id)
	begin
		case (op)
		`READ0:
		begin
			command <= `FORWARD;
		end
		`READ1:
		begin
			command <= `FORWARD;
		end
		`COMPUTE:
		begin
			command <= `COMPUTE;
		end
		default:
		begin
			command <= `FORWARD;
		end
		endcase
	end
	else
	if (my_id == id)
	begin
		command <= op;
	end
	else
	begin
		if (op == `COMPUTE)
		begin
			command <= `COMPUTE;
		end
		else
		begin
			command <= `IDLE;
		end
	end
end

endmodule
