ifndef BS__XS_MK
BS__XS_MK=1

# Rules for compiling XS

_BS_SUPPORTED_LANGUAGES += XS
_BS_LANGUAGE_INPUT_PATTERNS_XS = %.xs

_BS_LANGUAGE_OBJECTS_XS =
_BS_LANGUAGE_GENERATED_SOURCES_XS = $(1)_XS.cpp
_BS_LANGUAGE_GENERATED_HEADERS_XS =

# Arguments: target name, target generated source file, input source file
define _BS_LANGUAGE_COMPILE_RULE_XS

$(call add-dir,$(dir $(2)))

$(2): $(3) | $(dir $(2))
	xsubpp -csuffix _XS.cpp \
	    -prototypes \
	    $$< >$$@

#	    $(if $(call get-target-variable,$(1),XS_TYPEMAP),-typemap $(call get-target-variable,$(1),XS_TYPEMAP)) \

endef

endif
