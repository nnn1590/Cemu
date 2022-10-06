set(CMAKE_SYSTEM_NAME Windows)
set(TOOLCHAIN_PREFIX x86_64-w64-mingw32)

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_RC_COMPILER ${TOOLCHAIN_PREFIX}-windres)

option(ENABLE_VCPKG "Enable the vcpkg package manager" ON)

if (ENABLE_VCPKG)
	# For unknown reason, manually adding vcpkg_installed/ to CMAKE_FIND_ROOT_PATH is needed
	# to avoid mysterious error
	# (e.g. "Could NOT find imgui (missing: imgui_LINK_LIBRARIES imgui_FOUND"
	#  even imgui exists under vcpkg_installed/)
	set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_BINARY_DIR}/vcpkg_installed/x64-mingw-static;/usr/local/${TOOLCHAIN_PREFIX};/usr/${TOOLCHAIN_PREFIX})
else()
	set(CMAKE_FIND_ROOT_PATH /usr/local/${TOOLCHAIN_PREFIX};/usr/${TOOLCHAIN_PREFIX})
endif()

# Avoid CMake's preference for /bin over the $PATH environment variable
set(CMAKE_FIND_USE_CMAKE_PATH FALSE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

if (ENABLE_VCPKG)
	if (NOT DEFINED VCPKG_OVERLAY_PORTS)
		set(VCPKG_OVERLAY_PORTS "${CMAKE_CURRENT_LIST_DIR}/dependencies/vcpkg_overlay_ports")
	endif()

	# Set this so that all the various find_package() calls don't need an explicit
	# CONFIG option
	set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

	if (NOT DEFINED VCPKG_TARGET_TRIPLET)
		set(VCPKG_TARGET_TRIPLET "x64-mingw-static" CACHE STRING "")
	else()
		set(VCPKG_TARGET_TRIPLET "${VCPKG_TARGET_TRIPLET}" CACHE STRING "")
	endif()

	include("${CMAKE_CURRENT_LIST_DIR}/dependencies/vcpkg/scripts/buildsystems/vcpkg.cmake")

	set(VCPKG_INITIALIZED TRUE)
endif()

add_compile_definitions(WINVER=0x0600 _WIN32_WINNT=0x0600)
