#@ copyright : Eng. Adel Shata

# Define the name of the project, which can be used for naming output files.
PROJECT_NAME    ?= output

# Define the directory for header files, which can be overridden as needed.
INCLUDES 		?= inc/

# Define the directory for linker scripts, which can be overridden as needed.
LINKER_DIR   	?= linker/

# Define the directory for startup files, which can be overridden as needed.
STARTUP_DIR  	?= startup/

# Define the directory for source files, which can be overridden as needed.
SRC_DIR        	?= src/

# Define the directory for build output, which can be overridden as needed.
BUILD_DIR	  	 = build/

# Define the directory for object files, which can be overridden as needed.
OBJS_DIR      	 = $(strip $(BUILD_DIR))objs/

# Define a fixed name for the output file by removing any spaces from the project name, which is used for naming the final executable.
FIXED_NAME 		 = $(subst $() ,$(empty),$(strip $(PROJECT_NAME)))

##For debugging
#$(info >>> FIXED_NAME is: $(FIXED_NAME))
#$(info >>> OBJS_DIR is: $(OBJS_DIR))

SRC 			 = $(foreach src_dir, $(SRC_DIR), $(wildcard $(src_dir)*.c)) 		 # Define the list of C source files in the source directory.
OBJS 			 = $(addprefix $(strip $(OBJS_DIR)), $(patsubst %.c, %.o, $(SRC)))	 # Define the list of object files generated from the C source files.


## Define the list of object files generated from the startup files.
STARTUP_OBJS 	 = $(patsubst %.c, $(strip $(OBJS_DIR))%.o, $(wildcard $(strip $(STARTUP_DIR))*.c))
STARTUP_OBJS 	 += $(patsubst %.s, $(strip $(OBJS_DIR))%.o, $(wildcard $(strip $(STARTUP_DIR))*.s))

##For debugging
#$(info >>> SRC is: $(SRC))
#$(info >>> OBJS is: $(OBJS))
#$(info >>> STARTUP_OBJS is: $(STARTUP_OBJS))

-include toolchain.mk	                      	## Include the toolchain configuration file, which defines the compiler, assembler, linker, and their respective flags.

## Define the build rules for compiling startup assembly files into object files.


.PHONY: all clean
all: $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).bin $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).hex $(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_readelf.txt $(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_elf_info.txt $(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_disassembly.txt $(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_symbols.txt
	@echo "======Build completed successfully!======"
	@echo "======Copyright : Eng. Adel Shata!======"

$(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_readelf.txt: $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).elf
	@echo "===Generating ReadElf report for $<==="
	$(RE) $(strip $(REFLAGS)) $< > $@

$(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_elf_info.txt: $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).elf
	@echo "=== Generating ELF information ==="
	$(OD) -x $< > $@

$(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_disassembly.txt: $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).elf
	@echo "=== Generating Disassembly ==="
	$(OD) -D $< > $@

$(strip $(BUILD_DIR))$(strip $(FIXED_NAME))_symbols.txt: $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).elf
	@echo "=== Generating Symbols ==="
	$(NM) $< > $@

$(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).bin: $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).elf

	$(CP) $(strip $(BIN_FLAGS)) $< $@

$(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).hex: $(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).elf
	@echo "===Generating Hex file for $<==="
	$(CP) $(strip $(HEX_FLAGS)) $< $@

$(strip $(BUILD_DIR))$(strip $(FIXED_NAME)).elf: $(STARTUP_OBJS) $(OBJS)
	@echo "===Compiler completed all files successfully!==="
	$(LD) $(strip $(LDFLAGS)) $^ -o $@
	@echo "===Linking completed successfully! Output file: $@==="

$(strip $(OBJS_DIR))%.o: %.s
	@mkdir -p $(dir $@)
	$(AS) $(strip $(ASFLAGS)) $< -o $@
	@echo "===Assembling completed successfully! Output file: $@==="

$(strip $(OBJS_DIR))%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(strip $(CFLAGS)) $< -o $@
	@echo "===Compiling completed successfully! Output file: $@==="

clean: 
	@rm -rf $(strip $(BUILD_DIR))
	@echo "===Cleaned build artifacts successfully!==="
	@echo "======Copyright : Eng. Adel Shata!======"


