# Verificación de referencias y mapeo de citas

Fecha de verificación: 2026-11-16. Fuente de cada referencia: búsqueda web y páginas de arXiv o ACL Anthology.
Las líneas indican posición en `articulos/multiturno/main.tex`.

## Tabla de verificación

| # | Referencia en el .docx | Estado | Fuente verificada | Discrepancias | Citas en main.tex |
|---|---|---|---|---|---|
| 1 | P. Laban et al., "LLMs Get Lost in Multi-Turn Conversation," 2025. | Existe | arXiv:2505.06120 (enviado el 9 de mayo de 2025). Autores: Philippe Laban, Hiroaki Hayashi, Yingbo Zhou, Jennifer Neville. | El texto cita "Laban et al. (2026)" (línea 97). La referencia dice 2025. | Línea 82 ([1], [2], [4]); 97 (Laban 2026); 459 (lista). |
| 2 | X. Guo et al., "Stop Listening to Me! How Multi-turn Conversations Can Degrade LLM Diagnostic Reasoning," 2026. | Existe con otro título | arXiv:2603.11394 (v3, mayo de 2026). Autor principal: Kevin H. Guo, con 7 coautores. Título en arXiv: "...Can Degrade LLM Reliability". | Inicial incorrecta: "X." debe ser "K.". Título distinto: "Diagnostic Reasoning" en el .docx y "Reliability" en arXiv. Los datos del texto (17 modelos, tres conjuntos clínicos, "conversation tax") coinciden con el resumen. | Líneas 82, 84 ([2]); 99 (Guo 2026); 460 (lista). |
| 3 | Y. Huang et al., "Do LLMs Benefit from Their Own Words?," 2026. | Existe | arXiv:2602.24287 (27 de febrero de 2026). Autores: Jenny Y. Huang et al. Publicado en COLM 2026. | Ninguna en título, año ni autor. Conviene citar la versión de COLM 2026 si está disponible. | Líneas 84 ([3]); 101 (Huang 2026); 461 (lista). |
| 4 | A. Sinha et al., "Beyond Continuity: Challenges of Context Switching in Multi-Turn Dialogue with LLMs," 2026. | Existe | arXiv:2605.09268 (10 de mayo de 2026). Autores: Aditya Sinha, Harald Steck, Vito Ostuni, Matteo Rinaldi. Aceptado en el taller ICBINB @ ICLR 2026. | Ninguna en título, autor ni año. Es un artículo de taller. | Líneas 82 ([4]); 103 (Sinha 2026); 462 (lista). |
| 5 | A. Graf et al., "TurnWise: The Gap between Single- and Multi-turn Language Model Capabilities," 2026. | Existe | arXiv:2603.16759 (17 de marzo de 2026). Autores: Victoria Graf, Valentina Pyatkin, Nouha Dziri, Nathan Lambert, Hannaneh Hajishirzi. | Inicial incorrecta: "A." debe ser "V.". Los datos del texto (TurnWiseEval, 12 %, 10.000 conversaciones) coinciden con el resumen. | Líneas 105 ([5]; Graf 2026); 463 (lista). |
| 6 | R. Joshi et al., "Amulet: Putting Complex Multi-Turn Conversations on the Stand with LLM Juries," 2025. | Existe, con otro primer autor | EMNLP 2025 (ACL Anthology 2025.emnlp-main.1300). Autores: Sahana Ramnath, Anurag Mudgil, Brihi Joshi, Skyler Hallinan, Xiang Ren. | Primer autor incorrecto: el primer autor es Ramnath, y Brihi Joshi es el tercero. El texto ya cita "Ramnath et al. (2025)". Además, la publicación es un artículo de conferencia, no un preprint. | Líneas 107 (Ramnath 2025); 464 (lista). |
| 7 | X. Huang et al., "Eliciting Behaviors in Multi-Turn Conversations," 2025. | Existe | arXiv:2512.23701 (29 de diciembre de 2025). Autores: Jing Huang, Shujian Zhang, Lun Wang, Andrew Hard, Rajiv Mathews, John Lambert. | Inicial incorrecta: "X." debe ser "J.". Las afirmaciones del texto sobre métodos estáticos y dinámicos no se confirmaron en el resumen; requieren revisar el artículo completo. | Líneas 84 ([3], [7]); 109 (Huang 2025); 465 (lista). |
| 8 | Microsoft Research (2024). "Faithfulness in Long-context and Multi-turn Conversations." URL: https://arxiv.org/pdf/2505.06120 | No verificada. Probablemente incorrecta. | Búsquedas en la web no encontraron ningún trabajo con ese título. La URL apunta a arXiv:2505.06120, que es el artículo de Laban (referencia 1). | La referencia no se cita en el texto. Su URL duplica la referencia 1. El formato del texto también está roto (enlace en Markdown dentro de la lista). | Solo en la lista (línea 466). Ninguna cita en el texto. |

## Datos del texto verificados

- Ramnath et al. (2025), línea 107: "las intenciones de los usuarios cambiaban entre un 60 % y un 70 %". El resumen de Amulet (arXiv:2505.20451) afirma que los humanos cambian de intención entre el 60 y el 70 % de las veces. Coincide.
- Huang et al. (2025), línea 109: "los métodos dinámicos ... podían identificar comportamientos problemáticos que algunas evaluaciones estáticas no lograban detectar". El artículo (arXiv:2512.23701) reporta que los métodos online, que adaptan las consultas, logran una tasa de éxito de 45/19/77 % donde los métodos estáticos encuentran pocos o ningún fallo. Coincide.

## Resultado de la etapa 2

- `referencias.bib` reescrito con las 7 referencias verificadas. Cada corrección queda anotada en el .bib como comentario junto a su entrada.
- Referencia 8: no incluida. Su nota está en el .bib como comentario.
- `main.tex`: las citas [n] se cambiaron por `\citep` y `\citet` según el mapeo de esta tabla. La lista manual de referencias se sustituyó por `\bibliography{referencias}`.
- Año de Laban: el texto pasó de 2026 a 2025, según el artículo.
- Compilación: 0 errores de LaTeX, 0 citas sin resolver y 0 advertencias de BibTeX.

## Formato de citas

En el texto, las citas son numéricas ([1], [2]), con estilo IEEE. La plantilla RCC usa APA 7 con `\citep` y `\citet`. Al pasar a BibTeX habrá que cambiar también las citas del texto, no solo la lista.
