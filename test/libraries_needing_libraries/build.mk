STATICS = lnl_s
DSOS = lnl1 lnl2
EXECUTABLES = lnl

lnl_SOURCES = executable.cc
lnl1_SOURCES = library1.cc
lnl2_SOURCES = library2.cc
lnl_s_SOURCES = static.cc

lnl_LIBRARIES = libraries_needing_libraries/lnl1
lnl1_LIBRARIES = libraries_needing_libraries/lnl2 libraries_needing_libraries/lnl_s
