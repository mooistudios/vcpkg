cmake_minimum_required(VERSION 3.11)
project(tray C)

add_library(tray INTERFACE)

install(TARGETS tray
  EXPORT trayTargets
  PUBLIC_HEADER DESTINATION include)

install(EXPORT trayTargets
  FILE trayTargets.cmake
  NAMESPACE tray::
  DESTINATION share/tray)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/tray.h DESTINATION include)

include(CMakePackageConfigHelpers)
install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/trayConfig.cmake
  DESTINATION share/tray)
