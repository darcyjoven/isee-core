#import "/lib.typ": (
  bussiness, company-header, ctypset, decimal, financial, format-table, hei, num, page-count, report-init, row-count,
  song, truncate, wrap, zhamt,
)
#import "/config.typ": company
#import "@preview/suiji:0.5.1": gen-rng-f, integers-f

// 这是一个单据表单打印
// 字体设定为中文宋体、数字拉丁文字黑体 10.5 pt
// 页面为常规a4

#show: ctypset
#set text(size: 10.5pt, font: financial)

#let footer = {
  set text(font: song, size: 6pt)
  set par(leading: 0em)
  [供方需知:

    Notes to vendor：

    1、供方收到我方采购单后，当日及时确认并盖章回复。否则视为认可。

    After receiving oure purchase order,the vender will confirm and reply with stamping on the same day;otherwise it will be regarded to have confirmed.

    2、供方收到订单后不能按期供货，需在半日内通知我方，否则因延误供货期而造成我方经济损失，由供方承担。

    If the vendor can't deliver the goods on time,it needs to inform us three days in advance;otherwise,it will bear the economic loss caused to us due
    to such delay.

    3、供方品质问题、材料变更、制造变更、产品变更必须及时通知我司，若未经我司确认而造成经济损失，由供方承担。

    If the vendor should inform us the problem of its good,the material,manufactur and production changing on time,otherwise the vendor shorld bear
    the encomic loss that hasn't been confrimed by us.

    4、供方在每月25日前将上月的对帐单明细表给我方核实确认并附上月发票，否则我方不确认，并拒绝付款。

    The vendor shall send us the detailed account list for the previous month before the day 5 of evrified,confirmed and enclosed with the
    invoice;otherwise,we will not confirm and will refuse to make payment.

    5、供方送货需要附产品合格证/产品质量检验报告及加盖公章的送货单。所有材料必须符合我司《环境物质管理规范》和RoHS等有害物质控制要求。

    The vendor's supply should be enclosed with the product certificate,product quality inspection report and the delivery notice with the official deal.All the materials should meet therequirements of RoHS and the document " Environmental Hazardous Substance Control Spec.

    6、严禁贿赂行为，否则，经查处即取消供应商资格。供应商承担由此而引起的法律责任。

    No bribery is allowed;otherwise,thevendor will be deprived of the qualification once discoverd,and it will undertake the legal.]
}
// 页面设计，除了设置了页面大小和页边距
// 这里还可以设置固定的header、footer
#set page(
  paper: "a4",
  flipped: true,
  header: company-header(name: company.name + "\n采购单"),
  footer: grid(
    columns: (1fr, 1fr, 1fr),
    inset: 0.5em,
    [采购员：], [审核：], [供方确认：],
    [BUYER], [ASSESSOR], [VENDOR SIGNATURE],
  ),
)

// 含有表格的模板，如果表格可能跨页。
// 那么所有内容都应该以表格为主题设计。
// 跨页需要重复显示内容作为表格固定的table.header，或者table.footer
// 如果不这么设计，跨页后只会显示表格内容，其它内容不重复显示。
// PS：页码等内容不需要放在表格中

// 这部分资料可以由json传入，这里为了减少示例文件个数，一起定义在typ文件中。
// isee项目都是以数据驱动的，数据处理完成后在放到typst中进行打印等操作
// 特别是舍入，小数位数，为了避免数据不一致，应该传入的时候数据就处理过。
// 避免由typst处理，typst只进行样式设定。
#let data = {
  let data = (
    docno: "PO-2608080008",
    payment: "月结30天",
    date: "26/08/08",
    suppiler: "OS.001",
    abbreviation: "橙光科技",
    cancat: "董小姐",
    phone: "021-90862345",
    tax: "13%",
    curency: "RMB",
    sumamt: 0,
    detail: (),
  )

  let rng = gen-rng-f(12345)
  for i in range(50) {
    let (new-rng, nums) = integers-f(
      rng,
      low: 1,
      high: 101,
      size: 3,
    )
    rng = new-rng
    let qty = nums.at(0)
    let price = nums.at(1)
    let amt = calc.round(qty * price, digits: 2)
    data.detail.push((
      seq: i + 1,
      item: "BP.02XR",
      desc: "签字笔",
      spec: "红色",
      qty: qty,
      unit: "支",
      price: price,
      amt: amt,
      date: "26/09/10",
      remark: "",
    ))
    data.sumamt += amt
  }
  data
}


// isee 项目 建议使用函数，将各部分独立
// 这样维护起来简单，且数据的传递更清晰，避免一个总数居传来传去


// 这里的header部分是表格跨页要重复显示在页眉的内容
// 会作为table.header加入
// 表格的标题部分不放在这里，为了维持逻辑一致，会放在表格中设置
#let header(data) = {
  grid(
    columns: (auto, 1fr) * 3,
    align: (x, _) => if calc.rem(x, 2) == 0 { right + horizon } else { left + horizon },
    inset: 0.5em,
    // stroke: 0.5pt + black,
    [单据编号:], data.docno, [付款方式：], data.payment, [税率：], data.tax,
    [供应商：], data.suppiler, [简称：], data.abbreviation, [币种：], data.curency,
    [联系人：], data.cancat, [联系电话：], data.phone,
  )
}

// table-footer 是每页显示在页尾的部分
// 当前页码也在这里设置
// 因为有时根据表格判断是否显示一个此页是否完成，所以单据设置
// 如果不是表格，直接在page中设置即可
#let table-footer(cnt, amt) = {
  row-count(fill: i => if i < cnt {
    v(0.5em)
    [接下页]
  } else {
    grid(
      columns: (1fr, 1fr),
      align: (right, left),
      stroke: 1pt + black,
      inset: 0.5em,
      [ 合计大写（RMB）：#zhamt(amt)#h(1em)], [#h(1em)合计小写￥：#decimal(amt, digits: 2)],
    )
  })
}

// detail 是table中的数据部分，为了不影响样式设定，单独函数设置数据部分
#let detail(data) = {
  for (i, v) in data.enumerate() {
    (
      [#v.seq #metadata((id: "main-table", index: i + 1))],
      [#v.item],
      [#truncate(v.desc)],
      [#wrap(v.spec)],
      [#v.qty],
      [#v.unit],
      [#v.price],
      [#v.amt],
      [#v.date],
      [#v.remark],
    )
  }
}

// table 的标题，独立定义，为了方便调整
#let table-header = (
  align(center)[序号],
  align(center)[料件编号],
  align(center)[品名],
  align(center)[规格],
  align(center)[数量],
  align(center)[单位],
  align(center)[价格],
  align(center)[金额],
  align(center)[交货日期],
  align(center)[备注],
)



// 与其它编程语言不同，typst的函数必须定义在使用之前
// 所以入口函数一般都在最后
#let main(data) = {
  // 设置表格数字样式，这样设置，可以使用每列的数字按照小数点对齐
  // show table: format-table(
  //   none,
  //   none,
  //   none,
  //   none,
  //   (math: false, trim-zeros: true, round: (precision: 3, pad: false)), //数量
  //   none,
  //   (math: false, trim-zeros: true, round: (precision: 6, pad: false)), // 价格
  //   (math: false, trim-zeros: true, digits: 2, round: (precision: 2, pad: true)), // 金额
  //   none,
  //   none,
  // )
  table(
    columns: (1.2cm, 2cm, 4cm, 4cm, 2cm, 1.2cm, 2cm, 2.5cm, 2cm, 1fr),
    align: (right, left, left, left, center, center, center, center, center, left),
    table.header(
      table.cell(colspan: 10, stroke: none, header(data)),
      ..table-header,
    ),
    ..detail(data.detail),
    table.footer(
      table.cell(colspan: 10, stroke: none, inset: 0cm, table-footer(data.detail.len(), data.sumamt)),
      table.cell(colspan: 10, stroke: none, align(left)[#footer]),
    ),
  )
}
#main(data)
