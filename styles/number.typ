#import "/core/styles/fonts.typ": ctypset, financial
#import "@preview/zero:0.7.0": format-table, num, set-group, set-num, set-round
#import "@preview/zh-kit:0.1.0": zhnumber-lower, zhnumber-upper

#set page(paper: "a4")

// 数字排版
#let decimal(
  number,
  digits: none,
  group: none,
  trim: none, // 去掉小数末尾0
  direction: none, // none|"towards-infinity"|"towards-negative-infinity"|"nearest"
) = {
  // 精度位数
  if digits == none {
    digits = auto
  }
  // 分隔符
  let group-size = 3
  let group-sep = ","
  if type(group) == str {
    group-sep = group
  } else if type(group) == int {
    group-size = group
  }
  // 舍去尾部的零值
  if trim == none {
    trim = false
  }
  // 舍入规则
  let ties = "nearest"
  if direction == none {
    direction = "nearest"
  } else if direction == "up" {
    direction = "towards-infinity"
    ties = "towards-infinity"
  } else if direction == "down" {
    direction = "towards-negative-infinity"
    ties = "towards-negative-infinity"
  } else {
    direction = "nearest"
  }
  num(
    number,
    math: false,
    group: (separator: group-sep, size: group-size),
    round: (precision: digits, direction: direction, ties: ties, pad: not trim),
  )
}

// 零值显示为char
#let no-zero(number, digits: none, char: "") = {
  if digits == none {
    digits = 0
  }
  let result = calc.round(number, digits: digits)
  if result == 0 {
    char
  } else {
    result
  }
}

// 去掉整数部分的0
#let trim-left(number, digits: none) = {
  if digits == none {
    digits = 0
  }
  let result = calc.round(number, digits)
  if result > -1 and result < 1 and result != 0 {
    if result > 0 {
      result.slice(1)
    } else {
      "-" + result.slice(2)
    }
  } else {
    result
  }
}
// 左边整数部分补0，保证整数位数等于size
#let pad-left(number, size) = {
  if size == none {
    return str(number)
  }

  let value = str(number)
  let negative = value.starts-with("-")

  // 去掉负号
  let body = if negative {
    value.slice(1)
  } else {
    value
  }

  // 分离整数部分和小数部分
  let parts = body.split(".")
  let integer = parts.at(0)
  let fraction = if parts.len() > 1 {
    "." + parts.at(1)
  } else {
    ""
  }

  // 整数部分补 0
  let padded = if integer.len() < size {
    "0" * (size - integer.len()) + integer
  } else {
    integer
  }

  if negative {
    "-" + padded + fraction
  } else {
    padded + fraction
  }
}

// 括号显示负数
#let negative(number) = {
  if number < 0 {
    [(#calc.abs(number))]
  } else {
    [#number]
  }
}

// 金额转中文大写
#let zhamt(number) = {
  // 元部分
  let yuan = zhnumber-upper(calc.round(number, digits: 0))
  yuan = yuan + "元"
  // 角分部分
  let (jiao, fen) = (
    calc.rem(calc.floor(number * 10), 10),
    calc.rem(calc.floor(number * 100), 10),
  )
  if jiao != 0 {
    yuan = yuan + zhnumber-upper(jiao) + "角"
  }
  if fen != 0 {
    yuan = yuan + zhnumber-upper(fen) + "分"
  }
  if jiao == 0 and fen == 0 {
    yuan = yuan + "整"
  }
  yuan
}


// ========== Test ==========
#show: ctypset
#set text(font: financial)
#outline()

数字样式使用`zero:0.7.0` 包，实现大部分数字样式，其中根据风格，和字体样式一样，分为全局生效，和局部使用两种。
本文件中定义了一些常用的风格，你也可以直接使用`zero:0.7.0`包的默认功能。

根据类型，可以分为：外观显示、精度处理和特殊情况三种。
它们并不都提供全局设置，有的只能局部使用。

说明：
1. `num`函数，会默认修改字体，参数`math:false`会取消字体设置，没有特别说明，所有函数都传递该参数，自己控制字体。


= 场景示例


- 四舍五入 12.45 ->
  #num(12.45, math: false, group: (separator: ","), round: (precision: 2))
  \= #decimal(12.45, digits: 2)
  ```typst
  #num(12.45, math: false, group: (separator: ","), round: (precision: 2))
  // 简写
  #decimal(12.45, digits: 2)
  ```

- 向上舍入12.43 ->
  #num(
    12.43,
    math: false,
    group: (separator: ","),
    round: (direction: "towards-infinity", ties: "towards-infinity", precision: 1),
  )
  \= #decimal(12.43, digits: 1, direction: "up")
  ```typst
  #num(
    12.43,
    math: false,
    group: (separator: ","),
    round: (direction: "towards-infinity", ties: "towards-infinity", precision: 1),
  )
  // 简写
  #decimal(12.43, digits: 1, direction: "up")
  ```

- 向下舍入12.8 ->
  #num(
    12.8,
    math: false,
    group: (separator: ","),
    round: (direction: "towards-negative-infinity", ties: "towards-negative-infinity", precision: 0),
  )
  \= #decimal(12.8, digits: 0, direction: "down")
  ```typst
  #num(
    12.8,
    math: false,
    group: (separator: ","),
    round: (direction: "towards-negative-infinity", ties: "towards-negative-infinity", precision: 0),
  )
  // 简写
  #decimal(12.8, digits: 0, direction: "down")
  ```

- 不补零 12.45 ->
  #num(12.45, math: false, group: (separator: ","), round: (precision: 4, pad: false))
  \= #decimal(12.45, digits: 4, trim: true)
  ```typst
  #num(12.45, math: false, group: (separator: ","), round: (precision: 4, pad: false))
  // 简写
  #decimal(12.45, digits: 4, trim: true)
  ```

- 分隔符符号 21677.23478 ->
  #num(21677.23478, math: false, group: (separator: " "))
  \= #decimal(21677.23478, group: " ")
  ```typst
  #num(21677.23478, math: false, group: (separator: " "))
  // 简写
  #decimal(21677.23478, group: " ")
  ```

- 分隔符位数 21677.23478 ->
  #num(21677.23478, math: false, group: (size: 4))
  \= #decimal(21677.23478, group: 4)
  ```typst
  #num(21677.23478, math: false, group: (size: 4))
  // 简写
  #decimal(21677.23478, group: 4)
  ```

- 不要分隔符  21677.23478 ->
  #num(21677.23478, math: false, round: (precision: 2, pad: false), group: (separator: ""))
  \= #decimal(21677.23478, digits: 2, group: "")
  ```typst
  #num(21677.23478, math: false, round: (precision: 2, pad: false), group: (separator: ""))
  // 简写
  #decimal(21677.23478, digits: 2, group: "")
  ```

- 负数括号显示 -12.00 -> #negative(-12.00)
  ```typst
  #negative(-12.00)
  ```

- 左边补0 12.134 -> #pad-left(12.123, 5)
  ```typst
  #pad-left(12.123, 5)
  ```

- 省略整数部分零值 0.12 -> #no-zero(0.12, digits: 0)
  ```typst
  #no-zero(0.12, digits: 0)
  ```
- 数字转为中文大小写
  ```typst
  #zhnumber-upper(1278000)
  #zhnumber-lower(1200123)
  #zhamt(1200123)
  #zhamt(1200000.12)
  #zhamt(1200000.123)
  ```
`#zhnumber-upper(1278000)` -> #zhnumber-upper(1278000)

`#zhnumber-lower(1200123)` -> #zhnumber-lower(1200123)

`#zhamt(1200123)` -> #zhamt(1200123)

`#zhamt(1200000.12)` -> #zhamt(1200000.12)

`#zhamt(1200000.123)` -> #zhamt(1200000.123)

= 简化函数
== `decimal` 数字的排版
```typst
#let decimal(
  number,   // 数字
  digits: none,    // 小数位数，舍入和保留小数将一起发生
  group: none,     // 分隔符设置，设置为整数表示位数，设置为字符表示分隔符样式
  trim: none,      // 去掉小数末尾0
  direction: none, // 舍入的规则，默认四舍五入，"up"向上 "down"向下
)
```
== `no-zero` 零值不显示

== `trim-left` 整数部分为0不显示
```typst
#let trim-left(
  number,       // 数字
  digits: none, // 小数位数
  )
```
== `pad-left` 整数部分补足0
```typst
#let pad-left(
  number, // 数字
  size    // 补足的总位数
)
```
== `negative` 负数括号显示，用于国际报表
```typst
#let negative(number) // 只传入一个数字
```
== `zhnumber-upper`&`zhnumber-lower` 中文大小写转满
```typst
#let zhnumber-upper(number) // 只能传入正整数
#let zhnumber-lower(number) // 只能传入正整数
```

= `num` 核心函数
#figure(
  ```typst
  #num(
    number:                 str | content | int | float | dictionary | array,
    digits:                 auto | int = auto,
    exponent:               auto | str = auto,
    decimal-separator:      str = ".",
    product:                content = sym.times,
    tight:                  bool = false,
    breakable:              bool | dict = false,
    math:                   bool = true,
    omit-unity-mantissa:    bool = false,
    omit-zero-exponent:     bool = false,
    positive-sign:          bool = false,
    positive-sign-exponent: bool = false,
    trim-zeros:             bool = false,
    base:                   int | content = 10,
    uncertainty-mode:       str = "separate",
    round:                  dictionary,
    group:                  dictionary,
    alt:                    auto | dictionary | string | none = auto,
  )
  ```,
  caption: `num`,
  supplement: "代码",
  kind: "code",
)

== 常用的参数
- `number` 原始数字
- `digits` 小数位数
- `decimal-separator` 小数点字符，默认为`.`
- `breakable` 允许换行
- `positive-sign` 是否显示+符号
- `round` 舍入选项
- `group` 分组选项

== 不常用参数
- `trim-zeros` 是否省略尾部零
- `exponent` 控制指数的值
- `product` 科学计数法中的乘号
- `tight` 操作数之间是否精密
- `math` 是否使用数学公式和字体
- `omit-unity-mantissa` 科学计数法中位数为1时是否省略
- `omit-zero-exponent` 是否省略指数为0的幂
- `positive-sign-exponent` 是否显示正指数+符号
- `base` 科学计数法底数
- `uncertainty-mode` 不确定的显示方式
- `alt` 屏幕阅读器支持


= `group` 分组
```typst
#set-group(
  size:       int = 3,
  separator:  content = sym.space.narrow,
  threshold:  int | dictionary = 5
)
```
== 参数

- `size` 分组大小
- `separator` 分组符号
- `threshold` 开始启用的位数

= `round` 舍入
```typst
#set-round(
  follow-uncertainty:    bool = true,
  uncertainty-precision: auto | int | dictionary = auto,
  mode:                  str = "places",
  precision:             int | auto = auto,
  pad:                   bool = true,
  direction:             str = "nearest",
  ties:                  str = "away-from-zero"
)
```
== 常用参数
- `precision` 保留的位数
- `pad` 是否需要补0
- `direction` 舍入规则
  - `nearest` 更近的舍入
  - `towards-infinity`  向更大的入
  - `towards-negative-infinity` 向更小的舍
  - `towards-zero` 向0舍入
  - `away-from-zero` 远离0舍入
== 不常用参数
- `ties` 距离一样如何舍入
  - `away-from-zero` 远离0
  - `towards-zero` 向0
  - `towards-infinity` 、向大
  - `towards-negative-infinity` 向小
  - `to-even` 最近偶数
  - `to-odd` 最近奇数
- `mode` 保留方式
  - `places` 小数位数保留位数
  - `figures` 总数字个数
- `follow-uncertainty` 不确定度是否跟随主数一起舍入
- `uncertainty-precision` 不确定度位数

= `format-table` 表格格式化数字

#figure(
  ```typst
    #{
    show table: format-table((math: false, trim-zeros: true, round: (precision: 2, pad: false)), auto, auto)
    table(
      columns: 3,
      align: center,
      $n$, $α$, $β$,
      [1.1234], [3.41235], [-11.11231],
      [2.11231], [2], [2.09123],
    )
  }
  ```,
  kind: "code",
  caption: "表格对齐",
  supplement: "代码",
)<formats-table>

@formats-table 使用`show table: format-table(col1,col2,col3...)`可以让表格中的数字，根据小数点位置对其。
`col1,col2,col3...`是每列的属性，填入`num`作为参数。例如：`(math: false, trim-zeros: true, round: (precision: 2, pad: false)`。
还可以设置为`none`或者`auto`。

= 全局设置
将`num`、`group`、`round`的参数传入`set-num` `set-group` `set-round`，可以作用域全局设置数字样式。
设置了全局样式，也只有在使用`num`函数时候才会生效，其它的数字并不影响。
```typst
#set-group(size: 2, threshold: 3)
#set-num(digits:2,math:false)
#set-round(precision:2)

#num(12.15678)

12.15678
```

#set-group(size: 2, threshold: 3)
#set-num(digits: 2, math: false)
#set-round(precision: 2)

#num(12.15678)

12.15678
