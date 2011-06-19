ifndef BS__FUNCTIONS_MK
BS__FUNCTIONS_MK=1

# dirname
#
# Arguments: a file name
#
# Returns the directory containing the given file name. Differs from
# $(dir $(FOO)) in that this won't have a trailing slash. Grr.
dirname=$(patsubst %/,%,$(dir $(1)))

# add-dir
#
# Arguments: list of directories to add.
#
# Adds all the given directories to the list of those which will be
# automatically created.
#
_do_add_dir=$(if $(filter $(1),$(DIRS)),,$(eval DIRS += $(1)))
_add_one_dir=$(call _do_add_dir,$(1))$(call _do_add_dir,$(1)/)
add-dir=$(foreach d,$(1),$(call _add_one_dir,$(patsubst %/,%,$(d))))

# save-vars
#
# Arguments: list of variable names to save, unique tag name under
#            which to save them.
#
# Saves the current values of all the given variables under the tag name given,
# to be later retrieved by load-vars.
#
save-vars=$(eval __saved_vars_$(2)=$(1)) \
		$(foreach v,$(1),$(eval __saved_$(v)_$(2)=$(value $(v))))

# load-vars
#
# Arguments: tag name
#
# Restores the variables saved under the given tag name to their saved values.
#
load-vars=$(foreach v,$(__saved_vars_$(1)),$(eval $(v)=$(value __saved_$(v)_$(1))))

# expand-target-variable
#
# Arguments: target name, variable name
#
# Returns the concatenated value of the given variable to use when building the
# named target.
#
# This consists of:
#  - the global default value
#  - the value specified in the target's subdirectory (if the variable name is
#    in SUBDIR_VARIABLES)
#  - the target-specific value specified in the target's subdirectory (if the
#    variable name is in PER_TARGET_VARIABLES)
#

expand-target-variable=$($(2)) \
			$(if $(filter $(2),$(SUBDIR_VARIABLES)),$($(SUBDIR_$(1))_$(2)),) \
			$(if $(filter $(2),$(TARGET_VARIABLES)),$($(1)_$(2)),)

# get-target-variable
#
# Arguments: target name, variable name
#
# Returns the most specific defind value of the given variable for the named
# target. Unlike expand-target-variable which concatenates all defined versions,
# this returns only the most specific version.

_bs_first_defined = $(if $(1),$(1),$(if $(2),$(2),$(3)))
get-target-variable = $(call _bs_first_defined, \
			$(if $(filter $(2),$(TARGET_VARIABLES)),$($(1)_$(2)),), \
			$(if $(filter $(2),$(SUBDIR_VARIABLES)),$($(SUBDIR_$(1))_$(2)),), \
			$($(2)) \
		       )

endif
