CC = gcc
CFLAGS = -Wall -g
TARGET = main.c

all: $(TARGET)

$(TARGET) : main.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c

clean:
	rm -f $(TARGET)
