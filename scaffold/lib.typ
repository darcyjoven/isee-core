/// 根 lib：转发 core 的全部导出，并在这里追加项目自定义内容。
/// core 是 submodule，升级时直接更新 submodule 即可，不会覆盖本目录文件。

// ===== core =====
#import "/core/lib.typ": *

// ===== 自定义样式 =====
// #import "/styles/xxx.typ": ...

// ===== 自定义组件 =====
// #import "/components/xxx.typ": ...

// ===== 常用初始化 =====
/// 代码 / 说明文档
#let code-init(body) = {
  set page(paper: "a4", height: auto)
  show: ctypset
  set text(font: code) // 覆盖正文拉丁文字为等宽字体
  show: fakebold // 伪粗体
  set-num(math: false)
  body
}

/// 报表
#let report-init(body) = {
  set page(paper: "a4")
  show: ctypset
  set text(font: financial)
  set-round(
    pad: true,
    direction: "nearest",
    ties: "away-from-zero",
    mode: "places",
  )
  set-group(
    separator: ",",
    size: 3,
    threshold: 4,
  )
  set-num(math: false)
  show: fakebold

  body
}
