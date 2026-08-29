# ===========================================================================
#  build.ps1 - One-shot build / clean for the NWNU thesis template
#
#  Usage (Windows PowerShell):
#    .\build.ps1            # build (default)
#    .\build.ps1 build      # build (explicit)
#    .\build.ps1 clean      # remove intermediate files in build/, keep main.pdf
#    .\build.ps1 cleanall   # remove build/ and the built main.pdf
#
#  Compile: latexmk -pdf -outdir=build -synctex=1 main.tex
#  latexmk 自动调度编译顺序（pdflatex 补跑、bibtex 按需触发、引用未稳定时自动
#  重跑），所以这里不再手写 pdflatex -> bibtex -> pdflatex -> pdflatex 的旧式四步链。
#
#  如需改用 XeLaTeX（Overleaf 等无 Windows 中文字体的环境），把下面的
#  $Engine 改为 '-pdfxe' 即可。
#
#  中间文件全部输出到 build/；最终 main.pdf 复制回项目根目录。
#  完整日志保存在 build/latexmk.log，正文警告显示在控制台。
#
#  注意：本文件须保持 UTF-8 编码并带 BOM —— Windows PowerShell 5.1（默认
#  控制台代码页为 CP936/GBK）读取无 BOM 的 UTF-8 中文/emoji 会乱码解析报错。
#
#  若执行策略阻止脚本，先运行一次：
#      Set-ExecutionPolicy -Scope Process Bypass
#  或：
#      powershell -ExecutionPolicy Bypass -File .\build.ps1
# ===========================================================================

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet("build", "clean", "cleanall")]
    [string]$Action = "build"
)

$ErrorActionPreference = "Stop"

# 让 emoji / 中文在 PowerShell 5.1 下按 UTF-8 输出，避免被控制台代码页（CP936）
# 转成乱码；Windows Terminal 下即可正常显示 emoji。
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$Main      = "main"
$BuildDir  = "build"
$Engine    = '-pdf'          # '-pdf' = pdflatex ; '-pdfxe' = xelatex
$BuildSubDirs = @("$BuildDir/body", "$BuildDir/appendix")

# 从日志中提取错误行并打印（最多 30 行）
function Show-Errors {
    param([string]$Log)
    Select-String -Path $Log -Pattern 'Error|^!' -ErrorAction SilentlyContinue |
        Select-Object -Last 30 | ForEach-Object { Write-Host $_.Line }
}

function Invoke-Compile {
    # 预建 \include 子目录（分章 aux 文件的输出位置），让 latexmk 首遍即可写入
    foreach ($d in $BuildSubDirs) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
    }

    Write-Host "🔨 [1/1] latexmk 编译（自动调度 pdflatex / bibtex / 补跑）…"
    # latexmk 会把正常提示写到 stderr；在 $ErrorActionPreference='Stop' 下，
    # PowerShell 会把任何 stderr 行升级成终止性 NativeCommandError，因此仅对这次
    # 调用临时放宽为 'Continue'，改以 $LASTEXITCODE 判断成败。
    $prevEAP = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & latexmk $Engine "-outdir=$BuildDir" "-synctex=1" $Main *> "$BuildDir/latexmk.log"
    $code = $LASTEXITCODE
    $ErrorActionPreference = $prevEAP
    if ($code -ne 0) {
        Write-Host "❌ latexmk 失败，错误信息："
        Show-Errors "$BuildDir/latexmk.log"
        throw "latexmk failed (see build/latexmk.log)"
    }

    Copy-Item "$BuildDir/$Main.pdf" "$Main.pdf" -Force

    # 显示最后一遍正文的警告，带 ⚠️ 前缀
    $warnings = Select-String -Path "$BuildDir/main.log" -Pattern 'Warning' -ErrorAction SilentlyContinue
    foreach ($w in $warnings) { Write-Host "⚠️ $($w.Line)" }

    $pagesLine = (Select-String -Path "$BuildDir/main.log" -Pattern 'Output written' |
        Select-Object -Last 1).Line
    if ($pagesLine -match '\((\d+)\s*pages') { $pageInfo = "（$($matches[1]) 页）" } else { $pageInfo = "" }
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
