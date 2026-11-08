# ============================================================
# Makefile for europasscv2025 LaTeX class
# ============================================================
#
# Copyright 2025 Lorenzo Calisti
#
# This work may be distributed and/or modified under the conditions of
# the LaTeX Project Public License, either version 1.3 of this license
# or (at your option) any later version.
# The latest version of this license is in
#   https://www.latex-project.org/lppl.txt
# and version 1.3c or later is part of all distributions of LaTeX
# version 2008 or later.
#
# This work has the LPPL maintenance status `maintained'.
#
# The Current Maintainer of this work is Lorenzo Calisti.
#

# Engine selection: make ENGINE=xelatex, make ENGINE=lualatex, make ENGINE=pdflatex
ENGINE ?= xelatex

LATEXMK = latexmk
LATEXMK_FLAGS = -$(ENGINE) -interaction=nonstopmode

INSTALL = install -m 644
INSTALLDIR = install -d

PACKAGE_NAME = europasscv2025

# ============================================================
# Source files
# ============================================================
CLASS = europasscv2025.cls
LETTER_CLASS = europassletter2025.cls
COMMON_STY = europasscv2025-common.sty
BIBSTY = europasscv2025-bibliography.sty
LOCALE_DEF = $(wildcard locale/*.def)
COLORS_DEF = $(wildcard colors/*.def)
CLASS_FILES = $(CLASS) $(LETTER_CLASS) $(COMMON_STY)

# ============================================================
# Targets
# ============================================================
.PHONY: all class images documentation examples clean distclean package tds

all: class images documentation examples

# ------------------------------------------------------------
# class: no build step needed, just a check that files exist
# ------------------------------------------------------------
class: $(CLASS_FILES) $(BIBSTY) $(LOCALE_DEF) $(COLORS_DEF)
	@echo "Class files ready."

# ------------------------------------------------------------
# images: convert SVG logo to PDF with Inkscape
# ------------------------------------------------------------
images: photo.png europass_logo.pdf

europass_logo.pdf: europass_logo.svg
	inkscape $< --export-area-drawing --export-type="pdf" --export-filename="$@"

photo.png: photo.svg
	inkscape $< --export-area-drawing --export-type="png" --export-filename="$@"

# ------------------------------------------------------------
# pdf file from tex
# ------------------------------------------------------------
%.pdf: %.tex $(CLASS_FILES) $(BIBSTY) $(LOCALE_DEF) $(COLORS_DEF)
	$(LATEXMK) $(LATEXMK_FLAGS) $<
# ------------------------------------------------------------
# documentation
# ------------------------------------------------------------
documentation: class images europasscv2025.pdf

# ------------------------------------------------------------
# examples
# ------------------------------------------------------------
examples: class images europasscv2025_en.pdf europasscv2025_bib_en.pdf europassletter2025_en.pdf

# ------------------------------------------------------------
# package: build a CTAN-ready tarball
# ------------------------------------------------------------
package: all tds
	$(INSTALLDIR) $(PACKAGE_NAME)
	$(INSTALLDIR) $(PACKAGE_NAME)/locale
	$(INSTALLDIR) $(PACKAGE_NAME)/colors
	$(INSTALL) $(CLASS) $(PACKAGE_NAME)
	$(INSTALL) $(LETTER_CLASS) $(PACKAGE_NAME)
	$(INSTALL) $(COMMON_STY) $(PACKAGE_NAME)
	$(INSTALL) $(BIBSTY) $(PACKAGE_NAME)
	$(INSTALL) europass_logo.pdf $(PACKAGE_NAME)
	$(INSTALL) locale/*.def $(PACKAGE_NAME)/locale
	$(INSTALL) colors/*.def $(PACKAGE_NAME)/colors
	$(INSTALL) europasscv2025.tex $(PACKAGE_NAME)
	$(INSTALL) europasscv2025.pdf $(PACKAGE_NAME)
	$(INSTALL) README.md $(PACKAGE_NAME)
	$(INSTALL) CHANGELOG.md $(PACKAGE_NAME)
	$(INSTALL) LICENCE $(PACKAGE_NAME)
	$(INSTALL) europasscv2025_en.tex $(PACKAGE_NAME)
	$(INSTALL) europasscv2025_en.pdf $(PACKAGE_NAME)
	$(INSTALL) europasscv2025_bib_en.tex $(PACKAGE_NAME)
	$(INSTALL) europasscv2025_bib_en.pdf $(PACKAGE_NAME)
	$(INSTALL) europassletter2025_en.tex $(PACKAGE_NAME)
	$(INSTALL) europassletter2025_en.pdf $(PACKAGE_NAME)
	$(INSTALL) europasscv2025_example.bib $(PACKAGE_NAME)
	$(INSTALL) photo.png $(PACKAGE_NAME)
	$(INSTALL) Makefile $(PACKAGE_NAME)/Makefile.$(PACKAGE_NAME)
	tar -cvf $(PACKAGE_NAME).tar --owner=0 --group=0 $(PACKAGE_NAME) $(PACKAGE_NAME).tds.zip
	gzip -f $(PACKAGE_NAME).tar
	rm -fr $(PACKAGE_NAME)
	rm -fr $(PACKAGE_NAME).tds.zip

# ------------------------------------------------------------
# tds: build the TDS (TeX Directory Structure) zip for CTAN
# ------------------------------------------------------------
tds: all
	$(INSTALLDIR) tds/tex/latex/$(PACKAGE_NAME)
	$(INSTALLDIR) tds/tex/latex/$(PACKAGE_NAME)/locale
	$(INSTALLDIR) tds/tex/latex/$(PACKAGE_NAME)/colors
	$(INSTALL) $(CLASS) tds/tex/latex/$(PACKAGE_NAME)
	$(INSTALL) $(LETTER_CLASS) tds/tex/latex/$(PACKAGE_NAME)
	$(INSTALL) $(COMMON_STY) tds/tex/latex/$(PACKAGE_NAME)
	$(INSTALL) $(BIBSTY) tds/tex/latex/$(PACKAGE_NAME)
	$(INSTALL) europass_logo.pdf tds/tex/latex/$(PACKAGE_NAME)
	$(INSTALL) locale/*.def tds/tex/latex/$(PACKAGE_NAME)/locale
	$(INSTALL) colors/*.def tds/tex/latex/$(PACKAGE_NAME)/colors
	$(INSTALLDIR) tds/doc/latex/$(PACKAGE_NAME)
	$(INSTALLDIR) tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) europasscv2025.tex tds/doc/latex/$(PACKAGE_NAME)
	$(INSTALL) europasscv2025.pdf tds/doc/latex/$(PACKAGE_NAME)
	$(INSTALL) README.md tds/doc/latex/$(PACKAGE_NAME)
	$(INSTALL) CHANGELOG.md tds/doc/latex/$(PACKAGE_NAME)
	$(INSTALL) LICENCE tds/doc/latex/$(PACKAGE_NAME)
	$(INSTALL) europasscv2025_en.tex tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) europasscv2025_en.pdf tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) europasscv2025_bib_en.tex tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) europasscv2025_bib_en.pdf tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) europassletter2025_en.tex tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) europassletter2025_en.pdf tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) europasscv2025_example.bib tds/doc/latex/$(PACKAGE_NAME)/example
	$(INSTALL) photo.png tds/doc/latex/$(PACKAGE_NAME)/example
	cd tds && zip -r $(PACKAGE_NAME).tds.zip * && mv $(PACKAGE_NAME).tds.zip ..
	rm -fr tds

# ------------------------------------------------------------
# clean: remove auxiliary files
# ------------------------------------------------------------
distclean:
	rm -f *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.out
	rm -f *.run.xml *.synctex.gz *.toc *.xdv *~ *.dvi

# remove also PDFs and pngs
clean: distclean
	rm -f *.pdf
	rm -f *.png
