include $(NESCTRL_DIR)/hardware/hardware.mk

DEFINE+=$(defmacro)VCD

VSRC+=$(wildcard $(NESCTRL_HW_DIR)/testbench/*.v)
