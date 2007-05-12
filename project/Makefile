# Makefile example
# Scott Bronson
# 22 Apr 2007
#
# This file demonstrates how to incrementally build files from anywhere
# on your filesystem in a single object directory with full dependencies.


# This file needs to define a single variable, SOURCE, that
# tells the location of each file that we will compile.  The
# files can be from anywhere in the filesystem.
include source-files


FILES := $(notdir $(SOURCE))
OBJFILES := $(addprefix obj/, $(addsuffix .o, $(FILES)))
DEPFILES := $(addprefix obj/, $(addsuffix .d, $(FILES)))

# Set up an assoc array to find the original file from its dependency.
$(foreach V,$(SOURCE),$(eval file_$(notdir $(V)) = $(V)))

# make sure that our object dir exists.
$(shell mkdir -p obj)

# Need to use CXX instead of CC because of link errors on the Mac.
# Pass CXX flags so linker knows the status of -O.
prog: $(OBJFILES)
	$(CXX) $(CXXFLAGS) $(OBJFILES) $(LIBS) -o $@

-include $(DEPFILES)


obj/%.cpp.o:
	$(CXX) -c -MD -MP $(CPPFLAGS) $(CXXFLAGS) $(file_$(basename $(notdir $@))) -o $@

obj/%.c.o:
	$(CC) -c -MD -MP $(CPPFLAGS) $(CFLAGS) $(file_$(basename $(notdir $@))) -o $@

clean:
	rm -rf obj prog
