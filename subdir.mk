ifndef BS__SUBDIR_MK
BS__SUBDIR_MK=1

# In this file resides most of the scary voodoo. Essentially, we include
# build.mk from each subdirectory in turn, doing appropriate reassignments to
# isolate its settings from those in any other subdirectory.
#
# Annoyingly, the use of eval on every line inside here is, I think, required
# to support recursive including (and hence SUBDIRS more than one level deep).
#
# Essentially, the first include must be processed completely before we can
# know how many other include statements will be needed, hence it must be
# eval-ed in here, and everything else then cascades -- we need to do the other
# processing of this subdir before doing anything to the next one, so that must
# be eval-ed immediately, etc.

# Arguments: subdir, target type
define process-subdir-target-type

$(foreach target, $($(2)S), \
    $(eval _BS_ALL_TARGETS += $(1)/$(target)) \
    $(eval _BS_TARGET_TYPE_$(1)/$(target) = $(2)) \
    $(eval _BS_BUILD_TARGET_$(1)/$(target) = $(BUILDDIR)/$(call _BS_DEFAULT_OUTPUT_$(2),$(target))) \
    $(eval SUBDIR_$(1)/$(target) = $(1)) \
    $(eval $(call _BS_EXTRA_TARGET_SETTINGS_$(2),$(1),$(target))) \
    $(foreach v,$(TARGET_VARIABLES), \
        $(eval $(1)/$(target)_$(v)=$(value $(target)_$(v))) \
    ) \
)

endef

# Arguments: subdir path
define subdir-include

$(eval SUBDIR=$(1))
$(eval $(call save-vars,$(SUBDIR_VARIABLES),subdir_$(1)))
$(foreach v,$(SUBDIR_VARIABLES),$(eval $(v)=))

$(eval include $(1)/build.mk)

$(foreach type, $(_BS_SUPPORTED_TARGETS), \
    $(eval $(call process-subdir-target-type,$(1),$(type))))

$(foreach v,$(SUBDIR_VARIABLES), \
    $(eval $(1)_$(v)=$($(v))) \
)

$(foreach v,$($(1)_SUBDIRS), \
    $(eval $(call subdir-include,$(1)/$(v))))

$(eval $(call load-vars,subdir_$(1)))

endef

#include $(foreach s,$(SUBDIRS),$(s)/build.mk)
$(foreach s,$(SUBDIRS),$(eval $(call subdir-include,$(s))))

ALL_BUILD_TARGETS = $(foreach t, $(_BS_ALL_TARGETS), $(_BS_BUILD_TARGET_$(t)))

endif
