ifndef BS__TARGETS_TEST_MK
BS__TARGETS_TEST_MK=1

_BS_SUPPORTED_TARGETS += TEST

_BS_DEFAULT_OUTPUT_TEST = $(call get-target-variable,$(2),TESTDIR)/$(1)
_BS_EXTRA_TARGETS_TEST = run_test_$(1)

define _BS_TARGET_RULE_TEST

$(call add-dir,$(dir $(_BS_BUILD_TARGET_$(1))))

$(_BS_BUILD_TARGET_$(1)): $(_BS_OBJECTS_$(1)) \
			  $(call expand-target-dependency-statics,$(1)) \
			| $(call dirname,$(_BS_BUILD_TARGET_$(1))) \
			  $(call expand-target-dependency-dsos,$(1))
	@rm -f $$@
	$(CXX) -o $$@ \
	    $(_BS_OBJECTS_$(1)) \
	    -L$(BUILDDIR)/$(LIBDIR) \
	    -Wl,-rpath-link,$(BUILDDIR)/$(LIBDIR) \
	    $(call expand-target-variable,$(1),LDFLAGS) \
	    $(call expand-target-dependencies,$(1))

.PHONY: run_test_$(1)
run_test_$(1): $(_BS_BUILD_TARGET_$(1))
	LD_LIBRARY_PATH=$(BUILDDIR)/$(LIBDIR) $(_BS_BUILD_TARGET_$(1))

endef

endif
