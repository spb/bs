ifndef BS__DEPENDS_MK
BS__DEPENDS_MK=1

# Functions for dealing with dependencies.
#
# These are dependencies between libraries/executables that control linker
# flags, not file-based dependencies between (e.g.) .cc and .o files.


# expand-target-dependencies
#
# Arguments: target name
#
# Returns the linker options required to link all of the given target's link
# dependencies.
#

expand-target-dependencies = \
    $(foreach d,$($(1)_LIBRARIES), \
        $(call expand-dependency,$(d)))

# expand-dependency
#
# Arguments: a dependency specification
#
# Returns the linker option required to bring in a given dependency spec.
#
# Used internally by expand-target-dependencies.
#

expand-dependency = \
    $(if $(filter -l%,$(1)), \
        $(1), \
        -l$(LIBRARY_NAME_$(1)) \
    )

# expand-target-dependency-files
#
# Arguments: target name
#
# Returns the list of (library) files that the target should depend on, in addition to its objects
#

expand-target-dependency-files = \
    $(foreach d,$($(1)_LIBRARIES), \
        $(call expand-dependency-file,$(d)))

# expand-dependency-file
#
# Arguments: a dependency specification
#
# Returns the filename, if local to this project, that satisfies the dependency
#
# Used internally by expand-target-dependency-files
#

expand-dependency-file = \
    $(if $(filter -l%,$(1)), \
        , \
        $(_BS_BUILD_TARGET_$(1)) \
    )

endif
