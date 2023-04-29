SHELL:=/bin/bash

TOP_MODULE=iob_im

#IM
IM0_DATA_W ?= 12
IM0_ADDR_W ?= 11
IM1_DATA_W ?= 12
IM1_ADDR_W ?= 11
IM0_X_LEN ?= 40
IM0_Y_LEN ?= 40
IM1_X_LEN ?= 40
IM1_Y_LEN ?= 40


#PATHS
REMOTE_ROOT_DIR ?=sandbox/iob-im
SIM_DIR ?=$(IM_HW_DIR)/simulation
FPGA_DIR ?=$(IM_DIR)/hardware/fpga/$(FPGA_COMP)
DOC_DIR ?=

#define macros
DEFINE+=$(defmacro)IM0_DATA_W=$(IM0_DATA_W)
DEFINE+=$(defmacro)IM0_ADDR_W=$(IM0_ADDR_W)
DEFINE+=$(defmacro)IM1_DATA_W=$(IM1_DATA_W)
DEFINE+=$(defmacro)IM1_ADDR_W=$(IM1_ADDR_W)
DEFINE+=$(defmacro)IM0_X_LEN=$(IM0_X_LEN)
DEFINE+=$(defmacro)IM0_Y_LEN=$(IM0_Y_LEN)
DEFINE+=$(defmacro)IM1_X_LEN=$(IM1_X_LEN)
DEFINE+=$(defmacro)IM1_Y_LEN=$(IM1_Y_LEN)

LIB_DIR ?=$(IM_DIR)/submodules/LIB
MEM_DIR ?=$(IM_DIR)/submodules/MEM
IM_HW_DIR:=$(IM_DIR)/hardware

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
iob_im_swreg_def.vh iob_im_swreg_gen.vh: $(IM_DIR)/mkregs.conf
	$(MKREGS) iob_im $(IM_DIR) HW

im-gen-clean:
	@rm -rf *# *~ version.txt

.PHONY: default im-gen-clean
