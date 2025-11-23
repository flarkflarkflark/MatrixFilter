cmake_minimum_required(VERSION 3.17)
project(MatrixFilter VERSION 1.0.0 LANGUAGES C CXX)

add_library(MatrixFilter SHARED)
set_target_properties(MatrixFilter PROPERTIES
    C_STANDARD 11
    CXX_STANDARD 17
)

# Include directories
target_include_directories(MatrixFilter PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/external/clap/include
)

# Source files
target_sources(MatrixFilter PRIVATE
    src/dsp.cpp
    src/plugin.cpp
    src/plugin-extensions.cpp
    src/plugin-factory.cpp
    src/plugin-entry.cpp
)

# Add GUI files if OpenGL is available
if(OpenGL_FOUND)
    target_sources(MatrixFilter PRIVATE
        src/gui.cpp
        src/gui-extension.cpp
    )
endif()

# Link libraries
target_link_libraries(MatrixFilter PRIVATE
    m
    pthread
)

# Platform-specific settings and dependencies
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    # Find OpenGL for Linux (optional for GUI)
    find_package(OpenGL QUIET)
    if(OpenGL_FOUND)
        target_link_libraries(MatrixFilter PRIVATE OpenGL::GL)
        target_compile_definitions(MatrixFilter PRIVATE HAS_OPENGL=1)
    endif()

    # Link pthread for Linux
    find_package(Threads REQUIRED)
    target_link_libraries(MatrixFilter PRIVATE Threads::Threads)

    # Symbol exports for Linux
    target_link_libraries(MatrixFilter PRIVATE -Wl,--version-script=${CMAKE_CURRENT_SOURCE_DIR}/src/symbols.map)
    target_link_libraries(MatrixFilter PRIVATE -Wl,-z,defs)
    set_target_properties(MatrixFilter PROPERTIES SUFFIX ".clap" PREFIX "")
    
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    # Find OpenGL for macOS (optional for GUI)
    find_package(OpenGL QUIET)
    if(OpenGL_FOUND)
        target_link_libraries(MatrixFilter PRIVATE OpenGL::GL)
        target_compile_definitions(MatrixFilter PRIVATE HAS_OPENGL=1)
    endif()

    # Symbol exports for macOS
    target_link_options(MatrixFilter PRIVATE -exported_symbols_list ${CMAKE_CURRENT_SOURCE_DIR}/src/symbols-macos.txt)
    set_target_properties(MatrixFilter PROPERTIES
        BUNDLE True
        BUNDLE_EXTENSION clap
        MACOSX_BUNDLE_GUI_IDENTIFIER com.flark.matrixfilter
        MACOSX_BUNDLE_BUNDLE_NAME "flark's MatrixFilter"
        MACOSX_BUNDLE_BUNDLE_VERSION "1.0.0"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0.0"
    )

elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    # Find OpenGL for Windows (optional for GUI)
    find_package(OpenGL QUIET)
    if(OpenGL_FOUND)
        target_link_libraries(MatrixFilter PRIVATE OpenGL::GL)
        target_compile_definitions(MatrixFilter PRIVATE HAS_OPENGL=1)
    endif()

    # Symbol exports for Windows
    target_link_options(MatrixFilter PRIVATE /DEF:${CMAKE_CURRENT_SOURCE_DIR}/src/symbols-windows.txt)
    set_target_properties(MatrixFilter PROPERTIES SUFFIX ".clap" PREFIX "")
endif()

# Installation
install(TARGETS MatrixFilter DESTINATION .)
install(FILES README.md DESTINATION .)