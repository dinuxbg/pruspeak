# Copyright (c) 2015, Dimitar Dimitrov
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#   * Neither the name of the copyright holders nor the names of
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.

# Very simple makefile to cross-compile for PRU


# Use the same build options for each core.
CROSS_COMPILE ?= pru-
CFLAGS += -g -Os
CFLAGS += -Wall -Wextra

# Set device-specific linker script, if needed. Default is am335x.pru0
CFLAGS += -Xlinker -Tpruelf-am335x.pru0.x
# CFLAGS += -Xlinker -Tpruelf-am437x.icss0.pru1.x

# Define this to squeeze code size by removing atexit, exit, constructors
# and destructors from CRT.
CFLAGS += -minrt


# List of object files to compile for each PRU core.
OBJS0 := pru0_firmware.o pru0_syscall.o
OBJS1 := pru1_firmware.o

LDFLAGS0 :=
LDFLAGS1 :=

# Where to output compiled objects
OUT := out

# ============================ DO NOT TOUCH BELOW ============================
all: pru0_firmware pru1_firmware
	@echo Success: $^

# OBJS0 := $(addprefix $(OUT)/, $(patsubst %.c,%.o,$(SRC0)))
# OBJS1 := $(addprefix $(OUT)/, $(patsubst %.c,%.o,$(SRC1)))
OBJS0 := $(addprefix $(OUT)/, $(OBJS0))
OBJS1 := $(addprefix $(OUT)/, $(OBJS1))

DEPS := $(OBJS0:.o=.d) $(OBJS1:.o=.d)
-include $(DEPS)

$(OUT)/%.o : %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) $< -c -o $@ -MMD

$(OUT)/%.o : %.S
	$(CROSS_COMPILE)gcc $(CFLAGS) $< -c -o $@ -MMD

$(OUT)/%.s : %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) $< -S -o $@

%.s : %.elf
	$(CROSS_COMPILE)objdump -S -d $< > $@

$(OBJS0): | $(OUT)
$(OBJS1): | $(OUT)

$(OUT):
	mkdir $(OUT)

pru0_firmware: $(OBJS0) | $(OUT)
	$(CROSS_COMPILE)gcc $(CFLAGS) $(LDFLAGS0) $^ $(LDFLAGS) -o $@

pru1_firmware: $(OBJS1) | $(OUT)
	$(CROSS_COMPILE)gcc $(CFLAGS) $(LDFLAGS1) $^ $(LDFLAGS) -o $@

clean:
	$(RM) -fr pru0_firmware pru1_firmware $(OBJS0) $(OBJS1) $(OUT)

cscope:
	cscope -bRk

install: all
	install -m 444 pru0_firmware /lib/firmware
	install -m 444 pru1_firmware /lib/firmware

.PHONY: all clean cscope install
