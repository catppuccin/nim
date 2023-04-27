import std/[os,strformat]
# Package

version       = "0.1.1"
author        = "Daylin Morgan"
description   = "Soothing pastel theme for nim"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.4"

task gen, "generate src/catppuccin/palette.nim":
  let paletteJson = "./tools/palette-porcelain.json"
  let srcUrl = "https://raw.githubusercontent.com/catppuccin/palette/main/palette-porcelain.json"
  if not fileExists(paletteJson): exec &"wget -O {paletteJson} {srcUrl}"
  exec "nim r ./tools/generate.nim"


task docs, "Deploy doc html + search index to public/ directory":
  let
    deployDir = getCurrentDir() / "public"
    pkgName = "catppuccin"
    srcFile = getCurrentDir() / "src" / (pkgName & ".nim")
    gitUrl = "https://github.com/daylinmorgan/catppuccin-nim"
  selfExec &"doc --index:on --git.url:{gitUrl} --git.commit:v{version} --outdir:{deployDir} --project {srcFile}"
  withDir deployDir:
    mvFile(pkgName & ".html", "index.html")
    for file in walkDirRec(".", {pcFile}):
      # As we renamed the file, we need to rename that in hyperlinks
      exec(r"sed -i -r 's|$1\.html|index.html|g' $2" % [pkgName, file])
      # drop 'src/' from titles
      exec(r"sed -i -r 's/<(.*)>src\//<\1>/' $1" % file)
