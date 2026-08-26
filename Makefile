# ============================================================
# Makefile for the NWNU graduate thesis template
# Builds M.Eng.Main.tex into M.Eng.Main.pdf.
#
# Default engine is the dvipdfmx route (same as pdfmake.bat):
#     latex -> bibtex -> latex -> latex -> dvipdfmx
# Use `make pdflatex` to build with pdflatex instead.
# (Note: the header of M.Eng.Main.tex, \def\usewhat{...},
#  should match the engine you pick.)
#
# Requires: GNU make + a TeX distribution with latex/bibtex/
# dvipdfmx (and optionally pdflatex) on PATH. Under Git Bash,
# `make clean` uses find -delete.
#
# Targets:
#   make / make latex   build with the latex+dvipdfmx chain
#   make pdflatex       build with pdflatex
#   make clean          remove intermediate files (keeps PDF)
#   make cleanall       remove intermediates and the built PDF
# ============================================================

MAIN     := main
BIB      := bibtex
LATEX    := latex
PDFLATEX := pdflatex
DVIPDFMX := dvipdfmx

# Files that should trigger a rebuild when changed
SOURCES := $(MAIN).tex \
           references.bib \
           NWNUThesis.bst \
           artratex.sty \
           setup/package.tex \
           setup/format.tex \
           setup/bibspacing.sty \
           $(wildcard body/*.tex) \
           $(wildcard appendix/*.tex) \
           $(wildcard preface/*.tex)

.PHONY: all latex pdflatex clean cleanall

all: latex

# --- dvipdfmx route (default, matches pdfmake.bat) ---
latex: $(MAIN).pdf

$(MAIN).pdf: $(SOURCES)
	$(LATEX)   -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	$(BIB)     $(MAIN)
	$(LATEX)   -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	$(LATEX)   -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	$(DVIPDFMX) $(MAIN).dvi
	@echo "Built: $(MAIN).pdf"

# --- pdflatex route ---
pdflatex:
	$(PDFLATEX) -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	$(BIB)      $(MAIN)
	$(PDFLATEX) -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	$(PDFLATEX) -synctex=1 -interaction=nonstopmode -halt-on-error $(MAIN)
	@echo "Built: $(MAIN).pdf"

# --- cleanup (same list as clean.sh) ---
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
	rm -f $(MAIN).pdf $(MAIN).dvi
	@echo "Also removed the built PDF."
