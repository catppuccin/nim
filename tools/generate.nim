import std/[json, strformat, strutils]


type
  Color = object
    hex: string
    rgb: array[3, int]
    hsl: array[3, float]
  Flavor = object
    rosewater, flamingo, pink, mauve, red, maroon, peach, yellow, green, teal,
        sky, sapphire, blue, lavender, text, subtext1, subtext0, overlay2,
        overlay1, surface2, surface1, surface0, base, mantle, crust: Color
  Palette = object
    latte, frappe, macchiato, mocha: Flavor

proc createColor(c: Color, name: string): string =
  result = &"""
    {name}: ColorRGB(r: {c.rgb[0]}, g: {c.rgb[1]}, b: {c.rgb[2]})"""

proc createFlavor(f: Flavor, name: string): string =
  var colorsDef: seq[string]
  for name, color in f.fieldPairs():
    colorsDef.add color.createColor(name)

  result = &"""
  {name}* = Flavor(
{colorsDef.join(",\n")}
  )"""


when isMainModule:
  const paletteJsonStr = slurp "./palette-porcelain.json"
  const doNotEdit = "# DO NOT EDIT this file is autogenerated by tools/generate.nim!"

  let palette = paletteJsonStr.parseJson().to(Palette)
  var flavors: string
  for name, flavor in palette.fieldPairs():
    flavors &= flavor.createFlavor(name) & "\n"

  let catppuccin = &"""
{doNotEdit}

const
{flavors}
"""
  writeFile("./src/catppuccin/palette.nim", catppuccin)