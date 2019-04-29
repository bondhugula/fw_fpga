/* 
 *
 * params.v 
 *
 * $Id: params.v,v 1.40 2005/11/02 07:44:07 osc0414 Exp $
 *
 * Parameters for the FPGA FW Kernel
 *
 * Uday Kumar Reddy Bondhugula
 *
 * Copyright (C) 2005 Uday Bondhugula
 *
 * Please see the LICENSE file for details.
 *
*/

`ifndef PARAMS_V
`define PARAMS_V

/* Width of each distance matrix element (in bits) */
`define WIDTH 16

/* right now L has to be set to 4 to balance I/O with the system */
`define L 4
`define logL 2

/* 
 * 
 * The maximum block size we can support which is the same as the number of
 * PEs we have. Note that changing B would require changing logB,
 * ADDR_WIDTH.
 *
 */
`define B 32
`define logB 5

/* addr width is log(B/L); B/L rows of L shorts; total B shorts*/
`define ADDR_WIDTH (`logB - `logL)


/* phases: different types of blocks */
`define SELF_DEP 	2'b00
`define ROW_DEP 	2'b01 // row comes from another tile
`define COL_DEP 	2'b10
`define DOUBLY_DEP 	2'b11 // both row and col come from another tile

/*
 *
 * PE Commands
 *
 * READ_ROW, READ_COL correspond to initial part of phase 1 when you read
 * and store.
 *
 * PROCESS_ROW, PROCESS_COL occur in the latter part of phase 1 and in
 * phase 2.
 *
 * SEND_ROW and SEND_COL occur in initial part of phase 2
 *
 */

`define READ_ROW 		3'b000
`define READ0 		3'b000
`define READ1 		3'b000
`define COMPUTE 		3'b000
`define READ_COL 		3'b001
`define PROCESS_ROW		3'b010
`define PROCESS_COL		3'b011
`define SEND_ROW 		3'b100
`define SEND_COL 		3'b101
`define FORWARD_DATA 	3'b110
`define FORWARD     3'b110
`define IDLE 			3'b111

/* width of a PE command */
`define OP_WIDTH 3

/* refer pe_instr_decoder.v for PE instruction format */
`define INSTR_WIDTH (1 + `logB + `OP_WIDTH)

`endif
