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


endif
