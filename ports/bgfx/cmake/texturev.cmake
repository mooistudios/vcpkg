file(GLOB_RECURSE TEXTUREV_SOURCES tools/texturev/*)
add_executable(texturev ${TEXTUREV_SOURCES})
add_executable(bgfx::texturev ALIAS texturev)
target_link_libraries(texturev
  example-common
  bgfx)
