# ============================================================
# Makefile for the NWNU graduate thesis template
# Builds main.tex into main.pdf with XeLaTeX:
#     xelatex -> bibtex -> xelatex -> xelatex
# (The project was migrated to XeLaTeX; Chinese is handled by
#  ctex + xeCJK, so the old latex+dvipdfmx / pdflatex routes
#  are no longer needed.)
#
# Requires: GNU make + a TeX distribution with xelatex/bibtex on PATH.
# Under Git Bash, `make clean` uses find -delete.
#
# Targets:
#   make           build with xelatex
#   make clean     remove intermediate files (keeps PDF)
#   make cleanall  remove intermediates and the built PDF
# ============================================================

MAIN    := main
BIB     := bibtex
XELATEX := xelatex

# Files that should trigger a rebuild when changed
SOURCES := $(MAIN).tex \
           references.bib \
           NWNUThesis.bst \
           nwnuthesis.sty \
           $(wildcard body/*.tex) \
           $(wildcard appendix/*.tex) \
           $(wildcard preface/*.tex)

.PHONY: all clean cleanall

all: $(MAIN).pdf

$(MAIN).pdf: $(SOURCES)
	$(XELATEX) -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	$(BIB)     $(MAIN)
	$(XELATEX) -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	$(XELATEX) -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	@echo "Built: $(MAIN).pdf"

# --- cleanup (same list as clean.bat) ---
clean:
	@find . -type f \( \
	    -name '*.aux' -o -name '*.bbl' -o -name '*.blg' -o -name '*.bcf' -o \
	    -name '*.run.xml' -o -name '*.cpx' -o -name '*.log' -o -name '*.out' -o \
	    -name '*.toc' -o -name '*.toe' -o -name '*.thm' -o -name '*.lof' -o \
	    -name '*.lot' -o -name '*.loa' -o -name '*.fen' -o -name '*.ten' -o \
	    -name '*.fls' -o -name '*.fdb_latexmk' -o -name '*.synctex' -o \
	    -name '*.synctex.gz' -o -name '*.dvi' -o -name '*.xdv' -o -name '*.ps' -o \
	    -name '*.gz' -o -name '*.gz(busy)' -o -name '*.idx' -o -name '*.ind' -o \
	    -name '*.ilg' -o -name '*.nlo' -o -name '*.nls' -o -name '*.glo' -o \
	    -name '*.gls' -o -name '*.acn' -o -name '*.acr' -o -name '*.alg' -o \
	    -name '*.ist' -o -name '*.nav' -o -name '*.snm' -o -name '*.vrb' -o \
	    -name '*.brf' -o -name '*.lol' -o -name '*.bak' -o -name '*.swp' \
	\) -delete
	@echo "Cleaned intermediate files."

cleanall: clean
	rm -f $(MAIN).pdf
	@echo "Also removed the built PDF."
