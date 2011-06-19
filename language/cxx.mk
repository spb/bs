ifndef BS__CXX_MK
BS__CXX_MK=1

# Rules for compiling C++

_BS_SUPPORTED_LANGUAGES += CXX
_BS_LANGUAGE_INPUT_PATTERNS_CXX = %.cc %.cpp

# Creates one object file, and no generated sources or headers
_BS_LANGUAGE_OBJECTS_CXX = $(1).o
_BS_LANGUAGE_GENERATED_SOURCES_CXX =
_BS_LANGUAGE_GENERATED_HEADERS_CXX =

# Arguments: target name, target object, input source file
define _BS_LANGUAGE_COMPILE_RULE_CXX

$(call add-dir,$(dir $(2)))

$(2): $(3) | $(dir $(2))
	$$(CXX) -c \
	    $$(call expand-target-variable,$(1),CPPFLAGS) \
	    $$(call expand-target-variable,$(1),CXXFLAGS) \
	    -o $$@ \
	    $$<

endef

endif
