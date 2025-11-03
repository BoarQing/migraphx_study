cmake_minimum_required(VERSION 3.22.1)
project(migraphx_sample_inference
        VERSION 1.0.0
        LANGUAGES C CXX)
# where did u install the MiGraphX
list(APPEND CMAKE_PREFIX_PATH "../mi_install_dir")
find_package(migraphx CONFIG REQUIRED)