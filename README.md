# europasscv2025

**Unofficial LaTeX classes for the 2025 Europass CV and cover letter**

## Overview

`europasscv2025` is an unofficial LaTeX implementation of the Europass CV,
the standard model for curriculum vitae recommended by the European Commission
and widely used across the European Union and beyond.

The Europass CV has gone through several major revisions since its introduction.
The original European CV was launched in 2002 and rebranded as Europass CV in
2004. In 2013 a major visual redesign introduced a neater, more compact layout —
this is the version implemented by the
[europasscv](https://ctan.org/pkg/europasscv) package. In 2020 the European
Commission launched a new online Europass platform with an integrated CV editor,
introducing multiple new templates with a significantly different visual identity.
The current 2025 version of the platform offers a further refined set of
templates, but no LaTeX implementation existed for any of the post-2020 layouts.

`europasscv2025` fills this gap by implementing the **classic** template of the
2025 Europass CV editor, as available on the
[official Europass website](https://europa.eu/europass) at the time of writing.
The package also provides `europassletter2025`, a companion class for matching
cover letters.

This class is inspired by [europasscv](https://ctan.org/pkg/europasscv) by
Giacomo Mazzamuto, which remains the reference implementation for the 2013
layout. However, `europasscv2025` is an entirely independent reimplementation:
**the API is in no way backwards-compatible or interchangeable with
`europasscv`**.

## Features

The `europasscv2025` class implements the *"classic"* Europass CV theme. The
package also includes a matching cover-letter class. Features include:

- Full-width colored header with personal information and optional circular profile picture
- A4 cover letter with sender and recipient details, contact icons and optional signature image
- Seven predefined color schemes: `default`, `darkblue`, `blue`, `darkgreen`, `green`, `darkviolet`, `violet`
- Individual color overrides for fine-grained customization
- Section headings with full-width decorative rule
- Optional bibliography support via `europasscv2025-bibliography.sty` (powered by `biblatex` and `biber`)
- Supports pdfLaTeX, XeLaTeX, and LuaLaTeX
- Translated CV and letter labels in English, German, Hungarian, Italian and Romanian

## Download and installation

Install the `europasscv2025` package through the package manager of your TeX distribution or download it from [CTAN](https://ctan.org/pkg/europasscv2025).

## How to use

Please refer to the [documentation](europasscv2025.pdf) for full instructions. A quick example:

```latex
\documentclass[english, color-default]{europasscv2025}
\begin{document}

  \ecvphoto{photo.png}
  \begin{ecvinfo}
    \ecvname{Katie Smith}
    \ecvdateofbirth{1 March 1975}
    \ecvemail{smith@example.com}
  \end{ecvinfo}

  \ecvsection{Work experience}
  \ecventry{
    title={Software Engineer},
    organization={Acme Corp},
    date={2020--Present}
  }

\end{document}
```

Cover letters use a separate set of commands:

```latex
\documentclass[german,color-darkgreen]{europassletter2025}
\eclname{Katie Smith}
\ecladdress{12 Strawberry Hill, Dublin 8}
\eclemail{smith@example.com}
\eclphone[mobile]{(+353) 555 123 555}
\eclim[\faWhatsapp]{WhatsApp}{ksmith}
\eclrecipientname{Selection Committee}
\eclrecipientorganization{Example Company}
\ecldate{Dublin, 8 November 2026}
\eclsubject{Application for Software Engineer}
\eclopening{Dear Selection Committee,}
\eclclosing{Yours sincerely,}
\eclsignature{Katie Smith}

\begin{document}
\begin{eclletter}
I am writing to apply for the advertised position.
\end{eclletter}
\end{document}
```

For a complete example, see `europassletter2025_en.tex`.

## Building from source

The repository comes with a `Makefile` that handles all build steps, including converting logos from SVG to PDF using [Inkscape](https://inkscape.org) and compiling all documents with `latexmk`.

```bash
make                    # build everything (default: xelatex)
make ENGINE=lualatex    # use lualatex
make ENGINE=pdflatex    # use pdflatex
make documentation      # build documentation only
make examples           # build examples only
make distclean          # remove auxiliary files
make clean              # remove auxiliary files and PDFs
```

You need to have **Inkscape** and **latexmk** installed on your system.

## Contributing

Contributions are welcome, in particular:

- **New language files** — add a `locale/ecv_<lang>.def` file following the structure of the existing ones and open a pull request
- **Bug reports and feature requests** — open an issue on GitHub

## License

This material is subject to the [LaTeX Project Public License Version 1.3c](https://www.latex-project.org/lppl/).

## Acknowledgements

Special thanks to Giacomo Mazzamuto for the [europasscv](https://ctan.org/pkg/europasscv) package, which served as inspiration for this project.
