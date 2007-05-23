# default values for the makefile engine.
#
# You will almost certainly want to override PROGNAME.
# You may also want to add some configs of your own, and probably
# also want o add -Werror to your debug configurations.

PROGNAME = program
OBJNAME = obj

# Default configurations:
CONFIGS += release debug

# Settings for each configuration
CFLAGS_release += -O2 -Wall
CXXFLAGS_release += -O2 -Wall
CFLAGS_debug += -O0 -g -Wall
CXXFLAGS_debug += -O0 -g -Wall

# And we always want the version number added
CPPFLAGS += -DVERSION=r$(shell svnversion .)

