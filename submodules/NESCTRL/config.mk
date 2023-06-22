SHELL:=/bin/bash

TOP_MODULE=iob_nesctrl


#PATHS
REMOTE_ROOT_DIR ?=sandbox/iob-nesctrl
SIM_DIR ?=$(NESCTRL_HW_DIR)/simulation
FPGA_DIR ?=$(NESCTRL_DIR)/hardware/fpga/$(FPGA_COMP)
DOC_DIR ?=

LIB_DIR ?=$(NESCTRL_DIR)/submodules/LIB
MEM_DIR ?=$(NESCTRL_DIR)/submodules/MEM
NESCTRL_HW_DIR:=$(NESCTRL_DIR)/hardware

#MAKE SW ACCESSIBLE REGISTER
MKREGS:=$(shell find $(LIB_DIR) -name mkregs.py)

#DEFAULT FPGA FAMILY AND FAMILY LIST
FPGA_FAMILY ?=XCKU
FPGA_FAMILY_LIST ?=CYCLONEV-GT XCKU

#DEFAULT DOC AND DOC LIST
DOC ?=pb
DOC_LIST ?=pb ug

# default target
default: sim

# VERSION
VERSION ?=V0.1
$(TOP_MODULE)_version.txt:
	echo $(VERSION) > version.txt

#cpu accessible registers
iob_nesctrl_swreg_def.vh iob_nesctrl_swreg_gen.vh: $(NESCTRL_DIR)/mkregs.conf
	$(MKREGS) iob_nesctrl $(NESCTRL_DIR) HW

nesctrl-gen-clean:
	@rm -rf *# *~ version.txt

.PHONY: default nesctrl-gen-clean
