# CMakeLists.txt
# Edge-AI-APP
# Created by Alexandre on 11/04/2026
# Example extensive CMake file in English

cmake_minimum_required(VERSION 3.20)

# Project definition
project(EdgeAIManager
    VERSION 1.0.0
    DESCRIPTION "EdgeAIManager build system with CMake"
    LANGUAGES C CXX)

# Global build settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Source directory
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")
file(GLOB_RECURSE SOURCES "${SRC_DIR}/*.cpp" "${SRC_DIR}/*.c")

# Main executable
add_executable(edge_ai_manager ${SOURCES})

# Include directories
target_include_directories(edge_ai_manager PRIVATE "${SRC_DIR}/include")

# Compiler options
target_compile_options(edge_ai_manager PRIVATE -Wall -Wextra -Wpedantic)

# Installation
install(TARGETS edge_ai_manager DESTINATION bin)

# Testing (optional)
enable_testing()
add_test(NAME run_edge_ai_manager COMMAND edge_ai_manager)

# Informative messages
message(STATUS "EdgeAIManager build configured")
message(STATUS "Source directory: ${SRC_DIR}")
message(STATUS "Output binary: edge_ai_manager")
