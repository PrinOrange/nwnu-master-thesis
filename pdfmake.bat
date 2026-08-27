@echo off
REM ============================================================
REM  pdfmake.bat - Compile the thesis (Windows)
REM  Compile chain: xelatex -> bibtex -> xelatex -> xelatex
REM  All intermediate files go to build\; the final main.pdf
REM  is copied back to the project root.
REM  NOTE: keep this file ASCII-only (no Chinese).
REM ============================================================

set ARTICLE=main

if not exist build\body mkdir build\body
if not exist build\appendix mkdir build\appendix

xelatex -synctex=1 -output-directory=build %ARTICLE%
bibtex build\%ARTICLE%
xelatex -synctex=1 -output-directory=build %ARTICLE%
xelatex -synctex=1 -output-directory=build %ARTICLE%

copy /y build\%ARTICLE%.pdf %ARTICLE%.pdf
