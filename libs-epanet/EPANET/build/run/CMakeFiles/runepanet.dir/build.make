# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.13

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/lib/python3.7/dist-packages/cmake/data/bin/cmake

# The command to remove a file.
RM = /usr/local/lib/python3.7/dist-packages/cmake/data/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/augusto/Documents/EPANET

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/augusto/Documents/EPANET/build

# Include any dependencies generated for this target.
include run/CMakeFiles/runepanet.dir/depend.make

# Include the progress variables for this target.
include run/CMakeFiles/runepanet.dir/progress.make

# Include the compile flags for this target's objects.
include run/CMakeFiles/runepanet.dir/flags.make

run/CMakeFiles/runepanet.dir/main.c.o: run/CMakeFiles/runepanet.dir/flags.make
run/CMakeFiles/runepanet.dir/main.c.o: ../run/main.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/augusto/Documents/EPANET/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object run/CMakeFiles/runepanet.dir/main.c.o"
	cd /home/augusto/Documents/EPANET/build/run && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/runepanet.dir/main.c.o   -c /home/augusto/Documents/EPANET/run/main.c

run/CMakeFiles/runepanet.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/runepanet.dir/main.c.i"
	cd /home/augusto/Documents/EPANET/build/run && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/augusto/Documents/EPANET/run/main.c > CMakeFiles/runepanet.dir/main.c.i

run/CMakeFiles/runepanet.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/runepanet.dir/main.c.s"
	cd /home/augusto/Documents/EPANET/build/run && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/augusto/Documents/EPANET/run/main.c -o CMakeFiles/runepanet.dir/main.c.s

# Object files for target runepanet
runepanet_OBJECTS = \
"CMakeFiles/runepanet.dir/main.c.o"

# External object files for target runepanet
runepanet_EXTERNAL_OBJECTS =

bin/runepanet: run/CMakeFiles/runepanet.dir/main.c.o
bin/runepanet: run/CMakeFiles/runepanet.dir/build.make
bin/runepanet: lib/libepanet2.so
bin/runepanet: run/CMakeFiles/runepanet.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/augusto/Documents/EPANET/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable ../bin/runepanet"
	cd /home/augusto/Documents/EPANET/build/run && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/runepanet.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
run/CMakeFiles/runepanet.dir/build: bin/runepanet

.PHONY : run/CMakeFiles/runepanet.dir/build

run/CMakeFiles/runepanet.dir/clean:
	cd /home/augusto/Documents/EPANET/build/run && $(CMAKE_COMMAND) -P CMakeFiles/runepanet.dir/cmake_clean.cmake
.PHONY : run/CMakeFiles/runepanet.dir/clean

run/CMakeFiles/runepanet.dir/depend:
	cd /home/augusto/Documents/EPANET/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/augusto/Documents/EPANET /home/augusto/Documents/EPANET/run /home/augusto/Documents/EPANET/build /home/augusto/Documents/EPANET/build/run /home/augusto/Documents/EPANET/build/run/CMakeFiles/runepanet.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : run/CMakeFiles/runepanet.dir/depend

