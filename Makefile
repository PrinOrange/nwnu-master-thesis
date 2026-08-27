# ============================================================
# Makefile for the NWNU graduate thesis template
# Builds main.tex into main.pdf with XeLaTeX:
#     xelatex -> bibtex -> xelatex -> xelatex
# (The project was migrated to XeLaTeX; Chinese is handled by
#  ctex + xeCJK, so the old latex+dvipdfmx / pdflatex routes
#  are no longer needed.)
#
# All intermediate files go to build/; the final main.pdf is copied
# back to the project root.  \include subdirs (body/, appendix/)
# need matching build/ subdirs, created before compiling.
#
# Prints friendly progress + warnings/errors; the full logs are kept
# in build/pass1.log, pass2.log, pass3.log, bib.log and main.log.
# NOTE: this file is ASCII-only for cross-platform safety (Windows
#       Git Bash + Unix alike).  The Windows build.ps1 has the full
#       Chinese/emoji output.
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

# 编译（四步），全部输出到 build/，打印进度 + 警告/错误
$(BUILD)/$(MAIN).pdf: $(SOURCES)
	@mkdir -p $(BUILD_SUBDIRS)
	@echo "[1/4] xelatex (pass 1) ..."
	@$(XELATEX) -synctex=1 -output-directory=$(BUILD) -interaction=nonstopmode -halt-on-error $(MAIN) >$(BUILD)/pass1.log 2>&1 || { echo "[!!] xelatex (pass 1) FAILED:"; grep -E 'Warning|^!' $(BUILD)/pass1.log | tail -n 30; exit 1; }
	@echo "[2/4] bibtex ..."
	@$(BIB) $(BUILD)/$(MAIN) >$(BUILD)/bib.log 2>&1 || { echo "[!!] bibtex FAILED:"; grep -E 'Warning|^!' $(BUILD)/bib.log | tail -n 30; exit 1; }
	@echo "[3/4] xelatex (pass 2) ..."
	@$(XELATEX) -synctex=1 -output-directory=$(BUILD) -interaction=nonstopmode -halt-on-error $(MAIN) >$(BUILD)/pass2.log 2>&1 || { echo "[!!] xelatex (pass 2) FAILED:"; grep -E 'Warning|^!' $(BUILD)/pass2.log | tail -n 30; exit 1; }
	@echo "[4/4] xelatex (pass 3) ..."
	@$(XELATEX) -synctex=1 -output-directory=$(BUILD) -interaction=nonstopmode -halt-on-error $(MAIN) >$(BUILD)/pass3.log 2>&1 || { echo "[!!] xelatex (pass 3) FAILED:"; grep -E 'Warning|^!' $(BUILD)/pass3.log | tail -n 30; exit 1; }
	@grep -E 'Warning' $(BUILD)/pass3.log | sed 's/^/[!] /' || true

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
