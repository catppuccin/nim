import std/[hashes, math, strutils]

## Standalone types/methods ported from treeform/chroma.
##
## See `chroma` `LICENSE <https://github.com/treeform/chroma/blob/master/LICENSE>`_.

# chroma/colortypes ---------------
type
  Color* = object
    ## Main color type, float32 points
    r*: float32 ## red (0-1)
    g*: float32 ## green (0-1)
    b*: float32 ## blue (0-1)
    a*: float32 ## alpha (0-1, 0 is fully transparent)

  # Color Space: rgb
  ColorRGB* = object
    ## Color stored as 3 uint8s
    r*: uint8 ## Red 0-255
    g*: uint8 ## Green 0-255
    b*: uint8 ## Blue 0-255

  # Color Space: rgba
  ColorRGBA* = object
    ## Color stored as 4 uint8s
    r*: uint8 ## Red 0-255
    g*: uint8 ## Green 0-255
    b*: uint8 ## Blue 0-255
    a*: uint8 ## Alpha 0-255

  # Color Space: HSL
  ColorHSL* = object
    ## HSL attempts to resemble more perceptual color models
    h*: float32 ## hue 0 to 360
    s*: float32 ## saturation 0 to 100
    l*: float32 ## lightness 0 to 100

  SomeColor* = Color|ColorRGB|ColorRGBA|ColorHSL

  InvalidColor* = object of ValueError

proc color*(r, g, b: float32, a: float32 = 1.0): Color {.inline.} =
  ## Creates from floats like:
  ## * color(1,0,0) -> red
  ## * color(0,1,0) -> green
  ## * color(0,0,1) -> blue
  ## * color(0,0,0,1) -> opaque  black
  ## * color(0,0,0,0) -> transparent black
  Color(r: r, g: g, b: b, a: a)

proc rgb*(r, g, b: uint8): ColorRGB {.inline.} =
  ## Creates from uint8s like:
  ## * rgba(255,0,0) -> red
  ## * rgba(0,255,0) -> green
  ## * rgba(0,0,255) -> blue
  ColorRGB(r: r, g: g, b: b)

proc rgba*(r, g, b, a: uint8): ColorRGBA {.inline.} =
  ## Creates from uint8s like:
  ## * rgba(255,0,0,255) -> red
  ## * rgba(0,255,0,255) -> green
  ## * rgba(0,0,255,255) -> blue
  ## * rgba(0,0,0,255) -> opaque  black
  ## * rgba(0,0,0,0) -> transparent black
  ColorRGBA(r: r, g: g, b: b, a: a)

proc hsl*(h, s, l: float32): ColorHSL {.inline.} =
  ColorHSL(h: h, s: s, l: l)

# chroma/colortypes ---------------

# chroma/transformations ----------

proc rgb*(c: Color): ColorRGB {.inline.} =
  ## Convert Color to ColorRGB
  result.r = round(c.r * 255).uint8
  result.g = round(c.g * 255).uint8
  result.b = round(c.b * 255).uint8

proc color*(c: ColorRGB): Color {.inline.} =
  ## Convert ColorRGB to Color
  result.r = float32(c.r) / 255
  result.g = float32(c.g) / 255
  result.b = float32(c.b) / 255
  result.a = 1.0

proc rgba*(c: Color): ColorRGBA {.inline.} =
  ## Convert Color to ColorRGBA
  result.r = round(c.r * 255).uint8
  result.g = round(c.g * 255).uint8
  result.b = round(c.b * 255).uint8
  result.a = round(c.a * 255).uint8

proc color*(c: ColorRGBA): Color {.inline.} =
  ## Convert ColorRGBA to Color
  result.r = float32(c.r) / 255
  result.g = float32(c.g) / 255
  result.b = float32(c.b) / 255
  result.a = float32(c.a) / 255

proc min3(a, b, c: float32): float32 {.inline.} = min(a, min(b, c))
proc max3(a, b, c: float32): float32 {.inline.} = max(a, max(b, c))

proc hsl*(c: Color): ColorHSL =
  ## convert Color to ColorHSL
  let
    min = min3(c.r, c.g, c.b)
    max = max3(c.r, c.g, c.b)
    delta = max - min
  if max == min:
    result.h = 0.0
  elif c.r == max:
    result.h = (c.g - c.b) / delta
  elif c.g == max:
    result.h = 2 + (c.b - c.r) / delta
  elif c.b == max:
    result.h = 4 + (c.r - c.g) / delta

  result.h = min(result.h * 60, 360)
  if result.h < 0:
    result.h += 360

  result.l = (min + max) / 2

  if max == min:
    result.s = 0
  elif result.l <= 0.5:
    result.s = delta / (max + min)
  else:
    result.s = delta / (2 - max - min)

  result.s *= 100
  result.l *= 100

func fixupColor[T: int | float32](r, g, b: var T): bool =
  ## performs a fixup of the given r, g, b values and returnes whether
  ## any of the values was modified.
  ## This func works on integers or floats. It is only used within the
  ## conversion of `Color -> ColorHCL` (on integers) and `ColorHCL -> Color`
  ## (on floats).
  template fixC(c: untyped): untyped =
    if c < T(0):
      c = T(0)
      result = true
    when T is int:
      if c > 255:
        c = 255
        result = true
    else:
      if c > 1.0:
        c = 1.0
        result = true
  fixC(r)
  fixC(g)
  fixC(b)

# overload working on `var Color`. It's `discardable`, because in our usage
# here we do not really care whether a value was modified.
func fixupColor(c: var Color): bool {.inline, discardable.} =
  fixupColor(c.r, c.g, c.b)

proc color*(c: ColorHSL): Color =
  ## convert ColorHSL to Color
  let
    h = c.h / 360
    s = c.s / 100
    l = c.l / 100
  var t1, t2, t3: float32
  if s == 0.0:
    return color(l, l, l)
  if l < 0.5:
    t2 = l * (1 + s)
  else:
    t2 = l + s - l * s
  t1 = 2 * l - t2

  var rgb: array[3, float32]
  for i in 0..2:
    t3 = h + 1.0 / 3.0 * - (float32(i) - 1.0)
    if t3 < 0:
      t3 += 1
    elif t3 > 1:
      t3 -= 1

    var val: float32
    if 6 * t3 < 1:
      val = t1 + (t2 - t1) * 6 * t3
    elif 2 * t3 < 1:
      val = t2
    elif 3 * t3 < 2:
      val = t1 + (t2 - t1) * (2 / 3 - t3) * 6
    else:
      val = t1

    rgb[i] = val
  result.r = rgb[0]
  result.g = rgb[1]
  result.b = rgb[2]
  result.a = 1.0
  fixupColor(result)
  result

proc color*(c: Color): Color {.inline.} =
  c

proc to*[T: SomeColor](c: SomeColor, toColor: typedesc[T]): T {.inline.} =
  ## Allows conversion of transformation of a color in any color space into any
  ## other color space.
  when type(c) is T:
    c
  else:
    when toColor is Color:
      c.color
    elif toColor is ColorRGB:
      c.color.rgb
    elif toColor is ColorRGBA:
      c.color.rgba
    elif toColor is ColorHSL:
      c.color.hsl

proc asColor*(c: SomeColor): Color {.inline.} = c.to(Color)
proc asRgb*(c: SomeColor): ColorRGB {.inline.} = c.to(ColorRGB)
proc asHsl*(c: SomeColor): ColorHSL {.inline.} = c.to(ColorHSL)

# chroma/transformations ----------

# chroma --------------------------

proc toHex(a: float32): string {.inline.} = toHex(int(a))

proc `$`*(c: Color): string =
  ## Returns colors as "(r, g, b, a)".
  "(" & $c.r & ", " & $c.g & ", " & $c.b & ", " & $c.a & ")"

func hash*(c: Color): Hash =
  ## Hashes a Color - used in tables.
  hash((c.r, c.g, c.b, c.a))

func hash*(c: ColorRGB): Hash =
  ## Hashes a ColorRGB - used in tables.
  hash((c.r, c.g, c.b))

func hash*(c: ColorRGBA): Hash =
  ## Hashes a ColorRGB - used in tables.
  hash((c.r, c.g, c.b, c.a))

func hash*(c: ColorHSL): Hash =
  ## Hashes a ColorHSL - used in tables.
  hash((c.h, c.s, c.l))

proc toHex*(c: Color): string =
  ## Formats color as hex (upper case):
  ## * red -> FF0000
  ## * blue -> 0000FF
  ## * white -> FFFFFF
  template pair(n: float32): string =
    toHex(n*255)[^2..^1]
  pair(c.r) & pair(c.g) & pair(c.b)

proc toHexAlpha*(c: Color): string =
  ## Formats color as hex (upper case):
  ## * red -> FF0000FF
  ## * blue -> 0000FFFF
  ## * white -> FFFFFFFF
  ## * opaque  black -> 000000FF
  ## * transparent black -> 00000000
  template pair(n: float32): string =
    toHex(n*255)[^2..^1]
  pair(c.r) & pair(c.g) & pair(c.b) & pair(c.a)

proc toHtmlHex*(c: Color): string =
  ## Formats color as HTML hex (upper case):
  ## * red -> #FF0000
  ## * blue -> #0000FF
  ## * white -> #FFFFFF
  '#' & c.toHex()

proc toHtmlHexTiny*(c: Color): string =
  ## Formats color as HTML 3 hex numbers (upper case):
  ## * red -> #F00
  ## * blue -> #00F
  ## * white -> #FFF
  proc pair(n: float32): string =
    toHex(n*15)[^1..^1]
  return '#' & pair(c.r) & pair(c.g) & pair(c.b)

proc toHtmlRgb*(c: Color): string =
  ## Parses colors in html's rgb format:
  ## * red -> rgb(255, 0, 0)
  ## * blue -> rgb(0,0,255)
  ## * white -> rgb(255,255,255)
  "rgb(" &
    $round(c.r * 255).int & ", " &
    $round(c.g * 255).int & ", " &
    $round(c.b * 255).int &
  ")"

proc toHtmlRgba*(c: Color): string =
  ## Parses colors in html's rgb format:
  ## * red -> rgb(255, 0, 0)
  ## * blue -> rgb(0,0,255)
  ## * white -> rgb(255,255,255)
  "rgba(" &
    $round(c.r * 255).int & ", " &
    $round(c.g * 255).int & ", " &
    $round(c.b * 255).int & ", " &
    $c.a &
  ")"
