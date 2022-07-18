cmake_minimum_required(VERSION 3.2.0)

#set the project name
set(LISIN_MTR "CMake_Project")

set(CMAKE_BUILD_TYPE "Debug") #Release 如果是发行版本就更换Debug为Release 
if(CMAKE_BUILD_TYPE STREQUAL Debug)
    add_definitions(-D_DEBUG) #添加D_DEBUG编译参数
endif()

#设置编译参数
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lpthread -std=gnu99 -g -o0") #
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -W -Wall -Wextra -g2 -ggdb -o0 -lpthread")


# 设置编译工具链
#set(COMPILER_PREFIX "arm-linux-")
#set(CMAKE_C_COMPILER ${COMPILER_PREFIX}gcc)
#set(CMAKE_CXX_COMPILER ${COMPILER_PREFIX}g++)




#下面这部分是可修改部分，根据自己的实际工程要做什么去定义，我下面只是给你们一个参考
#################################################################
# 定义头文件路径对应的名字，方便等下去设定
#通用与辅助
set(SYS_FRAME_H     "${CMAKE_SOURCE_DIR}/source/System_Frame")





#库文件路径添加
file(GLOB_RECURSE Mqtt_lib ${THIRLD_LIB_PATH}/mqtt_lib/lib/*.so*)


#项目编译选择，通过选择开关来进行编译选项,通过这种方式去选择编译测试模块中的哪一个
# 之后需要添加，
option(Main_Source "main pro"     ON)
option(BOARD_TEST  "board_test"   OFF)


#添加子工程目录
if(Main_Source)
add_subdirectory(${CMAKE_SOURCE_DIR}/source)
endif()


#测试程序
if(BOARD_TEST)
option(IIC_TEST  "UART"   OFF)
option(GPIO_TEST "GPIO"  OFF)
add_subdirectory(${CMAKE_SOURCE_DIR}/unit_test/board_test)
endif()

