# Order important here: executable before library
# This way, if the dependency isn't declared, it won't build.
SUBDIRS = executable library
