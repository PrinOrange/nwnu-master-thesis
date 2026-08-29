# ===========================================================================
#  build.ps1 - One-shot build / clean for the NWNU thesis template
#
#  Usage (Windows PowerShell):
#    .\build.ps1            # build (default)
#    .\build.ps1 build      # build (explicit)
#    .\build.ps1 clean      # remove intermediate files in build/, keep main.pdf
#    .\build.ps1 cleanall   # remove build/ and the built main.pdf
#
#  Compile chain: pdflatex -> bibtex -> pdflatex -> pdflatex
#  All intermediate files go to build/; the final main.pdf is copied back
#  to the project root.
#
#  Prints friendly progress + warnings/errors; the full logs are saved to
#  build/pass1.log / pass2.log / pass3.log, bib.log and main.log.
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

# 从日志中提取警告/错误行并打印（最多 30 行）
function Show-Issues {
    param([string]$Log, [string]$Pattern = 'Warning|^!')
    Select-String -Path $Log -Pattern $Pattern | Select-Object -Last 30 | ForEach-Object { Write-Host $_.Line }
}

function Invoke-Compile {
    # 预建 \include 子目录（分章 aux 文件的输出位置）
    foreach ($d in $BuildSubDirs) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
    }

    Write-Host "🔨 [1/4] pdflatex 第一遍编译…"
    & pdflatex "-synctex=1" "-output-directory=$BuildDir" "-interaction=nonstopmode" "-halt-on-error" $Main *> "$BuildDir/pass1.log"
    if ($LASTEXITCODE -ne 0) { Write-Host "❌ pdflatex 第一遍失败，错误信息："; Show-Issues "$BuildDir/pass1.log"; throw "pdflatex (pass 1) failed" }

    Write-Host "📚 [2/4] bibtex 生成参考文献…"
    & bibtex "$BuildDir/$Main" *> "$BuildDir/bib.log"
    if ($LASTEXITCODE -ne 0) { Write-Host "❌ bibtex 失败，错误信息："; Show-Issues "$BuildDir/bib.log"; throw "bibtex failed" }

    Write-Host "🔨 [3/4] pdflatex 第二遍编译…"
    & pdflatex "-synctex=1" "-output-directory=$BuildDir" "-interaction=nonstopmode" "-halt-on-error" $Main *> "$BuildDir/pass2.log"
    if ($LASTEXITCODE -ne 0) { Write-Host "❌ pdflatex 第二遍失败，错误信息："; Show-Issues "$BuildDir/pass2.log"; throw "pdflatex (pass 2) failed" }

    Write-Host "🔨 [4/4] pdflatex 第三遍编译…"
    & pdflatex "-synctex=1" "-output-directory=$BuildDir" "-interaction=nonstopmode" "-halt-on-error" $Main *> "$BuildDir/pass3.log"
    if ($LASTEXITCODE -ne 0) { Write-Host "❌ pdflatex 第三遍失败，错误信息："; Show-Issues "$BuildDir/pass3.log"; throw "pdflatex (pass 3) failed" }

    Copy-Item "$BuildDir/$Main.pdf" "$Main.pdf" -Force

    # 显示最终一遍（pass 3）的警告，带 ⚠️ 前缀
    $warnings = Select-String -Path "$BuildDir/pass3.log" -Pattern 'Warning'
    foreach ($w in $warnings) { Write-Host "⚠️ $($w.Line)" }

    $pagesLine = (Select-String -Path "$BuildDir/main.log" -Pattern 'Output written' | Select-Object -Last 1).Line
    if ($pagesLine -match '\((\d+)\s*pages\)') { $pageInfo = "（$($matches[1]) 页）" } else { $pageInfo = "" }
    Write-Host "✅ 构建成功：$Main.pdf$pageInfo"
}

function Remove-Build {
    Write-Host "🧹 清理中间文件（build/）…"
    if (Test-Path $BuildDir) {
        Remove-Item $BuildDir -Recurse -Force
        Write-Host "✅ 清理完成"
    }
    else {
        Write-Host "✅ 无需清理（build/ 不存在）"
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
            Write-Host "🗑️ 已删除 main.pdf"
        }
    }
}
