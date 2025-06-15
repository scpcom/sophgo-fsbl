#include lib/cpu/${BOOT_CPU}/cpu-ops.mk

ABI = lp64d

RISCV_MARCH = rv64imafdc

ifeq ($(call cc-option-yn, -mcpu=thead-c906 -mabi=$(ABI) -march=$(RISCV_MARCH)),y)
RISCV_CPU = -mcpu=thead-c906
else ifeq ($(call cc-option-yn, -mcpu=c906fdv -mabi=$(ABI) -march=$(RISCV_MARCH)),y)
RISCV_CPU = -mcpu=c906fdv
endif

ifneq ($(RISCV_CPU),-mcpu=c906fdv)
# Newer binutils versions default to ISA spec version 20191213 which moves some
# instructions from the I extension to the Zicsr and Zifencei extensions.
toolchain-need-zicsr-zifencei := $(call cc-option-yn, $(RISCV_CPU) -mabi=$(ABI) -march=$(RISCV_MARCH)_zicsr_zifencei)
ifeq ($(toolchain-need-zicsr-zifencei),y)
	toolchain-need-xtheadcmo1p0-xtheadsync1p0 := $(call cc-option-yn, -mabi=$(ABI) -march=$(RISCV_MARCH)_xtheadcmo1p0_xtheadsync1p0)
endif
endif
ifeq ($(toolchain-need-zicsr-zifencei),y)
	RISCV_MARCH := $(RISCV_MARCH)_zicsr_zifencei
endif
ifeq ($(toolchain-need-xtheadcmo1p0-xtheadsync1p0),y)
	RISCV_MARCH := $(RISCV_MARCH)_xtheadcmo1p0_xtheadsync1p0
else
	RISCV_MARCH := $(RISCV_MARCH)xthead
endif

ASFLAGS +=\
	$(CPPFLAGS) \
	-DRISCV \
	-D__ASSEMBLY__ \
	-march=$(RISCV_MARCH) -mstrict-align \
	-mcmodel=medany \
	-mabi=$(ABI) \
	-ffreestanding  \
	-Wa,--fatal-warnings

TF_CFLAGS += \
	$(CPPFLAGS) \
	-DRISCV \
	-march=$(RISCV_MARCH) \
	-mcmodel=medany \
	-mabi=$(ABI) \
	-ffreestanding -fno-builtin -Wall -std=gnu99 \
	-Os -ffunction-sections -fdata-sections \
	-fno-delete-null-pointer-checks

TF_LDFLAGS += \
	--fatal-warnings -Os \
	--gc-sections \
	${TF_LDFLAGS_aarch64}

TF_LDFLAGS += $(call ld-option, --no-warn-rwx-segments)

ifeq ($(toolchain-need-xtheadcmo1p0-xtheadsync1p0),y)
TF_CFLAGS += -DTOOLCHAIN_NEED_XTHEADCMO1P0_XTHEADSYNC1P0
endif

CPU_INCLUDES := \
	-Iinclude/cpu/${BOOT_CPU} \

CPU_SOURCES := \
	lib/cpu/${BOOT_CPU}/cpu_helper.c \
	lib/cpu/${BOOT_CPU}/misc_helpers.c \
	lib/cpu/${BOOT_CPU}/cache.c \
	lib/cpu/${BOOT_CPU}/delay_timer.c \
	lib/cpu/${BOOT_CPU}/bl2_helper.c \
	plat/${CHIP_ARCH}/uart/uart_dw.c


BL1_CPU_SOURCES := \
	lib/cpu/${BOOT_CPU}/bl1_entrypoint.S \
#	lib/cpu/${BOOT_CPU}/bl1_exceptions.S

BL2_CPU_SOURCES := \
	lib/cpu/${BOOT_CPU}/bl2_entrypoint.S \
#	lib/cpu/${BOOT_CPU}/bl2_exceptions.S
