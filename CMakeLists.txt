# SPDX-License-Identifier: GPL-3.0-or-later
cmake_minimum_required(VERSION 3.20)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" BMWLINK_PROJECT_VERSION)
string(STRIP "${BMWLINK_PROJECT_VERSION}" BMWLINK_PROJECT_VERSION)
if(NOT BMWLINK_PROJECT_VERSION MATCHES "^[0-9]+\\.[0-9]+\\.[0-9]+$")
  message(FATAL_ERROR "VERSION must contain a semantic major.minor.patch version")
endif()
project(BMWLINK VERSION "${BMWLINK_PROJECT_VERSION}" LANGUAGES C)

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/include/bmwlink/bmwlink.h" BMWLINK_PUBLIC_VERSION_HEADER)
string(REGEX MATCH
  "#define[ \t]+BMWLINK_VERSION[ \t]+\"([0-9]+\\.[0-9]+\\.[0-9]+)\""
  BMWLINK_PUBLIC_VERSION_MATCH "${BMWLINK_PUBLIC_VERSION_HEADER}")
if(NOT BMWLINK_PUBLIC_VERSION_MATCH OR NOT CMAKE_MATCH_1 STREQUAL PROJECT_VERSION)
  message(FATAL_ERROR "VERSION and BMWLINK_VERSION must agree")
endif()
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
add_subdirectory(src/link EXCLUDE_FROM_ALL)
set(BUILD_TESTING ON CACHE BOOL "" FORCE)
enable_testing()

add_library(bmwlink-core STATIC src/bmwlink.c)
add_library(BMWLINK::Core ALIAS bmwlink-core)
target_include_directories(bmwlink-core PUBLIC include)
target_compile_definitions(bmwlink-core PRIVATE BMWLINK_VERSION="${PROJECT_VERSION}")
target_link_libraries(bmwlink-core PUBLIC LINK::Core)

add_executable(bmwlink-smoke tests/test_smoke.c)
target_compile_definitions(bmwlink-smoke PRIVATE BMWLINK_EXPECTED_VERSION="${PROJECT_VERSION}")
target_link_libraries(bmwlink-smoke PRIVATE BMWLINK::Core)
add_test(NAME bmwlink-smoke COMMAND bmwlink-smoke)
add_executable(bmwlink-obd2 tests/test_obd2.c)
target_link_libraries(bmwlink-obd2 PRIVATE BMWLINK::Core)
add_test(NAME bmwlink-obd2 COMMAND bmwlink-obd2)
add_executable(bmwlink-generic-diagnostics tests/test_generic_diagnostics.c)
target_link_libraries(bmwlink-generic-diagnostics PRIVATE BMWLINK::Core)
add_test(NAME bmwlink-generic-diagnostics COMMAND bmwlink-generic-diagnostics)

option(BMWLINK_BUILD_LINUX_GUI "Build native GTK4 GUI" OFF)
option(BMWLINK_BUILD_WINDOWS_DISCOVER "Build Win32 Discover GUI" ${WIN32})
include(GNUInstallDirs)

if(BMWLINK_BUILD_LINUX_GUI)
  if(NOT UNIX OR APPLE)
    message(FATAL_ERROR "BMWLINK_BUILD_LINUX_GUI is Linux-only")
  endif()
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4>=4.6)
  find_program(GLIB_COMPILE_RESOURCES_EXECUTABLE NAMES glib-compile-resources REQUIRED)
  set(BMWLINK_LINUX_RESOURCE_SOURCE "${CMAKE_CURRENT_BINARY_DIR}/bmwlink-linux-resources.c")
  add_custom_command(OUTPUT "${BMWLINK_LINUX_RESOURCE_SOURCE}"
    COMMAND "${GLIB_COMPILE_RESOURCES_EXECUTABLE}" --generate-source --c-name=bmwlink_linux_resources
      "--target=${BMWLINK_LINUX_RESOURCE_SOURCE}" bmwlink.gresource.xml
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/app/linux"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/app/linux/bmwlink.gresource.xml"
      "${CMAKE_CURRENT_SOURCE_DIR}/app/linux/assets/bmwlink-emblem.png"
    VERBATIM)
  add_executable(bmwlink app/linux/main.c "${BMWLINK_LINUX_RESOURCE_SOURCE}")
  set_source_files_properties("${BMWLINK_LINUX_RESOURCE_SOURCE}" PROPERTIES COMPILE_OPTIONS "-w")
  target_link_libraries(bmwlink PRIVATE BMWLINK::Core PkgConfig::GTK4)
  link_enable_linux_gtk_shell(bmwlink UDEV_RULE_NAME "60-bmwlink-openport2.rules")
  install(TARGETS bmwlink RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
  install(FILES app/linux/assets/bmwlink-emblem.png DESTINATION "${CMAKE_INSTALL_DATADIR}/pixmaps" RENAME bmwlink.png)
  install(FILES app/linux/bmwlink.desktop DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
  install(FILES README.md docs/OBD2.md docs/GENERIC_BASELINE.md DESTINATION "${CMAKE_INSTALL_DATADIR}/doc/bmwlink")
  set(CPACK_GENERATOR "DEB")
  set(CPACK_PACKAGE_NAME "bmwlink")
  set(CPACK_PACKAGE_VENDOR "Infiltrator Projects")
  set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "BMW diagnostics GUI using LINK")
  set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
  set(CPACK_PACKAGE_CONTACT "Infiltrator Projects")
  set(CPACK_PACKAGING_INSTALL_PREFIX "/usr")
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Infiltrator Projects")
  set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
  set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
  set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
  set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
  set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
  include(CPack)
endif()

if(BMWLINK_BUILD_WINDOWS_DISCOVER)
  if(NOT WIN32)
    message(FATAL_ERROR "BMWLINK_BUILD_WINDOWS_DISCOVER is Windows-only")
  endif()
  link_add_windows_discover(bmwlink-discover
    PRODUCT_NAME "BMWLINK" PRODUCT_SLUG "bmwlink" WINDOW_CLASS "BMWLINKDiscoverWindow"
    PRODUCT_VERSION "${PROJECT_VERSION}" PRODUCT_COPYRIGHT "Copyright (C) 2026 Shannon Smith"
    PRODUCT_SUBTITLE "BMW Diagnostics"
    PRODUCT_DESCRIPTION "A C-first, open-source BMW vehicle diagnostics platform."
    PRODUCT_AUTHORS "Shannon Smith"
    PRODUCT_LICENSE_NAME "GPL-3.0-or-later"
    PRODUCT_WEBSITE "https://github.com/Infiltrator-Projects/BMWLINK"
    PRODUCT_ICON_PNG "${CMAKE_CURRENT_SOURCE_DIR}/app/ios/BMWLINK/Assets.xcassets/AppIcon.appiconset/AppIcon-60@3x.png")
  target_link_libraries(bmwlink-discover PRIVATE BMWLINK::Core)
  if(MSVC)
    target_compile_options(bmwlink-discover PRIVATE
      "/FI${CMAKE_CURRENT_SOURCE_DIR}/src/link/platform/windows/link-discover-theme.h")
  endif()
  target_compile_definitions(bmwlink-discover PRIVATE
    LINK_THEME_BACKGROUND=0x00100B08
    LINK_THEME_PANEL=0x00251B12
    LINK_THEME_INPUT=0x001C1510
    LINK_THEME_TEXT=0x00FBF6F2
    LINK_THEME_MUTED=0x00BAA58E
    LINK_THEME_ACCENT=0x00D4691C
    LINK_THEME_ACCENT_TEXT=0x001C1510
    "LINK_PRODUCT_FONT_UI=\"Segoe UI\"")
endif()
