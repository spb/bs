ifndef BS__TARGETS_SCRIPT_MK
BS__TARGETS_SCRIPT_MK=1

_BS_SUPPORTED_TARGETS += SCRIPT

_BS_DEFAULT_OUTPUT_SCRIPT = $(call get-target-variable,$(2),BINDIR)/$(1)

define _BS_TARGET_RULE_SCRIPT

$(eval $(call add-dir,$(dir $(_BS_BUILD_TARGT_$(1)))))

$(_BS_BUILD_TARGET_$(1)): $(1) \
			| $(dir $(_BS_BUILD_TARGET_$(1)))
	cp -p $$< $$@

endef

endif
