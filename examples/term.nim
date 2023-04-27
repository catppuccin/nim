import std/[strformat]
import catppuccin

const ansiReset = "\e[0m"

proc ansi(s: string, c: ColorRGB): string =
  let code = &"\e[48;2;{c.r};{c.g};{c.b}m"
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
