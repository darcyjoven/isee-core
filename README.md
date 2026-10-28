# isee-core

ISEE 的核心库。作为 [isee](https://github.com/darcyjoven/isee) 项目的 `core` submodule 使用，也可以被其它 Typst 项目直接引用。

## 内容

```
isee-core
├─ lib.typ                 # 所有导出函数的汇总入口
├─ styles/                 # fonts.typ 字体、number.typ 数字/金额、pages.typ 页面
├─ components/             # header / page_count / row-count / truncate / wrap / charts
├─ assets/                 # 内置图片
├─ config.typ              # 单独预览本仓库时的占位配置（项目中使用根目录的 config.typ）
├─ scaffold/               # 复制到 isee 根目录的骨架（脱敏版本）
├─ docs/                   # 完整文档（README.typ / INSTALL.md）
└─ .gitignore              # 忽略 fonts/ 与 PDF 产物
```

## 作为 submodule 使用

```bash
git submodule add git@github.com:darcyjoven/isee-core.git core
git submodule update --remote core   # 升级
```

`scaffold/` 下的文件由 isee 根目录的 `init.sh` / `init.ps1` 复制出去：

- 目标文件已存在时跳过，不覆盖使用者自己的 `config.typ`、`.vscode` 等修改。
- 修改骨架内容请在本仓库的 `scaffold/` 中进行，然后提交并升级 submodule。

## 字体

字体文件不进版本库，`core/fonts` 需要手动放置：

- 下载 <https://github.com/darcyjoven/isee-attachment/releases/latest/download/fonts.zip>
- 解压到 `core/fonts`

`styles/fonts.typ` 使用 Source Han Serif/Sans SC、KaiTi、Fira Code、Libertinus Serif 等字体，缺少字体时 Typst 会静默回退。

## 文档

- `docs/README.typ`：项目介绍、目录约定、生产环境部署
- `docs/INSTALL.md`：本地与服务器安装步骤

## 注意

本仓库只放通用的核心逻辑与脱敏后的骨架，**不要**提交公司名称、内网地址、真实报表数据、字体和 PDF 产物。
