ifeq ($(filter NESCTRL, $(SW_MODULES)),)

SW_MODULES+=NESCTRL

include $(NESCTRL_DIR)/software/software.mk

# add embeded sources
SRC+=iob_nesctrl_swreg_emb.c

iob_nesctrl_swreg_emb.c: iob_nesctrl_swreg.h

endif
