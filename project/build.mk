# This describes all configurations in addition to the default (empty) config.
CONFIGS += release debug headless headless-debug

# All configurations share these settings
CPPFLAGS += -I ../libs

SOURCE += ./main.cpp \
	../libs/tv/a.c \
	../libs/tv/b.cpp \


# And these settings are specific to 
CCFLAGS_release += -O2
CCFLAGS_debug += -O0 -g
CCFLAGS_headless += -DHEADLESS

