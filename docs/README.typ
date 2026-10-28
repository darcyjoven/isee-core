#set text(font: ((name: "Arial", covers: "latin-in-cjk"), "Source Han Sans SC"), size: 10pt)
#show raw: set text(font: ((name: "Fira Code", covers: "latin-in-cjk"), "Maple Mono NF"), size: 10pt, fill: blue)
#set page(paper: "a4", numbering: "1 / 1")

#outline()

#pagebreak()

#let short-link(url) = link(url)[#raw(url)]

= ISEE

== 项目由来

在可视化报表中，有`水晶报表`、`帆软`等商业方案。也有很多前端的库。
但是它们要么就是非常的重量，要么就是单一库无法完成：设计、数据交互、结果。

作者目前的系统用的是`水晶报表`，而且是非常老的版本，虽然几乎能覆盖所有报表样式，但是在使用起来非常繁琐。
下面这几种功能都是缺少的：
1. 版本管控
2. 浏览器兼容
3. 样式稳定性
4. 背景执行

在寻找可替代方案的时候，我考虑过很多项目：
1. #link("https://pdfme.com/")[`pdfme`] 开源的带有设计器UI的前端产生pdf的项目
  - 设计器很卡
  - 表格支持很弱
  - 自由度低
2. #link("https://github.com/johnfercher/maroto")[`maroto`] `Go`写的自适应产生PDF
  - 数据与样式不能分离
  - 表格跨页功能支持都很弱
  - 自由度低
3. #link("https://github.com/phpdave11/gofpdf")[gofpdf] `Go`写的PDF底层产生
  - 控件少
  - 需要自定义大量的模板代码
  - 社区活跃度低
`gofpdf`是唯一能够实现所有需求的，但是因为社区热度很低的原因，我没有选择。

后面再查询`rust`的PDF库的时候，我发现了#link("https://github.com/typst/typst")[`typst`],其社区热度很高。
其目标是取代#link("https://www.taxdev.org/")[`LaTeX`]排版系统。
在速度、效能方便已经超过`LaTeX`很多了，目前已经有不少期刊接受`typst`排版的论文。
其`github`仓库start已经接近60k了。

所以`typst` 是一个功能完、社区完善，有发展计划的项目，所以我选择了`typst`作为报表基石。

我目前使用`typst`来替代水晶报表的大部分功能，弥补企业系统打印以下短板：
1. 版本管控，`typst`可以直接使用`git`直接管理模板代码;
2. AI开发，`typst`模板开发更偏向于`代码`,不是传统的模板开发更偏向于`word`;
3. 数据流转，使用`json文件`可以流转于不同系统。

目前还未验证，可以替代`水晶报表`所有功能，我正在逐步替代。

== 简单介绍

#link("https://github.com/darcyjoven/isee")[`ISEE`]是一个基于 #link("https://github.com/typst/typst")[`typst`]开发的生成PDF的项目。
主要用于需要精细、稳定样式的场景。模板使用`typst`文件，数据文件使用`json文件`传递。

Typst 是一款全新的基于标记语言的排版系统，旨在拥有与 LaTeX 一样强大的功能，同时又更易于学习和使用。Typst 具有以下特点：

- 内置标记，用于执行最常见的格式化任务
- 其他所有方面都具有灵活的功能
- 一个紧密集成的脚本系统
- 数学排版、参考文献管理等等
- 由于采用了增量编译，编译速度很快。
- 如果出现问题，会显示友好的错误信息。

== 兼容性说明

因为作者本地使用`windows`开发，生产环境是`TIPTOP GP`的`RedHat 6.5`服务器上。所以安装部署是按照此环境写的。
但用到的所有工具都是兼容三端平台的(`windows`、`linux`、`macos`)，所以不用担心无法使用。

== 项目欣赏

在使用本项目前可以先看一下，本项目产出的报表PDF样式，如果这些文件中有你需要达到的效果。那么本项目应该对你有很大帮助。

TODO

== 相关文档

- typst 教程  #link("https://typst.app/docs/tutorial/")[`https://typst.app/docs/tutorial`]
- typst 第三方库 #link("https://typst.app/universe/")[`https://typst.app/universe`]

== 关联项目

- isee-cli 一个用于`ISEE`的一个cli命令程序，包含同步、环境检查、部署等功能

  #link("https://github.com/darcyjoven/isee-cli/")[`https://github.com/darcyjoven/isee-cli`]

#pagebreak()

= 下载
== 项目文件下载
如果你安装了`git`，且后续使用`git`做版本管控，可以使用`git`下载项目文件。
如果不使用`git`的话，可以直接下载整合的`zip`打包文件。

- `zip`打包文件下载地址

  #link(
    "https://github.com/darcyjoven/isee/releases/latest/download/project.zip",
  )[`https://github.com/darcyjoven/isee/releases/latest/download/project.zip`]

- 使用`git`下载，要分为三步，因为`core`是 submodule，且字体文件不在`git`项目中
  - 下载代码文件与`core`
  `git clone --recurse-submodules https://github.com/darcyjoven/isee.git`
  - 初始化根目录（已存在的文件会跳过，不会覆盖你的修改）
  `./init.sh`
  - 下载字体文件并解压到项目的`core/fonts`目录下
  #link(
    "https://github.com/darcyjoven/isee-attachment/releases/latest/download/fonts.zip",
  )[`https://github.com/darcyjoven/isee-attachment/releases/latest/download/fonts.zip`]

此时你的项目结构是这样的
```
isee
├─.vscode       <由 init.sh 从 core/scaffold 生成>
├─core          <核心库 submodule，不要修改，升级用 submodule update>
│  ├─assets
│  ├─components
│  ├─fonts      <字体，从 fonts.zip 解压，不进版本库>
│  ├─scaffold   <根目录骨架，init.sh 从这里复制>
│  └─styles
│
├─assets        <自定义文件>
│  └─image
├─components    <自定义组件>
├─fonts         <自定义字体，自己创建>
├─styles        <自定义样式文件>
├─tests         <测试文件>
│
├─projects      <项目根目录>
│  └─...
```
== VS Code

本地开发时，我们使用`VS Code`作为编辑器，请自行按照并下载 。

#link("https://code.visualstudio.com/")[`https://code.visualstudio.com`]。

== Tinymist 插件

`VS Code`中有一个强大的`typst`的插件，集`语言服务器`、`预览`、`报错`所有开发时需要的功能。

`Tinymist`，在插件商店中搜索关键字`tinymist`或者`typst`下载并启用该插件。

#image("images/tinymist.png", width: 8cm)


#image("images/highlight.png", width: 10cm)

启用插件之后，所有后缀为`.typ`的文件，都会解析为`typst`文件。
- 该插件会有高亮、和语法提示功能；
- 第三方包会自动下载；
- 导入包分析；

在打开`typst`文件时，右上角会增加导出PDF、预览两个按钮。
预览可以像`markdown`一样，左右打开并实时预览结果内容。
#image("images/button.png")

*现在打开`tests`目录下任意一个`typst`文件，使用预览或者导出PDF按钮，来验证环境正确。*

== typst

到目前位置，我们还没有下载过`typst`程序，`Tinymist`插件自己管理一个`typst`分支，该分支更方便发开环境使用。

后续我们部署在生产环境的时候，就要用到`typst`的程序了。

官方下载页面#link("https://github.com/typst/typst/releases")[`https://github.com/typst/typst/releases`]

如果你和我一样时部署在`RedHat`系列主机的话，直接下面下面的文件即可。

#link(
  "https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz",
)[`https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz`]

该压缩文件中，我们只需要一个名为`typst`（windows版本是`typst.exe`）的二进制执行文件。
后面部署到生产环境的时候，我们会详细介绍。


#pagebreak()
= 本地使用
== VSCode配置
如果你用`VS Code`打开的本项目，能够看到项目配置中，有以下这个配置。
```json
"tinymist.fontPaths": [
    "./core/fonts",
    "./fonts"
]
```
这个配置制定了两个`fonts`文件，`./core/fonts`是本项目核心字体文件，不建议异动。

`./fonts`目录应该是空的，或者不存在，用来保存开发过程中的字体文件。
如果你需要项目外额外的字体文件，可以放在这里。

`Tinymist`会自动将目录中的文件纳入编译环境。

== 预览 & 验证

`core` 目录下，每个`typst`文件除了定义了组件、函数等，还在最下面实现了简单的预览页面。
只要打开预览页面，既可以预览这些组件、函数的样式和用法。

例如：`core/styles/fonts.typ`文件中实现了，不同字体的显示。
点击预览查看吧。

== 自定义目录

在项目结构中，可以看到很多目录在根目录和`core`目录下面，都是重复的。
例如：`assets`、`components`、`fonts`和`styles`，还有文件`lib.typ`也有两个。

上面提供`fonts`目录是用来放自定义字体的，同样其它文件可以在开发过程中防止自定义静态文件、组件、样式文件。

`lib.typ`文件只是把所有的组件、函数、变量归集到一个文件中，方便调用。

`core`目录是独立的`git`仓库（submodule），不要在其中修改文件。升级时更新 submodule 即可，不会影响根目录下你自己的文件。请只在根目录下其它目录下开发。

#pagebreak()
= 生产环境

将`isee`项目中所有文件上传到生产环境。

== 第三方包
在生产环境中，可能会连接不了外网，第三包无法自动下载。
这个时候需要手动将开发环境包复制到生产环境。

默认目录如下：
- windows `%LOCALAPPDATA%\typst\packages\preview`
- linux/mac `~/.cache/typst/packages/preview`

== 编译文件

之前我们下载的`typst/typst.exe`二进制文件，放到生产环境中。

如果是`linux/mac`，要使用`chomod +x typst`赋予运行的权限。

这个时候所有文件都已经准备好了，使用以下命令即可在生产环境产生PDF文件。

```shell
typst compile \
# isee项目的根目录
--root  root
# 字体文件目录，允许多个
--font-path  root/core/fonts
--font-path  root/fonts
# 模板文件，相对路径绝对路径都可以，但必须在项目目录下
.../project/aapr001/main.typ \
# 输出文件路径，允许任意位置，不指定则在模板目录下生成，自动覆盖
.../out/aapr001.pdf \
# 模板中如果需要外部穿参数可以使用input指定
--input data=".../data.json"
```

其它编译命令请使用`typst --help`查看

#pagebreak()
= isee-cli 工具介绍

`isee-cli`是一个实用工具，用户处理`isee`一些繁琐的内容。
部分功能还未开发完成，后续也有可能增加功能。没有此工具也可以实用`isee-cli`所有功能，本工具只是把常用功能集成一起了。

项目地址： #link("https://github.com/darcyjoven/isee-cli")[`https://github.com/darcyjoven/isee-cli`]

目前功能如下：
- `sync`  同步项目文件到生产短
- `generate`  产生模板代码

具体说明见 `isee-cli`的项目文档。

#pagebreak()
= ISEE & typst 逻辑说明


#pagebreak()

= 附录

#figure(
  table(
    columns: 2,
    align: left + horizon,
    table.header([说明], [链接]),
    `ISEE 项目 git 仓库`, short-link("https://github.com/darcyjoven/isee"),
    `ISEE 项目打包文件`, short-link("https://github.com/darcyjoven/isee/releases/latest/download/project.zip"),
    `core 字体单独文件`, short-link("https://github.com/darcyjoven/isee-attachment/releases/latest/download/fonts.zip"),
    `isee-cli git 仓库`, short-link("https://github.com/darcyjoven/isee-cli"),
    `VS Code 官网`, short-link("https://code.visualstudio.com"),
    `typst git 仓库`, short-link("https://github.com/typst/typst"),
    `typst 官方手册`, short-link("https://typst.app/docs/tutorial"),
    `typst 第三方库`, short-link("https://typst.app/universe"),
  ),
  caption: "超链接清单",
  supplement: "清单",
  kind: "清单",
)
