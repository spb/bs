ifndef BS__LANGUAGE_FUNCTIONS_MK
BS__LANGUAGE_FUNCTIONS_MK=1

# transform-source-to-object: Given a list of source filenames, return
# the corresponding objects
#
# Arguments: list of source files, temporary directory.
transform-source-to-object = $(foreach f,$(1),$(2)/$(notdir $(basename $(f))).o)

endif
