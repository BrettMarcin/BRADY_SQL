cmake_minimum_required(VERSION 3.17)
project(test_bison)

set(CMAKE_CXX_STANDARD 14)

#include_directories(${CMAKE_SOURCE_DIR}/include/)
include_directories(include)

file(REMOVE ${CMAKE_SOURCE_DIR}/src/sql/build_files/parser.cpp)
file(REMOVE ${CMAKE_SOURCE_DIR}/src/sql/build_files/scanner.cpp)
file(REMOVE ${CMAKE_SOURCE_DIR}/src/sql/build_files/tokens.h)

file(
        GLOB SOURCES
)

FIND_PACKAGE(BISON REQUIRED)
SET(BisonOutput ${CMAKE_SOURCE_DIR}/src/sql/build_files/parser.cpp)
IF(BISON_FOUND)
    ADD_CUSTOM_COMMAND(
            OUTPUT ${BisonOutput}
            COMMAND ${BISON_EXECUTABLE}
            --defines=${CMAKE_SOURCE_DIR}/src/sql/build_files/tokens.h
            --output=${BisonOutput}
            ${CMAKE_SOURCE_DIR}/src/sql/parser.y
            COMMENT "Generating parser.cpp"
    )
ENDIF()

FIND_PACKAGE(FLEX REQUIRED)
SET(FlexOutput ${CMAKE_SOURCE_DIR}/src/sql/build_files/scanner.cpp)
IF(FLEX_FOUND)
    ADD_CUSTOM_COMMAND(
            OUTPUT ${FlexOutput}
            COMMAND ${FLEX_EXECUTABLE}
            --outfile=${FlexOutput}
            ${CMAKE_SOURCE_DIR}/src/sql/scanner.l
            COMMENT "Generating scanner.cpp"
    )
ENDIF()

ADD_LIBRARY(MyLib ${BisonOutput} ${FlexOutput})
target_include_directories(MyLib
        PUBLIC
        "include/"
        )

add_executable(test_bison main.cpp)

target_link_libraries(test_bison MyLib)

install(TARGETS test_bison DESTINATION bin)