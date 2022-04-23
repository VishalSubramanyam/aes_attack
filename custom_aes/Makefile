SRC_FILES = $(wildcard *.cpp)
CUDA_SRC_FILES = $(wildcard *.cu)
HEADER_FILES = $(wildcard *.h)

TARGET_NAME = libAES.a
OBJS = aes.o
TARGET_FOLDER = lib

TARGET = $(TARGET_FOLDER)/$(TARGET_NAME)
CFLAGS = -O0 -g --ptxas-options=-v --use_fast_math -Wall



all: $(TARGET) test

$(TARGET): $(SRC_FILES) $(CUDA_SRC_FILES) $(HEADER_FILES)
	$(NVCC) $(SRC_FILES) $(CUDA_SRC_FILES) $(CFLAGS) -c -o $(OBJS)
	ar rcs $@ $(OBJS)

test: $(TARGET)
	make -C ./test

.PHONY: all clean test