#!/bin/bash
set -e

# Prepare environment variables
ROOT_DIR=$(pwd)
BUILD_DIR=build
LLAMA_HASH="dd047b4"
LLAMA_DIR=$BUILD_DIR/llama-cpp
EMSDK_DIR=$BUILD_DIR/emsdk
TARGET_DIR=$BUILD_DIR/llama-bin

mkdir -p $BUILD_DIR

# Download emsdk
if [ ! -d $EMSDK_DIR ]; then
    echo "Downloading emsdk repository..."
    git clone https://github.com/emscripten-core/emsdk.git --branch 1.39.20 $EMSDK_DIR
    if [[ $(uname -m) == 'arm64' ]]; then
        echo "Apple Silicon device detected. Applying emsdk patch for Apple Silicon..."
        cd $EMSDK_DIR
        git apply $ROOT_DIR/patches/emsdk-apple-silicon.patch
        cd $ROOT_DIR
    fi
fi

# Actually activate and install emscripten
echo "Downloading and activating Emscripten..."
$EMSDK_DIR/emsdk install 1.39.20-fastcomp
$EMSDK_DIR/emsdk activate 1.39.20-fastcomp
source $EMSDK_DIR/emsdk_env.sh

# Clone llama.cpp library
if [ ! -d $LLAMA_DIR ]; then
    echo "Downloading llama.cpp repository..."
    git clone https://github.com/ggerganov/llama.cpp.git $LLAMA_DIR
    cd $LLAMA_DIR
    git reset --hard $LLAMA_HASH

    # Apply patch
    echo "Applying patch..."
    git apply $ROOT_DIR/patches/llama-cpp-llm-pdf.patch

    cd $ROOT_DIR
fi

# Set up target directory
if [ -d $TARGET_DIR ]; then
    rm -r $TARGET_DIR
fi
mkdir -p $TARGET_DIR
cd $TARGET_DIR

# Configure CMake
emcmake cmake $ROOT_DIR/$LLAMA_DIR

export EMCC_CFLAGS="-O3 -s SINGLE_FILE=1 -fno-rtti -flto=full -s DISABLE_EXCEPTION_CATCHING=0 -sWASM=0 -Wno-fastcomp -Wabsolute-value -static '-sEXPORTED_FUNCTIONS=[_main]' -s INITIAL_MEMORY=1GB -s MAXIMUM_MEMORY=1400MB -s ALLOW_MEMORY_GROWTH -s ASSERTIONS=1 -s --pre-js $ROOT_DIR/polyfill.js"

# Compile llama-cli
cd examples/main
emmake make

# Copy the generated files out to root directory llama.js
cd $ROOT_DIR/$TARGET_DIR
cp bin/llama-cli.js $ROOT_DIR/llama.js