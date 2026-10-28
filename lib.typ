/// 本文件是 core 目录所有导出变量、函数等内容的合集
/// 所有方便使用的函数都在此导出，在使用时，直接从lib导入即可


// styles
#import "styles/fonts.typ": hei, kai, maple, mono, sans, serif, song
#import "styles/fonts.typ": fakebold
#import "styles/fonts.typ": bussiness, code, financial, formal
#import "styles/fonts.typ": ctypset, font
#import "styles/number.typ": format-table, num, set-group, set-num, set-round
#import "styles/number.typ": zhamt, zhnumber-lower, zhnumber-upper
#import "styles/number.typ": decimal, negative, no-zero, pad-left, trim-left
// #import "styles/pages.typ"

// components
#import "components/header.typ": company-header
#import "components/page_count.typ": page-count
#import "components/row-count.typ": row-count
#import "components/truncate.typ": truncate
#import "components/wrap.typ": wrap


// ========== Test ==========
// 示例

#show: ctypset
#show figure.caption: text.with(font: kai, style: "italic", size: 8pt)

#set page(paper: "a4")

#outline()

= 样式
== 字体样式
=== 基础字体类型
#figure(
  ```typst
  #let (serif, sans, kai, mono, song, hei, maple) = (
    "Libertinus Serif",   // 拉丁宋体
    "DejaVu Sans",        // 拉丁黑体
    "KaiTi",              // 楷体
    "Fira Code",          // 拉丁等宽
    "Source Han Serif SC",// 中文宋体
    "Source Han Sans SC", // 中文黑体
    "Maple Mono NF",      // 中文等宽
  )
  ```,
  caption: "基础字体",
  supplement: "代码",
  kind: "code",
)
基础字体类型，可以像字符串一样，直接引入使用。
例如下年这两种写法是等价的，只是简化了长度。
#figure(
  ```typst
  #text(font:song)[宋体]
  #text(font:"Source Han Serif SC")[宋体]
  ```,
  caption: "基础字体使用示例",
  supplement: "示例代码",
  kind: "code",
)
=== cjk、latin混合类型

#figure(
  ```typst
  // 财务报表、正式报表、经营日报、日志代码
  #let (financial, formal, bussiness, code) = (
    diy(cjk: song, latin: sans),
    diy(cjk: song, latin: serif),
    diy(cjk: hei, latin: sans),
    diy(cjk: maple, latin: mono),
  )
  ```,
  caption: "混合排版",
  supplement: "示例代码",
  kind: "code",
)
中日韩与拉丁混合排版，拉丁文字会优先指定的拉丁字体，中日韩文字会优先设置的中日韩字体。

`diy`是`((name: latin, covers: "latin-in-cjk"), cjk)`的简化函数。

和基础字体一样，使用时直接指定即可。
#figure(
  ```typst
  #text(font:financial)[财务报表]
  ```,
  caption: "混合排版使用示例",
  supplement: "示例代码",
  kind: "code",
)

=== ctyp 全局排版

#figure(
  ```typst
  #import "@preview/ctyp:0.3.1": ctyp
  #let (ctypset, font) = ctyp(
    fontset-cjk: (
      family: (
        //...
      ),
      map: (
        //...
      ),
    ),
    font-latin: (
      .//...
    ),
  )
  ```,
  caption: "ctyp中文排版",
  supplement: "示例代码",
  kind: "code",
)
全局排版使用了ctyp，这个第三方库，中日韩和拉丁文字分开设置字体，并直接设置了`text` 、`strong`、`emph`、`heading`、`raw`、`title`，这些常用的排版的字体样式。除了字体还可以指定字体的粗细和风格。

使用的时候，只要在需要的作用域直接设置`#show: ctypset`即可。

`font` 可以导出,`ctypset`设置的字体，但不需要，直接用上面基础字体即可。

== 页面设置
……


= 控件
=== `company-header` 公司抬头
#figure(
  company-header(),
  caption: "公司抬头",
  supplement: [示例样式],
  kind: "example",
)<公司抬头>
@公司抬头，是一个简单的一个`logo`和一个公司名称组成的控件。
除了设置默认值，还可以指定参数，来实现 其它效果。
#figure(
  ```typst
  #let company-header(
    logo: company.logo, // logo 路径
    name: company.name, // 要显示的文字
    width: 1.5cm,       // logo的宽度
    height: 1.5cm,      // logo的高度
    size: 22pt,         // 字体的大小
    font: "Source Han Serif SC",  // 字体类型
  )
  ```,
  caption: "公司抬头",
  supplement: "示例代码",
  kind: "code",
)
// #pagebreak()
=== `page-count` 页次
#figure(
  page-count(fill: (x, y) => [ 第 #x 页 / 共 #y 页]),
  caption: "页次样式",
  supplement: "示例样式",
  kind: "example",
)<page-count>

页次可以统计所有页次和当前页次，@page-count 中，传入了一个回调函数，该函数有两个参数`x,y`分别是当前页次，和总页次，返回一个排版块。

#pagebreak()

=== `row-count` 计数控件
#figure(
  table(
    columns: (1fr, 1fr),
    ..for i in range(7) {
      ([#{ i + 1 }#metadata((id: "detail", row: i + 1))], [])
    },
    table.footer(
      [#row-count(id: "detail", index: "row", fill: i => [当前项次：#i])], [#row-count(id: "detail", index: "row")],
      repeat: true,
    ),
  ),
  caption: "计数控件",
  supplement: "示例样式",
  kind: "example",
)<row-count-example>

@row-count-example 计数控件，用在想要统计某些内容出现的次数的地方，在需要统计的地方加入标记`#metadata`，然后在需要显示的地方使用`row-count`即可。

#figure(
  ```typst
  #table(
    columns: (1fr, 1fr),
    ..for i in range(7) {
      ([#{ i + 1 }#metadata((id: "detail", row: i + 1))], [])
    },
    table.footer(
      [#row-count(id: "detail", index: "row", fill: i => [当前项次：#i])], [#row-count(id: "detail", index: "row")],
      repeat: true,
    ),
  )
  ```,
  caption: "计数控件",
  supplement: "示例代码",
  kind: "code",
)

=== `truncate` 截取控件是的

#figure(
  grid(
    columns: (4cm, 4cm),
    stroke: 0.5pt + black,
    inset: 0.2em,
    [无样式文本], [truncate截取],
    [窗前明月光，疑是地上霜。], [#truncate("举头望明月，低头思故乡。", suffix: "……")],
  ),
  caption: "截取函数",
  supplement: "示例样式",
  kind: "example",
)

`truncate`可以根据父节点尺寸，自动截取文本宽度。

除了必须传入的`string`参数，还有以下几个参数：
- `func`  样式函数，默认为`text`
- `width` 宽度，可以固定宽，就不从父节点去了
- `prefix` 前缀，为字符串增加前缀
- `suffix`  后缀，为字符串增加后缀，例如：举头望明月，低……

#figure(
  ```typst
  #truncate("举头望明月，低头思故乡。", suffix: "……")
  ```,
  caption: "截取函数",
  supplement: "示例代码",
  kind: "code",
)

#pagebreak()

=== `wrap`任意换行

#figure(
  grid(
    columns: (4cm, 4cm),
    stroke: 0.5pt + black,
    inset: 0.2em,
    [无样式文本], [wrap截取],
    lorem(6), wrap(lorem(6)),
  ),
  caption: "换行",
  supplement: "示例样式",
  kind: "example",
)

中文排版中，换行是任意字符都可以换行的。但是对于纯拉丁文字的时候，遇到空格等分隔符才会换行。
对于凭证打印中，一些长的规格或者品名等需要换行的时候，会导致溢出当前cell。
可以使用`wrap`函数在使拉丁文字也可以在每个字符都允许换行。
该函数的原理就是在每个字符中间看增加看不见的空白符。


#figure(
  ```typst
  #wrap(lorem(6))
  ```,
  caption: "换行",
  supplement: "示例代码",
  kind: "code",
)
