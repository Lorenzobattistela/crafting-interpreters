CC = gcc
CFLAGS = -std=c99 -Wall -Wextra
SRC_DIR = ./
OBJ_DIR = obj
BIN_DIR = bin

# List of source files
SRCS = $(wildcard $(SRC_DIR)/*.c)

# Generate a list of object files from source files
OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

# Target executable
TARGET = $(BIN_DIR)/myprogram

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)


