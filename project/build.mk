# This describes all configurations in addition to the default (empty) config.
CONFIGS += headless headless-debug

# All configurations share these settings
CPPFLAGS += -I ../libs

SOURCE += ./main.cpp \
	../libs/tv/a.c \
	../libs/tv/b.cpp \

# And these settings are specific to the various configurations.
CFLAGS_headless += $(CFLAGS_release) -DHEADLESS
CXXFLAGS_headless += $(CXXFLAGS_release) -DHEADLESS

CFLAGS_headless-debug += $(CFLAGS_debug) -DHEADLESS
CXXFLAGS_headless-debug += $(CXXFLAGS_debug) -DHEADLESS

