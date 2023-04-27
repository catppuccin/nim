<h3 align="center">
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
	Catppuccin for <a href="https://github.com/catppuccin/nim">nim</a>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
</h3>

<p align="center">
	<a href="https://github.com/catppuccin/nim/stargazers"><img src="https://img.shields.io/github/stars/catppuccin/template?colorA=363a4f&colorB=b7bdf8&style=for-the-badge"></a>
	<a href="https://github.com/catppuccin/nim/issues"><img src="https://img.shields.io/github/issues/catppuccin/template?colorA=363a4f&colorB=f5a97f&style=for-the-badge"></a>
	<a href="https://github.com/catppuccin/nim/contributors"><img src="https://img.shields.io/github/contributors/catppuccin/template?colorA=363a4f&colorB=a6da95&style=for-the-badge"></a>
</p>


## Usage

```sh
nimble install https://github.com/catppuccin/nim
```

The `catppuccin` nim library was designed to interface with [`treeform/chroma`](https://github.com/treeform/chroma), however it is not required for basic usage. Some of the basic color types and transformations have been ported from `chroma`

If you do wish to access `catppuccin` colors alongside `chroma` compile with `-d:inheritChroma` (see `./examples/use_chroma.nim`) to use the color types defined by `chroma`.

### Examples

```nim
import catppuccin

echo mocha.rosewater.color().toHex()
```

Output of `nim r examples/term.nim`:

![example screenshot](./assets/term.svg)


<!-- this section is optional -->
## 🙋 FAQ

-	Q: **_"Where can I find the doc?"_**\
	A: Run `nimble docs`

## 💝 Thanks to

- [daylinmorgan](https://github.com/daylinmorgan)

&nbsp;

<p align="center">
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" />
</p>

<p align="center">
	Copyright &copy; 2021-present <a href="https://github.com/catppuccin" target="_blank">Catppuccin Org</a>
</p>

<p align="center">
	<a href="https://github.com/catppuccin/catppuccin/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=d9e0ee&colorA=363a4f&colorB=b7bdf8"/></a>
</p>
