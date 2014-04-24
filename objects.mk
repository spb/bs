ifndef BS__OBJECTS_MK
BS__OBJECTS_MK=1

# $(1) = target name, $(2) = language, $(3) = input source file name, $(4) = header type (if applicable)
_bs_source_to_object=$(TMPROOT)/$(SUBDIR_$(1))/$(call _BS_LANGUAGE_OBJECTS_$(2),$(basename $(3)))
_bs_source_to_source=$(TMPROOT)/$(SUBDIR_$(1))/generated_source/$(call _BS_LANGUAGE_GENERATED_SOURCES_$(2),$(basename $(3)))

_bs_default_source_dirs = $(SUBDIR_$(1)) $(TMPROOT)/$(SUBDIR_$(1))/generated_source

# Find a source file that exists.
# $(1) = target name
# $(2) = source file name
# return: path to found file, or empty if not found
_bs_find_existing_source_file=$(word 1, $(wildcard \
                                  $(foreach d, \
                                      $(call _bs_default_source_dirs,$(1)) \
                                      $(addprefix $(SUBDIR_$(1))/,$(call expand-target-variable,$(1),SRCDIRS)), \
                                      $(d)/$(2))))

# Find the location to use for a source file
# $(1) = target name
# $(2) = source file name
# return: the location of the file that exists, or the generated source location if it doesn't
_bs_find_source_file=$(call get-default,$(filter $(TMPROOT)/$(SUBDIR_$(1))/%,$(2)), \
                        $(call get-default,$(_bs_find_existing_source_file),\
					$(TMPROOT)/$(SUBDIR_$(1))/generated_source/$(2)))

# Simplest to do this here, since we're already computing everything we need to know
include $(BS_DIR)/makedepend.mk

# $(1) = target, $(2) = language
define _bs_process_language_target

$(eval _BS_SOURCES_$(2)_$(1) = $(filter $(_BS_LANGUAGE_INPUT_PATTERNS_$(2)),$($(1)_SOURCES)))

$(foreach sourcefile, $(_BS_SOURCES_$(2)_$(1)), \
    $(eval $(call _bs_process_source_file,$(1),$(2),$(sourcefile))) \
)

endef

# $(1) = target, $(2) = language, $(3) = source file
define _bs_process_source_file

$(if $(call _BS_LANGUAGE_OBJECTS_$(2),$(3)), \
    $(call _bs_process_source_to_object_file,$(1),$(2),$(3)))

$(if $(call _BS_LANGUAGE_GENERATED_SOURCES_$(2),$(3)),
    $(call _bs_process_source_to_source_file,$(1),$(2),$(3)))

$(if $(call _BS_LANGUAGE_GENERATED_HEADER_TYPES_$(2),$(3)),
    $(call _bs_process_source_to_headers,$(1),$(2),$(3)))

endef

# $(1) = target, $(2) = language, $(3) = source file
define _bs_process_source_to_object_file

$(eval $(call _BS_LANGUAGE_COMPILE_RULE_$(2),$(1),\
            $(call _bs_source_to_object,$(1),$(2),$(3)), \
            $(call _bs_find_source_file,$(1),$(3))))

$(eval _BS_OBJECTS_$(2)_$(1) += $(call _bs_source_to_object,$(1),$(2),$(3)))

$(eval $(call _dependency_file_rule,$(1),$(TMPROOT)/$(SUBDIR_$(1))/dep/$(basename $(3)).d,$(call _bs_find_source_file,$(1),$(3)),$(call _bs_source_to_object,$(1),$(2),$(3))))

endef

# $(1) = target, $(2) = language, $(3) = source file
define _bs_process_source_to_source_file

$(eval $(call _BS_LANGUAGE_COMPILE_RULE_$(2),$(1),\
            $(call _bs_source_to_source,$(1),$(2),$(3)), \
            $(call _bs_find_source_file,$(1),$(3))))

$(foreach lang,$(_BS_SUPPORTED_LANGUAGES), \
    $(foreach file, $(filter $(_BS_LANGUAGE_INPUT_PATTERNS_$(lang)),$(call _bs_source_to_source,$(1),$(2),$(3))), \
        $(eval $(call _bs_process_source_file,$(1),$(lang),$(file)))))

endef

# $(1) = target name, $(2) = language, $(3) = input source file name, $(4) = header type (if applicable)
_bs_source_to_header=$(call __bs_source_to_header,$(1),$(2),$(3),$(4))$(info _bs_source_to_header($(1),$(2),$(3),$(4))=$(call __bs_source_to_header,$(1),$(2),$(3),$(4)))
_bs_source_to_header=$(if $(value _BS_LANGUAGE_INSTALLED_HEADERS_$(2)_$(4)), \
		     	$(call _BS_LANGUAGE_INSTALLED_HEADERS_$(2)_$(4),$(basename $(3)),$(1)), \
			$(TMPROOT)/$(SUBDIR_$(1))/generated_source/$(call _BS_LANGUAGE_GENERATED_HEADERS_$(2)_$(4),$(basename $(3)),$(4)))

# $(1) = target, $(2) = language, $(3) = source file
define _bs_process_source_to_headers

$(foreach type,$(_BS_LANGUAGE_GENERATED_HEADER_TYPES_$(2)),
    $(eval $(call _BS_LANGUAGE_COMPILE_RULE_$(2)_$(type),$(1), \
	$(call _bs_source_to_header,$(1),$(2),$(3),$(type)), \
	$(call _bs_find_source_file,$(1),$(3)))))

$(foreach type,$(_BS_LANGUAGE_GENERATED_HEADER_TYPES_$(2)),
    $(eval _BS_GENERATED_HEADERS_$(2)_$(1) += $(call _bs_source_to_header,$(1),$(2),$(3),$(type))))

endef

$(foreach target, $(_BS_ALL_TARGETS), \
    $(foreach lang, $(_BS_SUPPORTED_LANGUAGES), \
        $(eval $(call _bs_process_language_target,$(target),$(lang))) \
    ))

$(foreach target, $(_BS_ALL_TARGETS), \
    $(eval _BS_OBJECTS_$(target) = $(foreach lang, $(_BS_SUPPORTED_LANGUAGES),$(_BS_OBJECTS_$(lang)_$(target)))))

$(foreach target, $(_BS_ALL_TARGETS), \
    $(eval _BS_GENERATED_HEADERS_$(target) = $(foreach lang, $(_BS_SUPPORTED_LANGUAGES),$(_BS_GENERATED_HEADERS_$(lang)_$(target)))) \
    $(eval _BS_EXTRA_TARGET_DEPS_$(target) = $(_BS_GENERATED_HEADERS_$(target))))

# Force generated headers to be created before objects, and dependency files to be regenerated once the headers are created
# $(1) = target
define generated-header-dep-rule

$(_BS_OBJECTS_$(1)): | $(_BS_GENERATED_HEADERS_$(1))

$(_BS_DEPENDENCY_FILES_$(1)): $(_BS_GENERATED_HEADERS_$(1))

endef

$(foreach target, $(_BS_ALL_TARGETS), \
    $(eval $(call generated-header-dep-rule,$(target))))

endif
