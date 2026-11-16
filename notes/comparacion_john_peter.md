# Comparación de comentarios: John (J01 a J72) y Peter (R201 a R242)

Artículo: `articulos/multiturno/main.tex`. Los comentarios de Peter están en `notes/revision_peter_multiturno.md` y en `main_revision.tex`. John tiene 71 comentarios (no existe J68). Peter tiene 42.

## 1. Coinciden

| Tema | John | Peter | Diferencia |
|---|---|---|---|
| Resumen y abstract pasan de 150 palabras | J02, J17 | R202, R207 | Ninguna. |
| 6 palabras clave, el máximo es 5 | J16 | R206 | Peter añade que repiten el título. |
| Tono coloquial del resumen | J03 | R205 | Peter añade frases incompletas. |
| Resultado del control confuso en el resumen | J12 | R203 | Peter añade que falta el resultado de McNemar. |
| Recomendación final del resumen sin respaldo | J14, J15 | R204 | Ninguna. |
| Introducción sin referencias | J18, J20, J26 | R208, R209 | Ninguna. |
| Objetivo mal formulado | J06, J07 | R213 | John pide un solo objetivo. Peter pide moverlo al final y alinear "alucinación" con "fallo". |
| Cierre de la introducción sin soporte | J28, J29 | R214 | Ninguna. |
| Trabajos relacionados como "recital" | J30 | R215 | Ninguna. |
| Falta posicionar el aporte | J24, J32 | R216 | John lo plantea como valor. Peter, como vacío no declarado. |
| Uso de Gemini y prompts sin especificar | J36 | R219, R221 | John pide función exacta, anexos y validación humana. Peter pide versión, tareas y supervisión. |
| "Turno 0" con varios nombres | J09, J25, J33, J47 | R224 | John fija "consulta control". Peter pide elegir uno. |
| Diseño no explicado | J34, J35 | R219 | Ver tensión 5. |
| Tabla de una columna con las variables | J38, J39 | R222 | John la mandaría a anexos. Peter pide un diccionario de datos. |
| McNemar no está en Metodología, análisis poco robusto | J55, J59, J60 | R223, R231 | Ninguna. |
| Muestras pequeñas por sector | J56, J60 | R232 | Ninguna. |
| Resultados redundantes | J40, J42, J43, J46, J48, J50, J52, J54, J61, J62 | R225, R227, R234 | John es más radical con las tablas. |
| "Más de 2 errores" de Olimpica | J57 | R230 | Mismo hallazgo. |
| Falta la Discusión | J63, J64, J66 | R235 | John da estructura: 3 a 5 párrafos, una conclusión por cada uno. |
| "Fuentes de referencia" sin explicar | J65 | R236 | Ninguna. |
| Cierre de conclusiones vacío | J66, J67 | R237 | John elimina el párrafo. Peter pide cifras y trabajo futuro concreto. |
| Declaración de IA incompleta | J70 | R241 | Ninguna. |
| Agradecimientos a coautores | J71 | R242 | Peter añade primera persona y nombres mal escritos. |

## 2. Solo los aporta John

- **J19:** error del chatbot no es lo mismo que alucinación del LLM. Hay que separar sistema y modelo (integración con los sistemas de información, ventana de contexto).
- **J49:** cómo se clasifican las respuestas de abstención ("no puedo ayudarte") o de aclaración ("¿me podrías aclarar?").
- **J56:** riesgo legal por identificar empresas, sin autorización ni lectura de términos de uso. Agrupar por sector.
- **Enfoque del problema:** J04, J05, J21, J26 (centrar en multiturno, concretar qué decisiones se afectan con cifras, justificar por qué este error) y J10 (justificar la "premisa falsa").
- **Presentación:** J23 (figura con un caso real), J35 (diagrama del diseño), J44 (barras horizontales), J11 (método y validación en el resumen), J45 (efecto del peso de Tecnología).
- **Análisis de los fallos:** J66 y J64 (por chatbot, sector, premisa o turno; comparar con la literatura por qué bajó la tasa de errores).
- **Transcripción del .docx:** J01, J37, J58, J69, J72.
- **Menores:** J08, J13, J22, J27, J31, J41, J51 y la mención de Excel (J36).

## 3. Solo los aporta Peter

- R240: la declaración de datos dice "no se generaron datos nuevos", pero hay 120 registros propios.
- R217: sin criterios de selección, idioma ni fecha. Se mezclan empresas con proveedores de plataformas.
- R220: no se define fallo, fuente de verdad, evaluador ni acuerdo entre evaluadores.
- R223: las 90 respuestas son 3 por chatbot (no independientes). Falta el método de ajuste de p y el alfa.
- R233: si el control es la referencia y el 33,33 % contiene alucinaciones, el diseño se debilita. ¿Son los mismos 10 chatbots que fallaron en algún turno?
- R201: "hispanohablantes" no se sustenta con lo escrito.
- R219: falta una versión de un solo turno con la misma premisa falsa.
- R232: los 2 fallos de Retail podrían venir de un solo chatbot.
- Forma: R210, R211, R212, R218, R228, R238, R207, R231.
- R216: las 7 referencias son preprints o ponencias y ninguna define alucinación.

## 4. Tensiones y propuesta de resolución

La decisión es de John, como director. La propuesta evita que David y Diego reciban instrucciones contradictorias.

| # | Tensión | Propuesta |
|---|---|---|
| 1 | J53 pone la frase "por sorpresa... no se observa degradación" en Resultados. R229 la lleva a Discusión. | En Resultados solo la cifra (17 %, 10 %, 10 %) y que McNemar no fue significativo. La interpretación va a Discusión, que J63 ya pide. |
| 2 | J08 quiere destacar "hispanohablantes". R201 dice que el texto no lo sustenta. | Se mantiene el énfasis, pero Metodología debe declarar el idioma de cada interacción y la fecha. Sin eso, quitar la palabra del título. |
| 3 | J55 sugiere ANOVA o t-test. Las respuestas son binarias y pareadas. | Pedir que justifiquen el método en Metodología. McNemar (o Q de Cochran para los tres turnos) encaja mejor. John debe confirmarlo. |
| 4 | J44 pide una figura nueva y J52, J54 piden quitar tablas y figuras. | Regla única: un dato aparece una sola vez (texto, tabla o figura). Se conserva la figura de sectores, con intervalos o con aviso de muestra pequeña. |
| 5 | J34 describe el diseño como pareado (control contra tratamiento). R219 pide también una línea base de un solo turno con premisa falsa. | Son compatibles. Declarar el diseño como lo describe J34 y, en Limitaciones, que no se aisló el efecto del multiturno. J66 hace la misma pregunta. |

## 5. Orden de trabajo sugerido para David y Diego

No hay que atender todo a la vez. Tres tandas, en este orden.

**Tanda 1: validez y requisitos (bloquea el envío).**
1. Metodología: muestreo, premisas, criterio de fallo, evaluador, fuente de verdad, función de Gemini, análisis estadístico, qué es la consulta control (R217 a R224, J34, J36, J59).
2. Resultados: recortar y decidir qué se conserva (R225 a R234, J40 a J62). Corregir R230 y quitar la identificación de empresas (J56).
3. Discusión nueva, y Conclusiones ligadas a ella (R235 a R237, J63 a J67).
4. Resumen a 150 palabras y 5 palabras clave (R202, R206, J02, J16, J17).
5. Declaraciones de datos, ética e IA (R239 a R241, J70).

**Tanda 2: introducción y claridad.** Reordenar la introducción, referencias, distinción sistema y LLM, trabajos relacionados en forma narrativa, objetivo único (J04 a J32, R208 a R216).

**Tanda 3: forma.** Redacción, formato numérico, agradecimientos, título (R201, R205, R210 a R212, R218, R228, R238, R242, J71).

## 6. Antes de enviar

- Quitar todos los `\txcomment`.
- Quitar los nombres de empresas (J56).
- Volver a compilar en modo manuscrito.
