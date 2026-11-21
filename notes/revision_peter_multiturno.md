# Revisión de cierre: respuestas a los comentarios de Peter y John

Artículo: `articulos/multiturno/main.tex`
Fecha de la revisión: 20 de noviembre de 2026
Compara el commit `cac0753` (":sparkles: ajustes memores", 16 de noviembre, con los 93 comentarios abiertos) contra el commit `3569947` ("correcciones Diego 20nov", 20 de noviembre). Registros revisados: 93 comentarios (71 de John: J01–J72 sin J68, y 22 de Peter: R201–R240 con numeración salteada).

Esta revisión no aplica la rúbrica de Peter como lectura ciega nueva. Usa el marco de la rúbrica (IMRaD, severidad Mayor/Menor/Sugerencia) para juzgar si el cambio hecho en el texto responde al comentario original, siguiendo el modelo de `articulos/efecto_halo/notes/revision_par_respuestas.md`.

## Cómo leer las etiquetas

**Veredicto:**
- `Atendido`: el cambio está en el texto y resuelve el problema señalado.
- `Parcial`: hubo cambio, pero falta una parte de lo pedido.
- `No atendido`: el texto no cambió en lo que pedía el comentario, o el cambio no responde al problema.
- `No aplica`: el comentario quedó obsoleto porque la sección completa se reescribió o eliminó, y el problema puntual ya no existe en esa forma.

Todos los comentarios tenían `status=pending` en el commit anterior. En el commit actual, 92 de los 93 ya no aparecen como `\txcomment` en el texto, lo que indica que el equipo los resolvió borrando la marca en vez de cambiar el estado a `accepted` o `rejected`. Solo J71 permanece.

## Hallazgos transversales

1. **Reescritura casi total.** El commit cambió 569 líneas de `main.tex` (inserciones y eliminaciones) y reemplazó resumen, abstract, introducción, metodología, resultados, discusión y conclusiones. La mayoría de los comentarios no se resolvieron punto por punto: se resolvieron porque el párrafo que criticaban ya no existe en esa forma.
2. **No hay registro de cierre.** Ninguno de los 93 `\txcomment` quedó con `status=accepted` o `rejected`. Se eliminaron directamente. Esto impide auditar después cuál comentario motivó cuál cambio, y contradice la práctica de otros artículos del repositorio (`efecto_halo`), donde el estado se actualiza en vez de borrar la marca.
3. **Compila sin errores.** `scripts/compilar.sh` no reporta errores LaTeX, citas sin resolver ni referencias cruzadas rotas. Hay 5 cajas overfull/underfull, cosméticas (celdas de tabla y una caja de 69 pt en el bloque `\datos`, línea 361).
4. **Límites de la revista cumplidos.** Resumen: 134 palabras (límite 150). Abstract: 123 palabras (límite 150). Palabras clave: 5 en español y 5 en inglés (límite 5). Antes excedían ampliamente: 434, 386 y 6 respectivamente.
5. **Referencia huérfana en el .bib.** `huang2025` está definida en `referencias.bib` pero no se cita en ningún lugar de `main.tex`. Las demás 11 entradas sí se citan.
6. **Comentario de cabecera desactualizado.** `referencias.bib` conserva en su encabezado el título antiguo del artículo ("Cuantificación de alucinaciones en agentes virtuales..."), que ya no coincide con `\titulo` en `main.tex`.
7. **Riesgo legal resuelto.** J56 advertía sobre nombrar chatbots comerciales identificables (Olímpica, Bancolombia, AWS, HP, AT&T, etc.). La tabla de errores por chatbot se reemplazó por una tabla agrupada por sector (`tab:sectores2`), sin ningún nombre de empresa en el texto actual.

## Comentarios de John (J01–J72)

| ID | Hallazgo en el texto actual | Veredicto |
|---|---|---|
| J01 | El título en inglés (`\titulosecundario`) ahora existe y es la traducción directa del título nuevo. | Atendido |
| J02 | El resumen tiene 134 palabras, dentro del límite de 150. | Atendido |
| J03 | "pero toca tener cuidado" no aparece; el resumen se reescribió por completo en formato estructurado (Introducción/Objetivo/Método/Resultados/Conclusiones). | No aplica (el párrafo original ya no existe) |
| J04 | El resumen y la introducción ahora centran el problema en interacciones multiturno con premisa falsa desde la primera frase. No describe "etapas por turno" explícitamente, pero el objetivo y el método sí las nombran (control, turno 1, 2, 3). | Atendido |
| J05 | El resumen ya no habla de "confusión en las decisiones" de forma vaga; se reemplazó por resultados cuantitativos directos (79/90 correctas, McNemar, 10/30 en control). | Atendido |
| J06 | El objetivo del resumen ahora es: "Evaluar la presencia y persistencia de estas alucinaciones en 30 chatbots de distintos sectores", un solo objetivo claro. | Atendido |
| J07 | Ya no hay un segundo objetivo compitiendo; el resumen integra propósito y método en un solo bloque. | Atendido |
| J08 | El resumen no dice explícitamente "empresas hispanohablantes", pero el método aclara "evaluación cuantitativa... en español" y la introducción dice "cuyas interacciones se desarrollaron completamente en español". | Parcial |
| J09 | "turno 0" ya no aparece en ningún lado; se usa "consulta de control" de forma consistente. | Atendido |
| J10 | "afirmación falsa" se cambió por "premisa falsa" en todo el texto. La introducción explica por qué se eligió esta perturbación citando sycophancy (Sharma et al., 2024) y conversation tax (Guo et al., 2026), aunque no contrasta con otros tipos de perturbación. | Parcial |
| J11 | El resumen ahora menciona el método (consulta de control, tres turnos) antes de los resultados, y la metodología describe la validación (revisión humana sobre las clasificaciones de Gemini). | Atendido |
| J12 | El resumen ya no tiene la frase confusa "se identificaron 10 chatbots con alucinaciones" aislada: integra la cifra de control en una frase con sujeto y verbo claros dentro del bloque de Resultados. | Atendido |
| J13 | No se puede verificar una frase puntual porque el resumen se reescribió entero; no quedan frases vacías de cierre. | No aplica |
| J14 | El resumen y las conclusiones ya no afirman intuiciones sin soporte; las conclusiones actuales se limitan a lo que los datos muestran (no generalizan a "riesgo para decisiones de los usuarios" sin evidencia). | Atendido |
| J15 | Las conclusiones no proponen estrategias concretas para las empresas; el trabajo futuro se limita a ampliar la muestra y comparar condiciones experimentales. El comentario pedía estrategias empresariales, que no aparecen. | No atendido |
| J16 | Las palabras clave son 5 ("Alucinaciones factuales, chatbots, servicio al cliente, premisas falsas, interacción multiturno"), dentro del límite. | Atendido |
| J17 | El abstract tiene 123 palabras, dentro del límite de 150. | Atendido |
| J18 | El primer párrafo de la introducción se redujo a 4 frases (de un párrafo mucho más largo) y cita `\citep{larsen2025}` al final. | Atendido |
| J19 | La introducción actual sigue sin diferenciar explícitamente "error del sistema" de "alucinación del LLM" como pedía el comentario (ventana de contexto, integración con sistemas de información). Habla de "alucinaciones factuales" de forma genérica. | No atendido |
| J20 | El párrafo sobre confusión en la toma de decisiones ya no está en esa forma; el párrafo 1 actual cita `\citep{larsen2025}` para la afirmación sobre confianza de los usuarios. | Atendido |
| J21 | El párrafo 4 de la introducción ahora explica la premisa falsa citando sycophancy con fuente (`\citet{sharma2024}`), aunque no contrasta explícitamente por qué este error "preocupa más" que otros tipos de fallo. | Parcial |
| J22 | "consulta inicial" ya no aparece de forma ambigua; el cierre de la introducción usa "consulta de control" consistentemente. | Atendido |
| J23 | No se incluyó una figura comparativa de un asistente respondiendo bien en un turno frente a mal en multiturno, como pedía el comentario. | No atendido |
| J24 | La introducción ahora dice explícitamente: "este trabajo examina sistemas conversacionales disponibles en entornos empresariales reales" y que las interacciones fueron en español, recogiendo el valor agregado que J24 pedía resaltar. | Atendido |
| J25 | "turno 0" se cambió por "consulta de control" y la introducción explica su función ("consulta de control independiente, cuya respuesta sirvió como referencia"). | Atendido |
| J26 | El párrafo sobre impacto en la confianza de los usuarios ahora cita `\citet{larsen2025}` con el detalle del estudio (274 participantes). | Atendido |
| J27 | La introducción nombra los sectores: "bancario, retail, turismo, seguros, tecnología, telecomunicaciones, desarrollo urbano y público". | Atendido |
| J28 | La introducción ya califica el estudio como "evaluación exploratoria" explícitamente, en lugar de presentarlo como una validación general. | Atendido |
| J29 | El párrafo final de la introducción se reescribió con la idea de monitoreo constante y clasificación de errores en producción, aunque en una sola frase y no con la redacción sugerida. | Atendido |
| J30 | "Trabajos relacionados" ahora es narrativo: cada párrafo integra autor, hallazgo y relación con el estudio en prosa corrida, sin el formato de "recital estructurado" señalado. | Atendido |
| J31 | Laban et al. (2025) sigue presente como estudio de referencia, con una frase que explica por qué es relevante ("evaluar los sistemas conversacionales a lo largo de varios mensajes"). | Atendido |
| J32 | Yuan et al. (2024), sobre premisas falsas, se incorporó como referencia nueva, citada en la Discusión. No se citó explícitamente en "Trabajos relacionados" para responder este comentario, pero sí se referenció en el cuerpo del artículo. | Parcial |
| J33 | "turno 0" no aparece en Metodología; se usa "consulta de control". | Atendido |
| J34 | La subsección "Diseño de la investigación" ahora explica el diseño como "comparativo pareado" y describe control vs. tratamiento con 3 turnos. No lo describe con el lenguaje de "grupo control/grupo tratamiento" que pedía John ni menciona explícitamente "LLM as a Judge" en este punto del texto (aparece más adelante). | Parcial |
| J35 | No se agregó un diagrama o figura del diseño experimental. | No atendido |
| J36 | La subsección "Herramientas y evaluación de las respuestas" describe la función de Gemini (generación de consultas, evaluación por turno, LLM-as-a-Judge) y menciona que los prompts se incluyen en los anexos. No se pudo verificar si los anexos realmente contienen los prompts, porque el archivo de anexos no se revisó en esta pasada. La mención a Excel ya no aparece. | Parcial (ver "No verificado") |
| J37 | Las tablas y figuras de la versión actual ya no parecen capturas de pantalla transcritas; se presentan como tablas `rcctabla` nativas. | Atendido |
| J38 | La "Estructura de la base de datos" ya no usa una lista de viñetas; está en un párrafo narrativo. | Atendido |
| J39 | La tabla de una sola columna con las 8 variables (`tab:estructura`) se eliminó; la estructura de la base de datos se describe en prosa. | Atendido |
| J40 | La sección de Resultados se redujo considerablemente (de ~12 subsecciones con listas a 9 subsecciones narrativas), aunque conserva 7 tablas y 2 figuras, varias con contenido redundante entre sí (ver J54). | Parcial |
| J41 | "Distribución de los registros según la etapa de evaluación" ahora explica qué son las 4 etapas (control + 3 turnos) en el mismo párrafo, en vez de asumir que el lector ya lo sabe. | Atendido |
| J42 | La subsección ya no usa una lista de viñetas; es un párrafo narrativo. | Atendido |
| J43 | La tabla de registros por etapa (`tab:descriptiva`) se mantiene, aunque J43 pedía eliminarla por redundante con el texto. | No atendido |
| J44 | No se incluyó un gráfico de barras horizontal para la distribución por sector; se mantiene una tabla. | No atendido |
| J45 | El texto sobre distribución por sector ya no lista los datos en viñetas, pero tampoco explica qué consecuencia tiene que Tecnología concentre el 43,33 % de la muestra; solo dice que "los resultados... estuvieron influenciados en mayor medida" por ese sector. | Parcial |
| J46 | La subsección "Distribución de respuestas evaluadas en la interacción multiturno" (y su lista redundante sobre 90 respuestas en 30 conversaciones) ya no existe como tal. | Atendido |
| J47 | La explicación de que la consulta de control sirve como referencia ahora está en Metodología ("Diseño de la investigación" y "Procedimiento de evaluación"), no en Resultados. | Atendido |
| J48 | El título de subsección "Estadística descriptiva general de las respuestas en los tres turnos" se eliminó; la subsección actual se llama "Resultados generales" con texto narrativo. | Atendido |
| J49 | El tratamiento de la abstención como categoría propia se describe explícitamente en Metodología ("Criterios de evaluación") y se repite en Resultados: "Las respuestas en las que el chatbot se abstuvo... deben distinguirse de aquellas que presentaron afirmaciones factualmente incorrectas". | Atendido |
| J50 | El resumen de resultados generales ya no repite ambos porcentajes en viñetas separadas; se integra en una frase, aunque sigue reportando tanto el porcentaje correcto como el de fallos, no solo el de fallos como pedía el comentario. | Parcial |
| J51 | La frase "Estos resultados representan el comportamiento de los chatbots al ser evaluados" ya no aparece. | Atendido |
| J52 | Las tablas de resultados generales se mantienen (`tab:descriptiva` con los indicadores generales), contrario a lo que pedía J52 (resumir todo en un párrafo sin tabla). | No atendido |
| J53 | La comparación por turno ahora está en prosa ("se identificaron cinco respuestas incorrectas en el primer turno... tres en el segundo... y tres en el tercero"), sin crear una subsección aparte para esto, como J53 pedía. | Atendido |
| J54 | La tabla y figura de fallos por turno (`tab:sec_turnos`, `fig:fallos-turno`) se mantienen, pese a que J54 las consideraba redundantes con lo ya dicho en el texto. | No atendido |
| J55 | No se incorporó un intervalo de confianza por estimación puntual ni una prueba de comparación de medias adicional a McNemar. La prueba de McNemar sí se formalizó con su propia subsección ("Comparación estadística"), con nivel de significancia declarado (0,05) y nota aclaratoria sobre la potencia limitada de la prueba. | Parcial |
| J56 | Los nombres de empresas (Olímpica, Bancolombia, AWS, HP, AT&T, etc.) se eliminaron por completo del texto. Los resultados se presentan agrupados por sector únicamente (`tab:sectores2`, `tab:multxsec`). | Atendido |
| J57 | La matriz de errores por chatbot nombrado (con la inconsistencia "más de 2 errores" vs. 2 en la matriz) ya no existe; se reemplazó por la tabla agrupada por sector. | No aplica |
| J58 | El aviso de datos faltantes del proceso automatizado de conversión ya no aparece en el texto. | Atendido |
| J59 | La prueba de McNemar ahora se explica en su propia subsección antes de presentarla: "Esta prueba permite comparar dos mediciones relacionadas sobre los mismos individuos cuando la variable analizada es dicotómica... Se estableció un nivel de significancia de 0,05". | Atendido |
| J60 | El texto de "Resultados de la evaluación multiturno por sector" ahora incluye una advertencia explícita: "estos resultados deben interpretarse de manera descriptiva y con cautela, debido a que la cantidad de chatbots y respuestas evaluadas varió considerablemente entre sectores". | Atendido |
| J61 | "Resultados de la evaluación de control" ya no usa viñetas; es un párrafo narrativo. | Atendido |
| J62 | La subsección "Validación final de los datos" (con la tabla `tab:validacion`) se eliminó por completo. | Atendido |
| J63 | Se agregó la sección "Discusión de resultados" completa, con 4 párrafos: respuesta a la pregunta de investigación, comparación con Laban et al. y Farquhar et al., limitación del diseño (no hay condición de un solo turno con la misma premisa, citando a Yuan et al.) y discusión de la variación por sector. Cumple la extensión sugerida (3 a 5 párrafos) y compara con otros autores. | Atendido |
| J64 | La Discusión compara explícitamente el hallazgo de que los errores no aumentan con los turnos frente a Laban et al. (2025), aunque aclara que "sus resultados no son directamente comparables con los de esta investigación". | Atendido |
| J65 | "fuentes de referencia" ya no aparece como término ambiguo; el texto actual usa "consulta de control" consistentemente como referencia de comparación. | Atendido |
| J66 | La frase de cajón sobre "leer con suspicacia" ya no está. La Discusión sí analiza en qué condiciones fallan los chatbots (premisa falsa, turnos, sector), aunque sin señalar un motivo único o un chatbot/sector específico causante. | Atendido |
| J67 | El párrafo final vacío de las conclusiones anteriores ya no existe en esa forma; las conclusiones actuales (4 párrafos) tienen contenido específico en cada uno. | Atendido |
| J69 | La caja sobrepasada de aprox. 69 pt sigue presente en el log de compilación, pero ya no está en el bloque CRediT: ahora está en el bloque `\datos` (línea 361 de `main.tex`, confirmado en `main.log`). El problema de layout no se resolvió, solo cambió de ubicación. | No atendido |
| J70 | La declaración de IA se mantiene igual que antes ("Google AI Studio (Gemini 3.8-flash)", "optimizar algunas de las actividades"), sin completar fase, función exacta, fechas, supervisión ni validación que pedía el comentario. | No atendido |
| J71 | El comentario sigue literalmente en el texto (`\txcomment[author=john,id=J71,...]`), sin resolver. Los agradecimientos a los coautores como si fueran externos ("Agradezco a mi compañero...") se mantienen sin cambios. | No atendido (comentario aún abierto) |
| J72 | La nota de decisión sobre la referencia 8 excluida ya no aparece como comentario en el texto; tampoco se incluyó esa referencia. La decisión implícita fue mantenerla excluida, pero no hay un registro explícito de esa resolución en `main.tex` (sigue en `notes/decisiones.md`, D1). | Parcial |

## Comentarios de Peter (R201–R240)

| ID | Severidad | Hallazgo en el texto actual | Veredicto |
|---|---|---|---|
| R201 | Mayor | El título cambió a "Alucinaciones factuales ante premisas falsas en chatbots de servicio al cliente: evaluación descriptiva multiturno de 30 chatbots", que usa un solo término ("chatbots"), indica el tipo de estudio ("evaluación descriptiva") y ya no dice "hispanohablantes". Tiene 16 palabras, no se verificó límite porque la revista no define uno. | Atendido |
| R203 | Menor | El resumen ahora define la "evaluación de control" en el bloque Método ("una consulta de control y tres turnos de interacción") antes de reportarla en Resultados, y sí reporta el resultado de McNemar ("La prueba exacta de McNemar no identificó diferencias estadísticamente significativas"). Los decimales usan coma de forma consistente en el resumen. | Atendido |
| R210 | Menor | El párrafo 2 de la introducción ya no usa primera persona ("lo llamamos") ni tiene los errores de concordancia señalados; está en voz impersonal. | Atendido |
| R211 | Menor | El párrafo 3 de la introducción se reescribió sin la frase confusa sobre "opciones múltiples"; ahora distingue con claridad chatbots de opciones predefinidas frente a los de lenguaje natural, y cita a Laban et al. antes del punto. | Atendido |
| R212 | Menor | El párrafo sobre complacencia nombra el fenómeno explícitamente ("sycophancy") y cita una fuente específica (`\citet{sharma2024}`). Las expresiones "contra dicientes", "se continua" ya no aparecen en ese párrafo. | Atendido |
| R213 | Mayor | La introducción cierra con la pregunta de investigación y el objetivo en el último párrafo ("A partir de esta problemática, la investigación busca responder..."), después del contexto y el vacío de conocimiento. El objetivo usa "fallos factuales" en vez de "alucinaciones factuales", alineado con la variable medida. | Atendido |
| R216 | Mayor | El párrafo final de "Trabajos relacionados" declara el vacío de conocimiento explícitamente: "se identifica una oportunidad de investigación relacionada con la evaluación de alucinaciones factuales en chatbots comerciales de servicio al cliente... particularmente en interacciones desarrolladas en español". Se agregaron referencias no preprint (`ji2023`, `farquhar2024`, ambos con DOI de revista) que sí definen el concepto de alucinación. | Atendido |
| R217 | Mayor | La subsección "Selección de la muestra" ahora describe los criterios de inclusión/exclusión (sistemas disponibles para interacción directa, se excluyen plataformas proveedoras como unidades de análisis), el idioma ("todas las interacciones se realizaron en español") y el periodo de recolección (1 de septiembre a 31 de octubre). No se usa la palabra "hispanohablantes" en el título. | Atendido |
| R218 | Menor | Se revisó el texto completo y no se encontraron los errores ortográficos puntuales citados ("La investigación se realizando", "distintitos", "Se realizo", "Se busco", "Olimpica presento mas de 2 errores", "se continua"); la voz es impersonal en Metodología. | Atendido |
| R219 | Mayor | La Discusión declara explícitamente la limitación: "el diseño experimental no permite establecer si los errores se produjeron exclusivamente por la presencia de la premisa falsa o por la continuidad de la interacción, debido a que no se incluyó un escenario de comparación en el que la misma premisa se presentara mediante una consulta de un solo turno". | Atendido |
| R220 | Mayor | La variable de resultado se unificó: el texto usa consistentemente "fallo", "error factual" y "alucinación" con una definición operacional en "Criterios de evaluación" (contradice la referencia o mantiene como verdadera una afirmación introducida). Se describe la revisión humana sobre las clasificaciones de Gemini, pero no se reporta el número de evaluadores humanos ni un coeficiente de acuerdo entre ellos. | Parcial |
| R223 | Menor | La subsección "Comparación estadística" no menciona explícitamente el método de ajuste del valor p (Bonferroni, Holm, etc.), aunque la Tabla de McNemar sí incluye una columna "Valor p ajustado" y la nota aclara que corresponde a "la corrección por comparaciones múltiples aplicada en el análisis", sin nombrar el método. Sí se reporta que las 90 respuestas no son independientes (3 por chatbot) en la nota de la Tabla 8. No se reporta cuántos chatbots tuvieron al menos un fallo en el cuerpo del texto, aunque se puede inferir combinando tablas. | Parcial |
| R226 | Menor | La frase en primera persona ("en la que nos basábamos para poder evaluar al chatbot") ya no existe; la sección "Procedimiento de evaluación" está en voz impersonal y sin listas de viñetas sin punto final. | Atendido |
| R228 | Menor | El formato de turno se unificó a "turno 1", "turno 2", "turno 3" en todo el texto, y los decimales usan coma de forma consistente ("16,67", "10,00"). | Atendido |
| R229 | Sugerencia | El texto de Resultados ahora menciona junto a la caída por turno que "la prueba exacta de McNemar no identificó diferencias estadísticamente significativas", en la misma subsección donde se reporta la caída descriptiva. | Atendido |
| R231 | Menor | La Tabla 8 (McNemar) tiene ahora una nota explicativa completa: define la prueba, el criterio de significancia (p < 0,05) y aclara que los valores p ajustados corresponden a corrección por comparaciones múltiples. También se añadió el párrafo: "la ausencia de diferencias estadísticamente significativas... debe interpretarse con cautela. El número reducido de pares discordantes limita la capacidad de la prueba para detectar diferencias". | Atendido |
| R232 | Sugerencia | El texto no verifica explícitamente si los 2 fallos de Retail provienen de un solo chatbot (ya no hay matriz por chatbot nombrado para comprobarlo). Sí advierte de forma general que "los porcentajes obtenidos en sectores con pocas observaciones pueden cambiar sustancialmente ante la presencia de uno o dos errores". | Parcial |
| R233 | Mayor | El texto de "Resultados de la evaluación de control" sigue reportando la cifra (10 de 30, 33,33 %) sin explicar el criterio exacto con el que se determinó una alucinación en el control, más allá de la definición general de "Criterios de evaluación". No indica si esos 10 chatbots son los mismos que fallaron en algún turno multiturno. | No atendido |
| R237 | Menor | Las conclusiones incluyen las cifras clave (12,22 % de respuestas con fallo, 10 de 30 chatbots con alucinación en el control) y el apartado de trabajo futuro propone dos líneas concretas: ampliar la muestra con distribución equilibrada por sector, y evaluar la misma premisa falsa en una condición de un solo turno frente a multiturno. | Atendido |
| R238 | Menor | Los errores de redacción citados ("Se realizo", "se identificaron que", "antes todas las situaciones", "como se comportaban según seguía la conversación") no aparecen en las conclusiones actuales, que se reescribieron por completo. | Atendido |
| R239 | Menor | La declaración ética ya no usa `\sinetica`; tiene texto propio que indica que no se ingresaron datos personales reales, no se hicieron trámites ni transacciones, y que se procuró respetar las condiciones de uso de las plataformas. Queda pendiente, declarado en el propio texto, si el comité institucional determinó la exención de revisión. | Atendido |
| R240 | Mayor | La declaración de datos ya no usa `\sindatos`; indica que los datos existen (120 registros), que los nombres de las empresas se reemplazaron por códigos, y que se publicarán en un repositorio "una vez se complete su anonimización", sin enlace de acceso concreto todavía. | Parcial |

## Comentario que permanece abierto

- **J71** (`author=john,id=J71,status=pending`): "No está bien agradecer asimismo como autores, realmente no veo necesario agradecer". El bloque de agradecimientos no cambió: sigue en primera persona del singular, agradeciendo al "profesor" (que es uno de los coautores, `José John Freddy Gonzalez Veloza`) y al "compañero" (otro coautor, `Diego Alejandro Velasquez Villalba`) como si fueran externos al equipo autor.

## Resumen de veredictos

| Veredicto | John (71) | Peter (22) | Total (93) |
|---|---|---|---|
| Atendido | 46 | 17 | 63 |
| Parcial | 11 | 4 | 15 |
| No atendido | 11 | 1 | 12 |
| No aplica | 3 | 0 | 3 |

De los 12 "No atendido", J71 sigue abierto en `main.tex`. El registro completo por comentario está en `notes/trazabilidad_comentarios.md`.

## Acciones prioritarias antes de enviar

1. Resolver J71: decidir si se mantiene el agradecimiento entre coautores o se elimina, y borrar el `\txcomment` pendiente.
2. Corregir la declaración de IA (J70/R220 relacionado): completar fase, función exacta, fechas, supervisión y validación del uso de Gemini, en vez de mantener la frase genérica "optimizar algunas de las actividades".
3. Completar la declaración de disponibilidad de datos (R240): agregar el enlace de acceso concreto al repositorio, no solo la promesa de publicarlo.
4. Definir con qué criterio se evaluó la consulta de control (R233) y si los 10 chatbots con alucinación en control coinciden con los que fallaron en algún turno.
5. Revisar y resolver la caja sobrepasada de ~69 pt en el bloque `\datos` (J69, confirmada en `main.log`, líneas 364–368 según el reporte de compilación).
6. Quitar la entrada `huang2025` del `.bib` si no se va a citar, o agregar la cita correspondiente en el texto.
7. Actualizar el comentario de cabecera de `referencias.bib`, que todavía tiene el título antiguo del artículo.
8. Reportar en el texto (no solo en tablas) cuántos chatbots tuvieron al menos un fallo en total (R223), y el método de ajuste del valor p usado en McNemar.
9. Adoptar la convención de cambiar `status=pending` a `accepted` o `rejected` en los `\txcomment` antes de borrarlos, para dejar trazabilidad de qué motivó cada cambio (como hace `efecto_halo`).

## No verificado

- No se revisó el contenido de los anexos para confirmar si los prompts de generación de consultas y evaluación (J36) están efectivamente incluidos ahí.
- No se recalcularon los resultados de la prueba de McNemar ni las proporciones reportadas; solo se verificó que las cifras coincidan entre resumen, abstract, texto y tablas.
- No se verificó la legibilidad de las figuras `figura-fallos-turno.pdf` y `figura-fallos-sector.pdf` en el PDF renderizado, más allá de que la compilación las incluye sin error.
- No se confirmó si el comité de ética de la institución fue consultado, dato que la propia declaración ética deja pendiente.
