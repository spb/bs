ifndef BS__DEPENDS_MK
BS__DEPENDS_MK=1

# needed due to no escaping.
comma=,

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
        $(call expand-dependency,$(d))) \
    $(if $($(1)_CONTAINS), \
        -Wl$(comma)--whole-archive \
        $(foreach d,$($(1)_CONTAINS), \
            $(call expand-dependency,$(d))) \
        -Wl$(comma)--no-whole-archive \
    )

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
        $(addprefix -L,$(call get-unless-default,$(dir $(_BS_BUILD_TARGET_$(1))),$(BUILDDIR)/$(LIBDIR)/)) \
            -l$(LIBRARY_NAME_$(1)) \
    )

# expand-target-dependency-files
#
# Arguments: target name
#
# Returns the list of (library) files that the target should depend on, in addition to its objects
#

expand-target-dependency-files = \
    $(foreach d,$($(1)_LIBRARIES) $($(1)_CONTAINS), \
        $(call expand-dependency-file,$(d)))

# expand-target-dependency-dsos
#
# Arguments: target name
#
# Returns the list of DSO files on which the target depends
#
expand-target-dependency-dsos = $(filter %.so, $(expand-target-dependency-files))

# expand-target-dependency-statics
#
# Arguments: target name
#
# Returns the list of static library files on which the target depends
#
expand-target-dependency-statics = $(filter-out %.so, $(expand-target-dependency-files))

# expand-target-dependency-makefiles
#
# Arguments: target name
#
# Returns the list of makefiles modifications to which should trigger rebuilding this target.
# It's a bit heuristic; technically a change to any build.mk file *could* change the build
# behaviour of any target, but this is what's most likely to be right most of the time. Do a
# full rebuild if in doubt.
expand-target-dependency-makefiles = $(addsuffix /build.mk, \
    					$(patsubst %/,%,$(call expand-subdir-plus-parents,$(SUBDIR_$(1)))))
expand-subdir-plus-parents = $(if $(filter ./,$(1)),, \
				$(1) $(call expand-subdir-plus-parents,$(dir $(patsubst %/,%,$(1)))))

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
