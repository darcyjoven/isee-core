/// 改写自 @preview/chomp:0.1.0，增加了CJK中日韩字体的支持
/// truncate 的主要功能是，将字体自动截断，不要跨行显示
///
/// Chomp
/// Utility that enables the truncation of a string passed to a layout function
/// Usea a binary search to achieve O(log N) complexity.

/// Private
/// Utility function used by truncate
#let _compare-dims(dims1, dims2) = {
  return dims1.width <= dims2.width and dims1.height <= dims2.height
}

/// Shortens `string` until `func(string, ..args)` fits within `width` and `height`, adding `prefix` and `suffix` if truncation is active
/// Uses a binary search to find the optimal truncation point in O(log N) time
///
/// ```example
/// #let s = lorem(50)
/// #truncate(heading, s, width: none, height: 3em, suffix: "...", level: 3)
///
/// This panics if even truncation to an empty string (but with prefix and suffix) does not obey the given size constraints
///
/// -> content
#let truncate(
  /// String argument that can be truncated
  /// -> str
  string,

  /// Function with signature `func(string, ..args) -> content`)
  /// Defaults to the text function
  /// -> (str, ..arguments) -> content
  func: text,

  /// Maximal width that must be achieved using truncation
  /// `none` indicates that the layout width should be used
  /// -> length | none
  width: none,

  /// Maximal height that must be achieved using truncation
  /// `none` indicates that the layout height should be used
  /// -> length | none
  height: none,

  /// Prefix that should be added to `string` if truncation is used
  /// -> str
  prefix: "",

  /// Suffix that should be added to `string` if truncation is used
  /// -> str
  suffix: "",

  /// Additional arguments passed to `func`
  /// -> arguments
  ..args,
) = layout(size => {
  let _width = if width == none { size.width } else { width.to-absolute() }
  let _height = if height == none { size.height } else { height.to-absolute() }
  let target_dims = (width: _width, height: _height)

  // Check if string fits without modification, if so return without prefix/suffix
  let full_content = func(string, ..args)

  // [变动 1] 改为测量自然宽度，防止在表格等受限容器中因自动换行而误判
  let full_dims = measure(full_content, width: auto, height: auto)

  if _compare-dims(full_dims, target_dims) {
    full_content
  } else {
    // Perform Binary Search to find longest substring combined with prefix/suffix.
    let low = 0
    let chars = string.clusters()
    let high = chars.len()
    // let high = string.len()
    let best_len = none

    while low <= high {
      let mid = int((low + high) / 2)
      let candidate_str = prefix + chars.slice(0, mid).join() + suffix
      let candidate_content = func(candidate_str, ..args)

      // [变动 2] 二分查找时也使用自然宽度测量
      let dims = measure(candidate_content, width: auto, height: auto)

      if _compare-dims(dims, target_dims) {
        // Fits, try truncating less
        best_len = mid
        low = mid + 1
      } else {
        // Too big, truncate more
        high = mid - 1
      }
    }

    if best_len == none {
      panic("No amount of truncation could make content fit within given bounds.")
    }

    // Return largest string that fits
    func(prefix + chars.slice(0, best_len).join() + suffix, ..args)
  }
})

// ========== Test ==========
// 用例
#set page(width: 18cm, height: auto)
#let sample = lorem(10)
#let sample-chinese = "窗前明月光，疑是地上霜，举头望明月，低头思故乡。"
#grid(
  columns: (2fr, 1fr, 2fr),
  stroke: 0.5pt + black,
  inset: 0.4em,
  sample, sample, sample,

  truncate(sample, suffix: ".."), truncate(sample, prefix: ".."), truncate(sample, width: 5em),
  truncate(sample-chinese, width: 5em), truncate(sample-chinese), truncate(sample-chinese),
)
