
- fw.v is the top-level module. 

- For more details on the FPGA design, please see:

  1) Parallel FPGA-based All-Pairs Shortest-Paths in a Directed Graph 
     Uday Bondhugula, Ananth Devulapalli, Joseph Fernando, Pete Wyckoff, 
     and P. Sadayappan.  20th IEEE International Parallel & Distributed 
     Processing Symposium (IPDPS '06), Apr 2006, Rodos, Greece.
     https://ieeexplore.ieee.org/abstract/document/1639347/

  2) Code comments. 

- The testbench/ directory contains the testbench for the hardware 
  design.

- The C/ directory has the CPU reference code, and a 'make' in that 
  directory will generate binaries for 8x8, 16x16 and 32x32 matrix 
  sizes, that when run on the CPU, will emit input and outputs that can 
  be used to verify the FPGA designs for B = 8, 16, 32 (number of PEs) 
  respectively.

- Contact: Email: udayb@iisc.ac.in, udayreddy@gmail.com
