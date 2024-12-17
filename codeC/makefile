# Name of the executable
EXECUTABLE = programme

# Source files and corresponding object files
SOURCES = avl.c main.c
OBJECTS = $(SOURCES:.c=.o)  # Automatically convert .c files to .o files

# Compilation options
CC = gcc  # The C compiler to use
CFLAGS = -Wall -Wextra -Werror -std=c11  # Compiler flags:
# -Wall: Enable basic warnings
# -Wextra: Enable additional warnings
# -Werror: Treat warnings as errors
# -std=c11: Use the C11 standard

# Default rule (executed when running 'make' without arguments)
all: $(EXECUTABLE)

# Rule to build the executable
$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^ 

# Rule to compile .c source files into .o object files
%.o: %.c avl.h
	$(CC) $(CFLAGS) -c $< -o $@ 

# Rule to clean up generated files
clean:
	rm -f $(EXECUTABLE)

#$(OBJECTS) 

# Rule to completely clean the project (including the executable)
#mrproper: clean
#	rm -f $(EXECUTABLE)
