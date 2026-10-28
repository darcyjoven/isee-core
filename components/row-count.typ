// 类似page-count ，此功能可以统计表格（不是表格也可以使用）中的行数，但是是此功能需要更加复杂的使用方式
// 其原理是在排版中，加入`标记` 然后算出排版前一次的值

// - id metadata 的id，一个文档可以多个id，分开合计
// - index 传入的要计算的值
// - fill 渲染函数，参数为一个整数的回调函数，返回排版块
#let row-count(
  id: "main-table",
  index: "index",
  fill: i => [#i],
) = context {
  let current-page = here().page()
  let markers = query(metadata)
  let current-page-rows = markers.filter(m => {
    let value = m.value
    if type(value) != dictionary { return false }
    if not "id" in value { return false }
    value.id == id and m.location().page() == current-page
  })
  let current-row = if current-page-rows.len() == 0 {
    0
  } else {
    current-page-rows.map(m => m.value.at(index)).fold(0, (a, b) => calc.max(a, b))
  }
  fill(current-row)
}

// ========== Test ==========
// 用例
#set page(width: 6cm, height: 5cm)
#table(
  columns: (1fr, 1fr),
  ..for i in range(15) {
    ([#{ i + 1 }#metadata((id: "col1", index: i + 1))], [<\-\-\-\-\-\-\-\-\-\->#metadata((id: "col2", idx: i))])
  },
  table.footer(
    [col1. #row-count(id: "col1")], [col2. #row-count(id: "col2", index: "idx", fill: i => [no. #i]) ],
    repeat: true,
  ),
)
