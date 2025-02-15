# This mk file defines common features to build NNStreamer library for Android.

ifndef NNSTREAMER_ROOT
$(warning NNSTREAMER_ROOT is not defined! Using $(LOCAL_PATH)/.. )
NNSTREAMER_ROOT := $(LOCAL_PATH)/..
endif

NNSTREAMER_VERSION  := 1.0.0

NNSTREAMER_GST_HOME := $(NNSTREAMER_ROOT)/gst/nnstreamer
NNSTREAMER_EXT_HOME := $(NNSTREAMER_ROOT)/ext/nnstreamer
NNSTREAMER_CAPI_HOME := $(NNSTREAMER_ROOT)/api/capi

# nnstreamer common headers
NNSTREAMER_INCLUDES := \
    $(NNSTREAMER_GST_HOME)

# nnstreamer common sources
NNSTREAMER_COMMON_SRCS := \
    $(NNSTREAMER_GST_HOME)/nnstreamer.c \
    $(NNSTREAMER_GST_HOME)/nnstreamer_conf.c \
    $(NNSTREAMER_GST_HOME)/nnstreamer_subplugin.c \
    $(NNSTREAMER_GST_HOME)/tensor_common.c

# nnstreamer plugins
NNSTREAMER_PLUGINS_SRCS := \
    $(NNSTREAMER_GST_HOME)/tensor_converter/tensor_converter.c \
    $(NNSTREAMER_GST_HOME)/tensor_aggregator/tensor_aggregator.c \
    $(NNSTREAMER_GST_HOME)/tensor_decoder/tensordec.c \
    $(NNSTREAMER_GST_HOME)/tensor_demux/gsttensordemux.c \
    $(NNSTREAMER_GST_HOME)/tensor_filter/tensor_filter.c \
    $(NNSTREAMER_GST_HOME)/tensor_filter/tensor_filter_common.c \
    $(NNSTREAMER_GST_HOME)/tensor_filter/tensor_filter_custom.c \
    $(NNSTREAMER_GST_HOME)/tensor_merge/gsttensormerge.c \
    $(NNSTREAMER_GST_HOME)/tensor_mux/gsttensormux.c \
    $(NNSTREAMER_GST_HOME)/tensor_repo/tensor_repo.c \
    $(NNSTREAMER_GST_HOME)/tensor_repo/tensor_reposink.c \
    $(NNSTREAMER_GST_HOME)/tensor_repo/tensor_reposrc.c \
    $(NNSTREAMER_GST_HOME)/tensor_sink/tensor_sink.c \
    $(NNSTREAMER_GST_HOME)/tensor_split/gsttensorsplit.c \
    $(NNSTREAMER_GST_HOME)/tensor_transform/tensor_transform.c

# nnstreamer c-api
NNSTREAMER_CAPI_INCLUDES := \
    $(NNSTREAMER_CAPI_HOME)/include

NNSTREAMER_CAPI_SRCS := \
    $(NNSTREAMER_CAPI_HOME)/src/nnstreamer-capi-pipeline.c \
    $(NNSTREAMER_CAPI_HOME)/src/nnstreamer-capi-single.c \
    $(NNSTREAMER_CAPI_HOME)/src/nnstreamer-capi-util.c

# filter tensorflow
NNSTREAMER_FILTER_TF_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_tensorflow.c \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_tensorflow_core.cc

# filter tensorflow-lite
NNSTREAMER_FILTER_TFLITE_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_tensorflow_lite.c \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_tensorflow_lite_core.cc

# filter pytorch
NNSTREAMER_FILTER_TORCH_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_pytorch.c \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_pytorch_core.cc

# filter caffe2
NNSTREAMER_FILTER_CAFFE2_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_caffe2.c \
    $(NNSTREAMER_EXT_HOME)/tensor_filter/tensor_filter_caffe2_core.cc

# decoder boundingbox
NNSTREAMER_DECODER_BB_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_decoder/tensordec-boundingbox.c \
    $(NNSTREAMER_EXT_HOME)/tensor_decoder/tensordec-font.c

# decoder directvideo
NNSTREAMER_DECODER_DV_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_decoder/tensordec-directvideo.c

# decoder imagelabel
NNSTREAMER_DECODER_IL_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_decoder/tensordec-imagelabel.c

# decoder pose estimation
NNSTREAMER_DECODER_PE_SRCS := \
    $(NNSTREAMER_EXT_HOME)/tensor_decoder/tensordec-pose.c \
    $(NNSTREAMER_EXT_HOME)/tensor_decoder/tensordec-font.c

# common features
NO_AUDIO := false

ENABLE_NNAPI :=false

GST_LIBS_COMMON := gstreamer-1.0 gstbase-1.0 gstvideo-1.0 glib-2.0 \
                   gobject-2.0 intl z bz2 orc-0.4 gmodule-2.0 gsttag-1.0 iconv \
                   gstapp-1.0 png16 gio-2.0 pangocairo-1.0 \
                   pangoft2-1.0 pango-1.0 gthread-2.0 cairo pixman-1 fontconfig expat freetype \
                   gstcontroller-1.0 jpeg graphene-1.0 gstpbutils-1.0 gstgl-1.0 \
                   gstallocators-1.0 harfbuzz gstphotography-1.0 ffi fribidi gstnet-1.0 \
		   cairo-gobject cairo-script-interpreter

ifeq ($(NO_AUDIO), false)
GST_LIBS_COMMON += gstaudio-1.0 gstbadaudio-1.0
endif

GST_LIBS_GST := gstcoreelements gstcoretracers gstadder gstapp \
                gstpango gstrawparse gsttypefindfunctions gstvideoconvert gstvideorate \
                gstvideoscale gstvideotestsrc gstvolume gstautodetect gstvideofilter gstvideocrop gstopengl \
                gstopensles gstcompositor gstpng gstmultifile gstvideomixer gsttcp gstjpegformat gstcairo

ifeq ($(NO_AUDIO), false)
GST_LIBS_GST += gstaudioconvert gstaudiomixer gstaudiorate gstaudioresample gstaudiotestsrc gstjpeg
endif

# gstreamer building block for nstreamer
GST_BUILDING_BLOCK_LIST := $(GST_LIBS_COMMON) $(GST_LIBS_GST)

# gstreamer building block for decoder and filter
NNSTREAMER_BUILDING_BLOCK_LIST := $(GST_BUILDING_BLOCK_LIST) nnstreamer nnstreamer_decoder_bounding_boxes nnstreamer_decoder_pose_estimation nnstreamer_filter_tensorflow-lite

# libs for nnapi
NNAPI_BUILDING_BLOCK := arm_compute_ex backend_acl_cl backend_acl_neon backend_cpu \
                        neuralnetworks arm_compute_core arm_compute_graph arm_compute OpenCL

ifeq ($(ENABLE_NNAPI), true)
NNSTR$EAMER_BUILDING_BLOCK_LIST += $(NNAPI_BUILDING_BLOCK)
endif
