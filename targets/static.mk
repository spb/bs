ifndef BS__TARGETS_STATIC_MK
BS__TARGETS_STATIC_MK=1

_BS_SUPPORTED_TARGETS += STATIC

_BS_DEFAULT_OUTPUT_STATIC = $(call get-target-variable,$(2),LIBDIR)/lib$(call get-default,$($(1)_LIBNAME),$(1)).a
_BS_EXTRA_TARGET_SETTINGS_STATIC = LIBRARY_NAME_$(1)/$(2) := $$(call get-default,$$($(2)_LIBNAME),$(2))

# one argument: target internal name
define _BS_TARGET_RULE_STATIC

$(call add-dir,$(dir $(_BS_BUILD_TARGET_$(1))))

$(_BS_BUILD_TARGET_$(1)): $(_BS_OBJECTS_$(1)) | $(call dirname,$(_BS_BUILD_TARGET_$(1)))
	@rm -f $$@
	ar cru $$@ $(_BS_OBJECTS_$(1))

endef

endif
