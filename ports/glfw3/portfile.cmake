include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO glfw/glfw
    HEAD_REF master
    REF 0be4f3f75aebd9d24583ee86590a38e741db0904
    SHA512 1ac6fc88e729f62562f89e4ecff2885b3b163b8a9432481a87e397a647094940c44092d915f597f85b11439b671d8fd15ac82604376147a282032cadd9813d71)

if(NOT EXISTS ${SOURCE_PATH}/patch-config.stamp)
    message(STATUS "Patching src/glfw3Config.cmake.in")
    file(READ ${SOURCE_PATH}/src/glfw3Config.cmake.in CONFIG)
    string(REPLACE "\"@GLFW_LIB_NAME@\"" "NAMES @GLFW_LIB_NAME@ @GLFW_LIB_NAME@dll"
        CONFIG ${CONFIG}
    )
    #string(REPLACE "@PACKAGE_CMAKE_INSTALL_PREFIX@" "@PACKAGE_CMAKE_INSTALL_PREFIX@/../.."
    #    CONFIG ${CONFIG}
    #)
    file(WRITE ${SOURCE_PATH}/src/glfw3Config.cmake.in "${CONFIG}")
    file(APPEND ${SOURCE_PATH}/src/glfw3Config.cmake.in "set(GLFW3_LIBRARIES \${GLFW3_LIBRARY})\n")
    file(WRITE ${SOURCE_PATH}/patch-config.stamp)
endif()

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/move-cmake-min-req.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DGLFW_BUILD_EXAMPLES=OFF
        -DGLFW_BUILD_TESTS=OFF
        -DGLFW_BUILD_DOCS=OFF
        -DPACKAGE_CMAKE_INSTALL_PREFIX=\${CMAKE_CURRENT_LIST_DIR}/../..
)

vcpkg_install_cmake()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/glfw3 ${CURRENT_PACKAGES_DIR}/share/glfw3)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(READ ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets.cmake _contents)
set(pattern "get_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)\n")
string(REPLACE "${pattern}${pattern}${pattern}" "${pattern}${pattern}" _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets.cmake "${_contents}")

file(READ ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/glfw3/glfw3Targets-debug.cmake _contents)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets-debug.cmake "${_contents}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(RENAME ${CURRENT_PACKAGES_DIR}/lib/glfw3.dll ${CURRENT_PACKAGES_DIR}/bin/glfw3.dll)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/glfw3.dll ${CURRENT_PACKAGES_DIR}/debug/bin/glfw3.dll)
    foreach(_conf release
                  debug)
        file(READ ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets-${_conf}.cmake _contents)
        string(REPLACE "lib/glfw3.dll" "bin/glfw3.dll" _contents "${_contents}")
        file(WRITE ${CURRENT_PACKAGES_DIR}/share/glfw3/glfw3Targets-${_conf}.cmake "${_contents}")
    endforeach()

endif()

file(COPY ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/glfw3)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/glfw3/LICENSE.md ${CURRENT_PACKAGES_DIR}/share/glfw3/copyright)
vcpkg_copy_pdbs()

