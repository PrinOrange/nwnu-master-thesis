# ============================================================
# Makefile for the NWNU graduate thesis template
# Builds main.tex into main.pdf with XeLaTeX:
#     xelatex -> bibtex -> xelatex -> xelatex
# (The project was migrated to XeLaTeX; Chinese is handled by
#  ctex + xeCJK, so the old latex+dvipdfmx / pdflatex routes
#  are no longer needed.)
#
# 所有编译中间文件输出到 build/ 目录；最终 main.pdf 复制回项目根目录。
# \include 的子目录（body/、appendix/）需要在 build/ 下预建对应子目录，
# 因此构建前会执行 mkdir -p。
#
# Requires: GNU make + a TeX distribution with xelatex/bibtex on PATH.
#
# Targets:
#   make           build with xelatex
#   make clean     remove intermediate files (keeps PDF)
#   make cleanall  remove intermediates and the built PDF
# ============================================================

MAIN    := main
BIB     := bibtex
XELATEX := xelatex
BUILD   := build

# \include 路径对应的 build 子目录
BUILD_SUBDIRS := $(BUILD)/body $(BUILD)/appendix

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

# 根目录 main.pdf 由 build/main.pdf 复制而来
$(MAIN).pdf: $(BUILD)/$(MAIN).pdf
	cp $(BUILD)/$(MAIN).pdf $(MAIN).pdf

# 真正的编译目标：全部输出到 build/
$(BUILD)/$(MAIN).pdf: $(SOURCES)
	@mkdir -p $(BUILD_SUBDIRS)
	$(XELATEX) -synctex=1 -output-directory=$(BUILD) -interaction=nonstopmode -halt-on-error $(MAIN)
	$(BIB)     $(BUILD)/$(MAIN)
	$(XELATEX) -synctex=1 -output-directory=$(BUILD) -interaction=nonstopmode -halt-on-error $(MAIN)
	$(XELATEX) -synctex=1 -output-directory=$(BUILD) -interaction=nonstopmode -halt-on-error $(MAIN)
	@echo "Built: $(BUILD)/$(MAIN).pdf"

# 清理中间文件（build/ 目录），保留最终 PDF
clean:
	rm -rf $(BUILD)
	@echo "Cleaned intermediate files (build/)."

cleanall: clean
	rm -f $(MAIN).pdf
	@echo "Also removed the built PDF."
