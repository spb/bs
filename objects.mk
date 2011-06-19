ifndef BS__OBJECTS_MK
BS__OBJECTS_MK=1

_bs_source_to_object=$(TMPROOT)/$(SUBDIR_$(1))/$(call _BS_LANGUAGE_OBJECTS_$(2),$(basename $(notdir $(3))))

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
	    $(eval $(call _BS_LANGUAGE_COMPILE_RULE_$(lang),$(target),$(call _bs_source_to_object,$(target),$(lang),$(sourcefile)),$(SUBDIR_$(target))/$(sourcefile))) \
	    $(eval $(call _dependency_file_rule,$(target),$(TMPROOT)/$(SUBDIR_$(target))/dep/$(basename $(sourcefile)).d,$(SUBDIR_$(target))/$(sourcefile),$(call _bs_source_to_object,$(target),$(lang),$(sourcefile)))) \
	) \
    ))

$(foreach target, $(_BS_ALL_TARGETS), \
    $(eval _BS_OBJECTS_$(target) = $(foreach lang, $(_BS_SUPPORTED_LANGUAGES),$(_BS_OBJECTS_$(lang)_$(target)))))

endif
