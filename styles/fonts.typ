/// typst 的字体样式存在两种风格
/// 1. 全局风格：
///   #set 设置字体样式之后，作用域内排版都使用该字体
/// 2. 块指定风：
///   text(font:"KaiTi")[...]
/// 这两种风格各有优势，本文件只是定义一些常用字体的简便调用方式，不改变任何typst行为
/// ！！！ 指定的字体，如果在环境中没有找到，typst 会将字体回退 ！！！
/// 你可以指定多种字体，自己设置回退，例如：text(font:("KaiTi","SimSun"))[...]

/// typst 允许拉丁文字和CJK中日韩区分开
/// 本项目中定义了几种常用的字体样式，中日韩和拉丁文字是不同的，如果你们有安装或者部署字体，
/// 需要先部署才能使用，否则请自定义字体使用
/// 以上字体如果找不到来源，请到项目 https://github.com/darcyjoven/isee-attachment 中下载
///
/// 常用字体定义
///   衬线    cjk: "Source Han Serif SC", latin: "Libertinus Serif",
///   非衬线  cjk: "Source Han Sans SC",  latin: "DejaVu Sans",
///   楷体    cjk: "KaiTi", latin:        latin: "Libertinus Serif",
///   等宽    cjk: "Maple Mono NF",       latin: "Fira Code",

// 字体定义
#let (serif, sans, kai, mono, song, hei, maple) = (
  "Libertinus Serif",
  "DejaVu Sans",
  "KaiTi",
  "Fira Code",
  "Source Han Serif SC",
  "Source Han Sans SC",
  "Maple Mono NF",
)

/// 该函数为了快捷设置字体排版，默认中文字体为 Source Han Serif SC ，拉丁字体为 Libertinus Serif
#let diy(
  cjk: auto,
  latin: auto,
) = {
  if cjk == auto {
    cjk = "DejaVu Sans Mono"
  }
  if latin == auto {
    latin = "Source Han Serif SC"
  }
  ((name: latin, covers: "latin-in-cjk"), cjk)
}

// 财务报表、正式报表、经营日报、日志代码
#let (financial, formal, bussiness, code) = (
  diy(cjk: song, latin: sans),
  diy(cjk: song, latin: serif),
  diy(cjk: hei, latin: sans),
  diy(cjk: maple, latin: mono),
)


// 伪粗体，使没有粗体字体文件的字体支持粗体，例如：楷体
#import "@preview/cuti:0.3.0": show-cn-fakebold
#let fakebold = show-cn-fakebold

/// 全局设置风格
/// 使用 #import "@preview/ctyp:0.3.1": ctyp 来进行全局风格字体的设置
/// 允许使用不同的样式，设置不同的字体，text 、strong、emph、heading、raw、title

#import "@preview/ctyp:0.3.1": ctyp
#let (ctypset, font) = ctyp(
  fontset-cjk: (
    family: (
      song: (
        name: song,
        variants: "bold",
      ),
      hei: (
        name: hei,
        variants: "bold",
      ),
      kai: (name: "KaiTi"),
      maple: (
        name: maple,
        variants: ("bold", "italic"),
      ),
    ),
    map: (
      text: (cjk: "song", latin: "sans"),
      strong: (cjk: "hei:bold", latin: "sans"),
      emph: (cjk: "kai", latin: "serif:italic"),
      heading: (cjk: "hei:bold", latin: "sans"),
      raw: (cjk: "maple", latin: "mono"),
      title: (cjk: "song:bold", latin: "serif"),
    ),
  ),
  font-latin: (
    serif: "Libertinus Serif",
    mono: "Fira Code",
    sans: "DejaVu Sans",
  ),
)


// ========== Test ==========
// 示例
#set page(width: 20em, height: auto, margin: 0.5em)

#text(font: serif)[Libertinus Serif abcg:12.30]

#text(font: sans)[DejaVu Sans abcg:12.30]

#text(font: kai)[楷体 abcg:12.30]

#text(font: mono)[Fira Code abcg:12.30]

#text(font: song)[宋体 abcg:12.30]

#text(font: hei)[黑体 abcg:12.30]

#text(font: maple)[等宽 abcg:12.30]

#divider()
// 粗体

#text(font: serif)[*Libertinus Serif abcg:12.30*]

#text(font: sans)[*DejaVu Sans abcg:12.30*]

#text(font: kai)[*楷体 abcg:12.30*]

#show: fakebold // 伪装粗体

#text(font: kai)[*楷体（伪粗体） abcg:12.30*]


#text(font: mono)[*Fira Code abcg:12.30*]

#text(font: song)[*宋体 abcg:12.30*]

#text(font: hei)[*黑体 abcg:12.30*]

#text(font: maple)[*等宽 abcg:12.30*]

#divider()

// 全局文字设置
#show: ctypset

正常文本应该给是宋体，abc123.0

*粗体是黑体，abc123.0*

_斜体是楷体，abc123.0_


`下面是代码块`
```go
// 函数main
func main(){}
```
= 标题是加粗黑体，abc123.0
== 二级标题
=== 三级标题

你好，这是什么东西？你好，这是什么东西？你好，这是什么东西？你好，这是什么东西？
