@echo off
REM ============================================================
REM  clean.bat - Clean up LaTeX intermediate files (Windows)
REM  All intermediate files live in the build\ directory,
REM  so we simply remove that directory.
REM  The final PDF (root main.pdf) is kept.
REM  NOTE: keep this file ASCII-only (no Chinese).
REM ============================================================

echo Cleaning LaTeX intermediate files...
if exist build rd /s /q build
echo Done.
