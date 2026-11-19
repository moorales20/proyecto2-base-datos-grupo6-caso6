# Registro de decisiones de diseño: Proyecto Fase 2, Caso 6

**Curso:** TDFI103 Bases de Datos, Proyecto Semestral 2026
**Caso:** 6, Sistema Integral de Gestión de Expediciones Científicas Antárticas
**Documento base:** `DECISIONES_PENDIENTES.md` (19/11/2026)
**Versión del registro:** 1 · **Creado:** 19/11/2026 · **Última actualización:** (sin completar)

## 1. Propósito y alcance

Este documento es el registro de seguimiento de las decisiones de diseño de la Fase 2. Reúne las 20 decisiones identificadas al analizar el informe de Fase 1, el enunciado de Fase 2 y la rúbrica. Sirve para:

- saber qué está resuelto y qué no antes de modelar, programar o desplegar;
- dejar constancia de quién decidió, cuándo, por qué y cómo se validó (insumo para el informe, la bitácora y la defensa);
- mantener coherencia entre MERE, modelo relacional, script, PMV e informe (E§5, C1, C8).

**Este documento no contiene acuerdos del equipo.** Todos los campos de decisión, responsable, fecha y validación están sin completar y el estado de todas las decisiones es *Pendiente*, hasta que el equipo las apruebe.

### Siglas de las fuentes

| Sigla | Documento |
|---|---|
| **F1** | Informe Fase 1 (Caso 6), con § de sección o p. de página |
| **E** | Enunciado Fase 2, con § de sección o p. de página |
| **C1–C11** | Criterios de la Rúbrica Fase 2 |

### Estados posibles

| Estado | Significado |
|---|---|
| **Pendiente** | El equipo aún no ha aprobado una decisión. Es el estado inicial de todas. |
| **En consulta docente** | Se envió la consulta al docente y se espera respuesta. |
| **Adoptada** | El equipo aprobó la decisión; los campos de decisión, justificación, responsable y fecha están completos. |
| **Validada** | La decisión fue aplicada y comprobada; la evidencia de validación está registrada. |
| **Reemplazada** | Una decisión posterior la sustituyó (indicar cuál en el historial). |

---

## 2. Tabla resumen

La columna "Docente" indica si la decisión tiene una consulta asociada (ver sección 3): **Requerida** = depende de información que solo el docente puede dar; **Recomendada** = los documentos dejan una ambigüedad que podría confirmarse (el equipo decide si consulta).

| ID | Tema | Origen principal | Docente | Responsable | Fecha | Estado |
|---|---|---|---|---|---|---|
| D1 | Estructura de personas (Personal / Participante) | F1§3, F1§7.1, F1 p.8; E§6 | Recomendada | Por definir | (sin completar) | Pendiente |
| D2 | Cardinalidad Muestra–Recolección | F1§2, F1§3.2, F1§7; E§6, E§7 | Recomendada | Por definir | (sin completar) | Pendiente |
| D3 | Subtipos de muestra (atributos y garantía parcial + disjunta) | F1 p.8, F1§3, §4, §7; E§5, E§7 | No | Por definir | (sin completar) | Pendiente |
| D4 | Dominios de atributos con valores restringidos | F1§2, F1§3, F1§7; E§5 | No | Por definir | (sin completar) | Pendiente |
| D5 | Evaluación posterior al término de la expedición | F1§2, F1§3.2, F1§7 | No | Por definir | (sin completar) | Pendiente |
| D6 | Sector de la recolección vs. base de la expedición | F1§2, F1§7 | No | Por definir | (sin completar) | Pendiente |
| D7 | Tipo de `responsable` de expedición | F1§3, F1§7; E§6 | No | Por definir | (sin completar) | Pendiente |
| D8 | "Dentro del período" y fecha de término | E§7, E§10.1; F1§3.1, F1§7 | Recomendada | Por definir | (sin completar) | Pendiente |
| D9 | Reglas de capacidad | F1§2, F1§7; E§7 (R5) | No | Por definir | (sin completar) | Pendiente |
| D10 | Roles y permisos | E§6, E§10; C4; F1§2, F1§7, F1 p.8 | No | Por definir | (sin completar) | Pendiente |
| D11 | Tablas del CRUD y tipo de eliminación | E§10; C4; F1§7 | No | Por definir | (sin completar) | Pendiente |
| D12 | Relación unaria de supervisión | F1§3.3, F1§5, F1§7, F1§2; E§5 | No | Por definir | (sin completar) | Pendiente |
| D13 | Operación del formulario transaccional | E§10; C4 | No | Por definir | (sin completar) | Pendiente |
| D14 | Cuarta pregunta del dashboard | E§10.1; C4 | No | Por definir | (sin completar) | Pendiente |
| D15 | Tipo de identificadores | F1§7 | No | Por definir | (sin completar) | Pendiente |
| D16 | Organización de scripts SQL y de datos | E p.1, E§3, E§6, E§8; C2, C6 | Recomendada | Por definir | (sin completar) | Pendiente |
| D17 | Diseño del escenario de datos | E§6, E§11; C2 | No | Por definir | (sin completar) | Pendiente |
| D18 | Arquitectura del PMV | C5, C11; E§3, E§10 | No | Por definir | (sin completar) | Pendiente |
| D19 | Confirmaciones con el docente | E p.1, E§2, §3, §5, §13; F1 p.1 | **Requerida** | Por definir | (sin completar) | Pendiente |
| D20 | Asignación de responsables (matriz) | E§14, E§15; C7 | No | Por definir | (sin completar) | Pendiente |

**Recuento de estados:** Pendiente: 20 · En consulta docente: 0 · Adoptada: 0 · Validada: 0 · Reemplazada: 0
*(actualizar este recuento cada vez que cambie un estado)*

### Orden sugerido de resolución *(sugerencia de planificación, no exigencia de los documentos)*

- **Antes de escribir el DDL:** D1–D9, D12, D15 y D16.
- **Antes de programar el PMV:** D10, D11, D13, D14 y D18.
- **Antes de implementar cualquier cosa:** D19 y D20 (E§14 exige la matriz antes de implementar).
- **Durante el poblamiento:** D17 (depende de lo resuelto en D1, D2, D5, D6, D8 y D9).

---

## 3. Decisiones que requieren aclaración docente

### 3.1 Requerida: D19 (confirmaciones sobre información que los documentos no entregan)

| Ítem | Qué se debe confirmar | Origen | Respuesta del docente | Fecha | Estado |
|---|---|---|---|---|---|
| D19-a | Observaciones del docente sobre la Fase 1 (E§2 y E§5 exigen consistencia con ellas) | E§2, E§5 | (sin completar) | (sin completar) | Pendiente |
| D19-b | NRC y nombre del docente para la portada | E§13 | (sin completar) | (sin completar) | Pendiente |
| D19-c | Fecha de entrega en Canvas | E p.1 | (sin completar) | (sin completar) | Pendiente |
| D19-d | Herramienta de IA aprobada: E§3 indica "Herramienta aprendida en curso NoCode / OpenCode" | E§3 | (sin completar) | (sin completar) | Pendiente |
| D19-e | Aceptación de diagrams.net (usado en F1) como herramienta equivalente a ERDPlus | E§3; F1 p.8 | (sin completar) | (sin completar) | Pendiente |
| D19-f | Correo completo de Matías Morales (truncado en la portada de F1) | F1 p.1; E§13 | (sin completar) | (sin completar) | Pendiente |

*D19-f puede resolverse dentro del equipo; se mantiene aquí porque afecta la portada exigida en E§13.*

### 3.2 Recomendada: ambigüedades documentales que el equipo podría confirmar

Estas decisiones pueden tomarse dentro del equipo, pero los documentos dejan un punto sin definir. El equipo debe decidir si consulta. Si consulta, cambiar el estado a *En consulta docente* y registrar la respuesta.

| ID | Motivo de la posible consulta (según los documentos) | Pregunta sugerida | Consulta enviada | Respuesta | Estado de la consulta |
|---|---|---|---|---|---|
| D1 | E§6 pide Participantes (80–150) y Personal (40–80) como volúmenes distintos; F1§3 y §7 tienen una sola entidad PERSONAL; el diagrama de F1 muestra Persona → Trabajador / Participante. | ¿Participante y Personal deben ser entidades distintas, o los volúmenes de E§6 son solo orientativos sobre un modelo con una entidad de personas? | (sin completar) | (sin completar) | Pendiente |
| D2 | E§6 pide 300–700 recolecciones con 80–150 muestras; F1§3.2 define una relación 1:1 recolección–muestra. | ¿Los volúmenes de E§6 son vinculantes o el modelo puede mantener recolección–muestra 1:1 con menos recolecciones? | (sin completar) | (sin completar) | Pendiente |
| D8 | E§7 usa "período determinado" y rangos de fechas en R1, R4, R9, R11 y R12, sin definir cuándo una expedición queda dentro del período. | ¿Cómo se debe interpretar que una expedición esté dentro de un período (inicio, término, traslape)? | (sin completar) | (sin completar) | Pendiente |
| D16 | E p.1 y E§8 piden un script integral que incluye los datos y, aparte, un script de generación de datos; C6 menciona "el script del modelo relacional y el archivo de inserciones". | ¿Se espera un único script integral, o archivos separados de estructura e inserciones, además del generador? | (sin completar) | (sin completar) | Pendiente |

---

## 4. Registro detallado de decisiones

Convención de campos en cada decisión:

- **Alternativas:** solo las que tienen respaldo en los documentos. Si no las hay, se indica que el equipo debe proponerlas.
- **Validación sugerida:** orientación de cómo comprobar la decisión una vez aplicada (E§11 exige validar). Es una sugerencia, no un acuerdo.
- Los campos "Decisión adoptada", "Justificación", "Fecha" y "Evidencia de validación" están sin completar hasta que el equipo los llene.

### D1. Estructura de personas: Personal y Participante

- **Descripción:** F1 describe una sola entidad PERSONAL (con `tipoPersonal`) que participa en expediciones y puede tener cuenta. El diagrama MERE de F1 muestra una generalización *Persona → Trabajador / Participante*. E§6 pide volúmenes distintos para *Participantes* (80–150) y *Personal* (40–80), y define Personal como científicos, técnicos de terreno, coordinadores logísticos y administradores de base.
- **Origen:** F1§3, F1§7.1, F1 p.8 (diagrama); E§6.
- **Alternativas:**
  1. Mantener PERSONAL único (texto y relacional de F1); los rangos de E§6 son "orientativos".
  2. Adoptar la generalización del diagrama de F1 (Persona → Trabajador / Participante).
- **Impacto:** entidades del MERE; tablas y FK de PARTICIPACION, RECOLECCION, EVALUACION y CUENTA_USUARIO; poblamiento; redacción de R3, R8 y R11.
- **Aclaración docente:** Recomendada (ver 3.2).
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** comprobar que MERE, diagrama de Workbench, script y volúmenes de datos reflejan la misma estructura.

### D2. Cardinalidad Muestra–Recolección

- **Descripción:** F1 impone `idMuestra UNIQUE` en RECOLECCION (relación 1:1). E§6 pide 300–700 recolecciones y 80–150 muestras, y R7 exige conteo distinto de muestras. La regla 9 de F1 dice que cada recolección registra una muestra, pero no que la muestra aparezca solo una vez.
- **Origen:** F1§2 (regla 9), F1§3.2, F1§7; E§6; E§7 (R7).
- **Alternativas:**
  1. Quitar la unicidad (una muestra puede aparecer en varias recolecciones).
  2. Mantener 1:1 y ajustar el volumen de recolecciones (E§6 declara los rangos como orientativos).
- **Impacto:** MERE, DDL, poblamiento, y consultas R2, R6, R7 y R10.
- **Aclaración docente:** Recomendada (ver 3.2).
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** verificar en la BD poblada la relación entre cantidad de muestras y recolecciones, y que R7 entregue un conteo distinto con sentido.

### D3. Subtipos de muestra: atributos y garantía de especialización parcial y disjunta

- **Descripción:** Los atributos de los subtipos difieren entre el diagrama y el texto/relacional de F1. Además, el relacional con tres tablas hijas no impide por sí solo que una muestra esté en dos subtipos. R2 y R6 requieren obtener la clasificación de cada muestra.
- **Origen:** F1 p.8 (diagrama); F1§3, F1§4, F1§7; E§7 (R2, R6); E§5.
- **Alternativas:**
  - *Atributos:* (a) los del diagrama (biológica: tipo_organismo, características_biológicas, especie; geológica: tipo_roca, estructura_geológica, localización_estratégica; climática: parámetros_medidos, instrumento_utilizado, condiciones_momento); (b) los del texto/relacional (biológica: especie, tipoTejido; geológica: tipoRoca, composición; climática: variableClimática, valorMedido, unidadMedida).
  - *Mecanismo para garantizar disjunción y obtener la clasificación:* sin alternativas definidas en los documentos; el equipo debe proponerlas y justificarlas (E§5 pide "otras restricciones justificadas").
- **Impacto:** DDL, poblamiento, R2, R6 y gráfico de Dashboard Q2.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** intentar insertar una muestra en dos subtipos y confirmar el comportamiento esperado; verificar que existen muestras sin clasificar en los datos (E§6).

### D4. Dominios de atributos con valores restringidos

- **Descripción:** En F1 los atributos `tipoPersonal`, `estado` (participación), `funcion`, `nivelAislamiento`, `nivelAcceso` y `estadoConservacion` son VARCHAR sin CHECK ni catálogo. La regla 13 de F1 lista cuatro tipos de personal y nombra un elemento TIPO_PERSONAL que no existe en el MERE ni en el relacional. Los documentos no definen los valores permitidos del resto.
- **Origen:** F1§2 (regla 13), F1§3, F1§7; E§5.
- **Alternativas:** (a) restricción CHECK (E§5 la menciona); (b) tabla TIPO_PERSONAL como indica la regla 13 (solo aplicable a ese atributo). Los valores de cada dominio los define el equipo.
- **Impacto:** DDL, poblamiento y validaciones del formulario y del CRUD.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** intentar insertar valores fuera del dominio y confirmar el rechazo; verificar que los datos generados usan solo valores válidos.

### D5. Evaluación posterior al término de la expedición

- **Descripción:** La regla 11 de F1 indica que la evaluación se registra después de finalizar la expedición. F1 no tiene ninguna restricción que lo respalde. Además, la cardinalidad declarada PARTICIPACIÓN–EVALUACIÓN es 1:0..1, pero la PK de EVALUACION (idExpedicion, nroEvaluacion) no impide varias evaluaciones por participación.
- **Origen:** F1§2 (reglas 11 y 12), F1§3.2, F1§7.
- **Alternativas:** sin alternativas definidas en los documentos; el equipo debe proponer cómo garantizar (i) la unicidad por participación y (ii) la regla de fechas.
- **Impacto:** DDL, validaciones del formulario (si se elige evaluación) y coherencia de fechas en el poblamiento.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** consulta que busque evaluaciones duplicadas por participación y evaluaciones con fecha anterior al término de la expedición (debe dar cero filas).

### D6. Sector de la recolección vs. base de la expedición

- **Descripción:** RECOLECCION guarda su propio `idBase` y `nroSector` (FK a SECTOR), y EXPEDICION ya tiene `idBase`. F1 no establece si el sector de una recolección debe pertenecer a la base de la expedición.
- **Origen:** F1§2 (reglas 4, 8, 9), F1§7.
- **Alternativas:** sin alternativas definidas en los documentos; el equipo debe decidir si esto es una regla de negocio y cómo se respalda.
- **Impacto:** DDL, coherencia del poblamiento, y resultados de R2, R7 y R10.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** consulta que compare la base del sector de cada recolección con la base de su expedición.

### D7. Tipo del atributo `responsable` de expedición

- **Descripción:** En F1 `EXPEDICION.responsable` es VARCHAR(100). E§6 pide expediciones distribuidas por "responsables".
- **Origen:** F1§3, F1§7; E§6.
- **Alternativas:** mantener el atributo como texto (F1§7). Cualquier otra alternativa debe ser propuesta por el equipo.
- **Impacto:** DDL y poblamiento.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** revisar que los datos muestren responsables variados entre expediciones.

### D8. Significado de "dentro del período" y fecha de término de expedición

- **Descripción:** R1, R4, R9, R11 y R12 filtran por fecha de inicio y término (o rango de fechas). La expedición en F1 tiene solo `fechaInicio` y `duracionDias`. No está definido cuándo una expedición se considera dentro del período (inicio dentro, término dentro, traslape u otro).
- **Origen:** E§7 (R1, R4, R9, R11, R12); E§10.1 (filtro por período); F1§7.
- **Alternativas:** F1§3.1 establece el precedente de no guardar atributos derivables (caso `duraciónSemanas`), lo que respalda derivar la fecha de término desde `fechaInicio` + `duracionDias`. La alternativa de almacenarla y la semántica de "dentro del período" deben ser propuestas por el equipo.
- **Impacto:** MERE/DDL (si se almacena), los procedimientos que reciben fechas y el filtro de período del Dashboard Q1.
- **Aclaración docente:** Recomendada (ver 3.2).
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** probar rangos de fechas con expediciones de borde (que empiezan antes, terminan después, o se traslapan) y confirmar que los resultados siguen la regla acordada.

### D9. Reglas de capacidad

- **Descripción:** Existe `capacidadMaxima` en BASE y en EXPEDICION. R5 calcula la ocupación respecto de la capacidad máxima de las expediciones. Ninguna regla de F1 establece que las participaciones no superen la capacidad, ni relaciona ambas capacidades.
- **Origen:** F1§2, F1§7; E§7 (R5).
- **Alternativas:** sin alternativas definidas en los documentos; el equipo debe decidir si formaliza una regla o solo cuida la coherencia de los datos.
- **Impacto:** DDL o validaciones, poblamiento y resultados de R5.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** consulta que compare participaciones por expedición con su capacidad; revisar que R5 muestre tasas variadas.

### D10. Roles y permisos

- **Descripción:** E§10 exige login y al menos 2 roles con permisos diferenciados que controlen acceso real a funcionalidades. F1 tiene ROL con `descripcion`; el diagrama de F1 incluye un atributo `permisos`. No están definidos los roles concretos, sus permisos ni cómo se representan.
- **Origen:** E§6 (usuarios/roles), E§10 (funcionalidad 3); C4; F1§2 (regla 15), F1§7; F1 p.8 (diagrama).
- **Alternativas:** representación en la tabla ROL como `permisos` (diagrama) o `descripcion` (relacional); el equipo debe proponer cualquier otra. Los roles y permisos los define el equipo.
- **Impacto:** DDL, poblamiento de usuarios, módulo de usuarios y restricciones de acceso en el PMV.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** iniciar sesión con cada rol y comprobar qué funcionalidades quedan disponibles o bloqueadas.

### D11. Tablas del CRUD y tipo de eliminación

- **Descripción:** E§10 pide CRUD de al menos 2 tablas maestras o básicas, con eliminación o desactivación lógica si la física viola integridad referencial. Los documentos de Fase 1 no incluyen un indicador de estado/activo en las tablas maestras.
- **Origen:** E§10 (funcionalidad 2); C4; F1§7.
- **Alternativas:** E§10 da como ejemplo Base Científica y Muestra Científica (ejemplo, no obligación). Eliminación física o desactivación lógica según integridad (E§10).
- **Impacto:** DDL (posible indicador de estado), CRUD y datos de prueba.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** ejecutar crear, consultar, modificar y eliminar/desactivar sobre registros con y sin dependencias, y confirmar que no se rompe la integridad.

### D12. Relación unaria de supervisión

- **Descripción:** F1§3.3 propone la relación PERSONAL supervisa PERSONAL (1:N, opcional) y el relacional incluye `idSupervisor`. No figura entre las 15 reglas de negocio de F1 ni en el enunciado de Fase 2. No pudo confirmarse que aparezca en el diagrama.
- **Origen:** F1§3.3, F1§5, F1§7, F1§2; E§5.
- **Alternativas:** mantenerla (declarándola como regla de negocio) o retirarla.
- **Impacto:** MERE, DDL, poblamiento y consistencia entre reglas de negocio y modelo (E§5, C1).
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** verificar que reglas de negocio, MERE, relacional y datos coinciden respecto de esta relación.

### D13. Operación del formulario transaccional

- **Descripción:** E§10 permite que el formulario registre la participación de una persona en una expedición, o un registro de recolección de muestra durante una expedición, según elija el equipo. Debe seleccionar datos existentes, validar campos y respetar FK.
- **Origen:** E§10 (funcionalidad 1); C4.
- **Alternativas:** (a) registrar participación; (b) registrar recolección (ambas, según E§10).
- **Impacto:** tablas involucradas, validaciones y pruebas del PMV; relación con D2, D5, D6 y D9 según la opción.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** registrar una operación válida y varias inválidas (campos vacíos, referencias inexistentes) y comprobar el resultado en la BD.

### D14. Cuarta pregunta del dashboard

- **Descripción:** E§10.1 exige una cuarta pregunta propuesta por el equipo: relevante, no equivalente a las tres de Fase 1, formulada, justificada, resuelta con consulta SQL, con visualización y filtros pertinentes, y con la decisión de negocio que apoyaría.
- **Origen:** E§10.1; C4.
- **Alternativas:** ninguna en los documentos (la pregunta la propone el equipo). *Ideas orientativas del análisis previo, no provenientes de los documentos, basadas en atributos ya existentes en F1:* evolución de expediciones por año; participación por tipo de personal o función; estado de las participaciones; presupuesto de país vs. cantidad de expediciones.
- **Impacto:** consulta SQL propia del dashboard (distinta de las vistas y procedimientos, E§9) y visualización.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** comprobar que la pregunta no es equivalente a las tres de Fase 1, que los filtros funcionan y que el resultado permite una decisión de negocio explicable.

### D15. Tipo de identificadores

- **Descripción:** F1§7 define los identificadores como VARCHAR(10). Los documentos no discuten alternativas.
- **Origen:** F1§7.
- **Alternativas:** mantener VARCHAR(10) como en F1§7. Cualquier otra alternativa debe ser propuesta por el equipo.
- **Impacto:** DDL, generación de datos y formularios del PMV.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** confirmar que MERE, Workbench, script, generador y PMV usan el mismo criterio de identificadores.

### D16. Organización de los scripts SQL y de datos

- **Descripción:** E p.1 y E§8 piden un script integral (creación, tablas, restricciones, datos, 6 vistas, 6 procedimientos) ejecutable desde cero, y además un "script de generación de datos" como entregable aparte. C6 pide que Docker inicialice MySQL con "el script del modelo relacional y el archivo de inserciones". No está definido cómo se organizan los archivos.
- **Origen:** E p.1; E§3 (Faker); E§6; E§8; C2; C6.
- **Alternativas:** sin alternativas definidas en los documentos; el equipo debe decidir la partición de archivos cumpliendo E§8 y C6.
- **Impacto:** DDL, poblamiento reproducible, inicialización de Docker y entregables.
- **Aclaración docente:** Recomendada (ver 3.2).
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** reconstruir la BD desde cero con los archivos entregables, de principio a fin, sin pasos manuales (E§8).

### D17. Diseño del escenario de datos

- **Descripción:** E§6 exige datos coherentes y reproducibles, con distribuciones que evidencien diferencias entre bases, sectores, expediciones, especies, períodos y evaluaciones, y que permitan validar los 12 requerimientos. E§11 exige verificar FK, distribuciones, fechas y coherencia del negocio. No está definido el escenario concreto.
- **Origen:** E§6; E§11; C2.
- **Alternativas:** ninguna en los documentos; el equipo diseña y documenta el escenario y la validación.
- **Impacto:** poblamiento, calidad de resultados de R1–R12 y del dashboard.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** lista de comprobaciones sobre FK, fechas, distribuciones y resultados no triviales de R1–R12.

### D18. Arquitectura del PMV

- **Descripción:** C5 evalúa separación interfaz/lógica/acceso a datos, uso efectivo de DAO o capa equivalente, conexión centralizada, consultas parametrizadas, manejo de errores y recursos, `requirements.txt` y estructura de carpetas trazable. E§3 fija SQLAlchemy + PyMySQL como acceso a MySQL. La estructura concreta no está definida.
- **Origen:** C5; C11 (e, f); E§3; E§10.
- **Alternativas:** "DAO o capa equivalente" (C5). Cualquier otra definición de capas y carpetas debe ser propuesta por el equipo.
- **Impacto:** estructura del código, trazabilidad hacia las tablas del modelo y defensa individual.
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** que cada integrante pueda indicar en qué archivo está cada responsabilidad (C11 e).

### D19. Confirmaciones con el docente

- **Descripción:** Información que los documentos no entregan o dejan ambigua: observaciones de Fase 1, NRC y docente, fecha de entrega, herramienta de IA aprobada, aceptación de diagrams.net y correo completo de un integrante. Detalle por ítem en la sección 3.1.
- **Origen:** E p.1; E§2, §3, §5, §13; F1 p.1.
- **Alternativas:** no aplica; se resuelve consultando al docente.
- **Impacto:** MERE corregido, portada del informe, herramienta de IA y plazos.
- **Aclaración docente:** **Requerida** (ver 3.1).
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** conservar la respuesta del docente (correo o mensaje) como evidencia.

### D20. Asignación de responsables (matriz de responsabilidades)

- **Descripción:** E§14 exige completar la matriz de 15 actividades **antes de iniciar la implementación**, con responsable principal y colaboradores. Condiciones oficiales: cada integrante es responsable principal en actividades de más de una etapa; distribución razonablemente equilibrada, sin que una sola persona concentre la implementación técnica; las 4 funcionalidades del PMV con responsables principales distintos; coherencia con las bitácoras.
- **Origen:** E§14; E§15; C7.
- **Alternativas:** ninguna en los documentos; el equipo reparte las actividades respetando las condiciones de E§14.
- **Impacto:** todo el proyecto, y coherencia matriz–bitácoras–producto evaluada en C7 y contrastada en la defensa (E§14, C11).
- **Aclaración docente:** No.
- **Decisión adoptada:** (sin completar)
- **Justificación:** (sin completar)
- **Responsable:** Por definir
- **Fecha:** (sin completar)
- **Estado:** Pendiente
- **Evidencia de validación:** (sin completar)
- **Validación sugerida:** revisar que la matriz cumple las condiciones de E§14 y que las bitácoras la respaldan.

---

## 5. Cómo actualizar este documento

Las instrucciones siguientes son una sugerencia de proceso; el equipo puede ajustarlas.

**Cuando el equipo adopte una decisión:**

1. Completar los campos de la decisión en la sección 4:
   - **Decisión adoptada:** qué se eligió, en una o dos frases.
   - **Justificación:** por qué, con referencia a la regla de negocio o a la fuente (F1, E, C) cuando corresponda. E§5 exige justificar los cambios que alteren estructuras de Fase 1.
   - **Responsable:** el nombre de la persona que lidera la decisión, tal como figure en la matriz de responsabilidades (E§14). No escribir nombres que no estén acordados.
   - **Fecha:** fecha de aprobación del equipo, en formato DD/MM/AAAA.
2. Cambiar el **Estado** a *Adoptada*.
3. Actualizar la **tabla resumen** (sección 2): responsable, fecha, estado y el recuento de estados.
4. Si la decisión tenía consulta docente, completar la respuesta y la fecha en la sección 3 y actualizar el estado de esa consulta.
5. Anotar el cambio en el **historial** (sección 6).

**Cuando la decisión se aplique y se compruebe:**

1. Completar **Evidencia de validación** con un hecho verificable: qué se ejecutó, qué resultado se obtuvo y dónde queda el respaldo (captura, consulta, nombre de archivo). E§11 pide conservar evidencia resumida de la validación.
2. Cambiar el **Estado** a *Validada* y actualizar tabla resumen e historial.

**Otras reglas de mantenimiento:**

- **No borrar decisiones.** Si el equipo cambia de criterio, marcar la decisión anterior como *Reemplazada* y registrar en el historial cuál la sustituye y por qué.
- **Si una decisión altera el modelo,** actualizar en el mismo momento MERE, diagrama de Workbench, script, PMV e informe, para evitar contradicciones (E§5, C1, C8).
- **Las decisiones están encadenadas.** Si una cambia, revisar las relacionadas: D1 con D12 y D17; D2 con D6 y D17; D5, D6 y D9 con D13; D8 con D17; D10 con D11.
- **Consistencia con las bitácoras.** Cada integrante debería poder registrar en su bitácora las decisiones en que participó (E§15).
- **Estado "En consulta docente".** Usarlo solo cuando la consulta se haya enviado; registrar la fecha de envío y de respuesta en la sección 3.

---

## 6. Historial de cambios

| Fecha | Decisión(es) | Cambio realizado | Quién lo registró |
|---|---|---|---|
| 19/11/2026 | D1–D20 | Creación del registro a partir de `DECISIONES_PENDIENTES.md`. Todas las decisiones en estado Pendiente. | (sin completar) |
| (sin completar) | (sin completar) | (sin completar) | (sin completar) |