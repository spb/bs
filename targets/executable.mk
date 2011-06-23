ifndef BS__TARGETS_EXECUTABLE_MK
BS__TARGETS_EXECUTABLE_MK=1

_BS_SUPPORTED_TARGETS += EXECUTABLE

_BS_DEFAULT_OUTPUT_EXECUTABLE = $(call get-target-variable,$(2),BINDIR)/$(1)

# one argument: target internal name
define _BS_TARGET_RULE_EXECUTABLE

$(eval $(call add-dir,$(dir $(_BS_BUILD_TARGET_$(1)))))

$(_BS_BUILD_TARGET_$(1)): $(_BS_OBJECTS_$(1)) \
			| $(call expand-target-dependency-files,$(1)) \
			  $(dir $(_BS_BUILD_TARGET_$(1)))
	$(CXX) -o $$@ \
	    $(call expand-target-variable,$(1),LDFLAGS) \
	    -L$(BUILDDIR)/$(LIBDIR) \
	    $(call expand-target-dependencies,$(1)) \
	    $(_BS_OBJECTS_$(1))

endef

endif
