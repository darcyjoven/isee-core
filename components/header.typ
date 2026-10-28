#import "/config.typ": company
/// 公司抬头
///
/// - logo (str): 图片的路径
/// - name (): 标题
/// - width (): 图片宽度
/// - height (): 图片高度
/// - size (): 字体大小
/// - font (): 标题字体
/// ->
#let company-header(
  logo: company.logo,
  name: company.name,
  width: 1.5cm,
  height: 1.5cm,
  size: 22pt,
  font: "Source Han Serif SC",
) = {
  grid(
    columns: (width, 1fr, height),
    align: horizon,
    // 左
    align(center + horizon)[
      #image(logo, width: 1.5cm)
    ],

    // 中
    align(center)[
      #text(font: font, size: 18pt, weight: "medium")[#name]
    ],
    // 右
    [],
  )
}

// ========== Test ==========
// 示例
#company-header()
