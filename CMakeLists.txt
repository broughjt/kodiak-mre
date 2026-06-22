cmake_minimum_required(VERSION 3.20)
project(kodiak_mre LANGUAGES CXX)

add_executable(mre src/main.cpp)
set_target_properties(mre PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED YES
  CXX_EXTENSIONS NO
)

target_include_directories(mre PRIVATE
  "$ENV{KODIAK_ROOT}/include/kodiak"
  "$ENV{FILIB_ROOT}/include"
)

target_link_directories(mre PRIVATE
  "$ENV{KODIAK_ROOT}/lib"
  "$ENV{FILIB_ROOT}/lib"
)

target_link_libraries(mre PRIVATE kodiak prim)
