ifndef BS__C_MK
BS__C_MK=1

_BS_SUPPORTED_LANGUAGES += C
_BS_LANGUAGE_INPUT_PATTERNS_C = %.c
_BS_LANGUAGE_OBJECTS_C = $(1).o
_BS_LANGUAGE_GENERATED_SOURCES_C=
_BS_LANGUAGE_GENERATED_HEADERS_C=

define _BS_LANGUAGE_COMPILE_RULE_C

$(call add-dir,$(TMPROOT)/$(SUBDIR_$(1)))

$(2): $(3) | $(TMPROOT)/$(SUBDIR_$(1))

$(2): $(3) | $(TMPROOT)/$(SUBDIR_$(1))
	$$(CC) -c \
	    $$(call expand-target-variable,$(1),CPPFLAGS) \
	    $$(call expand-target-variable,$(1),CFLAGS) \
	    -o $$@ \
	    $$<

endef

endif
