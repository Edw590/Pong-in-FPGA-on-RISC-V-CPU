ifeq ($(filter PMEM, $(SW_MODULES)),)

SW_MODULES+=PMEM

include $(PMEM_DIR)/software/software.mk

# add embeded sources
SRC+=iob_pmem_swreg_emb.c

iob_pmem_swreg_emb.c: iob_pmem_swreg.h

endif
