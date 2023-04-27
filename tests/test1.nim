import unittest

import catppuccin

test "color":
  check mocha.rosewater == ColorRGB(r: 245, g: 224, b: 220)

test "convert":
  check mocha.rosewater.color().toHex() == "F5E0DC"
