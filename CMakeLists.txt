cmake_minimum_required(VERSION 3.15)
project(EdgeAIApp)

set(CMAKE_CXX_STANDARD 17)

include_directories(include)

add_executable(EdgeAIApp
    src/main.cpp
    src/server.cpp
)
