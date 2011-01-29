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

endif