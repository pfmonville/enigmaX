CC = gcc
CFLAGS = -Wall -funroll-loops -std=c11 -O3

SRC = main.c
OBJ = $(SRC:.c=.o)

all: enigmax

enigmax: $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clean

clean:
	$(RM) $(OBJ) enigmax
