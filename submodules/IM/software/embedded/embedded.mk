ifeq ($(filter IM, $(SW_MODULES)),)

SW_MODULES+=IM

include $(IM_DIR)/software/software.mk

# add embeded sources
SRC+=iob_im_swreg_emb.c

iob_im_swreg_emb.c: iob_im_swreg.h

endif
