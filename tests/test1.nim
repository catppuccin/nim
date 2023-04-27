import unittest

import catppuccin

test "color":
  check mocha.rosewater.rgb() == ColorRGB(r: 245, g: 224, b: 220)

test "convert":
  check mocha.rosewater.toHex() == "F5E0DC"
