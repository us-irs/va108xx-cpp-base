target_include_directories(${TARGET_NAME} PRIVATE
	${CMAKE_CURRENT_SOURCE_DIR}
)

target_sources(${TARGET_NAME} PRIVATE
    hardfault_handler.c
    irq_va108xx.c
    system_va108xx.c
)
