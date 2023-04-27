when not defined(inheritChroma):
  import catppuccin/chroma
else:
  import chroma

type
  Flavor = object
    rosewater*, flamingo*, pink*, mauve*, red*, maroon*, peach*, yellow*,
        green*, teal*, sky*, sapphire*, blue*, lavender*, text*, subtext1*,
            subtext0*, overlay2*,
        overlay1*, surface2*, surface1*, surface0*, base*, mantle*,
            crust*: Color

include catppuccin/palette


export mocha, latte, macchiato, frappe
export chroma
