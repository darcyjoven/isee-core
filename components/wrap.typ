/// 对于一些中文和英文之间没有空格的内容，例如：规格、品名等内容。typst不会自动截断或者换行，因为拉丁文字遇到空格才会换行
/// 这里wrap使用来拒绝这个问题，在每个字符之间增加有一个非常小的空隙 0.0001pt 在不影响排版的情况下，让英文和中文一样可以在
/// 任意位置换行


// 定义一个函数，允许在任意字符间换行
#let wrap(text) = {
  // 遍历每个字符，并在其后插入一个 0pt 的间隙
  for char in text {
    char
    h(0.0001pt)
  }
}

// ========== Test ==========
// 用例
#set page(width: 5cm, height: auto)
#let sample = lorem(20)

#sample
#divider()
#wrap(sample)
