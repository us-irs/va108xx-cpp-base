target_include_directories(${TARGET_NAME} PRIVATE
	${CMAKE_CURRENT_SOURCE_DIR}
)

target_sources(${TARGET_NAME} PRIVATE
    circular_buffer.c
    redirect.c
    segger_rtt_printf.c
    segger_rtt.c
    utils.c
)

if(VOR_RTT_LOG)
    target_sources(${TARGET_NAME} PRIVATE
        segger_rtt_syscalls_gcc.c
    )
endif()
