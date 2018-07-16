cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

project(bimg CXX C)

set(TOOLS_DESTINATION "bin" CACHE STRING "Destination path to install tools.")

find_package(bx REQUIRED)



if(UNIX AND NOT APPLE)
  set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()



file(GLOB BIMG_SOURCES
          include/*
          src/image.*
          src/image_gnf.cpp)

add_library(bimg STATIC ${BIMG_SOURCES})
add_library(bimg::bimg ALIAS bimg)
target_link_libraries(bimg PRIVATE bx::bx)
target_include_directories(bimg
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)


file(GLOB BIMG_DECODE_SOURCES
          include/*
          src/image_decode.*)
add_library(bimg_decode STATIC ${BIMG_DECODE_SOURCES})
add_library(bimg::bimg_decode ALIAS bimg_decode)
target_link_libraries(bimg_decode PRIVATE bimg bx::bx)
target_include_directories(bimg_decode
  PRIVATE
    include
    3rdparty
    3rdparty/nvtt
    3rdparty/iqa/include)



file(GLOB BIMG_ENCODE_SOURCES
          include/*
          src/image_encode.*
          3rdparty/libsquish/*.cpp
          3rdparty/libsquish/*.h
          3rdparty/edtaa3/*.cpp
          3rdparty/edtaa3/*.h
          3rdparty/etc1/*.cpp
          3rdparty/etc1/*.h
          3rdparty/etc2/*.cpp
          3rdparty/etc2/*.hpp
          3rdparty/nvtt/*.cpp
          3rdparty/nvtt/*.h
          3rdparty/pvrtc/*.cpp
          3rdparty/pvrtc/*.h
          3rdparty/tinyexr/*.h
          3rdparty/iqa/include/*.h
          3rdparty/iqa/source/*.c)
add_library(bimg_encode STATIC ${BIMG_ENCODE_SOURCES})
add_library(bimg::bimg_encode ALIAS bimg_decode)
target_link_libraries(bimg_encode PRIVATE bimg bx::bx)
target_include_directories(bimg_encode
  PRIVATE
    include
    3rdparty
    3rdparty/nvtt
    3rdparty/iqa/include)



file(GLOB_RECURSE TEXTUREC_SOURCES
  3rdparty/libsquish/*.cpp
  3rdparty/libsquish/*.h
  3rdparty/edtaa3/*.cpp
  3rdparty/edtaa3/*.h
  3rdparty/etc1/*.cpp
  3rdparty/etc1/*.h
  3rdparty/etc2/*.cpp
  3rdparty/etc2/*.hpp
  3rdparty/nvtt/*.cpp
  3rdparty/nvtt/*.h
  3rdparty/pvrtc/*.cpp
  3rdparty/pvrtc/*.h
  3rdparty/tinyexr/*.h
  3rdparty/iqa/include/*.h
  3rdparty/iqa/source/*.c
  tools/texturec/*.cpp
  tools/texturec/*.h)
add_executable(texturec ${TEXTUREC_SOURCES})
add_executable(bimg::texturec ALIAS texturec)
target_link_libraries(texturec bx::bx bimg_encode bimg_decode)
target_include_directories(texturec
  PRIVATE
    include
    3rdparty
    3rdparty/nvtt
    3rdparty/iqa/include)


install(TARGETS bimg bimg_encode bimg_decode texturec
  EXPORT bimgTargets
  RUNTIME DESTINATION ${TOOLS_DESTINATION}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  INCLUDES DESTINATION include)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/bimg DESTINATION include)

install(EXPORT bimgTargets
  FILE bimgTargets.cmake
  NAMESPACE bimg::
  DESTINATION share/bimg)

include(CMakePackageConfigHelpers)
install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/bimgConfig.cmake
  DESTINATION share/bimg)
