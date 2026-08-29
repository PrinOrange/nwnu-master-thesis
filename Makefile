# ============================================================
# Makefile for the NWNU graduate thesis template
# Builds main.tex into main.pdf with latexmk:
#     latexmk -pdf -outdir=build -synctex=1 main.tex
# latexmk decides the compile order automatically (pdflatex as
# needed, bibtex when the bibliography changes, and repeats passes
# until references settle), so this replaces the old hand-written
# 4-step chain (pdflatex -> bibtex -> pdflatex -> pdflatex).
#
# Chinese is handled by ctex + CJK under pdflatex (Windows system
# CJK fonts).  To build with XeLaTeX instead (required on Overleaf,
# which lacks the Windows fonts), switch the engine:  make ENGINE=-pdfxe
# or edit ENGINE below.  nwnuthesis.sty is engine-aware (pdfLaTeX
# loads system fonts, XeLaTeX loads the bundled assets/ fonts).
#
# All intermediate files go to build/; the final main.pdf is copied
# back to the project root.  \include subdirs (body/, appendix/)
# need matching build/ subdirs; they are created before compiling
# so latexmk never hits a missing-aux-directory on its first pass.
#
# Requires: GNU make + a TeX distribution with latexmk and pdflatex
#           (or xelatex) on PATH.
#
# Targets:
#   make           build with latexmk (default pdflatex)
#   make clean     remove intermediate files (keeps PDF)
#   make cleanall  remove intermediates and the built PDF
# ============================================================

MAIN      := main
LATEXMK   := latexmk
ENGINE    := -pdf             # -pdf = pdflatex ; -pdfxe = xelatex (Overleaf)
BUILD     := build

# \include 子目录对应的 build 子目录
BUILD_SUBDIRS := $(BUILD)/body $(BUILD)/appendix

# 变更即触发重建的源文件
SOURCES := $(MAIN).tex \
           references.bib \
           NWNUThesis.bst \
           nwnuthesis.sty \
           $(wildcard body/*.tex) \
           $(wildcard appendix/*.tex) \
           $(wildcard preface/*.tex)

.PHONY: all clean cleanall

all: $(MAIN).pdf

# 编译：latexmk 自动调度编译顺序与补跑次数
$(BUILD)/$(MAIN).pdf: $(SOURCES)
	@mkdir -p $(BUILD_SUBDIRS)
	@$(LATEXMK) $(ENGINE) -outdir=$(BUILD) -synctex=1 $(MAIN) >$(BUILD)/latexmk.log 2>&1 \
	  || { echo "[!!] latexmk FAILED (see build/latexmk.log):"; \
	       grep -iE 'error|^!' $(BUILD)/latexmk.log | tail -n 30; exit 1; }
	@grep -E 'Warning' $(BUILD)/main.log | sed 's/^/[!] /' || true

# 根目录 main.pdf 由 build/main.pdf 复制而来
$(MAIN).pdf: $(BUILD)/$(MAIN).pdf
	@cp $(BUILD)/$(MAIN).pdf $(MAIN).pdf
	@echo "[OK] Built: $(MAIN).pdf ($$(grep -o '[0-9]* pages' $(BUILD)/main.log | tail -1 | sed 's/ pages//') pages)"

# 清理中间文件（build/ 目录），保留最终 PDF
clean:
	@rm -rf $(BUILD)
	@echo "[OK] Cleaned intermediate files (build/)."

cleanall: clean
	@rm -f $(MAIN).pdf
	@echo "[OK] Also removed $(MAIN).pdf."
