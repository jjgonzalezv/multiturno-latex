# Reflexión: el diseño es una prueba metamórfica

Fecha: 21 de noviembre de 2026. Comentario asociado en `main.tex`: NUEVO11 (al inicio del documento).

## El patrón que se repite

En `articulos/efecto_halo/main.tex` y en este artículo, el problema, los resultados y la discusión no se conectan. La causa común es que el diseño plantea una pregunta y el análisis estadístico responde otra.

- El diseño de los dos trabajos compara al mismo asistente consigo mismo: una consulta de control y una consulta de tratamiento (perturbada). Si las respuestas se contradicen, hay evidencia de que el asistente cambia según el contexto.
- El análisis, en cambio, reporta tasas de acierto como si se conociera la respuesta correcta.
  - Efecto halo: tasa de FAIL contrastada con un umbral del 20 % sin justificación (comentarios Posterior01, Posterior14 y S08) y comparación entre tipos de ruido. El control no se clasifica ni se reporta (Posterior12).
  - Multiturno: McNemar entre turnos, nunca control frente a tratamiento, y una sección que afirma que 10 de 30 asistentes "alucinaron en el control".
- Como las pruebas no responden la pregunta, la discusión se llena de cautelas y el trabajo parece no haber encontrado nada. Es la preocupación del comentario Posterior17 en efecto halo.

## La idea de fondo

No tenemos oráculo: no conocemos la respuesta correcta de cada empresa ni su arquitectura. La referencia la construimos con la consulta de control. Ese es el planteamiento de la **prueba metamórfica** (metamorphic testing): se aplica una transformación que no debería cambiar el resultado (relación de invariancia), y si la salida cambia, el sistema tiene un fallo. Visto desde la lógica, es una **demostración por contraejemplo**: la hipótesis "el asistente es inmune a esta perturbación" se refuta con un solo caso de contradicción.

Consecuencias directas:

- El control no puede "fallar" ni "alucinar". Es la salida de origen. Lo único observable es si la salida de seguimiento viola la relación.
- El umbral del 20 % de efecto halo sobra. Una violación ya refuta la invariancia. Lo que tiene sentido estimar es con qué frecuencia ocurre, con su intervalo de confianza.
- El LLM as a Judge no decide qué es verdad. Detecta contradicciones entre dos salidas del mismo sistema, que es una tarea más acotada y validable con un humano. Esto responde la objeción "critican un LLM usando otro LLM" (Posterior17).

## Matices antes de usar el marco

1. **Cada perturbación necesita su relación metamórfica escrita, y no todas son invariancias puras.** En subespecificación (falta un dato) lo esperado es que el asistente pida el dato, no que responda igual. La relación sería "no contradecir el control ni inventar el dato faltante". En premisa falsa, lo invariante son los hechos del producto, no el texto de la respuesta.
2. **Una violación demuestra inconsistencia, no cuál salida es la errónea.** Conviene hablar de "contradicciones" y no de "alucinaciones" en los resultados.
3. **No determinismo.** Un LLM puede cambiar su respuesta ante la misma consulta repetida. Sin medir esa variación de base, parte de las violaciones puede ser azar. La comparación de referencia es repetir la consulta de control en una sesión nueva, al menos en una submuestra. Aplica a los dos artículos.
4. **Abstención.** Una respuesta como "no tengo información" no viola la relación ni la cumple: es un caso no concluyente. Esto da un argumento metodológico para la categoría ABSTENCIÓN que pide NUEVO07.

## Pendientes para multiturno

Los estudiantes deben poder explicar, sin mirar el documento, qué es un fallo en este estudio y por qué se detecta sin conocer la respuesta correcta. Los cambios al texto vienen después.

- [ ] Encuadrar el método como prueba metamórfica desde la introducción, explicando el problema del oráculo.
- [ ] Escribir la relación metamórfica de cada tipo de perturbación (subespecificación, fragmentación contextual, síntesis multiturno y, donde aplique, premisa falsa). Se conecta con NUEVO06 y J10.
- [ ] Redefinir FAIL como violación de esa relación y ABSTENCIÓN como caso no concluyente (NUEVO07, R220).
- [ ] Quitar la sección "Resultados de la evaluación de control" y la cifra de 33,33 %. En su lugar, reportar cuántos controles no dieron una salida de origen utilizable y excluirlos del análisis declarándolo (NUEVO08, R233).
- [ ] Revisar si el juez usó fuentes externas como oráculo (Ley 100, Ley 1801, referencias [1], [2]) y decidir qué hacer con esos casos (NUEVO08).
- [ ] Medir la variación de base: repetir la consulta de control en una submuestra y reportar cuántas veces el asistente se contradice consigo mismo.
- [ ] Hacer que la cifra principal sea por asistente: "k de N asistentes violaron la relación en al menos un turno", con intervalo de Wilson.
- [ ] Dejar McNemar o la Q de Cochran como análisis secundario, declarando que la posición del turno y el tipo de perturbación están confundidos (NUEVO06, R223, J55).
- [ ] Ajustar el prompt del juez para que evalúe contradicción frente al control, no veracidad, y repetir la validación humana a ciegas (NUEVO10, J36).
- [ ] Reescribir la discusión alrededor de la cifra principal, comparándola con Laban et al. (2025) y Sharma et al. (2024), y cerrar las conclusiones con los tres pasos de NUEVO03.
- [ ] Actualizar título, resumen y abstract al final, cuando lo anterior esté resuelto (NUEVO04).

## Pendiente para efecto halo

- [ ] Llevar este mismo marco a efecto halo, junto con Posterior17: retirar o justificar el umbral del 20 % (Posterior14) y explicar por qué el control no se clasifica (Posterior12).

## Lecturas sugeridas (verificar datos bibliográficos antes de citar)

- Chen, T. Y., Cheung, S. C. y Yiu, S. M. (1998). *Metamorphic testing: A new approach for generating next test cases*. Informe técnico HKUST-CS98-01. Origen del método.
- Chen, T. Y. et al. (2018). *Metamorphic Testing: A Review of Challenges and Opportunities*. ACM Computing Surveys, 51(1).
- Segura, S., Fraser, G., Sanchez, A. B. y Ruiz-Cortés, A. (2016). *A Survey on Metamorphic Testing*. IEEE Transactions on Software Engineering, 42(9).
- Ribeiro, M. T., Wu, T., Guestrin, C. y Singh, S. (2020). *Beyond Accuracy: Behavioral Testing of NLP Models with CheckList*. ACL 2020. Sus pruebas de invariancia (INV) son esta misma idea aplicada a NLP.
- Hyun, S. et al. *METAL: Metamorphic Testing Framework for Analyzing Large-Language Model Qualities*. arXiv:2312.06056. Aplica relaciones metamórficas a LLM.
