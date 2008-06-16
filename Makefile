# It's usually easiest to override sensible defaults (optional)
include scripts/defaults.mk

# You get 'release' and 'debug' configurations by default.
# Release is built by default.  To build the debug configuration:
#     make CONFIG=debug
#
# This adds a 'testing' configuration.
# CONFIGS += testing

# Adds these arguments to CPPFLAGS for all configurations.
CPPFLAGS += -I ../libs

# Replace this with a list of your source files.
SOURCE += ./main.cpp \
	../libs/tv/a.c \
	../libs/tv/b.cpp \

# You can write a makefile for submodules.
include submodule/module.mk

# The testing configuration is exactly the same as the release
# configuration except that we'll define a macro while compiling:
CFLAGS_testing += $(CFLAGS_release) -DTESTING
CXXFLAGS_testing += $(CXXFLAGS_release) -DTESTING


# Finally, build the project!
include scripts/build.mk
