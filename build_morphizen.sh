export onnxruntime_DIR=/home/$USER/workspace/onnxruntime_install
export hip_DIR=/opt/rocm/lib/cmake/hip/
export MIOpen_DIR=/opt/rocm/lib/cmake/miopen
export rocblas_DIR=/opt/rocm/lib/cmake/rocblas
export hipblaslt_DIR=/opt/rocm/lib/cmake/hipblaslt
export Protobuf_DIR=/home/yueqingz/workspace/protobuf_install/lib/cmake/protobuf
export Boost_DIR=/home/yueqingz/workspace/boost_install/lib/cmake
export boost_process_DIR=/home/yueqingz/workspace/boost_install/lib/cmake
#export hipblas-common_DIR=/opt/rocm/lib/cmake/hipblas-common
# export CXX=/opt/rocm/bin/hipcc
# export CC=/opt/rocm/bin/amdclang
rm /home/yueqingz/workspace/morphizen_build -rf

    # -DCMAKE_CXX_COMPILER=/opt/rocm/bin/hipcc \
cmake -B /home/$USER/workspace/morphizen_build \
    -S /home/$USER/workspace/morphizen-migraphx \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -Dmorphizen_ENABLE_ORT_BRIDGE=ON \
    -DCMAKE_INSTALL_PREFIX=/home/$USER/workspace/morphizen_install \
    -DCMAKE_CXX_FLAGS="-Wno-error=conversion -Wno-error=sign-compare -Wno-error=nonnull-compare" \
    -DVAIP_JSON_CONFIG_FILE=/home/$USER/workspace/morphizen-migraphx/etc/vaip_config.json \
    -Dmorphizen_ENABLE_UNIT_TEST=OFF
cmake --build /home/$USER/workspace/morphizen_build --parallel 20