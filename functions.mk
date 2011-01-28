ifndef BS__FUNCTIONS_MK
BS__FUNCTIONS_MK=1


# add-dir
#
# Arguments: list of directories to add.
#
# Adds all the given directories to the list of those which will be
# automatically created.
#
_do_add_dir=$(if $(filter $(1),$(DIRS)),,$(eval DIRS += $(1)))
add-dir=$(foreach d,$(1),$(call _do_add_dir,$(patsubst %/,%,$(d))))

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

endif
