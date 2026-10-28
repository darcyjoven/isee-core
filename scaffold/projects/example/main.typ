// 最小可运行示例：读取同目录 data.json，渲染一个带页眉、合计行的表格
#import "/lib.typ": report-init, company-header, num, row-count

#show: report-init

#let data = json("data.json")
#let total = data.rows.map(r => r.amount).sum()

#company-header()

#align(center)[
  #text(size: 16pt, weight: "bold")[示例报表]
]

#table(
  columns: (auto, 1fr, auto, auto),
  align: (center, left, right, right),
  table.header([序号], [名称], [数量], [金额]),
  ..for (i, row) in data.rows.enumerate() {
    (
      [#metadata((id: "row", index: i + 1))#(i + 1)],
      row.name,
      row.qty,
      num(row.amount),
    )
  },
  table.footer(
    [合计], [], [#data.rows.map(r => r.qty).sum()], [#num(total)],
    repeat: true,
  ),
)

#align(right)[
  #text(size: 8pt)[#row-count(id: "row", fill: i => [本页共 #i 项])]
]
