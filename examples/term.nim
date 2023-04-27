import std/[strformat]
import catppuccin

const ansiReset = "\e[0m"

proc ansi(s: string, c: Color): string =
  let
    cRgb = c.rgb()
    (r, g, b) = (cRgb.r, cRgb.g, cRgb.b)
    code = &"\e[48;2;{r};{g};{b}m"

  result.add(code)
  result.add(s)
  result.add(ansiReset)


when isMainModule:
  let flavors = @[
    ("latte", latte),
    ("frappe", frappe),
    ("macchiato", macchiato),
    ("mocha", mocha)
  ]

  for (name, flavor) in flavors:

    echo name

    for name, color in flavor.fieldPairs():
      write(stdout, "  ".ansi(color))

    write(stdout, "\n\n")
