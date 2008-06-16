# Makefile engine
# Scott Bronson
# 22 Apr 2007
#
# This file contains the engine to allow you to make files from anywhere
# on your filesystem in a single object directory with full dependencies.
#
#
# To use a different object directory:
#     make OBJDIR=/tmp/obj
#
# To ignore the makefile when calculating dependencies (if, for example,
# you're tweaking the build and there's no need to regenerate the objects
# each time)
#     make IGNORE_MAKEFILE_DEPS=1
#
# To print the commands being run instead of just the file: make V=1
# To print debug information: make DEBUG=1
# (TODO: we have enough debug output that we should probably add debug levels)


# Make sure that we're running with a compatible version of GNU make
ifeq ($(MAKEFILE_LIST),)
# we also need 3.80's eval function, and maybe some other features.
$(error This makefile requires GNU make 3.80 or higher.)
endif

# Save list of included Makefiles for later before we include depfiles.
# This tells us to rebuild everything if any of the makefiles changes,
# see IGNORE_MAKEFILE_DEPS in the documentation.
SAVED_MAKEFILE_LIST := $(MAKEFILE_LIST)


# Use the default config if it hasn't been set already.
CONFIG ?= $(firstword $(CONFIGS))

ifeq ($(CONFIG), $(firstword $(CONFIGS)))
# If building the default config, don't use the config as a suffix.
EXECUTABLE := $(PROGNAME)
OBJDIR := $(OBJNAME)
CLEANFILES += $(EXECUTABLE) $(OBJDIR) $(addprefix $(PROGNAME)-, $(CONFIGS)) $(addprefix obj-, $(CONFIGS))
else
# Otherwise, if not the default config, everything gets a suffix.
EXECUTABLE := $(PROGNAME)-$(CONFIG)
OBJDIR := $(OBJNAME)-$(CONFIG)
CLEANFILES := $(EXECUTABLE) $(OBJDIR)
endif

ifneq ($(DEBUG),)
$(warning Making $(EXECUTABLE) in $(OBJDIR)...)
endif

# Copy the config-specific settings into the global vars
# If your Makefile has custom variables that you'd like to copy
# as well, just add them to COPYVARS and they'll be copied too.
COPYVARS += SOURCE LDLIBS ARFLAGS ASFLAGS CFLAGS CXXFLAGS COFLAGS CPPFLAGS FFLAGS GFLAGS LDFLAGS LFLAGS YFLAGS PFLAGS RFLAGS LINTFLAGS
$(foreach V,$(COPYVARS),$(eval $(V) += $$($(V)_$(CONFIG))))
ifneq ($(DEBUG),)
# Print all the configuration options if DEBUG=1
$(foreach V,$(COPYVARS),$(warning default $(V) = $($(V)) ))
$(foreach V,$(COPYVARS),$(warning $(V) += $$($(V)_$(CONFIG)): $($(V)_$(CONFIG)) ))
$(foreach V,$(COPYVARS),$(warning final $(V) = $($(V)) ))
endif


# We're done with the configuration, time for action

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
# one of your configurations.  Of course, we also support the
# executable-config dependency (i.e. program-debug).

# We need to zero out all our environment variables because we've
# already filled them in with defaults.  If we pass them to the
# child make, then the child make will fill them with defaults
# all over again.
#
# TODO: this doesn't work!  Zeroing out the environment variables
# also zeros out any upstream settings.  Somehow we need to save
# upstream's initial values before we fill in defaults, then restore
# them just before we call sub-make.  Pretty non-trivial!

#define ADD_TARGET
#.PHONY: $(1)
#$(1): $(EXECUTABLE)-$(1)
#
#$(EXECUTABLE)-$(1):
#	@$(addsuffix = ,$(COPYVARS)) $$(MAKE) --no-print-directory CONFIG=$(1)
#
#.PHONY: $(1)-clean
#$(1)-clean:
#	@$(addsuffix = ,$(COPYVARS)) $$(MAKE) --no-print-directory CONFIG=$(1) clean
#endef
#
#$(foreach conf,$(CONFIGS),$(eval $(call ADD_TARGET,$(conf))))



# ---- tool targets:
#
# Each tool produces both its target (%.cpp.o) AND a dependencies file
# that includes all dependencies for the target (%.cpp.d).

# Every tool target needs to depend on COMMONDEPS
COMMONDEPS+=$(OBJDIR)/build-tag
ifeq ($(IGNORE_MAKEFILE_DEPS),)
COMMONDEPS+=$(SAVED_MAKEFILE_LIST)
endif

# We normally print just the command name and the filename.
# Use 'make V=1' or 'make VERBOSE=1' to see the full command line.
ifdef V
  VERBOSE = $(V)
endif
ifndef VERBOSE
  VERBOSE = 0
endif

ifeq ($(VERBOSE),1)
  C = 
  U = @true
else
  C = @
  U = @echo
endif


# C++ compiler
$(OBJDIR)/%.cpp.o: $(COMMONDEPS)
	$(U) "    C++ $(file_$(basename $(notdir $@)))"
	$(C)$(CXX) -c -MD -MP $(CPPFLAGS) $(CXXFLAGS) $(file_$(basename $(notdir $@))) -o $@

# C compiler
$(OBJDIR)/%.c.o: $(COMMONDEPS)
	$(U) "    C   $(file_$(basename $(notdir $@)))"
	$(C)$(CC) -c -MD -MP $(CPPFLAGS) $(CFLAGS) $(file_$(basename $(notdir $@))) -o $@

# Linker
# Always use CXX because CC can't do C++ linkage.
# Pass CXX flags so linker knows the status of -O.
$(OBJDIR)/$(EXECUTABLE): $(COMMONDEPS) $(OBJFILES)
	$(U) "    Linking $(EXECUTABLE)"
	$(C)$(CXX) $(CXXFLAGS) $(LDFLAGS) $(OBJFILES) $(LDLIBS) -o $@

