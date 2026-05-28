#@ copyright : Eng. Adel Shata

# The TOOLCHAIN variable can be overridden by setting it in the environment or on the command line when invoking make.

TOOLCHAIN 	   ?= C:/TOOLCHAINS/ARM_TOOLCHAIN/bin/arm-none-eabi-

# Tools Aabstraction layer

CC = $(strip $(TOOLCHAIN))gcc
AS = $(strip $(TOOLCHAIN))as
LD = $(strip $(TOOLCHAIN))ld
CP = $(strip $(TOOLCHAIN))objcopy
OD = $(strip $(TOOLCHAIN))objdump
RE = $(strip $(TOOLCHAIN))readelf


### Define the flags for the compiler, assembler, and linker. These flags can be customized as needed for the specific project requirements.

##  Compiler flags for C files.
CFLAGS     = -c                    				# Compile and assemble, but do not link.
CFLAGS    += -Wall -Wextra #-Werror 			# Enable all warnings and extra warnings and threat all warnings as errors, if needed
CFLAGS    += -mcpu=arm926ej-s 					# Specify the target CPU architecture.
CFLAGS    += -g -gdwarf-3 						# Enable debugging information in the output.
CFLAGS    += -O0 								# Define optimization level.
CFLAGS    += -I $(strip $(INCLUDES))			# Include the directory for header files.

## 	Assembler flags for assembly files.
ASFLAGS    = -mcpu=arm926ej-s 					# Specify the target CPU architecture for the assembler.
ASFLAGS   += -g -gdwarf-3 						# Enable debugging information in the output of the assembler.

##  Linker flags for linking object files into an executable.
LDFLAGS    = -T $(strip $(LINKER_DIR))linker.ld				# Specify the linker script to use for linking the object files into an executable.
LDFLAGS   += -Map=$(strip $(BUILD_DIR))mapfile.map 			# Generate a map file for the linked output.

## Binary output flags for objcopy to generate binary and hex files from the linked executable.
BIN_FLAGS  = -O binary 							# Specify the output format for objcopy to generate a binary file.
HEX_FLAGS += -O ihex 							# Specify the output format for objcopy to generate a hex file.

## Readelf flags for generating a detailed report of the linked executable.
REFLAGS    = -a 								# Display all information about the linked executable, including headers, sections, symbols, and more.

