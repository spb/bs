ifndef BS__MAKEDEPEND_MK
BS__MAKEDEPEND_MK=1

# This is called from objects.mk, where all the relevant information is known
#
# $(1) = relevant target file
# $(2) = dep file
# $(3) = source file
# $(4) = object file
define _dependency_file_rule

$(call add-dir,$(dir $(2)))

$(2): $(3) | $(dir $(2))
	$(CXX) -MM -MG -MT '$(4)' \
	    $$(call expand-target-variable,$(1),CPPFLAGS) \
	    $$(call expand-target-variable,$(1),CXXFLAGS) \
	    -o $$@ \
	    $(3)

-include $(2)

endef

endif
