# Compilers
CC = gcc
CFLAGS = -O3 -Wall -m64 -L/usr/local/lib64 -lpthread
EXFLAGS = -DPRINT -D_REENTRANT

INC = -I../ -I/usr/local/include

all: fw_8_sd fw_8_rd  fw_8_cd  fw_8_dd fw_16_sd fw_16_rd fw_16_cd fw_16_dd \
	fw_32_sd fw_32_rd fw_32_cd fw_32_dd

# CPU-based FW
#
fw_8_sd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DSELF_DEP  fw.c timer.c -DSIZE=8

fw_8_rd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DROW_DEP  fw.c timer.c -DSIZE=8

fw_8_cd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DCOL_DEP  fw.c timer.c -DSIZE=8

fw_8_dd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DDOUBLY_DEP  fw.c timer.c -DSIZE=8


fw_16_sd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DSELF_DEP fw.c timer.c -DSIZE=16

fw_16_rd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DROW_DEP  fw.c timer.c -DSIZE=16

fw_16_cd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DCOL_DEP  fw.c timer.c -DSIZE=16

fw_16_dd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DDOUBLY_DEP  fw.c timer.c -DSIZE=16

fw_32_sd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DSELF_DEP fw.c timer.c -DSIZE=32

fw_32_rd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DROW_DEP  fw.c timer.c -DSIZE=32

fw_32_cd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DCOL_DEP  fw.c timer.c -DSIZE=32

fw_32_dd: fw.c timer.c
	gcc $(CFLAGS) $(EXFLAGS) -o $@ -DTIME -DDOUBLY_DEP  fw.c timer.c -DSIZE=32

clean:
	rm -f *.o fw_?_?? fw_??_??
