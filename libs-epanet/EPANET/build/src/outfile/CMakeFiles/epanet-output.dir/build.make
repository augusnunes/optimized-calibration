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
include src/outfile/CMakeFiles/epanet-output.dir/depend.make

# Include the progress variables for this target.
include src/outfile/CMakeFiles/epanet-output.dir/progress.make

# Include the compile flags for this target's objects.
include src/outfile/CMakeFiles/epanet-output.dir/flags.make

src/outfile/CMakeFiles/epanet-output.dir/src/epanet_output.c.o: src/outfile/CMakeFiles/epanet-output.dir/flags.make
src/outfile/CMakeFiles/epanet-output.dir/src/epanet_output.c.o: ../src/outfile/src/epanet_output.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/augusto/Documents/EPANET/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/outfile/CMakeFiles/epanet-output.dir/src/epanet_output.c.o"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/epanet-output.dir/src/epanet_output.c.o   -c /home/augusto/Documents/EPANET/src/outfile/src/epanet_output.c

src/outfile/CMakeFiles/epanet-output.dir/src/epanet_output.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/epanet-output.dir/src/epanet_output.c.i"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/augusto/Documents/EPANET/src/outfile/src/epanet_output.c > CMakeFiles/epanet-output.dir/src/epanet_output.c.i

src/outfile/CMakeFiles/epanet-output.dir/src/epanet_output.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/epanet-output.dir/src/epanet_output.c.s"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/augusto/Documents/EPANET/src/outfile/src/epanet_output.c -o CMakeFiles/epanet-output.dir/src/epanet_output.c.s

src/outfile/CMakeFiles/epanet-output.dir/__/util/errormanager.c.o: src/outfile/CMakeFiles/epanet-output.dir/flags.make
src/outfile/CMakeFiles/epanet-output.dir/__/util/errormanager.c.o: ../src/util/errormanager.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/augusto/Documents/EPANET/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object src/outfile/CMakeFiles/epanet-output.dir/__/util/errormanager.c.o"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/epanet-output.dir/__/util/errormanager.c.o   -c /home/augusto/Documents/EPANET/src/util/errormanager.c

src/outfile/CMakeFiles/epanet-output.dir/__/util/errormanager.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/epanet-output.dir/__/util/errormanager.c.i"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/augusto/Documents/EPANET/src/util/errormanager.c > CMakeFiles/epanet-output.dir/__/util/errormanager.c.i

src/outfile/CMakeFiles/epanet-output.dir/__/util/errormanager.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/epanet-output.dir/__/util/errormanager.c.s"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/augusto/Documents/EPANET/src/util/errormanager.c -o CMakeFiles/epanet-output.dir/__/util/errormanager.c.s

src/outfile/CMakeFiles/epanet-output.dir/__/util/filemanager.c.o: src/outfile/CMakeFiles/epanet-output.dir/flags.make
src/outfile/CMakeFiles/epanet-output.dir/__/util/filemanager.c.o: ../src/util/filemanager.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/augusto/Documents/EPANET/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object src/outfile/CMakeFiles/epanet-output.dir/__/util/filemanager.c.o"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/epanet-output.dir/__/util/filemanager.c.o   -c /home/augusto/Documents/EPANET/src/util/filemanager.c

src/outfile/CMakeFiles/epanet-output.dir/__/util/filemanager.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/epanet-output.dir/__/util/filemanager.c.i"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/augusto/Documents/EPANET/src/util/filemanager.c > CMakeFiles/epanet-output.dir/__/util/filemanager.c.i

src/outfile/CMakeFiles/epanet-output.dir/__/util/filemanager.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/epanet-output.dir/__/util/filemanager.c.s"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/augusto/Documents/EPANET/src/util/filemanager.c -o CMakeFiles/epanet-output.dir/__/util/filemanager.c.s

src/outfile/CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.o: src/outfile/CMakeFiles/epanet-output.dir/flags.make
src/outfile/CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.o: ../src/util/cstr_helper.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/augusto/Documents/EPANET/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object src/outfile/CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.o"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.o   -c /home/augusto/Documents/EPANET/src/util/cstr_helper.c

src/outfile/CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.i"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/augusto/Documents/EPANET/src/util/cstr_helper.c > CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.i

src/outfile/CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.s"
	cd /home/augusto/Documents/EPANET/build/src/outfile && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/augusto/Documents/EPANET/src/util/cstr_helper.c -o CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.s

# Object files for target epanet-output
epanet__output_OBJECTS = \
"CMakeFiles/epanet-output.dir/src/epanet_output.c.o" \
"CMakeFiles/epanet-output.dir/__/util/errormanager.c.o" \
"CMakeFiles/epanet-output.dir/__/util/filemanager.c.o" \
"CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.o"

# External object files for target epanet-output
epanet__output_EXTERNAL_OBJECTS =

lib/libepanet-output.so: src/outfile/CMakeFiles/epanet-output.dir/src/epanet_output.c.o
lib/libepanet-output.so: src/outfile/CMakeFiles/epanet-output.dir/__/util/errormanager.c.o
lib/libepanet-output.so: src/outfile/CMakeFiles/epanet-output.dir/__/util/filemanager.c.o
lib/libepanet-output.so: src/outfile/CMakeFiles/epanet-output.dir/__/util/cstr_helper.c.o
lib/libepanet-output.so: src/outfile/CMakeFiles/epanet-output.dir/build.make
lib/libepanet-output.so: src/outfile/CMakeFiles/epanet-output.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/augusto/Documents/EPANET/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking C shared library ../../lib/libepanet-output.so"
	cd /home/augusto/Documents/EPANET/build/src/outfile && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/epanet-output.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/outfile/CMakeFiles/epanet-output.dir/build: lib/libepanet-output.so

.PHONY : src/outfile/CMakeFiles/epanet-output.dir/build

src/outfile/CMakeFiles/epanet-output.dir/clean:
	cd /home/augusto/Documents/EPANET/build/src/outfile && $(CMAKE_COMMAND) -P CMakeFiles/epanet-output.dir/cmake_clean.cmake
.PHONY : src/outfile/CMakeFiles/epanet-output.dir/clean

src/outfile/CMakeFiles/epanet-output.dir/depend:
	cd /home/augusto/Documents/EPANET/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/augusto/Documents/EPANET /home/augusto/Documents/EPANET/src/outfile /home/augusto/Documents/EPANET/build /home/augusto/Documents/EPANET/build/src/outfile /home/augusto/Documents/EPANET/build/src/outfile/CMakeFiles/epanet-output.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/outfile/CMakeFiles/epanet-output.dir/depend
