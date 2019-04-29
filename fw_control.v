/*
*
* $Id: fw_control.v,v 1.22 2005/10/24 06:39:05 osc0414 Exp $
*
* Creates control instructions for the array of PEs 
*
* check pe_instr_decoder.v for instruction format
*
* Copyright (C) 2005 Uday Bondhugula
* Copyright (C) 2005 Ananth Devulapalli
*
* Please see the LICENSE file for details.
*
*/

`include "params.v"

`define READ_PHASE 1'b0
`define SEND_PHASE 1'b1
`define PROCESS_PHASE `SEND_PHASE

module fw_control(
	in_valid,
	inD,
	reset,
	clk,

	instr_out,
	dOut
);

input reset, in_valid, clk;
input [`L*`WIDTH-1: 0] inD;
/* the type of block we are processing */


output [`INSTR_WIDTH-1: 0] instr_out;
output [`L*`WIDTH-1: 0] dOut;

reg [`INSTR_WIDTH-1: 0] instr_out = {`logB'b0, `IDLE};
reg [`L*`WIDTH-1: 0] dOut;
reg [1:0] phase;

/* FSM for instruction encoding */
// there are basically two kinds of instructions
reg state = `READ_PHASE;

reg [`OP_WIDTH-1: 0] op = `READ_ROW;
reg [`logB-1: 0] id = `logB'b0;

/* We need a mod(2B^2/L) and a mod(B^2/L) counter */
reg [(1+2*`logB-`logL-1): 0] counter1 = 0;
reg [(2*`logB-`logL-1): 0] counter2 = 0;

reg fwd = 1'b1;
reg fwd1 = 1'b0;

always @(posedge clk, posedge reset)
begin
	if (reset)
	begin
		instr_out <= {`logB'b0, `IDLE};
		op <= `READ_ROW;
		id <= 0;
		state <= `READ_PHASE;
		counter1 <= 0;
		counter2 <= 0;
		dOut <= {`L*`WIDTH{1'b1}};

		fwd <= 1'b1;
		fwd1 <= 1'b0;
	end
	else
	begin
		/* The READ_PHASE is 2*B*B/L clock cycles and the SEND_PHASE is
		* B*B/L clock cycles with stalls inserted whenever we don't have
		* valid data (even for SEND_CASE in order to maintain the same
		* latency for all kinds of tiles.
		*/
	   if (in_valid)
	   begin
		   case (phase)
			   `SELF_DEP:
				begin
					case (state)
						`READ_PHASE: 
						begin
							counter1 <= counter1 + 1'b1;

							if (counter1%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								// flip the last bit to make read_row read_col
								// and vice versa
								op <= op^1'b1;
							end

							if (counter1%(2*`B/`L) == {1+`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							if (counter1 == 2*`B*`B/`L-1'b1)
							begin
								state <= `SEND_PHASE;
								op <= `SEND_ROW;
							end
							instr_out <= {1'b0, id, op};
						end
						`SEND_PHASE:
						begin
							counter2 <= counter2 + 1'b1;
							op <= `SEND_ROW;

							if (counter2%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							if (counter2 == `B*`B/`L-1'b1)
							begin
								state <= `READ_PHASE;
								op <= `READ_ROW;
							end
							instr_out <= {1'b0, id, op};
						end
					endcase
				end
				`DOUBLY_DEP:
				begin
					case (state)
						`READ_PHASE:
						begin
							counter1 <= counter1 + 1'b1;

							if (counter1%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							if (counter1 == `B*`B/`L-1'b1)
							begin
								op <= `READ_COL;
							end

							if (counter1 == 2*`B*`B/`L-1'b1)
							begin
								op <= `PROCESS_ROW;
								state <= `PROCESS_PHASE;
							end

							instr_out <= {1'b1, id, op};
						end
						`PROCESS_PHASE:
						begin
							counter2 <= counter2 + 1'b1;

							if (counter2 == `B*`B/`L-1'b1)
							begin
								state <= `READ_PHASE;
								op <= `READ_ROW;
							end

							if (counter2%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							instr_out <= {1'b0, id, op};
						end
					endcase // DOUBLY_DEP
				end
				`ROW_DEP:
				begin
					case (state)
						`READ_PHASE:
						begin
							counter1 <= counter1 + 1'b1;

							if (counter1%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								op <= op^1'b1;
								fwd <= fwd^1'b1;
							end

							if (counter1%(2*`B/`L) == {1+`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							if (counter1 == 2*`B*`B/`L-1'b1)
							begin
								op <= `SEND_COL;
								state <= `PROCESS_PHASE;
							end

							instr_out <= {fwd, id, op};
						end
						`PROCESS_PHASE:
						begin
							counter2 <= counter2 + 1'b1;

							if (counter2%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							if (counter2 == `B*`B/`L-1'b1)
							begin
								op <= `READ_ROW;
								state <= `READ_PHASE;
							end
							// everyone does process row
							instr_out <= {1'b0, id, op};
						end
					endcase
				end
				`COL_DEP:
				begin
					case (state)
						`READ_PHASE:
						begin
							counter1 <= counter1 + 1'b1;

							if (counter1%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								op <= op^1'b1;
								fwd1 <= fwd1^1'b1;
							end

							if (counter1%(2*`B/`L) == {1+`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							if (counter1 == 2*`B*`B/`L-1'b1)
							begin
								op <= `SEND_ROW;
								state <= `PROCESS_PHASE;
							end

							instr_out <= {fwd1, id, op};
						end
						`PROCESS_PHASE:
						begin
							counter2 <= counter2 + 1'b1;

							if (counter2%(`B/`L) == {`logB-`logL{1'b1}})
							begin
								id <= id + 1'b1;
							end

							if (counter2 == `B*`B/`L-1'b1)
							begin
								state <= `READ_PHASE;
								op <= `READ_ROW;
							end
							instr_out <= {1'b0, id, op};
						end
					endcase // for COL_DEP
				end
			endcase // for phase
		end // for in_valid
		else
		begin
			instr_out <= {1'b0, `logB'b0, `IDLE};
		end
		dOut <= inD;
	end // for reset
end // always block

endmodule
