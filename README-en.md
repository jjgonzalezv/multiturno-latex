# Revista Colombiana de Computación (RCC) – LaTeX template

This template reproduces the official Word template of the journal: A4 page, 2.5 cm margins, Times New Roman 10 pt, the journal colours and heading sizes, APA 7 citations and references, and a first-page banner with DOI, ORCID and the Creative Commons licence.

## Files

| File | Purpose |
|---|---|
| `template-en.tex` | **Start here** for articles in English. All commands are in English. |
| `plantilla-es.tex` | Template for articles in Spanish (Spanish commands). |
| `rcc.cls` | Class with the journal style, shared by both templates. |
| `rcc-apa.bst` | APA 7 bibliography style (BibTeX). |
| `referencias.bib` | Example references, all with DOI. |
| `figuras/` | Journal logo and an example figure. |

## Compiling

pdfLaTeX → BibTeX → pdfLaTeX → pdfLaTeX. In Overleaf, upload the .zip and compile. XeLaTeX also works. In manuscript mode the line numbers need one more LaTeX run (Overleaf and latexmk do it automatically).

## Manuscript (anonymous), proof or final version

Change only the first line:

```latex
\documentclass[manuscript,english]{rcc}   % first submission, double-blind review
\documentclass[proof,english]{rcc}        % typesetting proof, "RCC Proof" watermark
\documentclass[final,english]{rcc}        % version for publication
```

Write all your data from the beginning. In **manuscript** mode the PDF:

- hides authors, affiliations, e-mails, ORCID, dates, funding, contributions and acknowledgments;
- replaces anything inside `\anonymize{...}` (self-citations, project names, own repositories) with "[anonymized]";
- removes the issue data from the banner and adds line numbers for the reviewers. Use the `nolinenumbers` option to turn line numbering off.

Other options: `verify` adds a page that checks all measurements against the Word template; `frames` draws the page layout.

## Journal limits

- Abstract and Spanish abstract: maximum **150 words** each.
- Keywords: maximum **5**, separated by commas.

LaTeX counts them and shows a warning in the log if a limit is exceeded (for example "Abstract: 163 words (maximum 150)"). It also warns when a figure or table has no note.

## Citations (APA 7)

| Command | Output |
|---|---|
| `\citep{hochreiter1997}` | (Hochreiter & Schmidhuber, 1997) |
| `\citet{hochreiter1997}` | Hochreiter and Schmidhuber (1997) |
| `\citep{lecun2015, schmidhuber2015}` | (LeCun et al., 2015; Schmidhuber, 2015) |
| `\citep[p.~90]{schmidhuber2015}` | (Schmidhuber, 2015, p. 90) |
| `\citet{hevner2004}` | Hevner et al. (2004) |

In the `.bib` file:

- write the edition as a number (`edition = {2}` → "2nd ed.");
- write the DOI without `https://doi.org/`;
- write titles in sentence case: capital only for the first word and the first word after a colon ("Deep learning in neural networks: An overview"); put proper nouns and acronyms in braces, e.g. `{IEEE}`.

## Figures and tables

Every figure and table needs a note with its authorship or source (APA 7), written right after the caption for figures and after `\end{rcctable}` for tables:

| Case | Command | Output |
|---|---|---|
| Created by the authors | `\note{\ownwork}` | *Note.* Created by the authors. |
| Own, with third-party data | `\note{\ownworkdata{\citet{x}}}` | *Note.* Created by the authors based on data from Author (year). |
| Reproduced without changes | `\note{\reproducedfrom{\citet{x}}}` | *Note.* From Author (year). |
| Modified | `\note{\adaptedfrom{\citet{x}}}` | *Note.* Adapted from Author (year). |

Tables use the `rcctable` environment, with `\rccheader` for the blue header row and `\rcch{...}` for each header cell (see the example in `template-en.tex`). Cells are vertically centred, as in the Word template. Column types: `L`, `C`, `R` (left, centre, right; automatic width).

### Long tables (continuing on the next page)

A normal table (`table` + `rcctable`) cannot break across pages. For long tables use `rcclongtable`. It breaks between rows and **repeats the blue header row** on every page, like "Repeat as header row" in Word. Do not put it inside `\begin{table}`; its caption and label are arguments. Columns are `P{fraction}` (left) or `Q{fraction}` (centre) of the text width, and the fractions must add up to 1:

```latex
\begin{rcclongtable}{Caption of the table}{tab:long}{P{.2}P{.3}P{.25}P{.25}}
  {\rcch{Column 1} & \rcch{Column 2} & \rcch{Column 3} & \rcch{Column 4}}
  Row 1 & text & text & text \\ \hline
\end{rcclongtable}
\note{\ownwork}
```

## Declarations (before ORCID and References)

| Environment | Heading | Standard text if it does not apply | Manuscript mode |
|---|---|---|---|
| `conflictofinterest` | Conflict of interest statement | `\noconflict` | shown |
| `funding` | Funding | `\nofunding` | hidden |
| `ethics` | Ethical considerations | `\noethics` | shown |
| `dataavailability` | Data availability statement | `\nodata` | shown |
| `contributions` | Author contributions (CRediT) | — (`\credit{Name}{roles}`, one paragraph) | hidden |
| `aideclaration` | Declaration of generative AI use | `\noaiuse`, or `\aiuse{tool}{purpose}` | shown |
| `acknowledgments` | Acknowledgments | — | hidden |

Use the 14 CRediT roles: <https://credit.niso.org/contributor-roles-defined/>. `\orcidlist` prints the ORCID list automatically.

## Command reference

| English | Spanish equivalent |
|---|---|
| `\articletitle`, `\secondtitle` | `\titulo`, `\titulosecundario` |
| `\addauthor{Name}{affil.}{ORCID}{e-mail}` | `\autor` |
| `\affiliation{n}{text}`, `\shortauthors`, `\dates{rec.}{acc.}{pub.}` | `\afiliacion`, `\autorescorto`, `\fechas` |
| `\volume`, `\issue`, `\period`, `\pubyear`, `\doi`, `\eissn` | `\volumen`, `\numero`, `\periodo`, `\anio`, `\doi`, `\eissn` |
| `\firstpage`, `\pagerange`, `\license`, `\journalname` | `\primerapagina`, `\paginas`, `\licencia`, `\revista` |
| `abstract` + `\keywords`, `spanishabstract` + `\spanishkeywords` | `abstract` + `\keywords`, `resumen` + `\palabrasclave` |
| `\anonymize`, `\note`, `\ownwork`, `\ownworkdata`, `\reproducedfrom`, `\adaptedfrom` | `\anonimo`, `\nota`, `\elaboracionpropia`, `\elaboracionpropiacon`, `\tomadode`, `\adaptadode` |
| `rcctable`, `rcclongtable`, `\rccheader`, `\rcch` | `rcctabla`, `rcctablalarga`, `\rccencabezado`, `\rcch` |
| `\noconflict`, `\nofunding`, `\noethics`, `\nodata`, `\noaiuse`, `\aiuse` | `\sinconflicto`, `\sinfinanciamiento`, `\sinetica`, `\sindatos`, `\sinusoia`, `\usoia` |
| `\credit`, `\orcidlist`, `\rccverification`, `\rccsetup` | `\credito`, `\rccorcid`, `\rccverificacion`, `\rccset` |
| `manuscript`, `proof`, `final`, `english`, `spanish`, `verify`, `frames`, `nolinenumbers` | `manuscrito`, `prueba`, `final`, `english`, `spanish`, `verificar`, `marcos`, `sinnumerolineas` |

## Fine tuning: `\rccsetup{key = value}`

Font sizes are written in pt **without unit**; lengths need their unit. As in Word, the space after one element and the space before the next are not added: the larger one is used (keywords 6 pt + heading 26 pt = 26 pt). Colours are changed with `\definecolor` (for example `\definecolor{rccazul}{HTML}{498CF1}`).

| English key | Spanish key | Default (Word template) |
|---|---|---|
| `paper width` | `ancho papel` | 210mm |
| `paper height` | `alto papel` | 297mm |
| `top margin` | `margen superior` | 2.5cm |
| `bottom margin` | `margen inferior` | 2.5cm |
| `left margin` | `margen izquierdo` | 2.5cm |
| `right margin` | `margen derecho` | 2.5cm |
| `header distance` | `distancia encabezado` | 1.5cm |
| `footer distance` | `distancia pie` | 1.5cm |
| `first page space` | `espacio primera pagina` | 0.42cm |
| `first page footer reduction` | `reduccion pie primera` | 0pt (extra manual adjustment; the space for the licence is calculated automatically) |
| `space above license` | `espacio sobre licencia` | 9.76pt (minimum gap between the text and the licence on page 1) |
| `text size` | `tam texto` | 10 |
| `line factor` | `factor linea` | 1.15 |
| `line spacing` | `interlineado` | 1 |
| `indent` | `sangria` | 0.53cm |
| `paragraph space` | `espacio parrafos` | 0pt |
| `indent first paragraph` | `sangria primer parrafo` | false |
| `title size` | `tam titulo` | 14 |
| `second title size` | `tam titulo secundario` | 12 |
| `title margin` | `margen titulo` | 1cm |
| `space after title` | `espacio tras titulo` | 12pt |
| `author size` | `tam autores` | 10 |
| `author space` | `espacio autores` | 12pt |
| `affiliation size` | `tam afiliacion` | 9.5 |
| `email size` | `tam correo` | 9 |
| `email space` | `espacio correo` | 12pt |
| `dates size` | `tam fechas` | 8 |
| `abstract size` | `tam resumen` | 9 |
| `abstract margin` | `margen resumen` | 1cm |
| `keywords space` | `espacio palabras clave` | 6pt |
| `space between abstracts` | `espacio entre resumenes` | 0pt |
| `abstract on new page` | `resumen en nueva pagina` | false |
| `max abstract words` | `max palabras resumen` | 150 |
| `max keywords` | `max palabras clave` | 5 |
| `section size` | `tam seccion` | 12 |
| `space before section` | `antes seccion` | 26pt |
| `space after section` | `despues seccion` | 14pt |
| `section number tab` | `tab seccion` | 0.8cm |
| `subsection size` | `tam subseccion` | 10.5 |
| `space before subsection` | `antes subseccion` | 26pt |
| `space after subsection` | `despues subseccion` | 14pt |
| `subsection number tab` | `tab subseccion` | 0.9cm |
| `subsubsection size` | `tam subsubseccion` | 10.5 |
| `space before subsubsection` | `antes subsubseccion` | 16pt |
| `space after subsubsection` | `despues subsubseccion` | 6pt |
| `subsubsection number tab` | `tab subsubseccion` | 1.27cm |
| `caption size` | `tam leyenda` | 9 |
| `caption space` | `espacio leyenda` | 6pt |
| `note size` | `tam nota` | 8 |
| `note space` | `espacio nota` | 4pt |
| `note required` | `nota obligatoria` | true |
| `figure note alignment` | `alineacion nota figura` | left (APA) \| centered |
| `bullet position` | `posicion vineta` | 0.63cm |
| `list indent` | `sangria lista` | 0.63cm |
| `list space` | `espacio lista` | 0pt |
| `item space` | `espacio item` | 0pt |
| `credit sentence` | `frase credit` | true |
| `show dates` | `mostrar fechas` | true |
| `table header size` | `tam tabla cabecera` | 9 |
| `table size` | `tam tabla` | 8 |
| `table row stretch` | `estiramiento tabla` | 1.7 |
| `cell padding` | `relleno celda` | 1mm |
| `table rule width` | `grosor linea tabla` | 0.5pt |
| `equation space` | `espacio ecuacion` | 6pt |
| `header size` | `tam encabezado` | 8 |
| `header line factor` | `factor linea cabecera` | 1.22 |
| `footer size` | `tam pie` | 8 |
| `logo width` | `ancho logo` | 4.99cm |
| `logo offset` | `ajuste logo` | 0.2cm |
| `logo raise` | `subir logo` | 6.5pt |
| `first page header shift` | `bajar cabecera primera` | 5.5pt |
| `first page header indent` | `sangria cabecera primera` | 0.19cm |
| `license margin` | `margen licencia` | 1cm |
| `bibliography size` | `tam bibliografia` | 10 |
| `bibliography indent` | `sangria bibliografia` | 1cm |
| `bibliography space` | `espacio bibliografia` | 0pt |
| `bibliography alignment` | `alineacion bibliografia` | left \| justified |
| `underline doi` | `subrayar doi` | true |
| `orcid size` | `tam orcid` | 10 |
| `orcid icon size` | `tam icono orcid` | 0.45cm |
| `logo file` | `archivo logo` | figuras/logo-rcc.pdf |
| `proof text` | `texto prueba` | RCC Proof |
| `proof opacity` | `opacidad prueba` | 0.12 |
| `thin stroke` | `grosor adelgazar` | 0.13pt (thinner grey running head and licence with Carlito; 0pt = off) |
| `float space` | `espacio flotantes` | 6pt (space between the text and a figure or table) |
