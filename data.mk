ifndef BS__DATA_MK
BS__DATA_MK=1

# Handle data files for each subdir

# Arguments: subdir, data file name
define data-file-rule

$(eval _outfile=$(BUILDDIR)/$(call get-subdir-variable,$(1),DATADIR)/$(2))
$(call add-dir,$(dir $(_outfile)))

_data_$(1): $(_outfile)

$(_outfile): $(1)/$(2) | $(dir $(_outfile))
	cp -p $$< $$@

endef

# Arguments: subdir name
expand-data-files = \
    $(foreach name, $($(1)_DATA), \
        $(if $(wildcard $(1)/$(name)/.), \
            $(patsubst $(1)/%,%,$(call recurse-dir,$(1)/$(name))), \
            $(name) \
    ))

# Arguments: subdir name
define data-subdir-rule

.PHONY: _data_$(1)
_data_$(1): | $(call get-subdir-variable,$(1),DATADIR)

$(call add-dir,$(call get-subdir-variable,$(1),DATADIR))

$(foreach file,$(call expand-data-files,$(1)), \
        $(call data-file-rule,$(1),$(file)))

endef

$(foreach subdir, $(_BS_ALL_SUBDIRS), \
    $(eval $(call data-subdir-rule,$(subdir))))

ALL_BUILD_TARGETS += $(addprefix _data_,$(_BS_ALL_SUBDIRS))

endif
