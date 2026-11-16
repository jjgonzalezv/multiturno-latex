# Plantilla LaTeX – Revista Colombiana de Computación (RCC)

Reproduce la plantilla oficial en Word de la RCC: tamaño A4, márgenes de 2,5 cm, encabezado y pie a 1,5 cm (como en los artículos publicados), Times New Roman de 10 pt con interlineado sencillo, los colores HEX del Word, los tamaños de los títulos y la sangría de 0,53 cm, que se omite en el primer párrafo de cada sección.

## Archivos

| Archivo | Uso |
|---|---|
| `rcc.cls` | Clase con el estilo. **Todos los parámetros editables están en la sección 2.** |
| `template-en.tex` | Plantilla para artículos en inglés, **con todos los comandos en inglés** (ver `README-en.md`) |
| `plantilla-es.tex` | Plantilla para artículos en español, con los comandos en español |
| `README-en.md` | Guía en inglés para autores |
| `rcc-apa.bst` | Estilo de referencias (APA, autor-año) |
| `referencias.bib` | Referencias de ejemplo, todas con DOI: deep learning, atención y metodología de la investigación (artículo, ponencia, capítulo de libro, libro con edición; siete en total). Los títulos van en minúscula de oración, con mayúscula después de dos puntos |
| `figuras/figura-ejemplo-en.pdf`, `figura-ejemplo-es.pdf` | Figura genérica de ejemplo, vectorial; su código TikZ editable está en `figuras/fuentes/` |
| `figuras/logo-rcc.pdf` | Logo oficial del banner, vectorial y recortado a su contenido (convertido de `logo-rcc.svg`, que también se incluye). Para cambiarlo, reemplace el archivo o use `\rccset{archivo logo = ...}`; su tamaño y posición se ajustan con `ancho logo`, `ajuste logo` y `subir logo` |

## Dos plantillas, una sola clase

La revista tiene **dos plantillas**: `plantilla-es.tex` para artículos en español y `template-en.tex` para artículos en inglés. Las dos usan la misma clase `rcc.cls`. Así el diseño (márgenes, colores, tamaños) se mantiene en un solo lugar y no hay que actualizar dos estilos.

El idioma se elige en la primera línea: `spanish` o `english` (el mismo nombre que usa `babel`). Esa opción cambia:

- las etiquetas del PDF: Figura/Figure, Tabla/Table, Nota/Note, Referencias/References, Recibido/Received, los títulos de las declaraciones…;
- la cita narrativa con dos autores: "y" o "and";
- las palabras de la lista de referencias:

| | Español | Inglés |
|---|---|---|
| Páginas | (págs. 5998–6008), pág. 12 | (pp. 5998–6008), p. 12 |
| Capítulo o ponencia | En *Título del libro* | In *Book title* |
| Edición (en el .bib: `edition = {5}`) | (5.ª ed.) | (5th ed.) |
| Informe técnico | (Informe técnico n.º X) | (Technical Report No. X) |
| Tesis | Tesis de maestría / Tesis doctoral | Master's thesis / Doctoral dissertation |

Un mismo archivo `.bib` sirve para los dos idiomas.

**Comandos en inglés:** todos los comandos, entornos, opciones y claves de ajuste tienen también un nombre en inglés. Hacen exactamente lo mismo. `template-en.tex` usa solo los nombres en inglés, y la tabla de equivalencias está en `README-en.md`. Algunos ejemplos:

| Español | Inglés |
|---|---|
| `manuscrito`, `prueba`, `verificar`, `marcos`, `sinnumerolineas` | `manuscript`, `proof`, `verify`, `frames`, `nolinenumbers` |
| `\rccset{...}` | `\rccsetup{...}` |
| `\titulo`, `\titulosecundario` | `\articletitle`, `\secondtitle` |
| `\autor`, `\afiliacion`, `\autorescorto`, `\fechas` | `\addauthor`, `\affiliation`, `\shortauthors`, `\dates` |
| `\volumen`, `\numero`, `\periodo`, `\anio`, `\primerapagina`, `\paginas`, `\licencia` | `\volume`, `\issue`, `\period`, `\pubyear`, `\firstpage`, `\pagerange`, `\license` |
| `\nota`, `\elaboracionpropia`, `\elaboracionpropiacon`, `\tomadode`, `\adaptadode` | `\note`, `\ownwork`, `\ownworkdata`, `\reproducedfrom`, `\adaptedfrom` |
| `rcctabla`, `rcctablalarga`, `\rccencabezado` | `rcctable`, `rcclongtable`, `\rccheader` |
| `conflicto`, `financiamiento`, `etica`, `datos`, `contribuciones`, `declaracionia`, `agradecimientos` | `conflictofinterest`, `funding`, `ethics`, `dataavailability`, `contributions`, `aideclaration`, `acknowledgments` |
| `resumen`, `\palabrasclave` | `spanishabstract`, `\spanishkeywords` |
| `\sinconflicto`, `\sinfinanciamiento`, `\sinetica`, `\sindatos`, `\sinusoia`, `\usoia` | `\noconflict`, `\nofunding`, `\noethics`, `\nodata`, `\noaiuse`, `\aiuse` |
| `\credito`, `\anonimo`, `\rccorcid`, `\rccverificacion`, `\revista` | `\credit`, `\anonymize`, `\orcidlist`, `\rccverification`, `\journalname` |

## Compilar

pdfLaTeX → BibTeX → pdfLaTeX → pdfLaTeX. En Overleaf basta con subir el .zip y compilar. También funciona con XeLaTeX, que usa Times New Roman y Calibri Light si están instaladas; si no, sus equivalentes métricos (TeX Gyre Termes y Carlito). En modo manuscrito los números de línea necesitan una pasada más de LaTeX (Overleaf y latexmk la hacen solos).

## Versión manuscrito (anónima), prueba y versión final

Solo se cambia la primera línea del documento:

```latex
\documentclass[manuscrito,spanish]{rcc}   % primer envío, revisión doble ciego
\documentclass[prueba,spanish]{rcc}       % prueba de diagramación para el autor
\documentclass[final,spanish]{rcc}        % versión para publicar
```

La versión **prueba** (en inglés, `proof`) es idéntica a la final, pero cada página lleva en diagonal la marca de agua semitransparente "RCC Proof", como las pruebas de IEEE. Sirve para que el autor revise los ajustes editoriales e indique cualquier discrepancia antes de publicar. El texto y la transparencia se cambian con `\rccset{texto prueba = RCC Proof, opacidad prueba = 0.12}`.

Los autores escriben todos sus datos desde el principio (`\autor`, `\afiliacion`, agradecimientos…). En modo **manuscrito** el PDF:

- muestra "Autores anónimos – manuscrito en revisión" en lugar de los autores ("Anonymous author(s) – manuscript under review" en inglés), y oculta afiliaciones, correos, ORCID y los metadatos de autor del PDF;
- oculta las fechas de recibido, aceptado y publicado, que **solo aparecen en la versión final**. Si hace falta ocultarlas también en la final (por ejemplo, en una prueba de diagramación antes de la aceptación), se usa `\rccset{mostrar fechas = false}`;
- reemplaza financiamiento, contribuciones y agradecimientos por "[Información omitida para la revisión anónima]";
- cambia lo que se escriba dentro de `\anonimo{...}` (por ejemplo autocitas o proyectos) por "[anonimizado]" ("[anonymized]" en inglés);
- quita del encabezado el volumen, el DOI y la licencia, y numera las líneas para los revisores. Para no numerarlas se añade la opción `sinnumerolineas`.

## Datos editoriales y paginación (los diligencia la revista)

En el bloque 3 de cada plantilla:

```latex
\volumen{27}  \numero{1}  \periodo{January -- June}  \anio{2026}
\doi{10.29375/25392115.5326}
\primerapagina{45}     % página inicial según el consecutivo del número (por defecto 1)
% \paginas{45-66}      % opcional: fijar el rango a mano
```

- **Primera página (banner):** a la izquierda van la revista, el volumen, el número, el periodo, el año, "pp. 45-66", el e-ISSN y el DOI como hipervínculo; a la derecha, el logo. Los correos (`mailto:`) y los íconos ORCID enlazan al perfil de cada autor. En el pie va la licencia Creative Commons con su enlace, **sin número de página**.
- **Espacio sobre la licencia:** como en Word, el pie de la primera página crece hacia arriba. La plantilla mide la licencia, cuyas líneas dependen del texto y de la fuente, y acorta el texto de esa página para dejar como mínimo 9,76 pt, el párrafo vacío de 8 pt con que empieza el pie en el Word de la revista. Como la página solo admite líneas completas, el hueco real queda entre una y dos líneas según el artículo. Se ajusta con `\rccset{espacio sobre licencia = 9.76pt}`.
- **Cornisa larga:** si hay muchos autores y la cornisa ocupa dos líneas, la primera se queda en su sitio y la segunda crece hacia abajo, hacia el texto, como en Word. El texto no se mueve.
- **Páginas siguientes:** llevan la cornisa centrada ("P. Jimbo, E. Melchor, M. Jimbo / Revista Colombiana de Computación, Vol. 27, No. 1, 2026, pp. 45-66") y el número de página en el pie, que sigue el consecutivo: 46, 47…
- La última página del rango se calcula sola. Las páginas del visor de PDF también se numeran 45, 46…

## Límites del resumen y las palabras clave

- **Resumen y abstract:** máximo **150 palabras** cada uno.
- **Palabras clave y keywords:** máximo **5**, separadas por comas.

LaTeX cuenta las palabras al compilar. Si se pasa de un límite, muestra un aviso en el registro, por ejemplo "Abstract: 163 palabras (máximo 150)", y también si una figura o tabla no tiene nota. Con la opción `verificar`, la página de control incluye los conteos con la marca OK o EXCEDE. Los límites se cambian con `\rccset{max palabras resumen = 150, max palabras clave = 5}`.

## Ajustar el estilo

En el preámbulo:

```latex
\rccset{interlineado = 1.15, sangria = 0.6cm, margen izquierdo = 3cm, tam seccion = 12}
\definecolor{rccazul}{HTML}{498CF1}
```

Los tamaños se escriben en pt **sin unidad**. Las longitudes llevan su unidad. El espacio entre el texto y una figura o tabla se cambia con `espacio flotantes` (6 pt, como en Word), y el adelgazamiento del gris de la cornisa y la licencia con `grosor adelgazar` (0 pt lo desactiva). Como en Word, el espacio "después" de un elemento y el "antes" del siguiente no se suman: se usa el mayor (palabras clave 6 pt + título 26 pt = 26 pt; título de nivel 1 con 14 pt después + título de nivel 2 con 26 pt antes = 26 pt). Si el cambio es para todos los artículos de la revista, edite los valores por defecto en `rcc.cls` (sección 2).

## Verificar las medidas

La opción `verificar` (`\documentclass[final,spanish,verificar]{rcc}`) añade al final una página con los valores reales que usa LaTeX: tamaño de página, márgenes, sangría, tamaño e interlineado de cada elemento y colores. Cada valor aparece junto al del Word con la marca **OK** o **DIFIERE**. Esa página no cuenta en el rango de páginas. La opción `marcos` dibuja los márgenes y las zonas del encabezado y del pie.

## Estilo de citación y referencias: APA 7.ª edición

La plantilla Word usa APA 7 (`StyleName="APA7"` en su gestor de referencias). La plantilla LaTeX lo reproduce con `natbib` y `rcc-apa.bst`:

| Comando | Resultado |
|---|---|
| `\citep{hochreiter1997}` | (Hochreiter & Schmidhuber, 1997) — en español: (Hochreiter y Schmidhuber, 1997) |
| `\citep{lecun2015, schmidhuber2015}` | (LeCun et al., 2015; Schmidhuber, 2015) |
| `\citep[p.~90]{schmidhuber2015}` | (Schmidhuber, 2015, p. 90) |
| `\citet{hochreiter1997}` | Hochreiter and Schmidhuber (1997) — en español: "Hochreiter y Schmidhuber (1997)" |
| `\citet{hevner2004}` | Hevner et al. (2004) |

Las reglas APA 7 que se aplican:

- dos autores: en inglés, "&" entre paréntesis y "and" en la cita narrativa; en español, "y" en los dos casos (nunca "&");
- "et al." desde tres autores;
- en la lista, todos los autores; antes del último, ", &" en inglés y ", y" en español (Rodríguez, A., Pérez, J., y Gómez, M.); en las citas del texto no hay coma: (Gómez y López, 2020);
- títulos en minúscula de oración;
- revista y volumen en cursiva, (número), páginas y DOI como `https://doi.org/...`;
- ediciones como "(2nd ed.)": en el .bib se escribe solo el número (`edition = {2}`), y la plantilla pone "2nd ed." o "2.ª ed." según el idioma.

El color de las citas es negro, como en el Word. Hay dos formas de citar: **(Autor, año)** con `\citep{clave}` o `\citaparentesis{clave}`, y **Autor (año)** con `\citet{clave}` o `\citanarrativa{clave}`.

### Presentación de la bibliografía

Igual que en el Word: 10 pt, sangría francesa de 1 cm, sin espacio entre referencias, alineada a la izquierda, y los DOI/URL en azul #85B2F6 subrayados (estilo Hipervínculo). Todo se puede cambiar:

```latex
\rccset{
  sangria bibliografia    = 1cm,        % sangría francesa
  espacio bibliografia    = 0pt,        % espacio entre referencias
  alineacion bibliografia = justificada,% izquierda (Word) | justificada
  subrayar doi            = true,       % false = sin subrayado
  tam bibliografia        = 10,
}
\definecolor{rccdoi}{HTML}{85B2F6}     % color de DOI/URL
```

Un URL subrayado no se puede partir entre líneas. Si alguno es demasiado largo, use `subrayar doi = false`.

## Tablas

`rcctabla` (en inglés, `rcctable`) aplica el estilo de la revista. Las celdas van **centradas verticalmente**, como en el Word (`vAlign center`): si una celda ocupa varias líneas, las demás de la fila se centran respecto a ella, también en la cabecera. Columnas disponibles, todas de ancho automático: `L` (izquierda), `C` (centro), `R` (derecha) y `X`. Para anchos distintos se usa, por ejemplo, `>{\hsize=.6\hsize}L`.

### Tablas largas (continúan en la página siguiente)

La tabla normal (`table` + `rcctabla`) no se puede partir. Si no cabe en lo que queda de página, salta entera a la siguiente y deja un hueco. Para tablas largas se usa `rcctablalarga` (en inglés, `rcclongtable`). Se divide entre páginas por las filas y **repite la fila azul de encabezado** en cada página, como "Repetir como fila de encabezado" en Word:

```latex
\begin{rcctablalarga}{Leyenda de la tabla}{tab:larga}{P{.2}P{.3}P{.25}P{.25}}
  {\rcch{Columna 1} & \rcch{Columna 2} & \rcch{Columna 3} & \rcch{Columna 4}}
  Fila 1 & texto & texto & texto \\ \hline
  Fila 2 & texto & texto & texto \\ \hline
\end{rcctablalarga}
\nota{\elaboracionpropia}
```

- **Dónde va:** directamente en el texto, **no** dentro de `\begin{table}`. La leyenda y la etiqueta van como argumentos.
- **Columnas:** `P{fracción}` (izquierda) o `Q{fracción}` (centro), como fracción del ancho del texto; deben sumar 1.
- **Estilo:** el mismo de `rcctabla`: cabecera azul, celdas centradas verticalmente y líneas azul claro. Las filas no se parten por la mitad.

## Notas de tablas y figuras: autoría o fuente (APA 7)

Cada tabla y figura lleva debajo una nota a 8 pt que empieza con *Note.* (*Nota.* en español) en cursiva. Esa palabra va en el mismo azul (#85B2F6) que las etiquetas "Tabla 1." y "Figura 1."; el color se cambia con `\definecolor{rccnota}{HTML}{...}`.

```latex
\begin{figure}[H] \centering
  \includegraphics[width=.75\textwidth]{figuras/mi-figura.pdf}
  \caption{Título de la figura}\label{fig:x}
  \nota{\elaboracionpropia}
\end{figure}
```

| Caso | Comando | Resultado (ES / EN) |
|---|---|---|
| Elaborada por los autores | `\nota{\elaboracionpropia}` | Nota. Elaboración propia. / Note. Created by the authors. |
| Propia con datos de terceros | `\nota{\elaboracionpropiacon{\citet{x}}}` | Nota. Elaboración propia con base en datos de Autor (año). |
| Reproducida sin cambios | `\nota{\tomadode{\citet{x}}}` | Nota. Tomado de Autor (año). |
| Modificada | `\nota{\adaptadode{\citet{x}}}` | Nota. Adaptado de Autor (año). |

- Se puede añadir texto antes de la autoría: `\nota{MSE = error cuadrático medio. \elaboracionpropia}`.
- En la tabla la nota va después de `\end{rcctabla}`; en la figura, después de `\caption`.
- Si una figura o tabla no tiene `\nota`, LaTeX muestra un aviso en el registro de compilación. Se desactiva con `nota obligatoria = false`.
- Según APA 7, cuando la tabla o figura es de otra fuente, esa fuente también debe estar en la lista de referencias. Con `\citet` dentro de la nota se incluye sola. Si el material tiene derechos de autor, se añade el permiso o la licencia en la misma nota, por ejemplo "CC BY 4.0".
- Tamaño, espacio y alineación: `\rccset{tam nota = 8, espacio nota = 4pt, alineacion nota figura = izquierda}`. En las figuras, la nota va a la izquierda como indica APA; con `centrada` queda bajo la leyenda centrada.

## Listas con viñetas y numeradas

Siguen el formato de párrafo del Word de la revista:

- la viñeta va a 0,63 cm del margen y el texto, incluidas sus líneas siguientes, a 1,27 cm (sangría de 0,63 cm más francesa de 0,63 cm);
- alineación justificada, 0 pt antes y después, e interlineado sencillo;
- cada nivel anidado se desplaza otros 0,63 cm.

Se usan los entornos normales `itemize` y `enumerate`. Los valores se cambian con `\rccset{posicion vineta = 0.63cm, sangria lista = 0.63cm, espacio lista = 0pt, espacio item = 0pt}` (`posicion vineta` va del margen a la viñeta y `sangria lista` de la viñeta al texto).

## Declaraciones finales

Siguen la práctica de Elsevier, Springer Nature/BMC, MDPI e IEEE, y las guías de COPE. Van después de las conclusiones y antes de ORCID y de las referencias:

| Entorno | Título (EN / ES) | Texto estándar si no aplica | En modo manuscrito |
|---|---|---|---|
| `conflicto` | Conflict of interest statement / Declaración de conflicto de intereses | `\sinconflicto` | se muestra |
| `financiamiento` | Funding / Financiamiento | `\sinfinanciamiento` | **se oculta** |
| `etica` | Ethical considerations / Consideraciones éticas | `\sinetica` | se muestra |
| `datos` | Data availability statement / Disponibilidad de datos | `\sindatos` | se muestra |
| `contribuciones` | Author contributions (CRediT) / Contribución de los autores (CRediT) | — (`\credito{Nombre}{roles}`) | **se oculta** |
| `declaracionia` | Declaration of generative AI use / Declaración de uso de inteligencia artificial generativa | `\sinusoia`, o `\usoia{herramienta}{propósito}` | se muestra |
| `agradecimientos` | Acknowledgments / Agradecimientos | — | **se oculta** |

- Si una declaración no aplica, se conserva el título y se usa el texto estándar ("No aplica…"), como piden Springer Nature y BMC.
- **IA:** se declaran la herramienta, el propósito y la supervisión humana; la IA no puede ser autora (COPE). La revisión básica de ortografía no requiere declaración (Elsevier, IEEE). Si la IA se usó *en la investigación*, se describe en la metodología.
- **Contribuciones:** usan los 14 roles de la taxonomía CRediT. Las plantillas los traen listados en inglés y en español. El PDF abre la sección con una frase y el enlace a las definiciones (https://credit.niso.org/contributor-roles-defined/); se quita con `frase credit = false`. El comando `\rcccredit` escribe "CRediT taxonomy" o "taxonomía CRediT" con el enlace, por si se quiere usar en otro lugar.
  - EN: Conceptualization, Data curation, Formal analysis, Funding acquisition, Investigation, Methodology, Project administration, Resources, Software, Supervision, Validation, Visualization, Writing – original draft, Writing – review & editing.
  - ES: Conceptualización, Curación de datos, Análisis formal, Adquisición de fondos, Investigación, Metodología, Administración del proyecto, Recursos, Software, Supervisión, Validación, Visualización, Redacción – borrador original, Redacción – revisión y edición.
- **Ética:** se indica el comité, el código y la fecha de aprobación, y el consentimiento informado.
- **Modo manuscrito:** en las declaraciones que se muestran a los revisores, cualquier nombre que identifique (comité, institución, repositorio propio) se envuelve en `\anonimo{...}`.
