include $(IM_DIR)/config.mk

IM_SW_DIR:=$(IM_DIR)/software

#include
INCLUDE+=-I$(IM_SW_DIR)

#headers
HDR+=$(IM_SW_DIR)/*.h iob_im_swreg.h

#sources
SRC+=$(IM_SW_DIR)/iob-im.c

iob_im_swreg.h: $(IM_DIR)/mkregs.conf
	$(MKREGS) iob_im $(IM_DIR) SW
