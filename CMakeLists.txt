cmake_minimum_required(VERSION 3.16)
project(sda_workflow VERSION 1.0.0 LANGUAGES CXX)

# Options
option(SDA_TEST "Enable unit tests for sda workflow" ON)

# Variables
set(CMAKE_CXX_STANDARD 23)
set(SDA_NAME SDA_Workflow)
set(SDA_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE INTERNAL "Root Directory of the SDA Workflow project")

# Compiler flags and warnings
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    message(STATUS "Setting compiler flags and warnings")
    add_compile_options(-Wall -Wextra -Wpedantic -Wconversion -Wno-unused-parameter -Wno-unused-function)
endif()

# Include Fishnet
include(lib/fishnet.cmake)
add_subdirectory(src)

# Build tests
if(SDA_TEST)
    include(lib/gtest.cmake)
    enable_testing()
    add_subdirectory(test)
endif()