ifeq ($(filter NESCTRL, $(HW_MODULES)),)

include $(NESCTRL_DIR)/config.mk

#add itself to HW_MODULES list
HW_MODULES+=NESCTRL


NESCTRL_INC_DIR:=$(NESCTRL_HW_DIR)/include
NESCTRL_SRC_DIR:=$(NESCTRL_HW_DIR)/src

#import module
include $(LIB_DIR)/hardware/iob_reg/hardware.mk

#include files
VHDR+=$(wildcard $(NESCTRL_INC_DIR)/*.vh)
VHDR+=iob_nesctrl_swreg_gen.vh iob_nesctrl_swreg_def.vh
VHDR+=$(LIB_DIR)/hardware/include/iob_lib.vh $(LIB_DIR)/hardware/include/iob_s_if.vh $(LIB_DIR)/hardware/include/iob_gen_if.vh

#hardware include dirs
INCLUDE+=$(incdir). $(incdir)$(NESCTRL_INC_DIR) $(incdir)$(LIB_DIR)/hardware/include

#sources
VSRC+=$(wildcard $(NESCTRL_SRC_DIR)/*.v)

nesctrl-hw-clean:
	@rm -f *.v *.vh

.PHONY: nesctrl-hw-clean

endif
