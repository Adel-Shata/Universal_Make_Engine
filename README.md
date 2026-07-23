# Generic Embedded Build System using GNU Make

A scalable, architecture-independent embedded systems build system built entirely using GNU Make.

This project demonstrates how to create a fully customizable cross-compilation environment without relying on IDEs such as Keil, STM32CubeIDE, or MPLAB.

Instead of hardcoding the compiler or architecture, the build system is designed to support multiple architectures and toolchains dynamically through configurable toolchain abstraction.

---

# 👨‍💻 Author

## Eng. Adel Shata

Embedded Systems & Software Engineering Enthusiast  

---

# ✨ Key Idea

The build system itself is completely independent of the target architecture.

The compiler, assembler, linker, and architecture-specific flags are isolated inside:

```bash
toolchain.mk
```

This allows the same Makefile to work with:
- ARM GCC Toolchain
- AVR GCC Toolchain
- RISC-V Toolchains
- Native GCC
- Any custom cross compiler

simply by changing:

```bash
TOOLCHAIN
```

or editing:

```bash
toolchain.mk
```

---

# 🚀 Features

- Generic and reusable GNU Make build system
- Architecture-independent design
- Easily customizable project structure
- Dynamic toolchain selection
- User-configurable source/include/startup/linker directories
- Automatic source file discovery
- Automatic object file generation
- Separate build directory generation
- Scalable modular directory support
- Support for both C and Assembly source files
- Easy integration with any cross compiler
- Configurable compiler, assembler, and linker flags
- GNU Make debugging utilities
- Clean build support
- Fully IDE-independent workflow

---

# ✨ Key Idea

The goal of this project is not to provide a fixed embedded project template.

Instead, it provides a **generic and highly customizable GNU Make build system** that can be adapted to almost any embedded or native software project.

Most project paths and configurations are intentionally written using:

```make
?=
```

which allows users to override variables externally without modifying the original Makefile.

Example:

```make
PROJECT_NAME    ?= output
SRC_DIR         ?= src/
INCLUDES        ?= inc/
STARTUP_DIR     ?= startup/
LINKER_DIR      ?= linker/
```

This design makes the build system:
- reusable
- portable
- scalable
- architecture-independent

Users can fully customize:
- The name of output elf file
- source directories
- include directories
- startup files
- linker scripts
- toolchains
- compiler flags
- target architecture

directly from the command line or external configuration files.

---

# ⚙️ Toolchain Abstraction

The build system separates build logic from compiler implementation.

Example:

```make
CC = $(strip $(TOOLCHAIN))gcc
AS = $(strip $(TOOLCHAIN))as
LD = $(strip $(TOOLCHAIN))ld
CP = $(strip $(TOOLCHAIN))objcopy
OD = $(strip $(TOOLCHAIN))objdump
RE = $(strip $(TOOLCHAIN))readelf
NM = $(strip $(TOOLCHAIN))nm
```

This allows the same Makefile to work with:
- ARM GCC
- AVR GCC
- RISC-V Toolchains
- Native GCC
- Any custom cross compiler

without changing the core build system.

Example:

```bash
make TOOLCHAIN=toolchain_path/arm-none-eabi-
```

or:

```bash
make TOOLCHAIN=toolchain_path/avr-
```

or even:

```bash
make TOOLCHAIN=toolchain_path/riscv64-unknown-elf-
```

---

# 🧠 Build System Design

## Automatic Source Discovery

```make
SRC = $(foreach src_dir, $(SRC_DIR), $(wildcard $(src_dir)*.c))
```

This dynamically scans all source directories and collects all `.c` files automatically.

---

## Automatic Object File Generation

```make
OBJS = $(patsubst %.c,$(OBJS_DIR)%.o,$(SRC))
```

Example transformation:

```bash
src/app.c
```

becomes:

```bash
build/objs/src/app.o
```

---

## Pattern Rules

The project uses generic pattern rules to compile both C and Assembly files dynamically.

### C Files

```make
$(OBJS_DIR)%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $< -o $@
```

### Assembly Files

```make
$(OBJS_DIR)%.o: %.s
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $< -o $@
```

---

# 🔍 GNU Make Debugging Techniques

One of the most important parts of the project was debugging GNU Make internals.

I used debugging utilities such as:

```make
$(info >>> SRC is: $(SRC))
$(info >>> OBJS is: $(OBJS))
$(info >>> STARTUP_OBJS is: $(STARTUP_OBJS))
```

This helped trace:
- generated paths
- pattern matching behavior
- object file generation
- startup object generation
- dependency expansion
- build directory structure

---

# 🛠️ Problems Faced & Solutions

## 1️⃣ Conflicting Build Rules

### Problem

```bash
warning: overriding commands for target
```

### Cause

Incorrect rule definitions caused Make to overwrite build rules internally.

### Solution

Switched to proper generic pattern rules:

```make
$(OBJS_DIR)%.o: %.c
$(OBJS_DIR)%.o: %.s
```

---

## 2️⃣ Object File Path Mismatch

### Problem

```bash
No rule to make target
```

### Cause

The generated object file paths contained unexpected spaces, which caused the paths to no longer match the pattern rules correctly.

One of the main reasons behind this issue was adding long inline comments beside variable definitions, which unintentionally introduced extra whitespace during variable expansion and path concatenation.

Example:

```make
BUILD_DIR = build/        # build output directory
```

Those hidden spaces created several difficult-to-debug path matching problems inside GNU Make.

---

### Solution

I solved the issue by consistently using the GNU Make function:

```make
$(strip ...)
```

to remove leading and trailing whitespace from variables before using them in:
- path generation
- pattern rules
- compiler flags
- linker flags
- object file generation

Example:

```make
OBJS_DIR = $(strip $(BUILD_DIR))objs/
```

Using `$(strip)` significantly improved the stability and predictability of variable expansion across the entire build system.
---

## 3️⃣ Linker Linking Only First Object

### Problem

The linker linked only one object file.

### Cause

Using:

```make
$<
```

which references only the first dependency.

### Solution

Replaced with:

```make
$^
```

to link all object files correctly.

---

# 📚 Concepts Practiced

Through this project I practiced:

- Advanced GNU Make
- Pattern Rules
- Automatic Variables
- Cross Compilation
- Build System Architecture
- Embedded Project Structuring
- Linker Workflow
- Dependency Management
- Toolchain Abstraction
- Scalable Build Automation
- GNU Make Debugging

---

# 🎯 Why This Project Matters

Most embedded developers use IDEs that hide the actual build process.

This project focuses on understanding:
- how source files are discovered
- how object files are generated
- how linking works
- how toolchains operate internally
- how scalable embedded build systems are designed professionally
---