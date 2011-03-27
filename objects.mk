ifndef BS__OBJECTS_MK
BS__OBJECTS_MK=1

_bs_source_to_object=$(TMPROOT)/$(SUBDIR_$(1))/$(call _BS_LANGUAGE_OBJECTS_$(2),$(basename $(notdir $(3))))

$(foreach dso, $(ALL_DSOS), \
    $(foreach lang, $(_BS_SUPPORTED_LANGUAGES), \
	$(eval _BS_SOURCES_$(lang)_$(dso) = $(filter $(_BS_LANGUAGE_INPUT_PATTERNS_$(lang)),$($(dso)_SOURCES))) \
	$(eval _BS_OBJECTS_$(lang)_$(dso) = \
	    $(foreach sourcefile, $(_BS_SOURCES_$(lang)_$(dso)), \
		$(call _bs_source_to_object,$(dso),$(lang),$(sourcefile)) \
	)) \
	$(foreach sourcefile, $(_BS_SOURCES_$(lang)_$(dso)), \
	    $(eval $(call _BS_LANGUAGE_COMPILE_RULE_$(lang),$(dso),$(call _bs_source_to_object,$(dso),$(lang),$(sourcefile)),$(SUBDIR_$(dso))/$(sourcefile))) \
	) \
    ))

$(foreach exec, $(ALL_EXECS), \
    $(foreach lang, $(_BS_SUPPORTED_LANGUAGES), \
	$(eval _BS_SOURCES_$(lang)_$(exec) = $(filter $(_BS_LANGUAGE_INPUT_PATTERNS_$(lang)),$($(exec)_SOURCES))) \
	$(eval _BS_OBJECTS_$(lang)_$(exec) = \
	    $(foreach sourcefile, $(_BS_SOURCES_$(lang)_$(exec)), \
		$(call _bs_source_to_object,$(exec),$(lang),$(sourcefile)) \
	)) \
	$(foreach sourcefile, $(_BS_SOURCES_$(lang)_$(exec)), \
	    $(eval $(call _BS_LANGUAGE_COMPILE_RULE_$(lang),$(exec),$(call _bs_source_to_object,$(exec),$(lang),$(sourcefile)),$(SUBDIR_$(exec))/$(sourcefile))) \
	) \
    ))

$(foreach dso, $(ALL_DSOS), \
    $(eval OBJECTS_$(dso) = $(foreach lang, $(_BS_SUPPORTED_LANGUAGES),$(_BS_OBJECTS_$(lang)_$(dso)))))

$(foreach exec, $(ALL_EXECS), \
    $(eval OBJECTS_$(exec) = $(foreach lang, $(_BS_SUPPORTED_LANGUAGES),$(_BS_OBJECTS_$(lang)_$(exec)))))

$(foreach dso, $(ALL_DSOS), \
    $(eval $(dso): $(_BS_OBJECTS_$(dso))))

$(foreach exec, $(ALL_EXECS), \
    $(eval $(exec): $(_BS_OBJECTS_$(exec))))


endif
