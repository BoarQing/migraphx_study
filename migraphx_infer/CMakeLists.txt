cmake_minimum_required(VERSION 3.22.1)
project(migraphx_sample_inference
        VERSION 1.0.0
        LANGUAGES C CXX)
# where is onnxruntime cmake files
list(APPEND CMAKE_PREFIX_PATH "/home/yueqingz/workspace/onnxruntime_install")
find_package(onnxruntime CONFIG REQUIRED)
add_executable(test_onnx_runner_migraphx test_onnx_runner_migraphx_ep.cpp)
target_link_libraries(test_onnx_runner_migraphx onnxruntime::onnxruntime)

add_executable(test_onnx_runner_newabi test_onnx_runner_new_abi.cpp)
target_link_libraries(test_onnx_runner_newabi onnxruntime::onnxruntime)