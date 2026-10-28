
/// 定义一个获取页码的函数
/// 参数:
///   - fill: 自定义显示样式的函数，接收 (当前页码, 总页码)
///   - align: 默认显示时的对齐方式
#let page-count(
  fill: none,
) = context {
  // 1. 获取当前页码 (字符串类型，如 "1")
  let current = counter(page).display()

  // 2. 获取总页数 (整数类型，如 20)
  // .at(0) 取出计数器的值
  // str(...) 将其转为字符串，方便你在自定义函数中直接拼接
  let total = str(counter(page).final().at(0))

  // 3. 判断是否传入了自定义函数
  // 【修复点】使用 if fill != none 来判断
  if fill != none {
    // 将当前页(字符串)和总页数(字符串)传给用户自定义的函数
    fill(current, total)
  } else {
    // 如果没传函数，则使用默认格式：居中显示 "当前页 / 总页数"
    align(center)[#current / #total]
  }
}

// ========== Test ==========
// 示例
#set page(width: 3cm, height: 1cm)
#page-count(fill: (x, y) => text()[ 第 #x 页 共 #y 页])
#pagebreak()
#page-count(fill: (x, y) => text()[ 第 #x 页 共 #y 页])
