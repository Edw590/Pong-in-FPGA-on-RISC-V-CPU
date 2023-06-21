include $(PMEM_DIR)/config.mk

PMEM_SW_DIR:=$(PMEM_DIR)/software

#include
INCLUDE+=-I$(PMEM_SW_DIR)

#headers
HDR+=$(PMEM_SW_DIR)/*.h iob_pmem_swreg.h

#sources
SRC+=$(PMEM_SW_DIR)/iob-pmem.c

iob_pmem_swreg.h: $(PMEM_DIR)/mkregs.conf
	$(MKREGS) iob_pmem $(PMEM_DIR) SW
