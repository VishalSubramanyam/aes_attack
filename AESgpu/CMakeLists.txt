cmake_minimum_required(VERSION 3.0)

project(AESgpu LANGUAGES CXX CUDA)
add_compile_options(--compiler-options -Wall)

add_library(AES src/aes_main.cu)
target_include_directories(AES PUBLIC include)

add_executable(aes_test src/aes_test.cu)
target_link_libraries(aes_test PRIVATE AES)
target_include_directories(aes_test PRIVATE include)

add_executable(aes_generate src/aes_generate.cu)
target_link_libraries(aes_generate PRIVATE AES)
target_include_directories(aes_generate PRIVATE include)