## 西北师范大学硕士学位论文 LaTeX 模板

本项目是西北师范大学硕士研究生学位论文（**专业学位**）的 LaTeX 模板。基于 [学校官方模板](https://jsj.nwnu.edu.cn/_upload/article/files/eb/c1/e3afc0a744c3a476a36ca4b6e892/5f4f9570-49bc-4012-9d54-4765603a1f5b.zip) 改进。原学校官方模板存在大量死代码、命名不明、组织混乱等问题，在此重构了整个 LaTeX 项目，将全部格式规则、页面样式与自定义宏统一封装样式包，显著提升可维护性与可读性。

> 目前仅适用于专业学位；学术学位模板仍在开发中。

## 环境要求

- [TeX Live](https://www.tug.org/texlive/)（或其它支持 XeLaTeX 的发行版）
- 中文字体：Windows 自带 SimSun / SimHei / KaiTi / FangSong / LiSu。在非 Windows 系统上，需自行安装对应字体，或在 `nwnuthesis.sty` 中调整 `\setCJKfamilyfont` 的字体映射
- 推荐 [tex-fmt](https://github.com/wgunderwood/tex-fmt) ，一款格式化 CLI 工具，可以对 LaTeX 项目进行格式化

## 目录结构

```
.
├── main.tex            # 主文档：组织结构、正文与参考文献引入
├── nwnuthesis.sty      # 统一样式包：格式规则、页面样式、封面/声明/授权排版
├── preface/            # 导言部分
│   ├── cover.tex           # 封面信息配置（标题、作者、导师、专业、日期等）
│   ├── abstract.tex        # 中文摘要与关键词
│   └── abstract-eng.tex    # 英文摘要与关键词
├── body/               # 正文各章（chapter01 ~ chapter06）
├── appendix/           # 附录、致谢、攻读学位期间成果
├── figures/            # 插图资源
├── assets/             # 论文字体、LOGO 等设计资源
├── references.bib      # 参考文献数据库
├── NWNUThesis.bst      # 参考文献样式（BibTeX）
├── build/              # 构建编译过程中间文件
├── Makefile            # Linux / macOS 编译脚本
└── build.ps1           # Windows 编译 / 清理脚本（build / clean / cleanall）
```

## 快速开始

1. 编辑 `preface/cover.tex`，填写封面信息：论文标题（中英文）、作者、导师、专业学位类别/领域、日期等。
2. 分别在 `preface/abstract.tex` 与 `preface/abstract-eng.tex` 中撰写中英文摘要及关键词。
3. 在 `body/chapter01.tex` ~ `body/chapter06.tex` 中按章撰写正文；如需增删章节，请同步修改 `main.tex` 中的 `\include` 列表。
4. 将参考文献条目加入 `references.bib`，在正文中通过 `\cite{}` 引用（行内编号）。

### 编译

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

## 免责声明

本模板非学校官方模板，仅供参考、学习使用，使用者对其使用行为负责。

## 感谢

感谢 DeepSeek 和 Claude Code。没有这俩工具，我永远无法驾驭这种 LaTeX 工程。 

## 开源许可

本项目使用 CC 4.0 协议开源。不包括在 `./assets` 目录下的字体、LOGO 等设计资源，其使用协议另有规定。
