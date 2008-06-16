# This file shows how to include submodules.
# For instance, this file adds log4cpp to the build.

# BASE is the directory that contains this build.mk file.
BASE := $(dir $(lastword $(MAKEFILE_LIST)))

SOURCE += \
	$(BASE)src/FileAppender.cpp \
	$(BASE)src/Category.cpp \
	$(BASE)src/CategoryStream.cpp \
	$(BASE)src/Priority.cpp \
	$(BASE)src/LayoutAppender.cpp \
	$(BASE)src/AppenderSkeleton.cpp \
	$(BASE)src/LoggingEvent.cpp \
	$(BASE)src/HierarchyMaintainer.cpp \
	$(BASE)src/NDC.cpp \
	$(BASE)src/StringUtil.cpp \
	$(BASE)src/Appender.cpp \
	$(BASE)src/TimeStamp.cpp \
	$(BASE)src/DummyThreads.cpp \
	$(BASE)src/PropertyConfigurator.cpp \
	$(BASE)src/PropertyConfiguratorImpl.cpp \
	$(BASE)src/Properties.cpp \
	$(BASE)src/AbortAppender.cpp \
	$(BASE)src/Configurator.cpp \
	$(BASE)src/BasicLayout.cpp \
	$(BASE)src/SimpleLayout.cpp \
	$(BASE)src/PatternLayout.cpp \
	$(BASE)src/RollingFileAppender.cpp \
	$(BASE)src/SyslogAppender.cpp \
	$(BASE)src/RemoteSyslogAppender.cpp \
	$(BASE)src/OstreamAppender.cpp \
	$(BASE)src/FactoryParams.cpp

