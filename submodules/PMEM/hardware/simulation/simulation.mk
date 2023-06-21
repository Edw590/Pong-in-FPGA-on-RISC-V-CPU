include $(PMEM_DIR)/hardware/hardware.mk

DEFINE+=$(defmacro)VCD

VSRC+=$(wildcard $(PMEM_HW_DIR)/testbench/*.v)
