include $(NESCTRL_DIR)/config.mk

NESCTRL_SW_DIR:=$(NESCTRL_DIR)/software

#include
INCLUDE+=-I$(NESCTRL_SW_DIR)

#headers
HDR+=$(NESCTRL_SW_DIR)/*.h iob_nesctrl_swreg.h

#sources
SRC+=$(NESCTRL_SW_DIR)/iob-nesctrl.c

iob_nesctrl_swreg.h: $(NESCTRL_DIR)/mkregs.conf
	$(MKREGS) iob_nesctrl $(NESCTRL_DIR) SW
