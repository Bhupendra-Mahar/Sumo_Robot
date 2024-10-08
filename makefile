# # blink: main.c led.c
# # 	msp430-elf-gcc -mmcu=msp430g2553 \
# # 	-I /home/bhupi/Desktop/msp430-gcc/include/include \
# # 	-L /home/bhupi/Desktop/msp430-gcc/include/include \
# # 	-Og -g -Wall \
# # 	led.c main.c -oblink





# 	# Directories
# MSPGCC_ROOT_DIR = /home/bhupi/Desktop/msp430-gcc
# MSPGCC_BIN_DIR = $(MSPGCC_ROOT_DIR)/bin
# MSPGCC_INCLUDE_DIR = $(MSPGCC_ROOT_DIR)/include/include
# INCLUDE_DIRS = $(MSPGCC_INCLUDE_DIR)
# LIB_DIRS = $(MSPGCC_INCLUDE_DIR)
# BUILD_DIR = build
# OBJ_DIR = $(BUILD_DIR)/obj
# BIN_DIR = $(BUILD_DIR)/bin
# TI_CCS_DIR = /home/bhupi/ti/ccs1120/ccs
# DEBUG_BIN_DIR = $(TI_CCS_DIR)/ccs_base/DebugServer/bin
# DEBUG_DRIVERS_DIR = $(TI_CCS_DIR)/ccs_base/DebugServer/drivers

# # Toolchain
# CC = $(MSPGCC_BIN_DIR)/msp430-elf-gcc
# RM = rm
# DEBUG = LD_LIBRARY_PATH=$(DEBUG_DRIVERS_DIR) $(DEBUG_BIN_DIR)/mspdebug

# # Files
# TARGET = $(BIN_DIR)/blink

# SOURCES = main.c \
# 		  led.c

# OBJECT_NAMES = $(SOURCES:.c=.o)
# OBJECTS = $(patsubst %,$(OBJ_DIR)/%,$(OBJECT_NAMES))

# # Flags
# MCU = msp430g2553
# WFLAGS = -Wall -Wextra -Werror -Wshadow
# CFLAGS = -mmcu=$(MCU) $(WFLAGS) $(addprefix -I,$(INCLUDE_DIRS)) -Og -g
# LDFLAGS = -mmcu=$(MCU) $(addprefix -L,$(LIB_DIRS))

# # Build
# ## Linking
# $(TARGET): $(OBJECTS)
# 	@mkdir -p $(dir $@)
# 	$(CC) $(LDFLAGS) $^ -o $@

# ## Compiling
# $(OBJ_DIR)/%.o: %.c
# 	@mkdir -p $(dir $@)
# 	$(CC) $(CFLAGS) -c -o $@ $^

# # Phonies
# .PHONY: all clean flash

# all: $(TARGET)

# clean:
# 	$(RM) -r $(BUILD_DIR)

# flash: $(TARGET)
# 	$(DEBUG) tilib "prog $(TARGET)"




# Directories

TOOLS_DIR = ${TOOLS_PATH}
MSPGCC_ROOT_DIR = $(TOOLS_DIR)/msp430-gcc
MSPGCC_BIN_DIR = $(MSPGCC_ROOT_DIR)/bin
MSPGCC_INCLUDE_DIR = $(MSPGCC_ROOT_DIR)/include
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin
TI_CCS_DIR = $(TOOLS_DIR)/ccs1110/ccs
DEBUG_BIN_DIR = $(TI_CCS_DIR)/ccs_base/DebugServer/bin
DEBUG_DRIVERS_DIR = $(TI_CCS_DIR)/ccs_base/DebugServer/drivers

LIB_DIRS = $(MSPGCC_INCLUDE_DIR)
INCLUDE_DIRS = $(MSPGCC_INCLUDE_DIR) \
			   ./src \
			   ./external/ \
			   ./external/printf

# Toolchain
CC = $(MSPGCC_BIN_DIR)/msp430-elf-gcc
RM = rm
DEBUG = LD_LIBRARY_PATH=$(DEBUG_DRIVERS_DIR) $(DEBUG_BIN_DIR)/mspdebug
CPPCHECK = cppcheck

# Files
TARGET = $(BIN_DIR)/nsumo

DRIVERS_SRC = $(addprefix src/drivers/,\
				uart.c \
				i2c.c \
				)
APP_SRC = $(addprefix src/app/,\
			drive.c \
	  	  	enemy.c \
			)
TEST_SRC = $(addprefix src/test/,\
		     test.c \
			 )
SOURCES = src/main.c \
		  $(DRIVERS_SRC) \
		  $(APP_SRC) \
		  $(TEST_SRC)

OBJECT_NAMES = $(SOURCES:.c=.o)
OBJECTS = $(patsubst %,$(OBJ_DIR)/%,$(OBJECT_NAMES))

# Flags
MCU = msp430g2553
WFLAGS = -Wall -Wextra -Werror -Wshadow
CFLAGS = -mmcu=$(MCU) $(WFLAGS) $(addprefix -I,$(INCLUDE_DIRS)) -Og -g
LDFLAGS = -mmcu=$(MCU) $(addprefix -L,$(LIB_DIRS))

# Build
## Linking
$(TARGET): $(OBJECTS)
	echo $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) $^ -o $@

## Compiling
$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $^

# Phonies
.PHONY: all clean flash cppcheck

all: $(TARGET)

clean:
	$(RM) -r $(BUILD_DIR)

flash: $(TARGET)
	$(DEBUG) tilib "prog $(TARGET)"

cppcheck:
	@$(CPPCHECK) --quiet --enable=all --error-exitcode=1 \
	--inline-suppr \
	-I $(INCLUDE_DIRS) \
	$(SOURCES) \
	-i external/printf