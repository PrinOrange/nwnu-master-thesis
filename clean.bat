@echo off
REM ============================================================
REM  clean.bat - Clean up LaTeX intermediate files
REM  NOTE: This file must stay ASCII-only (no Chinese/UTF-8)
REM  or cmd.exe will misparse it under GBK codepage.
REM ============================================================
REM  Source files (.tex/.bib/.bst/.sty/figures) are kept.
REM  The compiled PDF is kept as well.
REM  To also delete the PDF, uncomment the line below:
REM  del /s *.pdf

echo Cleaning LaTeX intermediate files...

REM --- Main document auxiliary files ---
del *.aux /s
del *.bbl /s
del *.blg /s
del *.bcf /s
del *.run.xml /s
del *.cpx /s
del *.log /s
del *.out /s
del *.toc /s
del *.toe /s
del *.thm /s
del *.lof /s
del *.lot /s
del *.loa /s
del *.fen /s
del *.ten /s

REM --- latexmk etc. auxiliary files ---
del *.fls /s
del *.fdb_latexmk /s

REM --- SyncTeX / intermediate output ---
del *.synctex /s
del *.synctex.gz /s
del *.dvi /s
del *.xdv /s
del *.ps /s
del *.gz
del *.gz(busy)

REM --- Index / glossary / acronym auxiliary files ---
del *.idx /s
del *.ind /s
del *.ilg /s
del *.nlo /s
del *.nls /s
del *.glo /s
del *.gls /s
del *.acn /s
del *.acr /s
del *.alg /s
del *.ist /s

REM --- Others ---
del *.nav /s
del *.snm /s
del *.vrb /s
del *.brf /s
del *.lol /s
del *.bak /s
del *.swp /s

echo Done.
