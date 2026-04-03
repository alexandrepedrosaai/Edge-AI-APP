cmake_minimum_required(VERSION 3.15)
project(EdgeAIApp VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(include)

# Main executable
add_executable(EdgeAIApp
    src/main.cpp
    src/server.cpp
)

# Test executable
add_executable(EdgeAIApp_test
    tests/test_server.cpp
    src/server.cpp
)

# Enable CTest
enable_testing()
add_test(NAME ServerTest COMMAND EdgeAIApp_test)

# Install rules
install(TARGETS EdgeAIApp DESTINATION bin)
