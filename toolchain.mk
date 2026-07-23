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
NM = $(strip $(TOOLCHAIN))nm


### Define the flags for the compiler, assembler, and linker. These flags can be customized as needed for the specific project requirements.

##  Compiler flags for C files.

# Compile and assemble, but do not link.
CFLAGS     = -c

# Enable all warnings and extra warnings and threat all warnings as errors, if needed
CFLAGS    += -Wall -Wextra -Werror

# Specify the target CPU architecture.
CFLAGS    += -mcpu=cortex-m3 

# Enable debugging information in the output.
CFLAGS    += -g -gdwarf-3

# Define optimization level.
CFLAGS    += -O0

# Include the directory for header files.
CFLAGS    += -I $(strip $(INCLUDES))

## 	Assembler flags for assembly files.

# Specify the target CPU architecture for the assembler.
ASFLAGS    = -mcpu=cortex-m3

# Enable debugging information in the output of the assembler.
ASFLAGS   += -g -gdwarf-2

##  Linker flags for linking object files into an executable.

# Specify the linker script to use for linking the object files into an executable.
LDFLAGS    = -T $(strip $(LINKER_DIR))linkerscript.ld

# Generate a map file for the linked output.
LDFLAGS   += -Map=$(strip $(BUILD_DIR))mapfile.map

## Binary output flags for objcopy to generate binary and hex files from the linked executable.

# Specify the output format for objcopy to generate a binary file.
BIN_FLAGS  = -O binary

# Specify the output format for objcopy to generate a hex file.
HEX_FLAGS += -O ihex

## Readelf flags for generating a detailed report of the linked executable.

# Display all information about the linked executable, including headers, sections, symbols, and more.
REFLAGS    = -a

