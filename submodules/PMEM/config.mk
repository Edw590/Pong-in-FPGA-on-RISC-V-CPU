SHELL:=/bin/bash

TOP_MODULE=iob_pmem


#PATHS
REMOTE_ROOT_DIR ?=sandbox/iob-pmem
SIM_DIR ?=$(PMEM_HW_DIR)/simulation
FPGA_DIR ?=$(PMEM_DIR)/hardware/fpga/$(FPGA_COMP)
DOC_DIR ?=

LIB_DIR ?=$(PMEM_DIR)/submodules/LIB
MEM_DIR ?=$(PMEM_DIR)/submodules/MEM
PMEM_HW_DIR:=$(PMEM_DIR)/hardware

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
iob_pmem_swreg_def.vh iob_pmem_swreg_gen.vh: $(PMEM_DIR)/mkregs.conf
	$(MKREGS) iob_pmem $(PMEM_DIR) HW

pmem-gen-clean:
	@rm -rf *# *~ version.txt

.PHONY: default pmem-gen-clean
