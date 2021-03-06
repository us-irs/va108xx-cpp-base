C/C++ template project for VA108xx based projects
========

# Prerequisites

1. ARM Cross-compiler installed and added to system path
2. CMake installed
3. SEGGER J-Link tools installed
4. Eclipse or VS Code for development recommended, project files provided

# <a id="build"></a> Build

Instructions for command line. Make sure you can call the cross-compiler from the command line,
e.g. with `arm-none-eabi-gcc -v`.

1. Create build directory

   ```sh
   make build && cd build
   ```

2. Set up build system. Depending on the OS and desired build system, you might have
   to specify the build system explicitely (e.g. with `-G "MinGW Makefiles"` or
   `-G "Ninja"` on Windows) instead of using the defaults

   ```sh
   cmake ..
   ```

3. Build the project

   ```sh
   cmake --build . -j
   ```

# <a id="flashdebug"></a> Flashing and Debugging

It is recommended to use Eclipse or VS code for convenient flashing, but the instructions here
show how to do it in the commnand line

1. Start the JLink GDB server.
2. Run the GDB application, for example `gdb-multiarch`

   ```sh
   gdb-multiarch -q -x jlink.gdb build/va10820-template
   ```

3. The debugger should now be stopped at the start of the application. Press `C` to continue

# Using VS Code

The only requirement on the [VS Code](https://code.visualstudio.com/) installation is the
following plugin:

- [Cortex-Debug](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)

Another requirement is that you still need to set up the Eclipse build configuration at least once
in the `build` folder like shown in the [build](#build) section. After that, you can use the
Run & Debug Tab of VS Code to debug your application.

# Using Eclipse

The only requirement on the [Eclipse](https://www.eclipse.org/downloads/packages/installer)
installation is the following plugin:

- [Eclipse Embedded CDT](https://projects.eclipse.org/projects/iot.embed-cdt). It is recommended to
   install the [xPacks](https://xpack.github.io/arm-none-eabi-gcc/install/) cross-compiler as it
   offers the best Eclipse support when used with this plugin

It is also recommended to install the following plugins

- [CMakeEditor](https://marketplace.eclipse.org/content/cmake-editor)

After installing all plugins, copy the `.cproject` and `.project` files from the `eclipse` folder
to the repository root. Now open the folder in Eclipse as a project and make sure to deselect the
`eclipse` folder in the selection Window.

Another requirement is that you still need to set up the Eclipse build configuration at least once
in the `build` folder like shown in the [build](#build) section. After that you should be able to
build and debug with the hammer and debug button conveniently now.
