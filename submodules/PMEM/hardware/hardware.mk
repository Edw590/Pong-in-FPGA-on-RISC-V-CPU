ifeq ($(filter PMEM, $(HW_MODULES)),)

include $(PMEM_DIR)/config.mk

#add itself to HW_MODULES list
HW_MODULES+=PMEM


PMEM_INC_DIR:=$(PMEM_HW_DIR)/include
PMEM_SRC_DIR:=$(PMEM_HW_DIR)/src

#import module
include $(LIB_DIR)/hardware/iob_reg/hardware.mk
include $(MEM_DIR)/hardware/rom/iob_rom_sp/hardware.mk
include $(MEM_DIR)/hardware/ram/iob_ram_2p/hardware.mk

#include files
VHDR+=$(wildcard $(PMEM_INC_DIR)/*.vh)
VHDR+=iob_pmem_swreg_gen.vh iob_pmem_swreg_def.vh
VHDR+=$(LIB_DIR)/hardware/include/iob_lib.vh $(LIB_DIR)/hardware/include/iob_s_if.vh $(LIB_DIR)/hardware/include/iob_gen_if.vh

#hardware include dirs
INCLUDE+=$(incdir). $(incdir)$(PMEM_INC_DIR) $(incdir)$(LIB_DIR)/hardware/include

#sources
VSRC+=$(wildcard $(PMEM_SRC_DIR)/*.v)

pmem-hw-clean:
	@rm -f *.v *.vh

.PHONY: pmem-hw-clean

endif
