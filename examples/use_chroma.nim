{.define: inheritChroma.}

import std/[strutils]

import catppuccin


when isMainModule:
  echo "Mocha colors as CMYK"
  for n, c in mocha.fieldPairs():
    echo alignLeft(n, 9) & " -> " & $c.color().asCmyk()
