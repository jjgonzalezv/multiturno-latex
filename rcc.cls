%% =====================================================================
%%  rcc.cls  --  Clase LaTeX para la Revista Colombiana de Computación
%%  Reproduce la plantilla oficial en Word (RCC, e-ISSN 2539-2115).
%%
%%  Versión: 1.2 (2026-10-24)
%%  Compila con: pdfLaTeX o XeLaTeX (+ BibTeX con rcc-apa.bst)
%%  Plantillas: plantilla-es.tex (comandos en español)
%%              template-en.tex  (comandos en inglés, sección 15)
%%
%%  OPCIONES DE LA CLASE (\documentclass[<opciones>]{rcc})   [en inglés]
%%    manuscrito       [manuscript]    PRIMER ENVÍO, anónimo (doble ciego):
%%                     oculta autores, afiliaciones, correos, ORCID, fechas,
%%                     financiamiento, contribuciones, agradecimientos y
%%                     datos del número; numera las líneas.
%%    final            [final]         Versión para PUBLICAR (por defecto).
%%    prueba           [proof]         Igual a la final, con la marca de agua
%%                                     "RCC Proof" en cada página, para que el
%%                                     autor revise la diagramación.
%%    spanish          [spanish]       Artículo en español ("espanol" también
%%                                     se acepta, por compatibilidad).
%%    english          [english]       Artículo en inglés (por defecto).
%%    verificar        [verify]        Página final que mide todos los
%%                                     parámetros y los compara con el Word.
%%    marcos           [frames]        Dibuja márgenes, cabecera y pie.
%%    sinnumerolineas  [nolinenumbers] Manuscrito sin números de línea.
%%
%%  AJUSTES FINOS: \rccset{clave = valor} (claves en español, sección 2)
%%                 \rccsetup{key = value} (claves en inglés, sección 15).
%% =====================================================================
\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{rcc}[2026/10/24 v1.2 Revista Colombiana de Computacion]

%% ---------------------------------------------------------------------
%% 1. OPCIONES
%% ---------------------------------------------------------------------
\newif\ifrcc@manuscrito   \rcc@manuscritofalse
\newif\ifrcc@espanol      \rcc@espanolfalse
\newif\ifrcc@verificar    \rcc@verificarfalse
\newif\ifrcc@marcos       \rcc@marcosfalse
\newif\ifrcc@numlineas    \rcc@numlineastrue
\newif\ifrcc@prueba       \rcc@pruebafalse

\DeclareOption{manuscrito}{\rcc@manuscritotrue}
\DeclareOption{manuscript}{\rcc@manuscritotrue}
\DeclareOption{final}{\rcc@manuscritofalse}
\DeclareOption{prueba}{\rcc@manuscritofalse\rcc@pruebatrue}
\DeclareOption{proof}{\rcc@manuscritofalse\rcc@pruebatrue}
\DeclareOption{espanol}{\rcc@espanoltrue}
\DeclareOption{spanish}{\rcc@espanoltrue}
\DeclareOption{english}{\rcc@espanolfalse}
\DeclareOption{verificar}{\rcc@verificartrue}
\DeclareOption{verify}{\rcc@verificartrue}
\DeclareOption{frames}{\rcc@marcostrue}
\DeclareOption{nolinenumbers}{\rcc@numlineasfalse}
\DeclareOption{marcos}{\rcc@marcostrue}
\DeclareOption{sinnumerolineas}{\rcc@numlineasfalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
%% Las opciones de idioma no se pasan a los paquetes: babel recibe abajo el
%% idioma principal de forma explícita (si no, "spanish"/"english" de la clase
%% cambiaría cuál es el idioma principal).
\@expandtwoargs\@removeelement{spanish}\@classoptionslist\@classoptionslist
\@expandtwoargs\@removeelement{english}\@classoptionslist\@classoptionslist
\@expandtwoargs\@removeelement{espanol}\@classoptionslist\@classoptionslist

\LoadClass[10pt]{article}

%% ---------------------------------------------------------------------
%% Paquetes base
%% ---------------------------------------------------------------------
\RequirePackage{iftex}
\RequirePackage{etoolbox}
\RequirePackage{pgfkeys}
\RequirePackage{calc}
\RequirePackage{geometry}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{amsmath,amssymb}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{caption}
\RequirePackage{float}
\RequirePackage{array,tabularx,multirow}
\RequirePackage{longtable}   % tablas largas que se dividen entre páginas
\RequirePackage{enumitem}
\RequirePackage{lastpage}
\RequirePackage[authoryear,round]{natbib}
\RequirePackage{xurl}
\RequirePackage{lineno}
\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
\fi
\let\rcc@sinsangriatras\@afterindentfalse   % original de LaTeX (antes de babel)
%% Idiomas: se usa spanish.ldf si existe; si no, el archivo .ini de babel.
%% es-nolayout: babel no cambia el diseño (sin sangría en el primer párrafo
%% tras un título, listas y numeración romana como en el Word).
\IfFileExists{spanish.ldf}
  {\ifrcc@espanol
     \RequirePackage[english,spanish,es-noshorthands,es-nodecimaldot,es-nolayout]{babel}
   \else
     \RequirePackage[spanish,es-noshorthands,es-nodecimaldot,es-nolayout,english]{babel}
   \fi}
  {\ifrcc@espanol
     \RequirePackage[english]{babel}\babelprovide[import,main]{spanish}
   \else
     \RequirePackage[english]{babel}\babelprovide[import]{spanish}
   \fi}
%% El estilo español de babel pone sangría al primer párrafo tras un título;
%% la RCC no (como en el Word). Se restaura el comportamiento de LaTeX.
\AtBeginDocument{\let\@afterindentfalse\rcc@sinsangriatras}
%% Solo protrusión: la expansión de fuente estira las letras (10 pt pasaba a
%% 9.9/10.1 pt, 14 pt a 13.8 pt) y Word no lo hace.
\RequirePackage[protrusion=true,expansion=false]{microtype}

%% ---------------------------------------------------------------------
%% 2. PARÁMETROS EDITABLES  (valores medidos de la plantilla Word)
%%    Tamaños de letra: número en puntos (pt), SIN unidad.
%%    Longitudes: CON unidad (cm, mm, pt).
%% ---------------------------------------------------------------------
\newif\ifrcc@sangriaprimero
\newif\ifrcc@subrayardoi
\newif\ifrcc@notaobligatoria
\newif\ifrcc@fraseCredit
\newif\ifrcc@mostrarfechas
\newif\ifrcc@haynota
\newif\ifrcc@tablalarga
\newif\ifrcc@resumennuevapagina
\pgfkeys{/rcc/.is family, /rcc,
  % --- Página --------------------------------------------------------
  ancho papel/.store in       = \rcc@anchopapel,     % A4
  alto papel/.store in        = \rcc@altopapel,
  margen superior/.store in   = \rcc@msup,
  margen inferior/.store in   = \rcc@minf,
  margen izquierdo/.store in  = \rcc@mizq,
  margen derecho/.store in    = \rcc@mder,
  distancia encabezado/.store in = \rcc@dcab,        % borde -> encabezado
  distancia pie/.store in     = \rcc@dpie,           % borde -> pie
  espacio primera pagina/.store in = \rcc@espprimera,% bajo la cabecera de pág. 1
  reduccion pie primera/.store in  = \rcc@redpie,    % ajuste manual extra (se suma)
  espacio sobre licencia/.store in = \rcc@esplic,    % texto -> licencia en la pág. 1
  % --- Texto ---------------------------------------------------------
  tam texto/.store in         = \rcc@tamtexto,
  factor linea/.store in      = \rcc@factorlinea,    % interlineado "sencillo" de Word
  interlineado/.store in      = \rcc@interlineado,   % multiplicador (1 = sencillo)
  sangria/.store in           = \rcc@sangria,
  espacio parrafos/.store in  = \rcc@espparrafos,
  sangria primer parrafo/.is if = rcc@sangriaprimero,
  % --- Bloque de título ----------------------------------------------
  tam titulo/.store in        = \rcc@tamtitulo,
  tam titulo secundario/.store in = \rcc@tamtitulob,
  margen titulo/.store in     = \rcc@margentitulo,
  espacio tras titulo/.store in = \rcc@esptitulo,
  tam autores/.store in       = \rcc@tamautores,
  espacio autores/.store in   = \rcc@espautores,
  tam afiliacion/.store in    = \rcc@tamafil,
  tam correo/.store in        = \rcc@tamcorreo,
  espacio correo/.store in    = \rcc@espcorreo,
  tam fechas/.store in        = \rcc@tamfechas,
  % --- Resumen -------------------------------------------------------
  tam resumen/.store in       = \rcc@tamresumen,
  margen resumen/.store in    = \rcc@margenresumen,
  espacio palabras clave/.store in = \rcc@esppclave,
  espacio entre resumenes/.store in = \rcc@espresumenes,
  resumen en nueva pagina/.is if = rcc@resumennuevapagina,
  max palabras resumen/.store in = \rcc@maxresumen,   % límite de palabras del resumen
  max palabras clave/.store in   = \rcc@maxpclave,    % número máximo de palabras clave
  % --- Títulos de sección --------------------------------------------
  tam seccion/.store in       = \rcc@tamsec,
  antes seccion/.store in     = \rcc@antessec,
  despues seccion/.store in   = \rcc@despsec,
  tab seccion/.store in       = \rcc@tabsec,
  tam subseccion/.store in    = \rcc@tamsubsec,
  antes subseccion/.store in  = \rcc@antessubsec,
  despues subseccion/.store in= \rcc@despsubsec,
  tab subseccion/.store in    = \rcc@tabsubsec,
  tam subsubseccion/.store in = \rcc@tamsubsubsec,
  antes subsubseccion/.store in = \rcc@antessubsubsec,
  despues subsubseccion/.store in = \rcc@despsubsubsec,
  tab subsubseccion/.store in = \rcc@tabsubsubsec,
  % --- Figuras, tablas, ecuaciones -----------------------------------
  tam leyenda/.store in       = \rcc@tamleyenda,
  tam nota/.store in          = \rcc@tamnota,        % nota bajo tablas/figuras
  posicion vineta/.store in   = \rcc@posvineta,      % margen -> viñeta (0.63 cm)
  sangria lista/.store in     = \rcc@sanglista,      % viñeta -> texto (francesa 0.63 cm)
  espacio lista/.store in     = \rcc@esplista,       % antes/después de la lista
  espacio item/.store in      = \rcc@espitem,        % entre elementos
  espacio nota/.store in      = \rcc@espnota,
  nota obligatoria/.is if     = rcc@notaobligatoria, % aviso si falta \nota
  frase credit/.is if         = rcc@fraseCredit,      % frase + enlace CRediT
  mostrar fechas/.is if       = rcc@mostrarfechas,    % recibido/aceptado/publicado
  alineacion nota figura/.store in = \rcc@alinnotafig, % izquierda (APA) | centrada  [left | centered]
  espacio leyenda/.store in   = \rcc@espleyenda,
  tam tabla cabecera/.store in= \rcc@tamtablacab,
  tam tabla/.store in         = \rcc@tamtabla,
  estiramiento tabla/.store in= \rcc@estirtabla,
  relleno celda/.store in     = \rcc@rellenocelda,
  grosor linea tabla/.store in= \rcc@grosortabla,
  espacio ecuacion/.store in  = \rcc@especuacion,
  % --- Encabezado / pie / bibliografía -------------------------------
  tam encabezado/.store in    = \rcc@tamcab,
  factor linea cabecera/.store in = \rcc@factorcab,  % Calibri: sencillo = 1.22
  tam pie/.store in           = \rcc@tampie,
  ancho logo/.store in        = \rcc@ancholog,
  ajuste logo/.store in       = \rcc@ajustelogo,     % separación desde el margen derecho
  subir logo/.store in        = \rcc@subirlogo,      % logo por encima de la 1.ª línea del banner
  bajar cabecera primera/.store in = \rcc@bajacab,   % ajuste vertical cabecera pág. 1
  sangria cabecera primera/.store in = \rcc@sangriacab, % margen de celda en Word
  margen licencia/.store in   = \rcc@margenlic,
  tam bibliografia/.store in  = \rcc@tambib,
  sangria bibliografia/.store in = \rcc@sangriabib,
  espacio bibliografia/.store in = \rcc@espbib,
  alineacion bibliografia/.store in = \rcc@alinbib,  % izquierda | justificada  [left | justified]
  subrayar doi/.is if = rcc@subrayardoi,             % subrayado de DOI/URL
  tam orcid/.store in         = \rcc@tamorcid,
  grosor adelgazar/.store in  = \rcc@grosoradelg,   % Carlito -> aspecto Calibri Light
  espacio flotantes/.store in = \rcc@espflotantes,  % texto <-> figura/tabla [H]
  tam icono orcid/.store in   = \rcc@tamorcidicono,
  archivo logo/.store in      = \rcc@archivologo,
  texto prueba/.store in      = \rcc@textoprueba,
  opacidad prueba/.store in   = \rcc@opacidadprueba,
}
\newcommand\rccset[1]{\pgfkeys{/rcc,#1}}

%%  Valores por defecto = plantilla Word (1 twip = 1/20 pt; 567 twips = 1 cm)
\rccset{
  ancho papel = 210mm,  alto papel = 297mm,        % w:pgSz 11907 x 16840
  margen superior = 2.5cm, margen inferior = 2.5cm, % w:pgMar 1418
  margen izquierdo = 2.5cm, margen derecho = 2.5cm,
  distancia encabezado = 1.5cm, distancia pie = 1.5cm,  % 851 twips (artículos publicados 2026)
  espacio primera pagina = 0.42cm,  % título a ~29 pt del banner, como en Word con encabezado de 1.5 cm
  reduccion pie primera = 0pt,     % el espacio para la licencia se calcula solo
  espacio sobre licencia = 9.76pt, % = párrafo vacío de 8 pt con que empieza el pie en Word
  tam texto = 10,               % Normal: Times New Roman 10 pt
  factor linea = 1.15,          % "Sencillo" en Word con Times New Roman = 1.15 x tamaño
  interlineado = 1,             % 1 = sencillo (w:line=240); 1.5, 2 ...
  sangria = 0.53cm,             % w:firstLine = 301 twips
  espacio parrafos = 0pt,       % w:after = 0
  sangria primer parrafo = false, % 1er párrafo de cada sección SIN sangría
  tam titulo = 14,  tam titulo secundario = 12,
  margen titulo = 1cm,          % w:ind 567 izquierda/derecha
  espacio tras titulo = 12pt,   % w:after 240
  tam autores = 10, espacio autores = 12pt,
  tam afiliacion = 9.5,         % w:sz 19
  tam correo = 9, espacio correo = 12pt,
  tam fechas = 8,
  tam resumen = 9, margen resumen = 1cm, espacio palabras clave = 6pt,
  espacio entre resumenes = 0pt,   % Word: antes 0 pt; manda el mayor (6 pt de las palabras clave)
  resumen en nueva pagina = false,
  max palabras resumen = 150, max palabras clave = 5,
  tam seccion = 12,    antes seccion = 26pt,    despues seccion = 14pt,    tab seccion = 0.5cm,
  tam subseccion = 10.5, antes subseccion = 26pt, despues subseccion = 14pt, tab subseccion = 0.75cm,
  tam subsubseccion = 10.5, antes subsubseccion = 16pt, despues subsubseccion = 6pt, tab subsubseccion = 1.03cm,
  tam leyenda = 9,  espacio leyenda = 6pt,
  tam nota = 8, espacio nota = 4pt, nota obligatoria = true,
  posicion vineta = 0.63cm, sangria lista = 0.63cm, espacio lista = 0pt, espacio item = 0pt,
  frase credit = true,
  mostrar fechas = true,   % solo en versión final; en manuscrito siempre se ocultan
  alineacion nota figura = izquierda,
  tam tabla cabecera = 9, tam tabla = 8,
  estiramiento tabla = 1.7, relleno celda = 1mm, grosor linea tabla = 0.5pt,
  espacio ecuacion = 6pt,
  tam encabezado = 8, tam pie = 8, factor linea cabecera = 1.22,
  grosor adelgazar = 0pt,   % 0pt = Carlito sin adelgazar
  espacio flotantes = 6pt,     % Word: texto -> figura 8.1 pt, texto -> leyenda de tabla 16.6 pt
  ancho logo = 4.99cm, ajuste logo = 0.2cm,   % ancho del dibujo (logo-rcc.pdf recortado, sin márgenes)
  subir logo = 6.5pt,                         % círculos 6 pt por encima del texto del banner, como en Word
  texto prueba = RCC Proof, opacidad prueba = 0.12,   % marca de agua (opción prueba)
  bajar cabecera primera = 5.5pt, sangria cabecera primera = 0.19cm, margen licencia = 1cm,
  tam bibliografia = 10, sangria bibliografia = 1cm, espacio bibliografia = 0pt,
  alineacion bibliografia = izquierda,  % Word: alineado a la izquierda (w:jc left)
  subrayar doi = true,                  % como en Word; false si un URL muy largo no cabe en la línea
  tam orcid = 10, tam icono orcid = 0.45cm,   % igual al cuerpo (Word: 9 pt e ícono 0.423 cm)
  archivo logo = figuras/logo-rcc.pdf,  % vectorial (convertido de logo-rcc.svg)
}

%% ---------------------------------------------------------------------
%% 3. COLORES  (valores HEX exactos del Word; redefinibles con \definecolor)
%% ---------------------------------------------------------------------
\definecolor{rccazul}{HTML}{498CF1}       % título, sección, "Abstract."
\definecolor{rccazulclaro}{HTML}{85B2F6}  % título 2.º idioma, subsección, leyendas,
                                          % correos, enlaces, cabecera de tabla
\definecolor{rccazulsubsub}{HTML}{85B2F6} % nivel 3 de numeración (igual al nivel 2 en los artículos)
\definecolor{rccgris}{HTML}{808080}       % encabezado y licencia
\definecolor{rccpagina}{HTML}{7F8FA9}     % número de página
\definecolor{rcctexto}{HTML}{000000}      % texto
\definecolor{rcctablafondo}{HTML}{85B2F6} % relleno cabecera de tabla
\definecolor{rcctablatexto}{HTML}{FFFFFF} % texto cabecera de tabla
\definecolor{rcctablalinea}{HTML}{85B2F6} % líneas de tabla
\definecolor{rccnumecuacion}{HTML}{85B2F6}% número de ecuación
\definecolor{rcccita}{HTML}{000000}       % citas (Autor, año)
\definecolor{rccdoi}{HTML}{85B2F6}        % DOI y URL de las referencias (estilo Hipervínculo)
\definecolor{rccnota}{HTML}{85B2F6}       % palabra "Nota." bajo tablas y figuras (= etiquetas)
\definecolor{rcclogo1}{HTML}{4F7DB9}
\definecolor{rcclogo2}{HTML}{6197DF}
\definecolor{rcclogo3}{HTML}{D9D9D9}

%% ---------------------------------------------------------------------
%% 4. FUENTES
%%    Texto: Times New Roman   |   Encabezado/pie: Calibri Light
%%    Se usan las fuentes originales si están instaladas; si no, clones
%%    métricamente equivalentes (TeX Gyre Termes / newtx; Carlito).
%% ---------------------------------------------------------------------
%% Carlito solo existe en peso Regular; Calibri Light (Word) tiene el trazo
%% más fino. Con Carlito, la cornisa, la licencia y el número de página se
%% adelgazan: el texto se rellena en su color y se contornea en blanco con un
%% trazo fino ("grosor adelgazar"), que recorta el borde de cada letra. Así se
%% conserva el gris exacto del Word (#808080) con un trazo como el de la
%% versión Light. pdfLaTeX y LuaLaTeX: paquete pdfrender; con
%% XeLaTeX, que pdfrender no admite, se hace lo mismo con \special.
\newif\ifrcc@carlito
\ifPDFTeX
  \IfFileExists{newtxtext.sty}
    {\RequirePackage{newtxtext}\RequirePackage{newtxmath}}
    {\RequirePackage{mathptmx}\renewcommand\ttdefault{pcr}}
  \IfFileExists{carlito.sty}
    {\RequirePackage[lf]{carlito}\renewcommand{\familydefault}{\rmdefault}%
     \rcc@carlitotrue
     \newcommand\rcc@fuentecab{\fontfamily{Crlt-LF}\selectfont}}
    {\RequirePackage[scaled=0.92]{helvet}%
     \newcommand\rcc@fuentecab{\sffamily}}
\else
  \IfFileExists{newtxmath.sty}{\RequirePackage{newtxmath}}{\RequirePackage{mathptmx}}
  \RequirePackage[no-math]{fontspec}
  \IfFontExistsTF{Times New Roman}{\setmainfont{Times New Roman}}
    {\IfFontExistsTF{TeX Gyre Termes}{\setmainfont{TeX Gyre Termes}}
      {\IfFontExistsTF{Liberation Serif}{\setmainfont{Liberation Serif}}{}}}
  \IfFontExistsTF{Calibri Light}{\newfontfamily\rcc@fuentecab{Calibri Light}}
    {\IfFontExistsTF{Carlito}{\newfontfamily\rcc@fuentecab{Carlito}[Ligatures={TeX,NoCommon}]\rcc@carlitotrue}
      {\IfFontExistsTF{Liberation Sans}{\newfontfamily\rcc@fuentecab{Liberation Sans}[Scale=0.92]}
        {\newcommand\rcc@fuentecab{\sffamily}}}}
\fi

%% \rcc@ligera es una declaración: vale hasta el final del grupo. Los enlaces
%% (URL de la licencia, DOI) no cambian de color dentro (ya tienen el color del
%% texto), porque un cambio de color restablecería el contorno gris.
\newcommand\rcc@ligera{}
\newcommand\rcc@sincolorenlace{\def\Hy@colorlink##1{\begingroup}\def\Hy@endcolorlink{\endgroup}}
\ifrcc@carlito
  \ifXeTeX
    \renewcommand\rcc@ligera{\ifdim\rcc@grosoradelg>\z@
      \rcc@sincolorenlace
      \special{pdf:literal direct 2 Tr 1 G \strip@pt\dimexpr\rcc@grosoradelg*7227/7200\relax\space w}%
      \aftergroup\rcc@ligerafin\fi}
    \newcommand\rcc@ligerafin{\special{pdf:literal direct 0 Tr}}
  \else
    \RequirePackage{pdfrender}
    \renewcommand\rcc@ligera{\ifdim\rcc@grosoradelg>\z@
      \rcc@sincolorenlace
      \pdfrender{TextRenderingMode=FillStroke, LineWidth=\rcc@grosoradelg, StrokeColor=white}\fi}
  \fi
\fi

%% \rccfs{<pt>}: tamaño + interlineado "Word sencillo" (tamaño x factor x interlineado)
\newcommand\rcc@lineade[1]{\fpeval{round(#1*\rcc@factorlinea*\rcc@interlineado,3)}pt}
\newcommand\rccfs[1]{\fontsize{#1pt}{\rcc@lineade{#1}}\selectfont}

\renewcommand\normalsize{%
  \@setfontsize\normalsize{\rcc@tamtexto pt}{\rcc@lineade{\rcc@tamtexto}}%
  \abovedisplayskip\rcc@especuacion \@plus 2pt \@minus 2pt
  \belowdisplayskip\abovedisplayskip
  \abovedisplayshortskip\abovedisplayskip
  \belowdisplayshortskip\abovedisplayskip
  \let\@listi\@listI}
\renewcommand\small{\@setfontsize\small{9pt}{\rcc@lineade{9}}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{8pt}{\rcc@lineade{8}}}
\renewcommand\scriptsize{\@setfontsize\scriptsize{7pt}{\rcc@lineade{7}}}
\renewcommand\large{\@setfontsize\large{12pt}{\rcc@lineade{12}}}
\renewcommand\Large{\@setfontsize\Large{14pt}{\rcc@lineade{14}}}

%% ---------------------------------------------------------------------
%% 5. DATOS DEL ARTÍCULO Y DE LA REVISTA
%% ---------------------------------------------------------------------
\newcommand\rcc@def[2]{\expandafter\def\csname rcc@d@#1\endcsname{#2}}
\newcommand\rcc@get[1]{\csname rcc@d@#1\endcsname}
\newcommand\revista[1]{\rcc@def{revista}{#1}}
\newcommand\volumen[1]{\rcc@def{volumen}{#1}}
\newcommand\numero[1]{\rcc@def{numero}{#1}}
\newcommand\periodo[1]{\rcc@def{periodo}{#1}}
\newcommand\anio[1]{\rcc@def{anio}{#1}}
\newcommand\eissn[1]{\rcc@def{eissn}{#1}}
\newcommand\doi[1]{\rcc@def{doi}{#1}}
\newcommand\paginas[1]{\rcc@def{paginas}{#1}}
\newcommand\primerapagina[1]{\setcounter{page}{#1}\rcc@def{primera}{#1}}
\newcommand\autorescorto[1]{\rcc@def{autorescorto}{#1}}
\newcommand\titulo[1]{\rcc@def{titulo}{#1}}
\newcommand\titulosecundario[1]{\rcc@def{titulob}{#1}}
\newcommand\fechas[3]{\rcc@def{recibido}{#1}\rcc@def{aceptado}{#2}\rcc@def{publicado}{#3}}
\newcommand\licencia[1]{\rcc@def{licencia}{#1}}

% valores por defecto
\revista{Revista Colombiana de Computación}
\volumen{X}\numero{X}\periodo{January -- June}\anio{20XX}
\eissn{2539-2115}\doi{10.29375/25392115.XXXX}
\rcc@def{primera}{1}
\paginas{\rcc@get{primera}-\pageref*{rcc@ultimapagina}}
\autorescorto{A. Autor, B. Autor}
\titulo{}\titulosecundario{}
\fechas{}{}{}
\licencia{\textcopyright\rcc@get{anio}\ Universidad Autónoma de Bucaramanga. This article is
  an open access article distributed under the terms and conditions of the Creative Commons
  Attribution (CC BY-NC-SA 4.0) license
  (\url{https://creativecommons.org/licenses/by-nc-sa/4.0/})}

%% Autores: \autor{Nombre completo}{afiliaciones}{ORCID}{correo}
%% Afiliaciones: \afiliacion{número}{texto}
\newcounter{rcc@nautores}
\newcommand\rcc@autoreslinea{}
\newcommand\rcc@correos{}
\newcommand\rcc@orcids{}
\newcommand\rcc@afiliaciones{}
\newcommand\autor[4]{%
  \stepcounter{rcc@nautores}%
  \ifnum\value{rcc@nautores}>1 \gappto\rcc@autoreslinea{, }\fi
  \gappto\rcc@autoreslinea{#1\ifblank{#2}{}{\textsuperscript{#2}}%
     \ifblank{#3}{}{\,\rcc@iconoorcid{#3}}}%
  \ifblank{#4}{}{%
    \ifdefempty\rcc@correos{}{\gappto\rcc@correos{, }}%
    \gappto\rcc@correos{\href{mailto:#4}{#4}}}%
  \ifblank{#3}{}{\gappto\rcc@orcids{\rcc@lineaorcid{#1}{#3}}}%
  \ifdefempty\rcc@pdfautores{\gdef\rcc@pdfautores{#1}}{\gappto\rcc@pdfautores{, #1}}}
\newcommand\rcc@pdfautores{}
\newcommand\afiliacion[2]{\gappto\rcc@afiliaciones{%
  \ifblank{#1}{}{\textsuperscript{#1}\,}#2\par}}

%% Icono ORCID oficial (vectorial, geometría del logo de 1280 x 1280 unidades):
%% círculo verde #A6CE39, "i" minúscula (punto + trazo) y "D" en blanco.
%% Tamaño: clave "tam icono orcid" (Word: 0.423 cm).
\RequirePackage{tikz}

%% Marca de agua de la opción "prueba"/"proof": texto diagonal semitransparente
%% centrado en cada página, por encima del contenido (se ve también sobre
%% tablas y figuras). Claves: texto prueba, opacidad prueba.
\ifrcc@prueba
  \AddToHook{shipout/foreground}{%
    \put(0.5\paperwidth,-0.5\paperheight){\makebox(0,0){\rotatebox[origin=c]{54.7}{%
      \tikz\node[opacity=\rcc@opacidadprueba,text=rccgris,inner sep=0pt]
        {\rcc@fuentecab\bfseries\fontsize{96pt}{96pt}\selectfont\rcc@textoprueba};}}}}
\fi
\definecolor{rccorcidverde}{HTML}{A6CE39}
\newsavebox\rcc@cajaorcid
\newcommand\rcc@dibujaorcid{%
  \begin{tikzpicture}[x=\rcc@tamorcidicono/1280, y=-\rcc@tamorcidicono/1280]
    \fill[rccorcidverde] (640,640) circle[radius=640];
    \fill[white] (392.5,284) circle[radius=50.5];              % punto de la i
    \fill[white] (354,396) rectangle (431,931);                % trazo de la i
    \fill[white, even odd rule]                                 % D
      (544,396) -- (754,396) .. controls (950,396) and (1037,545) .. (1037,664)
        .. controls (1037,804) and (930,931) .. (754,931) -- (544,931) -- cycle
      (621,465) -- (741,465) .. controls (890,465) and (958,555) .. (958,664)
        .. controls (958,740) and (915,862) .. (744,862) -- (621,862) -- cycle;
  \end{tikzpicture}}
\AtBeginDocument{\sbox\rcc@cajaorcid{\rcc@dibujaorcid}}
\newcommand\rcc@iconoorcid[1]{\href{https://orcid.org/#1}{\raisebox{-0.12em}{\usebox\rcc@cajaorcid}}}
\newcommand\rcc@lineaorcid[2]{#1 \rcc@iconoorcid{#2}\,%
  \href{https://orcid.org/#2}{\color{rccazulclaro}\underline{https://orcid.org/#2}}\par}

%% Etiquetas según idioma
\ifrcc@espanol
  \newcommand\rcc@etqrecibido{Recibido}
  \newcommand\rcc@etqaceptado{aceptado}
  \newcommand\rcc@etqpublicado{publicado en línea}
  \newcommand\rcc@etqconflicto{Declaración de conflicto de intereses}
  \newcommand\rcc@etqagradecimientos{Agradecimientos}
  \newcommand\rcc@etqanonimo{[Información omitida para la revisión anónima]}
  \newcommand\rcc@etqanonimos{Autores anónimos -- manuscrito en revisión}
  \newcommand\rcc@etqmanuscrito{Manuscrito enviado para revisión}
  \newcommand\rcc@etqtextoanonimo{[anonimizado]}
\else
  \newcommand\rcc@etqrecibido{Received}
  \newcommand\rcc@etqaceptado{accepted}
  \newcommand\rcc@etqpublicado{published online}
  \newcommand\rcc@etqconflicto{Conflict of interest statement}
  \newcommand\rcc@etqagradecimientos{Acknowledgments}
  \newcommand\rcc@etqanonimo{[Information removed for blind review]}
  \newcommand\rcc@etqanonimos{Anonymous author(s) -- manuscript under review}
  \newcommand\rcc@etqmanuscrito{Manuscript submitted for review}
  \newcommand\rcc@etqtextoanonimo{[anonymized]}
\fi
\newcommand\rcc@etqorcid{ORCID ID}
%% Nombres de figura/tabla/referencias (fijos, independientes de babel)
\newcommand\rcc@nombres{%
  \ifrcc@espanol
    \renewcommand\figurename{Figura}\renewcommand\tablename{Tabla}%
    \renewcommand\refname{Referencias}%
  \else
    \renewcommand\figurename{Figure}\renewcommand\tablename{Table}%
    \renewcommand\refname{References}%
  \fi}
\AtBeginDocument{\rcc@nombres}

%% ---------------------------------------------------------------------
%% 6. PÁGINA: márgenes, encabezados y pies
%% ---------------------------------------------------------------------
\newlength\rcc@hh   % altura de la caja del encabezado (holgura para fancyhdr)
\newlength\rcc@hb   % distancia del borde superior del encabezado a su línea base
\AtEndPreamble{%
  \setlength\rcc@hh{13pt}%
  %% Word coloca la línea base de la cornisa a la distancia del encabezado
  %% + ascendente de Calibri (0.952 x tamaño): 18 mm + 7.6 pt.
  \setlength\rcc@hb{\fpeval{0.952*\rcc@tamcab}pt}%
  \geometry{paperwidth=\rcc@anchopapel, paperheight=\rcc@altopapel,
    top=\rcc@msup, bottom=\rcc@minf, left=\rcc@mizq, right=\rcc@mder,
    headheight=\rcc@hh,
    headsep=\dimexpr\rcc@msup-\rcc@dcab-\rcc@hb\relax,
    footskip=\dimexpr\rcc@minf-\rcc@dpie-2pt\relax}%
  \ifrcc@marcos\geometry{showframe}\fi
  %% fancyhdr fija \headwidth al cargarse (con el ancho de texto de article);
  %% se actualiza al ancho real para que cornisa, licencia y número de
  %% página queden centrados respecto al texto.
  \setlength\headwidth{\textwidth}%
  \setlength\parindent{\rcc@sangria}%
  \setlength\parskip{\rcc@espparrafos}%
}

\newcommand\rcc@fcab{\rcc@fuentecab
  \fontsize{\rcc@tamcab pt}{\fpeval{\rcc@tamcab*\rcc@factorcab}pt}\selectfont\color{rccgris}%
  \hypersetup{urlcolor=rccgris}}
\newcommand\rcc@cabeceracorr{%
  \ifrcc@manuscrito
    \rcc@get{revista} -- \rcc@etqmanuscrito
  \else
    \rcc@get{autorescorto} / \rcc@get{revista}, Vol.~\rcc@get{volumen},
    No.~\rcc@get{numero}, \rcc@get{anio}, pp.~\rcc@get{paginas}%
  \fi}
\newcommand\rcc@cabeceraprimera{%
  \makebox[0pt][l]{\raisebox{\dimexpr\rcc@hb-\rcc@bajacab\relax}[0pt][0pt]{%
  \begin{minipage}[t]{\textwidth}\vspace{0pt}%
    \hspace*{\rcc@sangriacab}%
    \begin{minipage}[t]{0.6\textwidth}\vspace{0pt}\raggedright\rcc@fcab\rcc@ligera
      \rcc@get{revista}\par
      \ifrcc@manuscrito
        \rcc@etqmanuscrito\par
      \else
        Vol.~\rcc@get{volumen}, No.~\rcc@get{numero} \rcc@get{periodo} \rcc@get{anio},
        pp.~\rcc@get{paginas}\par
        e-ISSN: \rcc@get{eissn}, \href{https://doi.org/\rcc@get{doi}}{https://doi.org/\rcc@get{doi}}\par
      \fi
    \end{minipage}\hfill
    \begin{minipage}[t]{\rcc@ancholog}\vspace{0pt}\vspace{-\rcc@subirlogo}%
      \IfFileExists{\rcc@archivologo}
        {\includegraphics[width=\rcc@ancholog]{\rcc@archivologo}}
        {\rcc@logovectorial}%
    \end{minipage}\hspace*{\rcc@ajustelogo}%
  \end{minipage}}}}
%% Logo de respaldo (vectorial) si no se encuentra el archivo
\newcommand\rcc@logovectorial{{\rcc@fuentecab\color{rcclogo1}%
  \setlength\unitlength{1mm}%
  \begin{picture}(53,11)
    \put(7,8.6){\color{rcclogo1}\circle*{2.6}}\put(10.6,8.6){\color{rcclogo2}\circle*{2.6}}
    \put(14.2,8.6){\color{rcclogo3}\circle*{2.6}}
    \put(5.6,3.6){\fontsize{6.4pt}{7pt}\selectfont R\,E\,V\,I\,S\,T\,A\enspace C\,O\,L\,O\,M\,B\,I\,A\,N\,A}
    \put(5.6,0.6){\fontsize{6.4pt}{7pt}\selectfont D\,E\enspace C\,O\,M\,P\,U\,T\,A\,C\,I\,Ó\,N}
  \end{picture}}}

%% Caja de la licencia (pie de la primera página). Crece hacia arriba desde
%% la distancia del pie, como en Word.
\newcommand\rcc@cajalicencia{\parbox[b]{\dimexpr\textwidth-\rcc@margenlic-\rcc@margenlic\relax}{\centering
    \rcc@fuentecab\fontsize{\rcc@tampie pt}{\fpeval{\rcc@tampie*\rcc@factorcab}pt}\selectfont
    \color{rccgris}%
    \hypersetup{urlcolor=rccgris}\rcc@ligera\rcc@get{licencia}}}
\newcommand\rcc@pielicencia{%
  \ifrcc@manuscrito\else\raisebox{0pt}[0pt][0pt]{\rcc@cajalicencia}\fi}
%% Espacio que el texto de la pág. 1 cede a la licencia: se MIDE la licencia
%% (su número de líneas depende del texto y de la fuente) y se reserva
%%   distancia pie + alto licencia + espacio sobre licencia - margen inferior.
%% "espacio sobre licencia" = el párrafo vacío de 8 pt con el que empieza el
%% pie en el Word de la revista. "reduccion pie primera" = ajuste manual extra.
\newsavebox\rcc@cajalic
\newlength\rcc@reservalic
\newcommand\rcc@reservarlicencia{%
  \sbox\rcc@cajalic{\rcc@cajalicencia}%
  \setlength\rcc@reservalic{\dimexpr\rcc@dpie+2pt+\ht\rcc@cajalic+\dp\rcc@cajalic
     +\rcc@esplic+\dp\strutbox-\rcc@minf+\rcc@redpie\relax}%
  \ifdim\rcc@reservalic>\z@\enlargethispage{-\rcc@reservalic}\fi}

\fancypagestyle{rccprimera}{%
  \fancyhf{}%
  \fancyhead[L]{\rcc@cabeceraprimera}%
  \fancyfoot[C]{\rcc@pielicencia}%
  \renewcommand\headrulewidth{0pt}\renewcommand\footrulewidth{0pt}}
\fancypagestyle{rcc}{%
  \fancyhf{}%
  %% Cornisa: si no cabe en una línea (muchos autores), crece hacia ARRIBA;
  %% así la distancia entre su última línea y el texto es siempre la misma
  %% (igual que en Word, donde el texto queda a ~1 línea de la cornisa).
  %% Cornisa: la primera línea queda siempre en la misma posición; si hay una
  %% segunda línea, crece hacia abajo, hacia el texto (como en Word).
  \fancyhead[C]{\raisebox{-\dp\strutbox}[0pt][0pt]{\parbox[t]{\headwidth}{\centering
    \leavevmode\rcc@fcab\rcc@ligera\rcc@cabeceracorr}}}%
  \fancyfoot[C]{\rcc@fuentecab\rccfs{\rcc@tampie}\color{rccpagina}\rcc@ligera\thepage}%
  \renewcommand\headrulewidth{0pt}\renewcommand\footrulewidth{0pt}}
\pagestyle{rcc}

%% ---------------------------------------------------------------------
%% 7. BLOQUE DE TÍTULO (\maketitle)
%% ---------------------------------------------------------------------
\newcommand\rcc@centrado[1]{\leftskip=#1 plus 1fil\rightskip=#1 plus 1fil
  \parfillskip=0pt\parindent=0pt}
\renewcommand\maketitle{%
  \thispagestyle{rccprimera}%
  \ifrcc@manuscrito\else\rcc@reservarlicencia\fi
  \begingroup
    \vspace*{\dimexpr\rcc@espprimera-\topskip\relax}%
    {\rcc@centrado{\rcc@margentitulo}\rccfs{\rcc@tamtitulo}\bfseries\color{rccazul}%
      \rcc@get{titulo}\par}%
    \vspace{\rcc@esptitulo}%
    \ifcsempty{rcc@d@titulob}{}{%
      {\rcc@centrado{\rcc@margentitulo}\rccfs{\rcc@tamtitulob}\bfseries\color{rccazulclaro}%
        \rcc@get{titulob}\par}%
      \vspace{\rcc@esptitulo}}%
    \ifrcc@manuscrito
      {\rcc@centrado{0pt}\rccfs{\rcc@tamautores}\itshape\rcc@etqanonimos\par}%
      \vspace{\rcc@espautores}%
    \else
      {\rcc@centrado{0pt}\rccfs{\rcc@tamautores}\rcc@autoreslinea\par}%
      \vspace{\rcc@espautores}%
      {\rcc@centrado{0pt}\rccfs{\rcc@tamafil}\rcc@afiliaciones}%
      \ifdefempty\rcc@correos{}{%
        \vspace{\rcc@espcorreo}%
        {\rcc@centrado{0pt}\rccfs{\rcc@tamcorreo}\color{rccazulclaro}%
          \hypersetup{urlcolor=rccazulclaro}\rcc@correos\par}}%
      \vspace{\rcc@espcorreo}%
      \ifrcc@mostrarfechas\ifcsempty{rcc@d@recibido}{}{%
        {\rcc@centrado{0pt}\rccfs{\rcc@tamfechas}(\rcc@etqrecibido: \rcc@get{recibido};
          \rcc@etqaceptado: \rcc@get{aceptado}; \rcc@etqpublicado: \rcc@get{publicado})\par}%
        \vspace{6pt}}\fi
    \fi
  \endgroup
  \ifrcc@manuscrito\ifrcc@numlineas\linenumbers\fi\fi}

%% ---------------------------------------------------------------------
%% 8. RESÚMENES
%%   \begin{abstract} ... \end{abstract}  \keywords{...}
%%   \begin{resumen}  ... \end{resumen}   \palabrasclave{...}
%% ---------------------------------------------------------------------
\newif\ifrcc@yahayresumen
\newcommand\rcc@bloqueresumen[2]{% #1 etiqueta, #2 idioma
  \ifrcc@yahayresumen
    \ifrcc@resumennuevapagina\clearpage\else\rcc@espaciado{\rcc@espresumenes}\fi
  \fi
  \global\rcc@yahayresumentrue
  \begin{otherlanguage}{#2}%
  \par\rccfs{\rcc@tamresumen}\leftskip=\rcc@margenresumen\rightskip=\rcc@margenresumen
  \parindent=0pt\noindent{\bfseries\color{rccazul}#1.}\ \ignorespaces}
\newcommand\rcc@pclave[2]{\par\vspace{\rcc@esppclave}%
  {\rccfs{\rcc@tamresumen}\leftskip=\rcc@margenresumen
   \rightskip=\rcc@margenresumen plus 1fil\parfillskip=0pt plus 1fil
   \parindent=0pt{\bfseries\color{rccazulclaro}#1:}\ #2\par}%
  \rcc@marcarespacio{\rcc@esppclave}}
%% Límites (claves "max palabras resumen" y "max palabras clave"):
%% LaTeX cuenta las palabras y avisa en el registro si se exceden; los
%% conteos aparecen también en la página de verificación.
\ExplSyntaxOn
\int_new:N \g_rcc_pal_abstract_int
\int_new:N \g_rcc_pal_resumen_int
\int_new:N \g_rcc_pc_keywords_int
\int_new:N \g_rcc_pc_palabras_int
\seq_new:N \l__rcc_pal_seq
\cs_new_protected:Npn \rcc_contar_palabras:nN #1#2
  {
    \tl_set:Nx \l_tmpa_tl { \tl_to_str:n {#1} }
    \seq_set_split:NnV \l__rcc_pal_seq { ~ } \l_tmpa_tl
    \seq_remove_all:Nn \l__rcc_pal_seq { }
    \int_gset:Nn #2 { \seq_count:N \l__rcc_pal_seq }
  }
\cs_new_protected:Npn \rcc_revisar:nNnn #1#2#3#4 % nombre, contador, máximo, unidad
  {
    \int_compare:nNnT {#2} > {#3}
      { \ClassWarningNoLine{rcc}{#1:~\int_use:N #2~#4~(\rcc@L{maximum}{máximo}~#3)} }
  }
\RenewDocumentEnvironment{abstract}{+b}
  {
    \rcc_contar_palabras:nN {#1} \g_rcc_pal_abstract_int
    \rcc_revisar:nNnn {Abstract} \g_rcc_pal_abstract_int {\rcc@maxresumen} {\rcc@L{words}{palabras}}
    \rcc@bloqueresumen{Abstract}{english}#1\par\end{otherlanguage}
  }{}
\NewDocumentEnvironment{resumen}{+b}
  {
    \rcc_contar_palabras:nN {#1} \g_rcc_pal_resumen_int
    \rcc_revisar:nNnn {Resumen} \g_rcc_pal_resumen_int {\rcc@maxresumen} {\rcc@L{words}{palabras}}
    \rcc@bloqueresumen{Resumen}{spanish}#1\par\end{otherlanguage}
  }{}
\NewDocumentCommand\keywords{m}
  {
    \int_gset:Nn \g_rcc_pc_keywords_int { \clist_count:n {#1} }
    \rcc_revisar:nNnn {Keywords} \g_rcc_pc_keywords_int {\rcc@maxpclave} {\rcc@L{keywords}{palabras~clave}}
    \rcc@pclave{Keywords}{#1}
  }
\NewDocumentCommand\palabrasclave{m}
  {
    \int_gset:Nn \g_rcc_pc_palabras_int { \clist_count:n {#1} }
    \rcc_revisar:nNnn {Palabras~clave} \g_rcc_pc_palabras_int {\rcc@maxpclave} {\rcc@L{keywords}{palabras~clave}}
    \rcc@pclave{Palabras~clave}{#1}
  }
\ExplSyntaxOff

%% ---------------------------------------------------------------------
%% 9. TÍTULOS DE SECCIÓN
%%   Sangría: el primer párrafo tras un título NO lleva sangría;
%%   los siguientes sí (0.53 cm). Cambie con  sangria primer parrafo=true
%% ---------------------------------------------------------------------
%% Espaciado como en Word: entre el "después" de un párrafo y el "antes"
%% del siguiente NO se suman; se usa el MAYOR de los dos (p. ej. palabras
%% clave 6 pt + título 26 pt = 26 pt; título 14 pt + subtítulo 26 pt = 26 pt).
\newif\ifrcc@trasespacio  % el último elemento dejó un espacio "después"
\newif\ifrcc@trastitulo   % ... y fue un título (titlesec omite el "antes")
\newdimen\rcc@ultimoespacio
\newcommand\rcc@marcarespacio[1]{\par\vspace{#1}%
  \global\rcc@ultimoespacio=#1\relax\global\rcc@trasespaciotrue}
\newcommand\rcc@espaciado[1]{% añade "antes" = #1 respetando el máximo
  \ifrcc@trasespacio
    \ifdim#1>\rcc@ultimoespacio\vspace{\dimexpr#1-\rcc@ultimoespacio\relax}\fi
  \else\vspace{#1}\fi}
\newcommand\rcc@antestitulo[1]{% #1 = espacio "antes" del título
  \ifrcc@trasespacio
    \ifrcc@trastitulo % (sin interlineado extra: el puntal del título ya da la profundidad)
      \ifdim#1>\rcc@ultimoespacio\vspace{\dimexpr#1-\rcc@ultimoespacio\relax}\fi
      \nointerlineskip
    \else
      \ifdim#1<\rcc@ultimoespacio\else\kern-\rcc@ultimoespacio\fi
    \fi
  \fi}
\newcommand\rcc@trastitulo[1]{\global\rcc@ultimoespacio=#1\relax
  \global\rcc@trasespaciotrue\global\rcc@trastitulotrue}
\AddToHook{para/begin}{\global\rcc@trasespaciofalse\global\rcc@trastitulofalse}
\AddToHook{cmd/section/before}{\rcc@antestitulo{\rcc@antessec}}
\AddToHook{cmd/subsection/before}{\rcc@antestitulo{\rcc@antessubsec}}
\AddToHook{cmd/subsubsection/before}{\rcc@antestitulo{\rcc@antessubsubsec}}

\setcounter{secnumdepth}{3}
\titleformat{\section}{\rccfs{\rcc@tamsec}\bfseries\color{rccazul}\raggedright}
  {\makebox[\rcc@tabsec][l]{\thesection}}{0pt}{}[\rcc@trastitulo{\rcc@despsec}]
\titleformat{\subsection}{\rccfs{\rcc@tamsubsec}\bfseries\color{rccazulclaro}\raggedright}
  {\makebox[\rcc@tabsubsec][l]{\thesubsection}}{0pt}{}[\rcc@trastitulo{\rcc@despsubsec}]
\titleformat{\subsubsection}{\rccfs{\rcc@tamsubsubsec}\bfseries\color{rccazulsubsub}\raggedright}
  {\makebox[\rcc@tabsubsubsec][l]{\thesubsubsection}}{0pt}{}[\rcc@trastitulo{\rcc@despsubsubsec}]
\titleformat{\paragraph}[runin]{\normalsize\bfseries}{\theparagraph}{0.5em}{}[.]
\AtEndPreamble{%
  \ifrcc@sangriaprimero
    \titlespacing{\section}{0pt}{\rcc@antessec}{\rcc@despsec}%
    \titlespacing{\subsection}{0pt}{\rcc@antessubsec}{\rcc@despsubsec}%
    \titlespacing{\subsubsection}{0pt}{\rcc@antessubsubsec}{\rcc@despsubsubsec}%
  \else
    \titlespacing*{\section}{0pt}{\rcc@antessec}{\rcc@despsec}%
    \titlespacing*{\subsection}{0pt}{\rcc@antessubsec}{\rcc@despsubsec}%
    \titlespacing*{\subsubsection}{0pt}{\rcc@antessubsubsec}{\rcc@despsubsubsec}%
  \fi
  \titlespacing*{\paragraph}{0pt}{6pt}{0.5em}}

%% ---------------------------------------------------------------------
%% SECCIONES FINALES / DECLARACIONES
%%   Orden recomendado (antes de ORCID y Referencias):
%%     conflicto, financiamiento, etica, datos, contribuciones,
%%     declaracionia, agradecimientos
%%   Si una declaración no aplica, se mantiene el título y se usa el
%%   texto estándar: \sinconflicto, \sinfinanciamiento, \sinetica,
%%   \sindatos, \sinusoia, \usoia{herramienta}{propósito}
%%   Modo manuscrito:
%%     - se OCULTAN (identifican a los autores): financiamiento,
%%       contribuciones, agradecimientos
%%     - se MUESTRAN (los evalúan los revisores): conflicto, etica,
%%       datos, declaracionia  -> use \anonimo{...} para nombres de
%%       comités, instituciones o repositorios propios.
%% ---------------------------------------------------------------------
\newcommand\rcc@L[2]{\ifrcc@espanol#2\else#1\fi}
\newcommand\rcc@etqfinanciamiento{\rcc@L{Funding}{Financiamiento}}
\newcommand\rcc@etqetica{\rcc@L{Ethical considerations}{Consideraciones éticas}}
\newcommand\rcc@etqdatos{\rcc@L{Data availability statement}{Disponibilidad de datos}}
\newcommand\rcc@etqcontribuciones{\rcc@L{Author contributions (CRediT)}{Contribución de los autores (CRediT)}}
\newcommand\rcc@etqia{\rcc@L{Declaration of generative AI use}{Declaración de uso de inteligencia artificial generativa}}

%% \rcc@declaracion{entorno}{título}{1 = ocultar en manuscrito, 0 = mostrar}
\newcommand\rcc@declaracion[3]{%
  \newenvironment{#1}
    {\section*{#2}\ifnum#3=1 \ifrcc@manuscrito
       \noindent\rcc@etqanonimo\par\setbox0\vbox\bgroup\fi\fi
     \csname rcc@inicio@#1\endcsname
     \noindent\ignorespaces}
    {\par\ifnum#3=1 \ifrcc@manuscrito\egroup\fi\fi}}
\rcc@declaracion{conflicto}{\rcc@etqconflicto}{0}
\rcc@declaracion{financiamiento}{\rcc@etqfinanciamiento}{1}
\rcc@declaracion{etica}{\rcc@etqetica}{0}
\rcc@declaracion{datos}{\rcc@etqdatos}{0}
\rcc@declaracion{contribuciones}{\rcc@etqcontribuciones}{1}
%% Frase con el enlace a la taxonomía CRediT al inicio de "contribuciones"
\newcommand\rcc@urlcredit{https://credit.niso.org/contributor-roles-defined/}
\newcommand\rcccredit{\href{\rcc@urlcredit}{\rcc@L{CRediT taxonomy}{taxonomía CRediT}}}
\newcommand\rcc@frasecredit{\rcc@L
  {Author contributions are described according to the \rcccredit\
   (\href{\rcc@urlcredit}{credit.niso.org}).}
  {Las contribuciones de los autores se describen según la \rcccredit\
   (\href{\rcc@urlcredit}{credit.niso.org}).}}
\newcommand\rcc@inicio@contribuciones{\emergencystretch=3em\ifrcc@fraseCredit
  \noindent\rcc@frasecredit\space\fi}
\rcc@declaracion{declaracionia}{\rcc@etqia}{0}
\rcc@declaracion{agradecimientos}{\rcc@etqagradecimientos}{1}

%% Textos estándar (redefinibles con \renewcommand)
\newcommand\sinconflicto{\rcc@L
  {The authors declare no conflict of interest regarding the research, authorship, or
   publication of this article.}
  {Los autores declaran no tener conflictos de interés relacionados con la investigación,
   la autoría o la publicación de este artículo.}}
\newcommand\sinfinanciamiento{\rcc@L
  {This research received no external funding.}
  {Esta investigación no recibió financiamiento externo.}}
\newcommand\sinetica{\rcc@L
  {Not applicable. This study did not involve human participants, personal data or animals.}
  {No aplica. Este estudio no involucró participantes humanos, datos personales ni animales.}}
\newcommand\sindatos{\rcc@L
  {Not applicable. No new data were created or analyzed in this study.}
  {No aplica. En este estudio no se generaron ni analizaron datos nuevos.}}
\newcommand\sinusoia{\rcc@L
  {The authors declare that no generative artificial intelligence tools were used in the
   preparation of this manuscript, apart from basic spelling and grammar checking.}
  {Los autores declaran que no utilizaron herramientas de inteligencia artificial generativa
   en la preparación de este manuscrito, salvo la revisión básica de ortografía y gramática.}}
%% \usoia{herramienta y versión}{propósito}
\newcommand\usoia[2]{\rcc@L
  {During the preparation of this work the authors used #1 in order to #2. After using
   this tool, the authors reviewed and edited the content as needed and take full
   responsibility for the content of the publication.}
  {Durante la preparación de este trabajo los autores utilizaron #1 con el fin de #2.
   Después de usar esta herramienta, los autores revisaron y editaron el contenido según
   fue necesario y asumen total responsabilidad por el contenido de la publicación.}}
%% \credito{Nombre}{roles CRediT}: todos los autores en un mismo párrafo,
%% con el nombre en negrita:  Nombre A: roles. Nombre B: roles.
\newcommand\credito[2]{\mbox{\textbf{#1:}}~#2.\space\ignorespaces}

\newcommand\anonimo[1]{\ifrcc@manuscrito\rcc@etqtextoanonimo\else#1\fi}
\newcommand\rccorcid{\ifrcc@manuscrito\else\ifdefempty\rcc@orcids{}{%
  \section*{\rcc@etqorcid}%
  {\parindent=0pt\rccfs{\rcc@tamorcid}\raggedright\rcc@orcids}}\fi}

%% ---------------------------------------------------------------------
%% 10. FIGURAS, TABLAS Y ECUACIONES
%% ---------------------------------------------------------------------
\DeclareCaptionFont{rcctam}{\rccfs{\rcc@tamleyenda}}
\DeclareCaptionFont{rccetq}{\bfseries\color{rccazulclaro}}
\AtEndPreamble{%
  \captionsetup{font=rcctam, labelfont=rccetq, labelsep=period,
    skip=\rcc@espleyenda}%
  \captionsetup[figure]{justification=centering, position=bottom}%
  \captionsetup[table]{justification=raggedright, singlelinecheck=false, position=top}}

%% Tablas al estilo RCC:
%%   \begin{rcctabla} \begin{tabularx}{\textwidth}{...}
%%     \rccencabezado \rcch{A} & \rcch{B} \\ \hline
%%     ... \\ \hline
%%   \end{tabularx} \end{rcctabla}
\newlength\rcc@altofila
\newlength\rcc@altomayus
\newcommand\rcc@estilotabla{%
  \rccfs{\rcc@tamtabla}%
  %% Alto de fila = estiramiento x interlineado; texto centrado verticalmente
  %% (como "vAlign center" en Word): la línea base se coloca de modo que la
  %% altura de mayúsculas quede en el centro de la fila.
  \setlength\rcc@altofila{\fpeval{\rcc@estirtabla*\rcc@tamtabla*\rcc@factorlinea}pt}%
  \setlength\rcc@altomayus{\fpeval{0.66*\rcc@tamtablacab}pt}%
  \setbox\strutbox\hbox{\vrule\@height\dimexpr(\rcc@altofila+\rcc@altomayus)/2\relax
    \@depth\dimexpr(\rcc@altofila-\rcc@altomayus)/2\relax\@width\z@}%
  \renewcommand\arraystretch{1}%
  %% Celdas centradas verticalmente (Word: vAlign center): las columnas X
  %% de tabularx (C, L, R, X) usan m{} en lugar de p{}.
  \renewcommand\tabularxcolumn[1]{m{##1}}%
  \setlength\tabcolsep{\rcc@rellenocelda}%
  \setlength\arrayrulewidth{\rcc@grosortabla}%
  \arrayrulecolor{rcctablalinea}}
\newenvironment{rcctabla}{\centering\rcc@estilotabla}{\par}

%% ---------------------------------------------------------------------
%% TABLA LARGA: se divide entre páginas y REPITE la fila de encabezado
%% (como "Repetir como fila de encabezado" en Word). No va dentro de
%% \begin{table}: la leyenda y la etiqueta se dan como argumentos.
%% Columnas: P{fracción} (izquierda) o Q{fracción} (centro), fracciones del
%% ancho del texto que deben sumar 1.
%%   \begin{rcctablalarga}{Leyenda}{tab:x}{P{.2}P{.3}Q{.2}P{.3}}
%%     {\rcch{A} & \rcch{B} & \rcch{C} & \rcch{D}}   % fila de encabezado
%%     a & b & c & d \\ \hline
%%     ...
%%   \end{rcctablalarga}
%%   \nota{\elaboracionpropia}
%% ---------------------------------------------------------------------
\newcolumntype{P}[1]{>{\raggedright\arraybackslash}m{\dimexpr#1\linewidth-2\tabcolsep\relax}}
\newcolumntype{Q}[1]{>{\centering\arraybackslash}m{\dimexpr#1\linewidth-2\tabcolsep\relax}}
\newcommand\rcc@deftablalarga[1]{%
\newenvironment{#1}[4]{%
  \rcc@revisarnotalarga
  \par\begingroup
  \rcc@estilotabla
  \setlength\LTpre{\intextsep}\setlength\LTpost{\intextsep}%
  \setlength\LTleft{0pt}\setlength\LTright{\fill}%
  \setlength\LTcapwidth{\textwidth}%
  \longtable{##3}%
    \caption{##1}\ifblank{##2}{}{\label{##2}}\\
    \rccencabezado ##4 \\ \endfirsthead
    \rccencabezado ##4 \\ \endhead}
  {\endlongtable\endgroup\global\rcc@tablalargatrue}}
\rcc@deftablalarga{rcctablalarga}
\rcc@deftablalarga{rcclongtable}
\newcommand\rccencabezado{\rowcolor{rcctablafondo}}
%% Celda de cabecera: sin llaves internas, para que el interlineado de 9 pt
%% se aplique también cuando el texto ocupa varias líneas.
%\newcommand\rcch[1]{\leavevmode\rccfs{\rcc@tamtablacab}\bfseries\color{rcctablatexto}#1}
\newcommand\rcch[1]{\centering\arraybackslash\leavevmode\rccfs{\rcc@tamtablacab}\bfseries\color{rcctablatexto}#1}
\newcolumntype{C}{>{\centering\arraybackslash}X}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcolumntype{R}{>{\raggedleft\arraybackslash}X}

%% ---------------------------------------------------------------------
%% NOTAS DE TABLAS Y FIGURAS (APA 7) -- declaran la autoría o la fuente
%%   Van debajo de la tabla/figura, empiezan con "Nota." en cursiva.
%%   \nota{\elaboracionpropia}                 Nota. Elaboración propia.
%%   \nota{\elaboracionpropiacon{\citet{x}}}   ... con base en datos de ...
%%   \nota{\tomadode{...}}                     reproducida sin cambios
%%   \nota{\adaptadode{...}}                   modificada
%%   Puede añadir texto: \nota{MSE = error cuadrático medio. \elaboracionpropia}
%%   Si la figura/tabla no lleva \nota, LaTeX avisa (nota obligatoria=false
%%   para desactivar el aviso).
%% ---------------------------------------------------------------------
\newcommand\nota[1]{\par\global\rcc@haynotatrue
  \ifrcc@tablalarga\vspace{-\intextsep}\fi  % justo después de una tabla larga
  \vspace{\rcc@espnota}%
  {\rccfs{\rcc@tamnota}\leftskip=0pt\rightskip=0pt\parfillskip=0pt plus 1fil
   \ifdef\@captype{\ifdefstring{\@captype}{figure}{\ifdefstring{\rcc@alinnotafig}{centrada}{\centering}{\ifdefstring{\rcc@alinnotafig}{centered}{\centering}{}}}{}}{}%
   \parindent=0pt\noindent{\color{rccnota}\textit{\rcc@L{Note}{Nota}.}}\ #1\par}%
  \ifrcc@tablalarga\vspace{\intextsep}\global\rcc@tablalargafalse\fi}
\newcommand\elaboracionpropia{\rcc@L{Created by the authors.}{Elaboración propia.}}
\newcommand\elaboracionpropiacon[1]{\rcc@L{Created by the authors based on data from #1.}
  {Elaboración propia con base en datos de #1.}}
\newcommand\tomadode[1]{\rcc@L{From #1.}{Tomado de #1.}}
\newcommand\adaptadode[1]{\rcc@L{Adapted from #1.}{Adaptado de #1.}}
%% Aviso si falta la nota: figuras y tablas normales al cerrar el entorno;
%% tablas largas cuando empieza otro elemento o termina el documento.
\newcommand\rcc@avisonota[2]{\ifrcc@notaobligatoria
  \ClassWarning{rcc}{\rcc@L{#1}{#2}\space\rcc@L{without}{sin}\space
    \string\nota/\string\note\space(\rcc@L{authorship/source}{autoría/fuente})}\fi}
\newcommand\rcc@revisarnotalarga{\ifrcc@tablalarga
  \rcc@avisonota{Table \thetable}{Tabla \thetable}\global\rcc@tablalargafalse\fi}
\AtBeginEnvironment{figure}{\rcc@revisarnotalarga\global\rcc@haynotafalse}
\AtBeginEnvironment{table}{\rcc@revisarnotalarga\global\rcc@haynotafalse}
\AtEndEnvironment{figure}{\ifrcc@haynota\else\rcc@avisonota{Figure \thefigure}{Figura \thefigure}\fi}
\AtEndEnvironment{table}{\ifrcc@haynota\else\rcc@avisonota{Table \thetable}{Tabla \thetable}\fi}
\AtEndDocument{\rcc@revisarnotalarga}

%% Número de ecuación: negrita, azul claro (solo junto a la ecuación).
%% La referencia en el texto, \eqref{...}, va sin negrita, como \cref.
\newif\ifrcc@eqref
\AddToHook{cmd/eqref/before}{\global\rcc@eqreftrue}
\def\tagform@#1{\ifrcc@eqref\global\rcc@eqreffalse
    \maketag@@@{\color{rccazulclaro}(\ignorespaces#1\unskip\@@italiccorr)}%
  \else
    \maketag@@@{\color{rccnumecuacion}\bfseries(\ignorespaces#1\unskip\@@italiccorr)}%
  \fi}

%% Listas (viñetas y numeradas) -- formato Word de la revista:
%%   viñeta a 0.63 cm del margen; texto y líneas siguientes a 1.27 cm
%%   (sangría 0.63 cm + francesa 0.63 cm medidas desde la viñeta).
%%   Alineación justificada, espaciado anterior/posterior 0 pt, sencillo.
%%   Cada nivel anidado repite el mismo desplazamiento desde el texto anterior.
\AtEndPreamble{%
  \setlist{labelindent=\rcc@posvineta, leftmargin=\dimexpr\rcc@posvineta+\rcc@sanglista\relax,
    labelsep=0pt, labelwidth=\rcc@sanglista, align=left,
    topsep=\rcc@esplista, partopsep=0pt, itemsep=\rcc@espitem, parsep=0pt}%
  \setlist[itemize,1]{label=\textbullet}%
  \setlist[itemize,2]{label=\normalfont\bfseries\textendash}%
  \setlist[itemize,3]{label=\textasteriskcentered}%
  \setlist[enumerate,1]{label=\arabic*.}%
  \setlist[enumerate,2]{label=\alph*)}%
  \setlist[enumerate,3]{label=\roman*.}
\setlist[itemize,enumerate,2,3,4]{labelindent=0pt, leftmargin=\rcc@sanglista}}

%% ---------------------------------------------------------------------
%% 11. BIBLIOGRAFÍA (natbib + rcc-apa.bst)
%% ---------------------------------------------------------------------
\renewcommand\bibsection{\section*{\refname}}
\renewcommand\bibfont{\rccfs{\rcc@tambib}%
  \ifdefstring{\rcc@alinbib}{justificada}{}{\ifdefstring{\rcc@alinbib}{justified}{}{\raggedright}}%
  \hypersetup{urlcolor=rccdoi}%
  \ifrcc@subrayardoi\let\rcc@urlorig\url\let\url\rcc@urlsub\fi}
\newsavebox\rcc@cajaurl
\newcommand\rcc@urlsub[1]{\leavevmode\sbox\rcc@cajaurl{\rcc@urlorig{#1}}%
  \rlap{\usebox\rcc@cajaurl}{\color{rccdoi}\rule[-1.3pt]{\wd\rcc@cajaurl}{0.4pt}}}
%% Espacio entre el texto y una figura o tabla en el texto ([H]); Word no deja
%% espacio extra (texto -> figura 8.1 pt, texto -> leyenda de tabla 16.6 pt).
\AtEndPreamble{\setlength\intextsep{\rcc@espflotantes}}
\AtEndPreamble{%
  \setlength\bibhang{\rcc@sangriabib}%
  \setlength\bibsep{\rcc@espbib}}
\bibliographystyle{rcc-apa}
%% Dos formas de citar (APA 7):
%%   (Autor, año)  -> \citep{clave}   o  \citaparentesis{clave}
%%   Autor (año)   -> \citet{clave}   o  \citanarrativa{clave}
\newcommand\citaparentesis{\citep}
\newcommand\citanarrativa{\citet}
%% Dos autores (APA 7):
%%   inglés:  "&" entre paréntesis (\citep) y "and" en la cita narrativa (\citet)
%%   español: "y" en los dos casos, nunca "&" (APA 7 en español)
\DeclareRobustCommand\rccy{\rcc@yactual}
\newcommand\rcc@yactual{\ifrcc@espanol y\else\&\fi}
\newcommand\rcc@ynarrativa{\ifrcc@espanol y\else and\fi}
\AtBeginDocument{%
  \NewCommandCopy\rcc@citet\citet \NewCommandCopy\rcc@citeauthor\citeauthor
  \RenewDocumentCommand\citet{s o o m}{\begingroup\let\rcc@yactual\rcc@ynarrativa
    \IfBooleanTF{#1}
      {\IfValueTF{#3}{\rcc@citet*[#2][#3]{#4}}{\IfValueTF{#2}{\rcc@citet*[#2]{#4}}{\rcc@citet*{#4}}}}
      {\IfValueTF{#3}{\rcc@citet[#2][#3]{#4}}{\IfValueTF{#2}{\rcc@citet[#2]{#4}}{\rcc@citet{#4}}}}%
    \endgroup}%
  \RenewDocumentCommand\citeauthor{s m}{\begingroup\let\rcc@yactual\rcc@ynarrativa
    \IfBooleanTF{#1}{\rcc@citeauthor*{#2}}{\rcc@citeauthor{#2}}\endgroup}}

%% ---------------------------------------------------------------------
%% 12. HIPERVÍNCULOS Y REFERENCIAS CRUZADAS
%% ---------------------------------------------------------------------
\RequirePackage{hyperref}
\hypersetup{colorlinks=true, linkcolor=rccazulclaro, citecolor=rcccita,
  urlcolor=rccazulclaro, breaklinks=true, bookmarksnumbered=true}
\ifrcc@espanol
  \RequirePackage[spanish,capitalise,nameinlink,noabbrev]{cleveref}
  \crefname{table}{Tabla}{Tablas}\Crefname{table}{Tabla}{Tablas}
  \crefname{figure}{Figura}{Figuras}\Crefname{figure}{Figura}{Figuras}
\else
  \RequirePackage[english,capitalise,nameinlink,noabbrev]{cleveref}
\fi
\urlstyle{same}
\frenchspacing
\setlength\emergencystretch{1em}  % evita líneas desbordadas con nombres largos
\AtBeginDocument{%
  \hypersetup{pdftitle={\rcc@get{titulo}},
    pdfauthor={\ifrcc@manuscrito\else\rcc@pdfautores\fi}}%
  \normalsize\color{rcctexto}}

%% Numeración de líneas (modo manuscrito)
\renewcommand\linenumberfont{\normalfont\fontsize{6.5pt}{7pt}\selectfont\color{rccgris}}

%% ---------------------------------------------------------------------
%% 13. VERIFICACIÓN: \rccverificacion  (u opción "verificar")
%%     Mide los valores reales que usa LaTeX y los compara con el Word.
%% ---------------------------------------------------------------------
\ExplSyntaxOn
\cs_new:Npn \rcc_mm:n #1 { \fp_eval:n { round( \dim_to_decimal_in_unit:nn {#1} {1mm}, 2) } }
\cs_new:Npn \rcc_pt:n #1 { \fp_eval:n { round( \dim_to_decimal:n {#1}, 2) } }
% #1 elemento, #2 valor LaTeX (num), #3 valor Word (num), #4 unidad
\cs_new_protected:Npn \rcc_fila:nnnn #1#2#3#4
  {
    #1 & #2\,#4 & #3\,#4 &
    \fp_compare:nNnTF { abs( (#2) - (#3) ) } < { 0.06 }
      { \textcolor[HTML]{2E8B57}{\textbf{OK}} }
      { \textcolor{red}{\textbf{\rcc@L{DIFFERS}{DIFIERE}}} } \\
  }
% medir tamaño y línea de un estilo: #1 nombre, #2 comandos de fuente, #3 tam Word, #4 línea Word
\cs_new_protected:Npn \rcc_fuente:nnnn #1#2#3#4
  {
    \group_begin: #2
      \tl_gset:Nx \g_tmpa_tl { \fp_eval:n { round(\f@size,2) } }
      \tl_gset:Nx \g_tmpb_tl { \rcc_pt:n { \f@baselineskip } }
    \group_end:
    \rcc_fila:nnnn {#1~--~\rcc@L{size}{tamaño}} { \g_tmpa_tl } {#3} {pt}
    \rcc_fila:nnnn {#1~--~\rcc@L{line~spacing}{interlineado}} { \g_tmpb_tl } {#4} {pt}
  }
\NewDocumentCommand \rccverificacion {}
  {
    \clearpage \nolinenumbers
    \section*{\rcc@L{RCC~template~verification}{Verificación~de~la~plantilla~RCC}}
    {\small\noindent
     \rcc@L{Values~measured~by~LaTeX~in~this~document~against~those~of~the~Word~template~
     (\texttt{styles.xml}~/~\texttt{document.xml}).~If~you~change~a~parameter~with~
     \texttt{\textbackslash rccsetup},~the~new~value~is~shown~here~marked~DIFFERS.~
     Word~``single''~line~spacing~=~1.15~$\times$~size~(Times~New~Roman),~
     1.22~$\times$~size~(Calibri~Light).~This~page~does~not~count~in~the~page~range.}
     {Valores~medidos~por~LaTeX~en~este~documento~frente~a~los~de~la~plantilla~Word~
     (\texttt{styles.xml}~/~\texttt{document.xml}).~Si~modifica~un~parámetro~con~
     \texttt{\textbackslash rccset},~verá~aquí~el~valor~nuevo~marcado~como~DIFIERE.~
     Interlineado~Word~``sencillo''~=~1{,}15~$\times$~tamaño~(Times~New~Roman),~
     1{,}22~$\times$~tamaño~(Calibri~Light).~Esta~página~no~cuenta~en~el~rango~de~páginas.}\par}
    \medskip
    {\footnotesize\renewcommand\arraystretch{1.12}\setlength\tabcolsep{4pt}
    \noindent\resizebox{\textwidth}{!}{%
    \begin{tabular}[t]{@{}lrrl@{}}
      \textbf{\rcc@L{Item}{Elemento}} & \textbf{LaTeX} & \textbf{Word} & \\ \hline
      \rcc_fila:nnnn {\rcc@L{Page~width}{Ancho~de~página}} { \rcc_mm:n {\paperwidth} } {210.01} {mm}
      \rcc_fila:nnnn {\rcc@L{Page~height}{Alto~de~página}}  { \rcc_mm:n {\paperheight} } {297.04} {mm}
      \rcc_fila:nnnn {\rcc@L{Left~margin}{Margen~izquierdo}} { \rcc_mm:n {\dimexpr 1in+\hoffset+\oddsidemargin\relax} } {25.01} {mm}
      \rcc_fila:nnnn {\rcc@L{Right~margin}{Margen~derecho}} { \rcc_mm:n {\dimexpr\paperwidth-1in-\hoffset-\oddsidemargin-\textwidth\relax} } {25.01} {mm}
      \rcc_fila:nnnn {\rcc@L{Top~margin}{Margen~superior}} { \rcc_mm:n {\dimexpr 1in+\voffset+\topmargin+\headheight+\headsep\relax} } {25.01} {mm}
      \rcc_fila:nnnn {\rcc@L{Bottom~margin}{Margen~inferior}} { \rcc_mm:n {\dimexpr\paperheight-1in-\voffset-\topmargin-\headheight-\headsep-\textheight\relax} } {25.01} {mm}
      \rcc_fila:nnnn {\rcc@L{Header~distance}{Distancia~encabezado}} { \rcc_mm:n {\dimexpr 1in+\voffset+\topmargin+\headheight-\rcc@hb\relax} } {15.01} {mm}
      \rcc_fila:nnnn {\rcc@L{Text~width}{Ancho~de~texto}} { \rcc_mm:n {\textwidth} } {160.0} {mm}
      \rcc_fila:nnnn {\rcc@L{Paragraph~indent}{Sangría~de~párrafo}} { \rcc_mm:n {\parindent} } {5.3} {mm}
      \rcc_fila:nnnn {\rcc@L{Space~between~paragraphs}{Espacio~entre~párrafos}} { \rcc_pt:n {\parskip} } {0} {pt}
      \rcc_fila:nnnn {\rcc@L{Abstract~margin}{Margen~del~resumen}} { \rcc_mm:n {\rcc@margenresumen} } {10.0} {mm}
      \rcc_fila:nnnn {\rcc@L{Title~margin}{Margen~del~título}} { \rcc_mm:n {\rcc@margentitulo} } {10.0} {mm}
      \rcc_fila:nnnn {\rcc@L{Bibliography~hanging~indent}{Sangría~francesa~bibliografía}} { \rcc_mm:n {\bibhang} } {10.0} {mm}
      \rcc_fila:nnnn {\rcc@L{List:~margin~to~bullet}{Lista:~margen~a~viñeta}} { \rcc_mm:n {\rcc@posvineta} } {6.3} {mm}
      \rcc_fila:nnnn {\rcc@L{List:~margin~to~text}{Lista:~margen~a~texto}} { \rcc_mm:n {\dimexpr\rcc@posvineta+\rcc@sanglista\relax} } {12.6} {mm}
      \rcc_fila:nnnn {\rcc@L{Space~before/after~list}{Espacio~antes/después~de~lista}} { \rcc_pt:n {\rcc@esplista} } {0} {pt}
      \rcc_fila:nnnn {\rcc@L{Section~number~tab}{Tabulación~número~sección}} { \rcc_mm:n {\rcc@tabsec} } {8.0} {mm}
      \rcc_fila:nnnn {\rcc@L{Space~before~section}{Espacio~antes~de~sección}} { \rcc_pt:n {\rcc@antessec} } {26} {pt}
      \rcc_fila:nnnn {\rcc@L{Space~after~section}{Espacio~después~de~sección}} { \rcc_pt:n {\rcc@despsec} } {14} {pt}
      \rcc_fila:nnnn {\rcc@L{Space~before~subsection}{Espacio~antes~de~subsección}} { \rcc_pt:n {\rcc@antessubsec} } {26} {pt}
      \rcc_fila:nnnn {\rcc@L{Space~after~subsection}{Espacio~después~de~subsección}} { \rcc_pt:n {\rcc@despsubsec} } {14} {pt}
      \rcc_fila:nnnn {\rcc@L{Space~before~subsubsection}{Espacio~antes~de~subsubsección}} { \rcc_pt:n {\rcc@antessubsubsec} } {16} {pt}
      \rcc_fila:nnnn {\rcc@L{Space~after~subsubsection}{Espacio~después~de~subsubsección}} { \rcc_pt:n {\rcc@despsubsubsec} } {6} {pt}
      \hline
      \rcc_fuente:nnnn {\rcc@L{Body~text}{Texto~normal}} {\normalsize} {10} {11.5}
      \rcc_fuente:nnnn {\rcc@L{Main~title}{Título~principal}} {\rccfs{\rcc@tamtitulo}} {14} {16.1}
      \rcc_fuente:nnnn {\rcc@L{Second-language~title}{Título~2.º~idioma}} {\rccfs{\rcc@tamtitulob}} {12} {13.8}
      \rcc_fuente:nnnn {\rcc@L{Authors}{Autores}} {\rccfs{\rcc@tamautores}} {10} {11.5}
      \rcc_fuente:nnnn {\rcc@L{Affiliations}{Afiliaciones}} {\rccfs{\rcc@tamafil}} {9.5} {10.93}
      \rcc_fuente:nnnn {\rcc@L{E-mails}{Correos}} {\rccfs{\rcc@tamcorreo}} {9} {10.35}
      \rcc_fuente:nnnn {\rcc@L{Dates}{Fechas}} {\rccfs{\rcc@tamfechas}} {8} {9.2}
      \rcc_fuente:nnnn {\rcc@L{Abstracts}{Resumen~/~Abstract}} {\rccfs{\rcc@tamresumen}} {9} {10.35}
      \rcc_fuente:nnnn {\rcc@L{Section~(level~1)}{Sección~(nivel~1)}} {\rccfs{\rcc@tamsec}} {12} {13.8}
      \rcc_fuente:nnnn {\rcc@L{Subsection~(level~2)}{Subsección~(nivel~2)}} {\rccfs{\rcc@tamsubsec}} {10.5} {12.08}
      \rcc_fuente:nnnn {\rcc@L{Subsubsection~(level~3)}{Subsubsección~(nivel~3)}} {\rccfs{\rcc@tamsubsubsec}} {10.5} {12.08}
      \rcc_fuente:nnnn {\rcc@L{Captions}{Leyendas}} {\rccfs{\rcc@tamleyenda}} {9} {10.35}
    \end{tabular}\hspace{1.2em}
    \begin{tabular}[t]{@{}lrrl@{}}
      \textbf{\rcc@L{Item}{Elemento}} & \textbf{LaTeX} & \textbf{Word} & \\ \hline
      \rcc_fuente:nnnn {\rcc@L{Table~header}{Cabecera~de~tabla}} {\rccfs{\rcc@tamtablacab}} {9} {10.35}
      \rcc_fuente:nnnn {\rcc@L{Table~body}{Cuerpo~de~tabla}} {\rccfs{\rcc@tamtabla}} {8} {9.2}
      \rcc_fuente:nnnn {\rcc@L{Running~head}{Encabezado}} {\rcc@fcab} {8} {9.76}
      \rcc_fuente:nnnn {\rcc@L{Footer~/~licence}{Pie~/~licencia}} {\fontsize{\rcc@tampie pt}{\fpeval{\rcc@tampie*\rcc@factorcab}pt}\selectfont} {8} {9.76}
      \rcc_fuente:nnnn {\rcc@L{Bibliography}{Bibliografía}} {\rccfs{\rcc@tambib}} {10} {11.5}
      \rcc_fuente:nnnn {ORCID} {\rccfs{\rcc@tamorcid}} {10} {11.5}
      \hline
      \textbf{\rcc@L{Journal~limits}{Límites~de~la~revista}} & \textbf{\rcc@L{Text}{Texto}} & \textbf{\rcc@L{Max.}{Máx.}} & \\
      \rcc_limite:nNn {\rcc@L{Abstract~words}{Palabras~del~Abstract}} \g_rcc_pal_abstract_int {\rcc@maxresumen}
      \rcc_limite:nNn {\rcc@L{Spanish~abstract~words}{Palabras~del~Resumen}} \g_rcc_pal_resumen_int {\rcc@maxresumen}
      \rcc_limite:nNn {Keywords} \g_rcc_pc_keywords_int {\rcc@maxpclave}
      \rcc_limite:nNn {\rcc@L{Spanish~keywords}{Palabras~clave}} \g_rcc_pc_palabras_int {\rcc@maxpclave}
    \end{tabular}}}
    \par\bigskip
    \noindent{\small\textbf{\rcc@L{Colours}{Colores}}~(\rcc@L{Word~HEX}{HEX~del~Word})}\par\smallskip
    {\footnotesize\setlength\tabcolsep{4pt}
     \noindent\resizebox{\textwidth}{!}{\begin{tabular}{@{}lll@{\hspace{1.5em}}lll@{}}
      \rcc_color:nnn{rccazul}{498CF1}{\rcc@L{Title,~sections,~``Abstract.''}{Título,~secciones,~``Abstract.''}} &
      \rcc_color:nnn{rccazulclaro}{85B2F6}{\rcc@L{Title~2,~subsections,~captions}{Título~2,~subsecciones,~leyendas}} \\
      \rcc_color:nnn{rccazulsubsub}{85B2F6}{\rcc@L{Sub-subsections}{Sub-subsecciones}} &
      \rcc_color:nnn{rcctablafondo}{85B2F6}{\rcc@L{Table~header~fill}{Fondo~cabecera~tabla}} \\
      \rcc_color:nnn{rccgris}{808080}{\rcc@L{Running~head~and~licence}{Encabezado~y~licencia}} &
      \rcc_color:nnn{rccpagina}{7F8FA9}{\rcc@L{Page~number}{Número~de~página}} \\
      \rcc_color:nnn{rccnumecuacion}{85B2F6}{\rcc@L{Equation~number}{Número~de~ecuación}} &
      \rcc_color:nnn{rcctexto}{000000}{\rcc@L{Text}{Texto}} \\
      \rcc_color:nnn{rccdoi}{85B2F6}{\rcc@L{DOI/URL~in~references}{DOI/URL~en~referencias}} &
      \rcc_color:nnn{rccnota}{85B2F6}{\rcc@L{Word~``Note.''}{Palabra~``Nota.''}} \\
     \end{tabular}}}
    \par\medskip
    {\footnotesize\noindent \rcc@L{Body~font}{Fuente~del~texto}:~{\normalfont\normalsize \tl_set:Nx \l_tmpa_tl {\fontname\font} \textbf{\l_tmpa_tl}}
     \par\noindent \rcc@L{Running~head~font}{Fuente~del~encabezado}:~{\rcc@fuentecab \tl_set:Nx \l_tmpa_tl {\fontname\font} \textbf{\l_tmpa_tl}}
     \par\noindent \rcc@L{Mode}{Modo}:~\ifrcc@manuscrito\textbf{\rcc@L{MANUSCRIPT~(anonymous)}{MANUSCRITO~(anónimo)}}\else\textbf{FINAL~(\rcc@L{publication}{publicación})}\fi
     \par}
  }
\cs_new_protected:Npn \rcc_limite:nNn #1#2#3
  {
    #1 & \int_use:N #2 & #3 &
    \int_compare:nNnTF {#2} > {#3}
      { \textcolor{red}{\textbf{\rcc@L{EXCEEDS}{EXCEDE}}} }
      { \textcolor[HTML]{2E8B57}{\textbf{OK}} } \\
  }
%% obtener el HEX de un color definido (xcolor) y compararlo
\cs_new_protected:Npn \rcc_color:nnn #1#2#3
  {
    \textcolor{#1}{\rule{1.2em}{0.9em}} & \texttt{#1} & #3
    \extractcolorspec{#1}{\l_rcc_spec_tl}
    \expandafter\convertcolorspec\l_rcc_spec_tl{HTML}\l_rcc_hex_tl
    \tl_set:Nx \l_tmpa_tl { \exp_args:NV \str_uppercase:n \l_rcc_hex_tl }
    \str_if_eq:VnTF \l_tmpa_tl {#2}
      { ~(\texttt{#2},~\textcolor[HTML]{2E8B57}{\textbf{OK}}) }
      { ~(\texttt{\l_tmpa_tl}~vs~\texttt{#2},~\textcolor{red}{\textbf{\rcc@L{DIFFERS}{DIFIERE}}}) }
  }
\tl_new:N \l_rcc_spec_tl
\tl_new:N \l_rcc_hex_tl
\ExplSyntaxOff
\AtEndDocument{\label{rcc@ultimapagina}\ifrcc@verificar\rccverificacion\fi}

%% =====================================================================
%% 14. IDIOMA DE LAS REFERENCIAS (palabras que escribe rcc-apa.bst)
%% =====================================================================
\newcommand\rccpp{\rcc@L{pp.}{págs.}}
\newcommand\rccp{\rcc@L{p.}{pág.}}
\newcommand\rccIn{\rcc@L{In}{En}}
\newcommand\rccyref{\rcc@L{, \&}{, y}}  % antes del último autor: ", &" (EN) / ", y" (ES)
\newcommand\rccTR{\rcc@L{Technical Report}{Informe técnico}}
\newcommand\rccNo{\rcc@L{No.}{n.\textordmasculine}}
\newcommand\rccEd{\rcc@L{ed.}{ed.}}
%% Edición: en el .bib escriba solo el número (edition = {5}); la clase
%% escribe "5th ed." en inglés o "5.ª ed." en español. Texto libre se respeta.
\ExplSyntaxOn
\NewDocumentCommand\rccedicion{m}
  {
    \regex_match:nnTF { \A \d+ \Z } {#1}
      {
        \rcc@L
          { #1 \int_compare:nNnTF { \int_mod:nn {#1} {100} } > {10}
               { \int_compare:nNnTF { \int_mod:nn {#1} {100} } < {14} {th} { \__rcc_ord:n {#1} } }
               { \__rcc_ord:n {#1} } ~ ed. }
          { #1.\textordfeminine{} ~ ed. }
      }
      { #1 ~ \rccEd }
  }
\cs_new:Npn \__rcc_ord:n #1
  {
    \int_case:nnF { \int_mod:nn {#1} {10} } { {1}{st} {2}{nd} {3}{rd} } {th}
  }
\ExplSyntaxOff
\newcommand\rccMasters{\rcc@L{Master's thesis}{Tesis de maestría}}
\newcommand\rccPhD{\rcc@L{Doctoral dissertation}{Tesis doctoral}}

%% =====================================================================
%% 15. ENGLISH INTERFACE -- every command, environment, option and key
%%     also has an English name (same behaviour, same output).
%% =====================================================================
%% Options:  manuscript | final | english | spanish | verify | frames | nolinenumbers
%% Fine tuning: \rccsetup{key = value} (English keys below) or \rccset{...}
\newcommand\rccsetup[1]{\pgfkeys{/rcc,#1}}
\pgfkeys{/rcc,
  paper width/.style={/rcc/ancho papel={#1}},
  paper height/.style={/rcc/alto papel={#1}},
  top margin/.style={/rcc/margen superior={#1}},
  bottom margin/.style={/rcc/margen inferior={#1}},
  left margin/.style={/rcc/margen izquierdo={#1}},
  right margin/.style={/rcc/margen derecho={#1}},
  header distance/.style={/rcc/distancia encabezado={#1}},
  footer distance/.style={/rcc/distancia pie={#1}},
  first page space/.style={/rcc/espacio primera pagina={#1}},
  first page footer reduction/.style={/rcc/reduccion pie primera={#1}},
  space above license/.style={/rcc/espacio sobre licencia={#1}},
  text size/.style={/rcc/tam texto={#1}},
  line factor/.style={/rcc/factor linea={#1}},
  line spacing/.style={/rcc/interlineado={#1}},
  indent/.style={/rcc/sangria={#1}},
  paragraph space/.style={/rcc/espacio parrafos={#1}},
  indent first paragraph/.style={/rcc/sangria primer parrafo={#1}},
  title size/.style={/rcc/tam titulo={#1}},
  second title size/.style={/rcc/tam titulo secundario={#1}},
  title margin/.style={/rcc/margen titulo={#1}},
  space after title/.style={/rcc/espacio tras titulo={#1}},
  author size/.style={/rcc/tam autores={#1}},
  author space/.style={/rcc/espacio autores={#1}},
  affiliation size/.style={/rcc/tam afiliacion={#1}},
  email size/.style={/rcc/tam correo={#1}},
  email space/.style={/rcc/espacio correo={#1}},
  dates size/.style={/rcc/tam fechas={#1}},
  abstract size/.style={/rcc/tam resumen={#1}},
  abstract margin/.style={/rcc/margen resumen={#1}},
  keywords space/.style={/rcc/espacio palabras clave={#1}},
  space between abstracts/.style={/rcc/espacio entre resumenes={#1}},
  abstract on new page/.style={/rcc/resumen en nueva pagina={#1}},
  max abstract words/.style={/rcc/max palabras resumen={#1}},
  max keywords/.style={/rcc/max palabras clave={#1}},
  section size/.style={/rcc/tam seccion={#1}},
  space before section/.style={/rcc/antes seccion={#1}},
  space after section/.style={/rcc/despues seccion={#1}},
  section number tab/.style={/rcc/tab seccion={#1}},
  subsection size/.style={/rcc/tam subseccion={#1}},
  space before subsection/.style={/rcc/antes subseccion={#1}},
  space after subsection/.style={/rcc/despues subseccion={#1}},
  subsection number tab/.style={/rcc/tab subseccion={#1}},
  subsubsection size/.style={/rcc/tam subsubseccion={#1}},
  space before subsubsection/.style={/rcc/antes subsubseccion={#1}},
  space after subsubsection/.style={/rcc/despues subsubseccion={#1}},
  subsubsection number tab/.style={/rcc/tab subsubseccion={#1}},
  caption size/.style={/rcc/tam leyenda={#1}},
  caption space/.style={/rcc/espacio leyenda={#1}},
  note size/.style={/rcc/tam nota={#1}},
  note space/.style={/rcc/espacio nota={#1}},
  note required/.style={/rcc/nota obligatoria={#1}},
  figure note alignment/.style={/rcc/alineacion nota figura={#1}},
  bullet position/.style={/rcc/posicion vineta={#1}},
  list indent/.style={/rcc/sangria lista={#1}},
  list space/.style={/rcc/espacio lista={#1}},
  item space/.style={/rcc/espacio item={#1}},
  credit sentence/.style={/rcc/frase credit={#1}},
  show dates/.style={/rcc/mostrar fechas={#1}},
  table header size/.style={/rcc/tam tabla cabecera={#1}},
  table size/.style={/rcc/tam tabla={#1}},
  table row stretch/.style={/rcc/estiramiento tabla={#1}},
  cell padding/.style={/rcc/relleno celda={#1}},
  table rule width/.style={/rcc/grosor linea tabla={#1}},
  equation space/.style={/rcc/espacio ecuacion={#1}},
  header size/.style={/rcc/tam encabezado={#1}},
  header line factor/.style={/rcc/factor linea cabecera={#1}},
  footer size/.style={/rcc/tam pie={#1}},
  logo width/.style={/rcc/ancho logo={#1}},
  logo offset/.style={/rcc/ajuste logo={#1}},
  logo raise/.style={/rcc/subir logo={#1}},
  first page header shift/.style={/rcc/bajar cabecera primera={#1}},
  first page header indent/.style={/rcc/sangria cabecera primera={#1}},
  license margin/.style={/rcc/margen licencia={#1}},
  bibliography size/.style={/rcc/tam bibliografia={#1}},
  bibliography indent/.style={/rcc/sangria bibliografia={#1}},
  bibliography space/.style={/rcc/espacio bibliografia={#1}},
  bibliography alignment/.style={/rcc/alineacion bibliografia={#1}},
  underline doi/.style={/rcc/subrayar doi={#1}},
  orcid size/.style={/rcc/tam orcid={#1}},
  orcid icon size/.style={/rcc/tam icono orcid={#1}},
  logo file/.style={/rcc/archivo logo={#1}},
  thin stroke/.style={/rcc/grosor adelgazar={#1}},
  float space/.style={/rcc/espacio flotantes={#1}},
  proof text/.style={/rcc/texto prueba={#1}},
  proof opacity/.style={/rcc/opacidad prueba={#1}},
}
%% Journal / editorial data
\newcommand\journalname{\revista}
\newcommand\volume{\volumen}
\newcommand\issue{\numero}
\newcommand\period{\periodo}
\newcommand\pubyear{\anio}
\newcommand\pagerange{\paginas}
\newcommand\firstpage{\primerapagina}
\newcommand\license{\licencia}
%% Article data
\newcommand\articletitle{\titulo}
\newcommand\secondtitle{\titulosecundario}
\newcommand\addauthor{\autor}          % {Full name}{affiliations}{ORCID}{e-mail}
\newcommand\affiliation{\afiliacion}   % {number}{text}
\newcommand\shortauthors{\autorescorto}
\newcommand\dates{\fechas}             % {received}{accepted}{published}
\newcommand\spanishkeywords{\palabrasclave}
\newenvironment{spanishabstract}{\resumen}{\endresumen}
%% Anonymization
\newcommand\anonymize{\anonimo}
%% Figure and table notes
\newcommand\note{\nota}
\newcommand\ownwork{\elaboracionpropia}
\newcommand\ownworkdata{\elaboracionpropiacon}
\newcommand\reproducedfrom{\tomadode}
\newcommand\adaptedfrom{\adaptadode}
%% Tables
\newenvironment{rcctable}{\rcctabla}{\endrcctabla}
\newcommand\rccheader{\rccencabezado}
%% Declarations
\newenvironment{conflictofinterest}{\conflicto}{\endconflicto}
\newenvironment{funding}{\financiamiento}{\endfinanciamiento}
\newenvironment{ethics}{\etica}{\endetica}
\newenvironment{dataavailability}{\datos}{\enddatos}
\newenvironment{contributions}{\contribuciones}{\endcontribuciones}
\newenvironment{aideclaration}{\declaracionia}{\enddeclaracionia}
\newenvironment{acknowledgments}{\agradecimientos}{\endagradecimientos}
\newcommand\noconflict{\sinconflicto}
\newcommand\nofunding{\sinfinanciamiento}
\newcommand\noethics{\sinetica}
\newcommand\nodata{\sindatos}
\newcommand\noaiuse{\sinusoia}
\newcommand\aiuse{\usoia}              % {tool and version}{purpose}
\newcommand\credit{\credito}           % {Name}{CRediT roles}
\newcommand\orcidlist{\rccorcid}
\newcommand\rccverification{\rccverificacion}

\endinput
