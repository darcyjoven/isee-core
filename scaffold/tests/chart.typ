#import "/lib.typ": ctypset, hei, song
#import "@preview/lilaq:0.6.0" as lq

#show: ctypset
#set text(font: hei)
#show lq.selector(lq.diagram): set text(.8em)


#link("https://lilaq.org")[`lilaq.org`]


#lq.diagram(
  lq.plot((0, 1, 2, 3, 4), (3, 5, 4, 2, 3)),
)

Precious data

#let xs = (0, 1, 2, 3, 4)
#lq.diagram(
  title: [Precious data],
  xlabel: $x$,
  ylabel: $y$,

  lq.plot(xs, (3, 5, 4, 2, 3), mark: "s", label: [A]),
  lq.plot(
    xs,
    (0, 0, 1, 2, 3),
    mark: "o",
    label: [B],
  ),
)


#show lq.selector(lq.label): set align(top + right)
#show lq.selector(lq.title): set align(right)

#lq.diagram(
  title: [Title],
  xlabel: $x$,
  ylabel: $y$,
)


#lq.diagram(
  cycle: (
    it => {
      set lq.style(fill: red)
      set lq.mark(align: lq.marks.s3)
      it
    },
    it => {
      set lq.style(fill: teal)
      set lq.mark(align: lq.marks.s)
      it
    },
  ),
  lq.plot(range(4), range(2, 6), label: [1]),
  lq.plot(range(4), range(1, 5), label: [2]),
  lq.plot(range(4), range(0, 4), label: [3]),
  lq.plot(range(4), range(-1, 3), label: [4]),
  lq.plot(range(4), range(-2, 2), label: [5]),
  lq.plot(range(4), range(-3, 1), label: [5]),
  lq.plot(range(4), range(-4, 0), label: [6]),
)
