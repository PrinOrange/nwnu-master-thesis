## 西北师范大学硕士学位论文 LaTeX 模板

本项目是西北师范大学硕士研究生学位论文（**专业学位**）的 LaTeX 模板。基于 [学校官方模板](https://jsj.nwnu.edu.cn/_upload/article/files/eb/c1/e3afc0a744c3a476a36ca4b6e892/5f4f9570-49bc-4012-9d54-4765603a1f5b.zip) 改进。原学校官方模板存在大量死代码、命名不明、组织混乱等问题，在此重构了整个 LaTeX 项目，将全部格式规则、页面样式与自定义宏统一封装进 `nwnuthesis.sty`，`main.tex` 只负责文档结构与内容装配，显著提升可维护性与可读性。

> 目前仅适用于专业学位；学术学位模板仍在开发中。

## 环境要求

- [TeX Live](https://www.tug.org/texlive/)（或其它支持 pdfLaTeX 的发行版）
- 中文字体：**pdfLaTeX 编译时调用系统已安装的 Windows 中文字体**（SimSun / SimHei / KaiTi / FangSong / LiSu，Windows 自带）。XeLaTeX 编译时则从 `assets/` 目录加载随模板分发的字体副本，不依赖系统字体。
- 推荐 [tex-fmt](https://github.com/wgunderwood/tex-fmt) ，一款格式化 CLI 工具，可以对 LaTeX 项目进行格式化

## 目录结构

```
.
├── main.tex            # 主文档：仅组织结构与内容装配，调用各排版命令
├── nwnuthesis.sty      # 统一样式包：宏包、格式规则、页面样式、封面/摘要/目录排版、自定义宏
├── preface/            # 导言信息配置文件（main.tex 通过排版命令自动载入）
│   ├── cover.tex           # 封面信息（标题、作者、导师、专业、日期等）
│   ├── abstract.zh.tex     # 中文摘要与关键词
│   └── abstract.en.tex     # 英文摘要与关键词
├── body/               # 正文各章（chapter01 ~ chapter06）
├── appendix/           # 附录、致谢、攻读学位期间成果
│   ├── acknowledgements.tex
│   ├── appendix.tex
│   └── publications.tex
├── figures/            # 插图资源
├── assets/             # 西文字体（Times）、CJK 字体副本、LOGO 等设计资源
├── references.bib      # 参考文献数据库
├── NWNUThesis.bst      # 参考文献样式（BibTeX）
├── build/              # 编译中间文件（临时生成，勿手动编辑）
├── Makefile            # Linux / macOS 编译脚本
└── build.ps1           # Windows 编译 / 清理脚本（build / clean / cleanall）
```

## 快速开始

1. 编辑 `preface/cover.tex`，填写封面信息：论文标题（中英文）、作者、导师、专业学位类别/领域、日期等。
2. 分别在 `preface/abstract.zh.tex` 与 `preface/abstract.en.tex` 中撰写中英文摘要及关键词。
3. 在 `body/chapter01.tex` ~ `body/chapter06.tex` 中按章撰写正文；如需增删章节，同步修改 `main.tex` 中的 `\include` 列表。
4. 将参考文献条目加入 `references.bib`，在正文中通过 `\cite{}` 引用（行内编号）。

> 封面、摘要等内容配置只需改 `preface/` 下的文件。`main.tex` 里通过 `\makecover`、`\abstractpageZh`、`\abstractpageEn` 等**单个命令**排版，`nwnuthesis.sty` 会在这几个命令内部自动载入对应的 `preface/*.tex`，无需手动 `\input`。

## 编译

默认使用 **pdfLaTeX** 编译。`nwnuthesis.sty` 自动检测编译引擎：pdfLaTeX 走 ctex(CJK 宏包) + 系统中文字体，XeLaTeX 走 ctex(xeCJK) + `assets/` 字体，两种引擎均可编译，仅需切换 `main.tex` 顶部的 `% !TeX program` 声明。

**Windows**（PowerShell）：

```powershell
.\build.ps1          # 编译文档（默认行为）
.\build.ps1 clean    # 清理中间文件（保留 PDF）
.\build.ps1 cleanall # 清理中间文件并删除 PDF
```

**Linux / macOS** 或其他类 Unix 系统：

```bash
make          # 编译文档
make clean    # 清理中间文件（保留 PDF）
make cleanall # 清理中间文件并删除 PDF
```

编译链为 `pdflatex → bibtex → pdflatex → pdflatex`，中间文件全部输出到 `build/`，最终 `main.pdf` 复制回项目根目录。

## 常用命令与环境

`nwnuthesis.sty` 封装了以下用户可直接调用的命令 / 环境：

| 命令 / 环境 | 用途 |
|---|---|
| `\makecover` | 排版封面（含声明、授权页），自动载入 `preface/cover.tex` |
| `\abstractpageZh` / `\abstractpageEn` | 排版中 / 英文摘要页，自动载入对应 `preface/abstract.*.tex` |
| `\tableofcontents` | 目录，首页版式与字距已在 `.sty` 内处理 |
| `\frontmatter` / `\mainmatter` | 导言 / 正文（罗马页码与阿拉伯页码切换、页式切换） |
| `\song` `\hei` `\kai` `\fs` `\li` | 中文字体命令（宋 / 黑 / 楷 / 仿宋 / 隶书） |
| `\yihao` … `\xiaowu` | 字号命令（一号 ~ 小五） |
| `publist` | 带 `[n]` 编号的成果列表 |
| `publistsec{标题}` | 成果分节板块：小标题 + 成果列表（见 `appendix/publications.tex`） |
| `theorem` `lemma` `corollary` `definition` `proposition` | 定理 / 引理 / 推论 / 定义 / 命题环境 |
| `code` | 带编号题注的代码浮动体（题注「代码 章-序号」，如「代码 1-1 冒泡排序代码」）；内部用 `lstlisting` 语法高亮 |

### 代码组件

`nwnuthesis.sty` 基于 `listings` 宏包提供带编号题注的**代码组件**，题注编号为「代码 章-序号」（如「代码 1-1 冒泡排序代码」），与图 / 表 / 算法一致。用法：

```latex
\begin{code}[htbp]
  \begin{lstlisting}[language=C]
#include <stdio.h>
int main(void) { return 0; }
  \end{lstlisting}
  \caption{冒泡排序代码}\label{code:bubble}
\end{code}
```

- **语言**：用 `[language=...]` 指定（`C`、`C++`、`Python`、`Java`、`Matlab` 等），省略则不高亮。
- **交叉引用**：正文用 `代码\ref{code:bubble}`（`\ref` 得到「1-1」）。
- **中文注释**：listings 默认按 ASCII 处理，若代码含中文，用 `(*@ ... @*)` 包裹中文片段，或把代码存为外部文件后用 `\lstinputlisting{file}` 调入，避免溢出 / 乱码。

## 注意事项

1. **迁移到 Overleaf**：将仓库以 ZIP 上传到 Overleaf，Compiler 切换到 **XeLaTeX**（Overleaf 的 Linux 环境未安装 Windows 中文字体，pdfLaTeX 的 `fontset=windows` 无法使用；XeLaTeX 会从 `assets/` 加载随模板分发的字体）。学位论文页数较多，CJK 渲染复杂，可能超过 Overleaf 免费限制，推荐本地编译。

2. **增删章节**：章节文件在 `./body` 目录，创建 TeX 文件后向 `main.tex` 的 `\include` 列表按序添加。每个章节文件开头保留：
   ```latex
   % !TeX root = ../main.tex
   ```
   以指定主入口，避免编译顺序、预览出现不匹配。

3. **无编号章 (`\chapter*`) 首段缩进**：致谢、附录、结论等无编号章，其正文首段已在 `nwnuthesis.sty` 中统一处理为缩进两格，无需在各文件内单独添加 `\setlength` 或 `\indent`。

## 感谢

感谢 DeepSeek 和 Claude Code。没有这俩工具，我永远无法驾驭这种 LaTeX 工程。

## 免责与许可

本模板非学校官方模板，仅供参考、学习使用，使用者对其使用行为负责。

本项目使用 CC 4.0 协议开源。不包括在 `./assets` 目录下的字体、LOGO 等设计资源，其使用协议另有规定。
