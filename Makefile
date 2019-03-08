CC = gcc
CFLAGS = -Wall -fno-move-loop-invariants -fno-unroll-loops -std=c11

SRC = main.c
OBJ = $(SRC:.c=.o)

all: enigmax

enigmax: $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clean

clean:
	$(RM) $(OBJ) enigmax
