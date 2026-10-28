#import "/lib.typ" as core
#set page(height: 8cm, width: auto)
#set text(font: "Source Han Serif SC")

= 简单表格
#table(
  columns: 2,
  [*料件编号*], [*品名*],
  [360g], [Baking flour],
  [250g], [Butter (room temp.)],
  [150g], [Brown sugar],
  [100g], [Cane sugar],
  [100g], [70% cocoa chocolate],
  [100g], [35-40% cocoa chocolate],
  [2], [Eggs],
  [Pinch], [Salt],
  [Drizzle], [Vanilla extract],
)
#pagebreak()

= 固定标题
#table(
  columns: 2,
  table.header[*料件编号*][*品名*],
  [360g], [Baking flour],
  [250g], [Butter (room temp.)],
  [150g], [Brown sugar],
  [100g], [Cane sugar],
  [100g], [70% cocoa chocolate],
  [100g], [35-40% cocoa chocolate],
  [2], [Eggs],
  [Pinch], [Salt],
  [Drizzle], [Vanilla extract],
)
#pagebreak()


= 全局样式
#{
  show table.cell.where(y: 0): it => {
    set text(weight: "bold")
    it
  }
  table(
    columns: 2,
    table.header[料件编号][品名],
    [100g], [35-40% cocoa chocolate],
  )
  pagebreak()
  table(
    columns: 2,
    table.header[料件编号][品名],
    [100g], [35-40% cocoa chocolate],
  )
  pagebreak()
}

= 还原样式
#table(
  columns: 2,
  [料件编号], [品名],
  [100g], [70% cocoa chocolate],
  [100g], [35-40% cocoa chocolate],
  [2], [Eggs],
  [Pinch], [Salt],
  [Drizzle], [Vanilla extract],
)
#pagebreak()


#{
  set page(height: 8cm, width: 10cm)
  heading("设置宽度")
  table(
    columns: (auto, 50%, 2cm),
    table.header[Date][°No][
      #core.truncate(
        "Description",
        height: 1em,
        suffix: "...",
      )],
    [24/01/03],
    [813],
    [#core.truncate(
      "Filtered participant pool",
      height: 1em,
      suffix: "...",
    )],

    [24/01/03], [477], [Transitioned to sec. regimen],
    [24/01/11], [051], [Cycled treatment substrate],
  )
  pagebreak()
}


#{
  set page(width: 21cm, height: 6cm)
  heading("斑马纹")
  show table.cell.where(y: 0): set text(weight: "medium")
  show table.cell.where(x: 1): set text(weight: "bold")

  // See the strokes section for details on this!
  // 控制显示边框
  let frame(stroke) = (x, y) => (
    left: if x > 0 { 0pt } else { stroke },
    right: stroke,
    top: if y < 2 { stroke } else { 0pt },
    bottom: stroke,
  )

  set table(
    fill: (_, y) => if calc.rem(y, 2) == 0 and y > 1 {
      rgb("#75a0e0")
    } else if y == 0 {
      rgb("#ab71db")
    } else {
      none
    },
    stroke: frame(1pt + rgb("#091be4")),
  )

  table(
    columns: (0.4fr, 1fr, 1fr, 1fr),

    table.header[Month][Title][Author][Genre],
    [January], [The Great Gatsby], [F. Scott Fitzgerald], [Classic],
    [February], [To Kill a Mockingbird], [Harper Lee], [Drama],
    [March], [1984], [George Orwell], [Dystopian],
    [April], [The Catcher in the Rye], [J.D. Salinger], [Coming-of-Age],
  )
  pagebreak()
}

#{
  heading("边框")
  table(
    columns: 4,
    stroke: none,
    [*Monday*], [11.5], [13.0], [4.0],
    [*Tuesday*], [8.0], [14.5], [5.0],
    table.hline(),
    [*Wednesday*], [9.0], [18.5], [13.0],
  )
  pagebreak()
}

#{
  heading("双线边框")
  table(
    columns: 3,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    table.header[Date][Exercise Type][Calories Burned],
    [2023-03-15], [Swimming], [400],
    [2023-03-17], [Weightlifting], [250],
    [2023-03-18], [Yoga], [200],
  )
  pagebreak()
}


= 对齐
#show table.cell.where(y: 0): set text(weight: "bold")

#table(
  columns: 4,
  align: (right, left, left, left),
  fill: (_, y) => if calc.odd(y) { green.lighten(90%) },
  stroke: none,

  table.header[Day][Location][Hotel or Apartment][Activities],
  [1], [Paris, France], [Hôtel de l'Europe], [Arrival, Evening River Cruise],
  [2], [Paris, France], [Hôtel de l'Europe], [Louvre Museum, Eiffel Tower],
  [3], [Lyon, France], [Lyon City Hotel], [City Tour, Local Cuisine Tasting],
  [4], [Geneva, Switzerland], [Lakeview Inn], [Lake Geneva, Red Cross Museum],
  [5], [Zermatt, Switzerland], [Alpine Lodge], [Visit Matterhorn, Skiing],
)
#pagebreak()

#{
  set page(width: 22cm, height: auto)
  heading("合并单元格")
  let ofi = [Office]
  let rem = [_Remote_]
  let lea = [*On leave*]

  show table.cell.where(y: 0): set text(
    fill: white,
    weight: "bold",
  )

  table(
    columns: 6 * (1fr,),
    align: (x, y) => if x == 0 or y == 0 { left } else { center },
    stroke: (x, y) => (
      // Separate black cells with white strokes.
      left: if y == 0 and x > 0 { white } else { black },
      rest: black,
    ),
    fill: (_, y) => if y == 0 { black },

    table.header([Team member], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday]),
    [Evelyn Archer],
    table.cell(colspan: 2, ofi),
    table.cell(colspan: 2, rem),
    ofi,
    [Lila Montgomery],
    table.cell(colspan: 5, lea),
    [Nolan Pearce],
    rem,
    table.cell(colspan: 2, ofi),
    rem,
    ofi,
  )
}
#pagebreak()

#{
  set page(width: 9cm, height: 6cm)
  show table.cell.where(y: 0): set text(weight: "bold")
  show figure: set block(breakable: true)
  heading("跨页显示")

  figure(
    caption: [Training regimen for Marathon],
    table(
      columns: 3,
      fill: (_, y) => if y == 0 { gray.lighten(75%) },

      table.header[Week][Distance (km)][Time (hh:mm:ss)],
      [1], [5], [00:30:00],
      [2], [7], [00:45:00],
      [3], [10], [01:00:00],
      [4], [12], [01:10:00],
      [5], [15], [01:25:00],
      [6], [18], [01:40:00],
      [7], [20], [01:50:00],
      [8], [22], [02:00:00],
      [...], [...], [...],
      table.footer[_Goal_][_42.195_][_02:45:00_],
    ),
  )
}
#pagebreak()

= 导入csv
#let moore = csv("more.csv")
#let moore-log = (
  moore
    .slice(1)
    .map(m => {
      let (.., year, count) = m
      let log = calc.log(float(count))
      let rounded = str(calc.round(log, digits: 2))
      (year, rounded)
    })
)

#show table.cell.where(x: 0): strong

#table(
  columns: moore-log.first().len(),
  align: right,
  fill: (_, y) => if calc.odd(y) { rgb("D7D9E0") },
  stroke: none,

  table.header[Year][Transistor count ($log_10$)],
  table.hline(stroke: rgb("4D4C5B")),
  ..moore-log.flatten(),
)


#set page(width: 20cm)

#set text(size: 10pt)

#let total-rows = 20

// 模拟数据
#let data = range(1, total-rows + 1).map(i => (
  id: i,
  name: "产品 " + str(i),
  description: if calc.rem(i, 7) == 0 {
    "这是一个比较长的产品描述，用来模拟真实报表中单元格内容自动换行的情况。这里可能会占用两行甚至更多行。"
  } else {
    "普通产品描述"
  },
  qty: i * 2,
  price: i * 1.25,
))

#table(
  columns: (15mm, 30mm, 1fr, 20mm, 25mm),

  // 表头
  table.header([序号], [产品], [描述], [数量], [单价]),

  // 数据行
  ..data
    .map(row => (
      // 第一个单元格放 metadata
      [
        #metadata((
          id: "main-table",
          index: row.id,
        ))
        #row.id
      ],

      [#row.name],
      [#row.description],
      [#row.qty],
      [#row.price],
    ))
    .flatten(),
  table.footer(
    repeat: true,
    table.cell(colspan: 5, core.row-count(fill: i => align(right)[#i / #data.len()])),
  ),
)
