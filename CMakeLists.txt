################################################################################
# CMake base support for the VA108XX devices
#
# Author: R. Mueller
################################################################################

################################################################################
# Pre-Project preparation
################################################################################
cmake_minimum_required(VERSION 3.13)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_SCRIPT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# Set toolchain file which sets cross-compiler and ABI flags
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SCRIPT_PATH}/VA10820Toolchain.cmake")

set(CONFIG_PATH config)

set(VOR_VERBOSE_LEVEL "1" CACHE STRING "Verbosity level for debug output")
set_property(CACHE VOR_VERBOSE_LEVEL PROPERTY STRINGS 0 1 2)

project(va108xx-template ASM C CXX)
set(TARGET_NAME ${CMAKE_PROJECT_NAME})

option(NVM1 "Generate image which can be flashed to non-volatile memory at position 1" OFF)
if(NOT NVM1)
    option(NVM2 "Generate image which can be flashed to non-volatile memory at position 1" OFF)
endif()

option(VOR_RTT_LOG "Use SEGGER RTT for logging messages" ON)
# Default REB1 frequency. Change to other frequency if desired
set(VOR_SYSTEM_CLOCK 50000000UL)

set(LINK_SCRIPTS_PATH "${CMAKE_CURRENT_SOURCE_DIR}/vorago/linker")
set(LINKER_SCRIPT_REGULAR ${LINK_SCRIPTS_PATH}/va108xx_linker.ld)
set(LINKER_SCRIPT_NVM1 ${LINK_SCRIPTS_PATH}/va108xx_linker_nvm_pos1.ld)
set(LINKER_SCRIPT_NVM2 ${LINK_SCRIPTS_PATH}/va108xx_linker_nvm_pos2.ld)

if(NVM1)
    set(LINKER_SCRIPT ${LINKER_SCRIPT_NVM1})
    set(NVM_BINARY_1 ON)
elseif(NVM2)
    set(LINKER_SCRIPT ${LINKER_SCRIPT_NVM2})
    set(NVM_BINARY_2 ON)
else()
    set(LINKER_SCRIPT ${LINKER_SCRIPT_REGULAR})
endif()

configure_file(${CONFIG_PATH}/VORConfig.h.in VORConfig.h)

# Add executable
add_executable(${TARGET_NAME})

add_subdirectory(src)
add_subdirectory(vorago)

set(OUTPUT_NAME_VAR ${TARGET_NAME})

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    target_include_directories(${TARGET_NAME} PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}
    )

    set(WARNING_FLAGS
        -Wall
        -Wextra
        -Wimplicit-fallthrough=1
        -Wno-unused-parameter
        -Wshadow=local
    )

    target_compile_options(${TARGET_NAME} PRIVATE
        -fomit-frame-pointer
        # Reduced code size
        -fno-unwind-tables
        -fno-exceptions
        # Remove unused code
        -ffunction-sections
        -fdata-sections
        ${WARNING_FLAGS}
    )

    if(NOT ${CMAKE_BUILD_TYPE} MATCHES "Debug")
        target_compile_options(${TARGET_NAME} PRIVATE
            # Compile with link time optimization
            -flto
        )
    endif()

    target_compile_options(${TARGET_NAME} PRIVATE 
        $<$<COMPILE_LANGUAGE:CXX>:-std=c++14 -fno-rtti>
    )

    target_link_options(${TARGET_NAME} PRIVATE
        -T${LINKER_SCRIPT}
        -Wl,-Map=${OUTPUT_NAME_VAR}.map
        # Remove unused code
        -Wl,--gc-sections
    )
    if(NOT ${CMAKE_BUILD_TYPE} MATCHES "Debug")
        target_link_options(${TARGET_NAME} PRIVATE
            # Compile with link time optimization
            -flto
        )
    endif()
endif()

# Always print image size
add_custom_target(${TARGET_NAME}_size
    ALL COMMAND ${CMAKE_SIZE} ${OUTPUT_NAME_VAR}
    COMMENT "Target Sizes: "
    DEPENDS ${TARGET_NAME}
)

add_custom_command(
    TARGET ${TARGET_NAME}
    POST_BUILD
    COMMAND echo Generating binary file ${OUTPUT_NAME_VAR}.bin..
    COMMAND ${CMAKE_OBJCOPY} -O binary ${OUTPUT_NAME_VAR} ${OUTPUT_NAME_VAR}.bin
)

add_custom_command(
    TARGET ${TARGET_NAME}
    POST_BUILD
    COMMAND echo Generating binary file ${OUTPUT_NAME_VAR}.hex..
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${OUTPUT_NAME_VAR} ${OUTPUT_NAME_VAR}.hex
)
    
include (${CMAKE_SCRIPT_PATH}/BuildType.cmake)
set_build_type()
