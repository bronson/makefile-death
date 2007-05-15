# Makefile example
# Scott Bronson
# 22 Apr 2007
#
# This file demonstrates how to incrementally build files from anywhere
# on your filesystem in a single object directory with full dependencies.

# To use a different object directory:
#     make OBJDIR=/tmp/obj

# By default we have only a single configuration: the empty one.
# You can add more configurations in your build.mak file.
CONFIGS = release debug
CUSTOMFILE = build.mk


# default flag settings (feel free to override in your build.mk file):
CFLAGS_release += -O2 -Wall
CXXFLAGS_release += -O2 -Wall
CFLAGS_debug += -O0 -g -Wall -Werror
CXXFLAGS_debug += -O0 -g -Wall -Werror


# By default objects go into objCONF in current dir.
# Pass a different OBJDIR to place them somewhere else.
OBJNAME = obj
PROGNAME = program


# This file needs to define a single variable, SOURCE, that
# tells the location of each file that we will compile.  The
# files can be from anywhere in the filesystem.
include $(CUSTOMFILE)

CONFIG ?= $(firstword $(CONFIGS))


# 'make' with no args is equivalent to 'make release'
ifeq ($(CONFIG), $(firstword $(CONFIGS)))
EXECUTABLE := $(PROGNAME)
OBJDIR := $(OBJNAME)
CLEANFILES += $(EXECUTABLE) $(OBJDIR) $(addprefix $(PROGNAME)-, $(CONFIGS)) $(addprefix obj-, $(CONFIGS))
else
EXECUTABLE := $(PROGNAME)-$(CONFIG)
OBJDIR := $(OBJNAME)-$(CONFIG)
CLEANFILES := $(EXECUTABLE) $(OBJDIR)
endif


# Copy the config-specific settings into the global vars
DEFVARS += ARFLAGS ASFLAGS CFLAGS CXXFLAGS COFLAGS CPPFLAGS FFLAGS GFLAGS LDFLAGS LFLAGS YFLAGS PFLAGS RFLAGS LINTFLAGS
$(foreach V,$(DEFVARS),$(eval $(V) += $$($(V)_$(CONFIG))))


# done with configuration, time for action

FILES := $(notdir $(SOURCE))
OBJFILES := $(addprefix $(OBJDIR)/, $(addsuffix .o, $(FILES)))
DEPFILES := $(addprefix $(OBJDIR)/, $(addsuffix .d, $(FILES)))

# Set up an assoc array to find the original file from its dependency.
$(foreach V,$(SOURCE),$(eval file_$(notdir $(V)) = $(V)))


all: $(EXECUTABLE)
.PHONY: all

-include $(DEPFILES)

# Using directories as build targets is not reliable.  Targets tend to
# get built far more often than they should.  Therefore, we'll use a random
# file to get make to tell us when the directory needs to be recreated.
$(OBJDIR)/build-tag:
	mkdir -p $(OBJDIR)
	touch $@

$(EXECUTABLE): $(OBJDIR)/$(EXECUTABLE)
	cp $< $@

.PHONY: clean
clean:
	rm -rf $(CLEANFILES)



# Add targets for each configuration.  Right now we support
# 'make target' and 'make target-clean' (where target is a name of
# one of your configurations.

define ADD_TARGET
.PHONY: $(1)
$(1):
	@$$(MAKE) --no-print-directory CONFIG=$(1)

.PHONY: $(1)-clean
$(1)-clean:
	@$$(MAKE) --no-print-directory CONFIG=$(1) clean
endef

$(foreach conf,$(CONFIGS),$(eval $(call ADD_TARGET,$(conf))))



# ---- tool targets:

# Every build target needs to depend on these
COMMONDEPS=$(CUSTOMFILE) $(OBJDIR)/build-tag Makefile

# C++ compiler
$(OBJDIR)/%.cpp.o: $(COMMONDEPS)
	$(CXX) -c -MD -MP $(CPPFLAGS) $(CXXFLAGS) $(file_$(basename $(notdir $@))) -o $@

# C compiler
$(OBJDIR)/%.c.o: $(COMMONDEPS)
	$(CC) -c -MD -MP $(CPPFLAGS) $(CFLAGS) $(file_$(basename $(notdir $@))) -o $@

# Linker
# Need to use CXX to link instead of CC because of link errors on the Mac.
# Pass CXX flags so linker knows the status of -O.
$(OBJDIR)/$(EXECUTABLE): $(COMMONDEPS) $(OBJFILES)
	$(CXX) $(CXXFLAGS) $(OBJFILES) $(LIBS) -o $@

