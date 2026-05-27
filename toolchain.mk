#@ copyright : Eng. Adel Shata

# The TOOLCHAIN variable can be overridden by setting it in the environment or on the command line when invoking make.
TOOLCHAINS_ROOT = C:/TOOLCHAINS/
TOOLCHAIN_PATH 	= $(strip $(TOOLCHAINS_ROOT))ARM_TOOLCHAIN/bin/
TOOLCHAIN 	   ?= $(strip $(TOOLCHAIN_PATH))arm-none-eabi-

CC = $(strip $(TOOLCHAIN))gcc
AS = $(strip $(TOOLCHAIN))as
LD = $(strip $(TOOLCHAIN))ld



### Define the flags for the compiler, assembler, and linker. These flags can be customized as needed for the specific project requirements.

##  Compiler flags for C files.
CFLAGS  = -c                    				# Compile and assemble, but do not link.
CFLAGS += -Wall -Wextra #-Werror 				# Enable all warnings and extra warnings and threat all warnings as errors, if needed
CFLAGS += -mcpu=arm926ej-s 						# Specify the target CPU architecture.
CFLAGS += -g -gdwarf-3 							# Enable debugging information in the output.
CFLAGS += -O0 									# Define optimization level.
CFLAGS += -I $(strip $(INCLUDES))				# Include the directory for header files.

## 	Assembler flags for assembly files.
ASFLAGS = -mcpu=arm926ej-s 						# Specify the target CPU architecture for the assembler.
ASFLAGS += -g -gdwarf-3 						# Enable debugging information in the output of the assembler.

##  Linker flags for linking object files into an executable.
LDFLAGS = -T $(strip $(LINKER_DIR))linker.ld				# Specify the linker script to use for linking the object files into an executable.
LDFLAGS += -Map=$(strip $(BUILD_DIR))mapfile.map 	# Generate a map file for the linked output, which can be useful for debugging and analyzing the memory layout of the executable.
