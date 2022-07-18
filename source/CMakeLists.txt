aux_source_directory("${PROJECT_SOURCE_DIR}/source/System_Frame" DIR_SOURCE_SYS_FRAME)
aux_source_directory("${PROJECT_SOURCE_DIR}/source" DIR_SOURCE_SRCS)



# 指定生成目标
add_executable( ${LISIN_MTR} 
                ${DIR_SOURCE_SYS_FRAME}
                ${DIR_SOURCE_SRCS}
              )

message(STATUS "SYS_FRAME_H: " ${SYS_FRAME_H})

#头文件包含
target_include_directories(${LISIN_MTR} PRIVATE
                           ${SYS_FRAME_H}
                           )

#连接库                         
target_link_libraries(${LISIN_MTR} PUBLIC ${Mqtt_lib})

#执行文件的安装位置
install(TARGETS ${LISIN_MTR} RUNTIME DESTINATION ${PROJECT_SOURCE_DIR}/bin)
