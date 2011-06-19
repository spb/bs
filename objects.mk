ifndef BS__OBJECTS_MK
BS__OBJECTS_MK=1

_bs_source_to_object=$(TMPROOT)/$(SUBDIR_$(1))/$(call _BS_LANGUAGE_OBJECTS_$(2),$(basename $(3)))

_bs_default_source_dirs = $(SUBDIR_$(1)) $(TMPROOT)/$(SUBDIR_$(1))/generated_source

# Find a source file that exists.
# $(1) = target name
# $(2) = source file name
# return: path to found file, or empty if not found
_bs_find_existing_source_file=$(word 1, $(wildcard $(foreach d, \
			      $(call _bs_default_source_dirs,$(1)) \
			      $(addprefix $(SUBDIR_$(1))/,$(call expand-target-variable,$(1),SRCDIRS)), \
			      $(d)/$(2))))

# Find the location to use for a source file
# $(1) = target name
# $(2) = source file name
# return: the location of the file that exists, or the generated source location if it doesn't
_bs_find_source_file=$(call get-default,$(_bs_find_existing_source_file),\
					$(TMPROOT)/$(SUBDIR_$(1))/generated_source/$(2))

# Simplest to do this here, since we're already computing everything we need to know
include $(BS_DIR)/makedepend.mk

$(foreach target, $(_BS_ALL_TARGETS), \
    $(foreach lang, $(_BS_SUPPORTED_LANGUAGES), \
	$(eval _BS_SOURCES_$(lang)_$(target) = $(filter $(_BS_LANGUAGE_INPUT_PATTERNS_$(lang)),$($(target)_SOURCES))) \
	$(eval _BS_OBJECTS_$(lang)_$(target) = \
	    $(foreach sourcefile, $(_BS_SOURCES_$(lang)_$(target)), \
		$(call _bs_source_to_object,$(target),$(lang),$(sourcefile)) \
	)) \
	$(foreach sourcefile, $(_BS_SOURCES_$(lang)_$(target)), \
	    $(eval $(call _BS_LANGUAGE_COMPILE_RULE_$(lang),$(target),$(call _bs_source_to_object,$(target),$(lang),$(sourcefile)),$(call _bs_find_source_file,$(target),$(sourcefile)))) \
	    $(eval $(call _dependency_file_rule,$(target),$(TMPROOT)/$(SUBDIR_$(target))/dep/$(basename $(sourcefile)).d,$(call _bs_find_source_file,$(target),$(sourcefile)),$(call _bs_source_to_object,$(target),$(lang),$(sourcefile)))) \
	) \
    ))

$(foreach target, $(_BS_ALL_TARGETS), \
    $(eval _BS_OBJECTS_$(target) = $(foreach lang, $(_BS_SUPPORTED_LANGUAGES),$(_BS_OBJECTS_$(lang)_$(target)))))

endif
