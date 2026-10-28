#import "/lib.typ": bussiness
#import "@preview/tiaoma:0.3.0"

#let r90(content, width, height) = box(
  width: width,
  height: height,
)[
  #align(center + horizon)[
    #rotate(90deg, content)
  ]
]


#set text(font: bussiness)
#set page(margin: 0cm)
#let a(i) = box(radius: 0.2cm, outset: -0.2cm, inset: 0.4cm, width: 5cm, height: 10cm, stroke: 1pt + black)[
  #i
  #tiaoma.ean("1234567890128")
  #tiaoma.qrcode("1234556")
]

#grid(
  columns: 2,
  ..for i in range(6) {
    (r90(a(i + 1), 10cm, 5cm),)
  }
)

#grid(
  columns: 4,
  ..for i in range(4) {
    (a(i + 1),)
  }
)
