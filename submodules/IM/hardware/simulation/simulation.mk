include $(IM_DIR)/hardware/hardware.mk

DEFINE+=$(defmacro)VCD

VSRC+=$(wildcard $(IM_HW_DIR)/testbench/*.v)
