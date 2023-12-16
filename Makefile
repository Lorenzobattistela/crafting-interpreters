# Makefile for compiling jlox project

# Define the Java compiler
JAVAC = javac

# Specify the source directory
SRC_DIR = jlox

# Specify the output directory
OUT_DIR = bin

# Find all Java files in the source directory
JAVA_FILES = $(shell find $(SRC_DIR) -name '*.java')

# Replace .java with .class for all Java files to get the target files
CLASS_FILES = $(patsubst $(SRC_DIR)/%.java, $(OUT_DIR)/%.class, $(JAVA_FILES))

# Default target: compile all Java files
all: $(CLASS_FILES)

# Compile Java files
$(OUT_DIR)/%.class: $(SRC_DIR)/%.java
	@mkdir -p $(OUT_DIR)
	$(JAVAC) -d $(OUT_DIR) $<

# Clean up compiled files
clean:
	rm -rf $(OUT_DIR)

# Run the application
run:
	java -cp $(OUT_DIR) jlox.Lox

# Phony target to prevent conflicts with files named clean or run
.PHONY: all clean run

