##########################################################################
#    Makefile for SeriesFinale

#    This is a helper Makefile to build the python translation files
#    since that is not automatically done with qtcreator.
#    The .ls files are converted to .po files with lconvert. A tool
#    that comes with the Qt distribution.
#    The .po files are compiled to binary .mo format with msgfmt.
##########################################################################

TSFILES = $(wildcard translations/python-messages-*.ts)
POFILES = $(subst .ts,.po,$(subst python-messages-,,$(TSFILES)))
LOCALEDIR = src/SeriesFinale/locale
MOFILES = $(patsubst translations/%.po,$(LOCALEDIR)/%/LC_MESSAGES/seriesfinale.mo, $(POFILES))

LCONVERT = /opt/Qt/6.7.0/gcc_64/bin/lconvert
MSGFMT = msgfmt

.PHONY: help clean

help:
	@echo ""
	@echo "  make translations   Convert and build python translation files"
	@echo "  make clean          Remove generated and compiled files"
	@echo ""

translations: $(MOFILES)

translations/%.po: translations/python-messages-%.ts
	$(LCONVERT) $< -o $@

$(LOCALEDIR)/%/LC_MESSAGES/seriesfinale.mo: translations/%.po
	@mkdir -p $(@D)
	$(MSGFMT) $< -o $@

clean:
	rm -f $(POFILES)
	rm -rf build $(LOCALEDIR)
