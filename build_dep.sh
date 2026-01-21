# export CXX=/opt/rocm/bin/hipcc
# export CC=/opt/rocm/bin/amdclang

if [ ! -f "v21.12.zip" ]; then
    wget https://github.com/protocolbuffers/protobuf/archive/refs/tags/v21.12.zip
fi
if [ ! -d "protobuf-21.12" ]; then
    unzip v21.12.zip
fi
cd protobuf-21.12

mkdir build && cd build
cmake .. \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$HOME/workspace/protobuf_install \
    -Dprotobuf_BUILD_TESTS=OFF \
    -Dprotobuf_BUILD_SHARED_LIBS=OFF
    # -DCMAKE_HIP_ARCHITECTURES=gfx1201 \
    # -DCMAKE_CXX_FLAGS="--offload-host-only"

make -j$(nproc)
make install



# cd ~/workspace
# if [ ! -f "boost-1.84.0.tar.xz" ]; then
#     wget https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.tar.xz
# fi

# if [ ! -d "boost-1.84.0" ]; then
#     tar -xf boost-1.84.0.tar.xz
# fi
# cd boost-1.84.0

# ./bootstrap.sh --prefix=$HOME/workspace/boost_install
# ./b2 install \
#     --prefix=$HOME/workspace/boost_install \
#     --with-filesystem \
#     --with-program_options \
#     --with-system \
#     link=static \
#     threading=multi \
#     variant=release \
#     cxxflags="-fPIC" \
#     -j$(nproc)

# ONNX_VERSION="1.18.0"
# ONNX_URL="https://github.com/onnx/onnx/archive/refs/tags/v1.18.0.zip"
# INSTALL_DIR="$HOME/workspace/onnx_install"
# PROTOBUF_DIR="$HOME/workspace/protobuf_install"

# # 1. Download and Extract
# if [ ! -f "v${ONNX_VERSION}.zip" ]; then
#     wget $ONNX_URL -O v${ONNX_VERSION}.zip
# fi

# if [ ! -d "onnx-${ONNX_VERSION}" ]; then
#     unzip v${ONNX_VERSION}.zip
# fi

# cd onnx-${ONNX_VERSION}
# mkdir -p build && cd build

# export Protobuf_DIR=/home/yueqingz/workspace/protobuf_install/lib/cmake/protobuf
# # 2. Build ONNX
# # Note: We use -DNDEBUG to match your Protobuf build and 
# # --offload-host-only to prevent HIP from trying to generate GPU code for ONNX logic.
# cmake .. \
#     -DCMAKE_BUILD_TYPE=Release \
#     -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
#     -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
#     -DProtobuf_DIR=$PROTOBUF_DIR/lib/cmake/protobuf \
#     -DONNX_NAMESPACE=morphizen_onnx \
#     -DONNX_USE_LITE_PROTO=OFF \
#     -DONNX_WERROR=OFF \
#     -DBUILD_SHARED_LIBS=ON \
#     -DCMAKE_CXX_FLAGS="-DNDEBUG -fPIC"
#     -DCMAKE_HIP_ARCHITECTURES=gfx1201 \
#     -DCMAKE_CXX_FLAGS="--offload-host-only"

# make -j$(nproc)
# make install