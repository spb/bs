ifndef BS__TARGETS_DSO_MK
BS__TARGETS_DSO_MK=1

_BS_SUPPORTED_TARGETS += DSO

_BS_DEFAULT_OUTPUT_DSO = lib/lib$(call get-default,$($(1)_LIBNAME),$(1)).so
_BS_EXTRA_TARGET_SETTINGS_DSO = LIBRARY_NAME_$(1)/$(2) := $$(call get-default,$$($(2)_LIBNAME),$(2))

# one argument: target internal name
define _BS_TARGET_RULE_DSO

$(_BS_BUILD_TARGET_$(1)): $(_BS_OBJECTS_$(1)) | $(call dirname,$(_BS_BUILD_TARGET_$(1)))
	@rm -f $$@
	$(CXX) -shared -o $$@ \
	    $(call expand-target-variable,$(1),LDFLAGS) \
	    $(_BS_OBJECTS_$(1))

endef

endif