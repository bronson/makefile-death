# Makefile example
# Scott Bronson
# 22 Apr 2007
#
# This file demonstrates how to incrementally build files from anywhere
# on your filesystem in a single object directory with full dependencies.

# By default we have only a single configuration: the empty one.
# You can add more configurations in your build.mak file.
CONFIGS =
CUSTOMFILE = build.mk

# By default objects go into objCONF in current dir.
# Pass a different OBJDIR to place them somewhere else.
OBJDIR = obj
PROGNAME = program


# This file needs to define a single variable, SOURCE, that
# tells the location of each file that we will compile.  The
# files can be from anywhere in the filesystem.
include build.mk
CONFIGS += headless


# If user specified a configuration, update all vars to use it
EXECUTABLE := $(PROGNAME)
ifeq ($(origin CONFIG), undefined)
CLEAN := $(EXECUTABLE) $(OBJDIR)
CLEAN += $(addprefix $(PROGNAME)-, $(CONFIGS)) $(addprefix obj-, $(CONFIGS))
else
EXECUTABLE := $(PROGNAME)-$(CONFIG)
OBJDIR := $(OBJDIR)-$(CONFIG)
CLEAN := $(EXECUTABLE) $(OBJDIR)
endif


# done with configuration, time for action

FILES := $(notdir $(SOURCE))
OBJFILES := $(addprefix $(OBJDIR)/, $(addsuffix .o, $(FILES)))
DEPFILES := $(addprefix $(OBJDIR)/, $(addsuffix .d, $(FILES)))

# Set up an assoc array to find the original file from its dependency.
$(foreach V,$(SOURCE),$(eval file_$(notdir $(V)) = $(V)))


all: $(EXECUTABLE)
.PHONY: all

$(OBJDIR):
	mkdir -p $@

$(EXECUTABLE): $(OBJDIR)/$(EXECUTABLE)
	cp $< $@

-include $(DEPFILES)

.PHONY: clean
clean:
	rm -rf $(CLEAN)

.PHONY: headless
headless:
	@$(MAKE) --no-print-directory CONFIG=headless

.PHONY: headless-clean
headless-clean:
	@$(MAKE) --no-print-directory CONFIG=headless clean


# ---- tool targets:

# Every build target needs to depend on these
COMMONDEPS=$(OBJDIR) $(CUSTOMFILE) Makefile

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

