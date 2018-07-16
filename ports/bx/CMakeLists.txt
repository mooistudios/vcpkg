cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

project(bx CXX C)

set(TOOLS_DESTINATION "bin" CACHE STRING "Destination path to install tools.")



if(UNIX AND NOT APPLE)
  set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()



file(GLOB BX_SOURCES
          src/*.cpp
          scripts/*.natvis)
file(GLOB BX_AMALGAMATED src/amalgamated.cpp)
list(REMOVE_ITEM BX_SOURCES ${BX_AMALGAMATED})

add_library(bx STATIC ${BX_SOURCES})
add_library(bx::bx ALIAS bx)

target_compile_features(bx PUBLIC cxx_std_11)

target_compile_definitions(bx PRIVATE "$<$<CONFIG:Debug>:BX_CONFIG_DEBUG=1>")
if(BGFX_CONFIG_DEBUG)
  target_compile_definitions(bx PRIVATE BX_CONFIG_DEBUG=1)
endif()

if(APPLE)
  find_library(FOUNDATION_LIBRARY Foundation)
  mark_as_advanced(FOUNDATION_LIBRARY)
  target_link_libraries(bx PRIVATE ${FOUNDATION_LIBRARY})
elseif(UNIX)
  find_package(Threads REQUIRED)
  target_link_libraries(bx PUBLIC Threads::Threads dl rt)
  set_target_properties(bx PROPERTIES POSITION_INDEPENDENT_CODE ON)
elseif(WIN32)
  find_library(PSAPI_LIBRARY Psapi)
  target_link_libraries(bx PRIVATE ${PSAPI_LIBRARY})
endif()

target_include_directories(bx
  PRIVATE
    3rdparty
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)

if(WIN32)
  target_include_directories(bx
    PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/compat/msvc>
      $<INSTALL_INTERFACE:include/compat/msvc>)
elseif(APPLE)
  target_include_directories(bx
    PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/compat/osx>
      $<INSTALL_INTERFACE:include/compat/osx>)
elseif(MINGW)
  target_include_directories(bx
    PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/compat/mingw>
      $<INSTALL_INTERFACE:include/compat/mingw>)
endif()



add_executable(bin2c tools/bin2c/bin2c.cpp)
add_executable(bx::bin2c ALIAS bin2c)
target_link_libraries(bin2c bx)



add_executable(lemon tools/lemon/lemon.c)
add_executable(bx::lemon ALIAS lemon)
target_link_libraries(lemon bx)



install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/tools/lemon/lempar.c
  DESTINATION ${TOOLS_DESTINATION})

install(TARGETS bx bin2c lemon
  EXPORT bxTargets
  RUNTIME DESTINATION ${TOOLS_DESTINATION}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/bx DESTINATION include)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/compat DESTINATION include)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/tinystl DESTINATION include)

install(EXPORT bxTargets
  FILE bxTargets.cmake
  NAMESPACE bx::
  DESTINATION share/bx)

include(CMakePackageConfigHelpers)
install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/bxConfig.cmake
  DESTINATION share/bx)
