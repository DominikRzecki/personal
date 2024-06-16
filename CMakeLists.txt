cmake_minimum_required(VERSION 3.20)
project(personal)

set(CMAKE_CXX_STANDARD 23)

include_directories(c++/math/vector)
include_directories(c++/math/complex)

add_executable(personal c++/examples/mathematical-vector.cpp)
