# ===========================================================================
#  build.ps1 - One-shot build / clean for the NWNU thesis template
#
#  Usage (Windows PowerShell):
#    .\build.ps1            # build (default)
#    .\build.ps1 build      # build (explicit)
#    .\build.ps1 clean      # remove intermediate files in build/, keep main.pdf
#    .\build.ps1 cleanall   # remove build/ and the built main.pdf
#
#  Compile chain: xelatex -> bibtex -> xelatex -> xelatex
#  All intermediate files go to build/; the final main.pdf is copied back
#  to the project root.
#
#  If the execution policy blocks scripts, either run once:
#      Set-ExecutionPolicy -Scope Process Bypass
#  or invoke with:
#      powershell -ExecutionPolicy Bypass -File .\build.ps1
# ===========================================================================

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet("build", "clean", "cleanall")]
    [string]$Action = "build"
)

$ErrorActionPreference = "Stop"

$Main      = "main"
$BuildDir  = "build"
$BuildSubDirs = @("$BuildDir/body", "$BuildDir/appendix")

function Invoke-Compile {
    Write-Host "Compiling: xelatex -> bibtex -> xelatex -> xelatex"

    # 预建 \include 子目录（分章 aux 文件的输出位置）
    foreach ($d in $BuildSubDirs) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
    }

    & xelatex "-synctex=1" "-output-directory=$BuildDir" "-interaction=nonstopmode" "-halt-on-error" $Main
    if ($LASTEXITCODE -ne 0) { throw "xelatex (pass 1) failed, exit code $LASTEXITCODE" }

    & bibtex "$BuildDir/$Main"
    if ($LASTEXITCODE -ne 0) { throw "bibtex failed, exit code $LASTEXITCODE" }

    & xelatex "-synctex=1" "-output-directory=$BuildDir" "-interaction=nonstopmode" "-halt-on-error" $Main
    if ($LASTEXITCODE -ne 0) { throw "xelatex (pass 2) failed, exit code $LASTEXITCODE" }

    & xelatex "-synctex=1" "-output-directory=$BuildDir" "-interaction=nonstopmode" "-halt-on-error" $Main
    if ($LASTEXITCODE -ne 0) { throw "xelatex (pass 3) failed, exit code $LASTEXITCODE" }

    Copy-Item "$BuildDir/$Main.pdf" "$Main.pdf" -Force
    Write-Host "Built: $Main.pdf"
}

function Remove-Build {
    if (Test-Path $BuildDir) {
        Remove-Item $BuildDir -Recurse -Force
        Write-Host "Cleaned intermediate files ($BuildDir/)."
    }
    else {
        Write-Host "Nothing to clean ($BuildDir/ not found)."
    }
}

switch ($Action) {
    "build" {
        Invoke-Compile
    }
    "clean" {
        Remove-Build
    }
    "cleanall" {
        Remove-Build
        if (Test-Path "$Main.pdf") {
            Remove-Item "$Main.pdf" -Force
            Write-Host "Also removed the built PDF ($Main.pdf)."
        }
    }
}
