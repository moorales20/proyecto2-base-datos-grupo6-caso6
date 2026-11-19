# Decisiones pendientes: Proyecto Fase 2, Caso 6

**Curso:** TDFI103 Bases de Datos, Proyecto Semestral 2026
**Caso:** 6, Sistema Integral de Gestión de Expediciones Científicas Antárticas
**Elaborado:** 19/11/2026

## Cómo leer este documento

- Este archivo **registra decisiones que el equipo aún debe tomar**. No contiene decisiones adoptadas.
- **Documentos de origen:** `Informe Fase 1` (F1), `Enunciado Fase 2` (E) y `Rúbrica Fase 2` (C, por número de criterio).
- **Alternativas:** solo se listan las que tienen respaldo en los documentos. Cuando no lo tienen, se indica y el equipo debe proponerlas.
- **Responsable:** queda "Por definir" en todas; se asigna en la matriz de responsabilidades (E§14).
- **Estado:** todas están en *Pendiente*. Al resolver una, completar los campos "Decisión adoptada", "Fecha" y "Justificación" (E§5 exige justificar los cambios que alteren estructuras relevantes de Fase 1).

## Resumen

| ID | Tema | Bloquea | Estado |
|---|---|---|---|
| D1 | Estructura de personas (Personal / Participante) | MERE, DDL, datos, R3, R8, R11 | Pendiente |
| D2 | Cardinalidad Muestra–Recolección | MERE, DDL, datos, R2, R6, R7, R10 | Pendiente |
| D3 | Subtipos de muestra (atributos y garantía de parcial + disjunta) | DDL, R2, R6, Dashboard Q2 | Pendiente |
| D4 | Dominios de atributos con valores restringidos | DDL, datos | Pendiente |
| D5 | Evaluación posterior al término de la expedición | DDL, formulario, datos | Pendiente |
| D6 | Sector de la recolección vs. base de la expedición | DDL, datos, R2, R7, R10 | Pendiente |
| D7 | Tipo de `responsable` de expedición | DDL, datos | Pendiente |
| D8 | Significado de "dentro del período" y fecha de término | R1, R4, R9, R12, Dashboard Q1 | Pendiente |
| D9 | Reglas de capacidad | Datos, R5 | Pendiente |
| D10 | Roles y permisos | Usuarios y roles, PMV | Pendiente |
| D11 | Tablas del CRUD y tipo de eliminación | DDL, CRUD | Pendiente |
| D12 | Relación unaria de supervisión | MERE, DDL | Pendiente |
| D13 | Operación del formulario transaccional | PMV | Pendiente |
| D14 | Cuarta pregunta del dashboard | Dashboard | Pendiente |
| D15 | Tipo de identificadores | DDL, datos, PMV | Pendiente |
| D16 | Organización de los scripts SQL y de datos | DDL, Docker | Pendiente |
| D17 | Diseño del escenario de datos | Datos | Pendiente |
| D18 | Arquitectura del PMV | PMV | Pendiente |
| D19 | Confirmaciones con el docente | Informe, MERE | Pendiente |
| D20 | Asignación de responsables | Todo el proyecto | Pendiente |

**Orden sugerido de resolución:** D1–D9, D12, D15 y D16 antes de escribir el DDL; D10, D11, D13, D14 y D18 antes de programar el PMV.

---

## D1. Estructura de personas: Personal y Participante

- **Descripción:** F1 describe una sola entidad PERSONAL (con `tipoPersonal`) que participa en expediciones y puede tener cuenta. El diagrama MERE de F1 muestra una generalización *Persona → Trabajador / Participante*. E§6 pide volúmenes distintos para *Participantes* (80–150) y *Personal* (40–80), y define Personal como científicos, técnicos de terreno, coordinadores logísticos y administradores de base.
- **Origen:** F1§3 y §7.1 (texto y relacional); F1 p.8 (diagrama); E§6.
- **Alternativas con respaldo:**
  1. Mantener PERSONAL único, como en el texto y relacional de F1 (los rangos de E§6 son "orientativos").
  2. Adoptar la generalización del diagrama de F1 (Persona → Trabajador / Participante).
- **Impacto:** define las entidades del MERE, las tablas, las FK de PARTICIPACION, RECOLECCION, EVALUACION y CUENTA_USUARIO, el poblamiento y la redacción de R3, R8 y R11.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D2. Cardinalidad Muestra–Recolección

- **Descripción:** F1 impone `idMuestra UNIQUE` en RECOLECCION (relación 1:1). E§6 pide 300–700 recolecciones y 80–150 muestras, y R7 exige conteo distinto de muestras. La regla 9 de F1 dice que cada recolección registra una muestra, pero no que la muestra aparezca solo una vez.
- **Origen:** F1§2 (regla 9), F1§3.2, F1§7; E§6; E§7 (R7).
- **Alternativas con respaldo:**
  1. Quitar la unicidad (una muestra puede aparecer en varias recolecciones).
  2. Mantener 1:1 y ajustar el volumen de recolecciones (E§6 declara los rangos como orientativos).
- **Impacto:** MERE, DDL, poblamiento, y consultas R2, R6, R7 y R10.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D3. Subtipos de muestra: atributos y garantía de especialización parcial y disjunta

- **Descripción:** Los atributos de los subtipos difieren entre el diagrama y el texto/relacional de F1. Además, el relacional con tres tablas hijas no impide por sí solo que una muestra esté en dos subtipos. R2 y R6 requieren obtener la clasificación de cada muestra.
- **Origen:** F1 p.8 (diagrama); F1§3, §4, §7; E§7 (R2, R6); E§5.
- **Alternativas con respaldo:**
  - *Atributos:* (a) los del diagrama (biológica: tipo_organismo, características_biológicas, especie; geológica: tipo_roca, estructura_geológica, localización_estratégica; climática: parámetros_medidos, instrumento_utilizado, condiciones_momento); (b) los del texto/relacional (biológica: especie, tipoTejido; geológica: tipoRoca, composición; climática: variableClimática, valorMedido, unidadMedida).
  - *Mecanismo para garantizar disjunción y obtener la clasificación:* sin alternativas definidas en los documentos; el equipo debe proponerlas y justificarlas (E§5 pide "otras restricciones justificadas").
- **Impacto:** DDL, poblamiento, R2, R6 y gráfico de Dashboard Q2.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D4. Dominios de atributos con valores restringidos

- **Descripción:** En F1 los atributos `tipoPersonal`, `estado` (participación), `funcion`, `nivelAislamiento`, `nivelAcceso` y `estadoConservacion` son VARCHAR sin CHECK ni catálogo. La regla 13 de F1 lista cuatro tipos de personal y nombra un elemento TIPO_PERSONAL que no existe en el MERE ni en el relacional. Los documentos no definen los valores permitidos del resto.
- **Origen:** F1§2 (regla 13), F1§3, F1§7; E§5.
- **Alternativas con respaldo:** (a) restricción CHECK (E§5 la menciona); (b) tabla TIPO_PERSONAL como indica la regla 13 (solo aplicable a ese atributo). Los valores de cada dominio los define el equipo.
- **Impacto:** DDL, poblamiento y validaciones del formulario y CRUD.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D5. Evaluación posterior al término de la expedición

- **Descripción:** La regla 11 de F1 indica que la evaluación se registra después de finalizar la expedición. F1 no tiene ninguna restricción que lo respalde. Además, la cardinalidad declarada PARTICIPACIÓN–EVALUACIÓN es 1:0..1, pero la PK de EVALUACION (idExpedicion, nroEvaluacion) no impide varias evaluaciones por participación.
- **Origen:** F1§2 (reglas 11 y 12), F1§3.2, F1§7.
- **Alternativas con respaldo:** sin alternativas definidas en los documentos; el equipo debe proponer cómo garantizar (i) la unicidad por participación y (ii) la regla de fechas.
- **Impacto:** DDL, validaciones del formulario (si se elige evaluación) y coherencia de fechas en el poblamiento.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D6. Sector de la recolección vs. base de la expedición

- **Descripción:** RECOLECCION guarda su propio `idBase` y `nroSector` (FK a SECTOR), y EXPEDICION ya tiene `idBase`. F1 no establece si el sector de una recolección debe pertenecer a la base de la expedición.
- **Origen:** F1§2 (reglas 4, 8, 9), F1§7.
- **Alternativas con respaldo:** sin alternativas definidas en los documentos; el equipo debe decidir si esto es una regla de negocio y cómo se respalda.
- **Impacto:** DDL, coherencia del poblamiento, y resultados de R2, R7 y R10.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D7. Tipo del atributo `responsable` de expedición

- **Descripción:** En F1 `EXPEDICION.responsable` es VARCHAR(100). E§6 pide expediciones distribuidas por "responsables".
- **Origen:** F1§3 y §7; E§6.
- **Alternativas con respaldo:** mantener el atributo como texto (F1§7). Cualquier otra alternativa debe ser propuesta por el equipo.
- **Impacto:** DDL y poblamiento.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D8. Significado de "dentro del período" y fecha de término de expedición

- **Descripción:** R1, R4, R9 y R12 filtran por fecha de inicio y término (o rango de fechas). La expedición en F1 tiene solo `fechaInicio` y `duracionDias`. No está definido cuándo una expedición se considera dentro del período (inicio dentro, término dentro, traslape u otro).
- **Origen:** E§7 (R1, R4, R9, R11, R12); E§10.1 (filtro por período); F1§7.
- **Alternativas con respaldo:** F1§3.1 establece el precedente de no guardar atributos derivables (caso `duraciónSemanas`), lo que respalda derivar la fecha de término desde `fechaInicio` + `duracionDias`. La alternativa de almacenarla y la semántica de "dentro del período" deben ser propuestas por el equipo.
- **Impacto:** MERE/DDL (si se almacena), cuatro procedimientos, y filtro de período del Dashboard Q1.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D9. Reglas de capacidad

- **Descripción:** Existe `capacidadMaxima` en BASE y en EXPEDICION. R5 calcula la ocupación respecto de la capacidad máxima de las expediciones. Ninguna regla de F1 establece que las participaciones no superen la capacidad, ni relaciona ambas capacidades.
- **Origen:** F1§2, F1§7; E§7 (R5).
- **Alternativas con respaldo:** sin alternativas definidas en los documentos; el equipo debe decidir si formaliza una regla o solo cuida la coherencia de los datos.
- **Impacto:** DDL o validaciones, poblamiento y resultados de R5.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D10. Roles y permisos

- **Descripción:** E§10 exige login y al menos 2 roles con permisos diferenciados que controlen acceso real a funcionalidades. F1 tiene ROL con `descripcion`; el diagrama de F1 incluye un atributo `permisos`. No están definidos los roles concretos, sus permisos ni cómo se representan.
- **Origen:** E§6 (usuarios/roles), E§10 (funcionalidad 3); C4; F1§2 (regla 15), F1§7; F1 p.8 (diagrama).
- **Alternativas con respaldo:** representación en la tabla ROL como `permisos` (diagrama) o `descripcion` (relacional); el equipo debe proponer cualquier otra. Los roles y permisos los define el equipo.
- **Impacto:** DDL, poblamiento de usuarios, módulo de usuarios y restricciones de acceso en el PMV.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D11. Tablas del CRUD y tipo de eliminación

- **Descripción:** E§10 pide CRUD de al menos 2 tablas maestras o básicas, con eliminación o desactivación lógica si la física viola integridad referencial. Los documentos de Fase 1 no incluyen un indicador de estado/activo en las tablas maestras.
- **Origen:** E§10 (funcionalidad 2); C4; F1§7.
- **Alternativas con respaldo:** E§10 da como ejemplo Base Científica y Muestra Científica (ejemplo, no obligación). Eliminación física o desactivación lógica según integridad (E§10).
- **Impacto:** DDL (posible indicador de estado), CRUD y datos de prueba.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D12. Relación unaria de supervisión

- **Descripción:** F1§3.3 propone la relación PERSONAL supervisa PERSONAL (1:N, opcional) y el relacional incluye `idSupervisor`. No figura entre las 15 reglas de negocio de F1 ni en el enunciado de Fase 2. No pudo confirmarse que aparezca en el diagrama.
- **Origen:** F1§3.3, F1§5, F1§7; F1§2; E§5.
- **Alternativas con respaldo:** mantenerla (declarándola como regla de negocio) o retirarla.
- **Impacto:** MERE, DDL, poblamiento y consistencia entre reglas de negocio y modelo (E§5, C1).
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D13. Operación del formulario transaccional

- **Descripción:** E§10 permite que el formulario registre la participación de una persona en una expedición, o un registro de recolección de muestra durante una expedición, según elija el equipo. Debe seleccionar datos existentes, validar campos y respetar FK.
- **Origen:** E§10 (funcionalidad 1); C4.
- **Alternativas con respaldo:** (a) registrar participación; (b) registrar recolección (ambas, según E§10).
- **Impacto:** tablas involucradas, validaciones y pruebas del PMV; relación con D2, D5, D6 y D9 según la opción.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D14. Cuarta pregunta del dashboard

- **Descripción:** E§10.1 exige una cuarta pregunta propuesta por el equipo: relevante, no equivalente a las tres de Fase 1, formulada, justificada, resuelta con consulta SQL, con visualización y filtros pertinentes, y con la decisión de negocio que apoyaría.
- **Origen:** E§10.1; C4.
- **Alternativas con respaldo:** ninguna en los documentos (la pregunta la propone el equipo). *Ideas orientativas del análisis previo, no provenientes de los documentos, basadas en atributos ya existentes en F1:* evolución de expediciones por año; participación por tipo de personal o función; estado de las participaciones; presupuesto de país vs. cantidad de expediciones.
- **Impacto:** consulta SQL propia del dashboard (distinta de las vistas y procedimientos, E§9) y visualización.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D15. Tipo de identificadores

- **Descripción:** F1§7 define los identificadores como VARCHAR(10). Los documentos no discuten alternativas.
- **Origen:** F1§7.
- **Alternativas con respaldo:** mantener VARCHAR(10) como en F1§7. Cualquier otra alternativa debe ser propuesta por el equipo.
- **Impacto:** DDL, generación de datos y formularios del PMV.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D16. Organización de los scripts SQL y de datos

- **Descripción:** E p.1 y E§8 piden un script integral (creación, tablas, restricciones, datos, 6 vistas, 6 procedimientos) ejecutable desde cero, y además un "script de generación de datos" como entregable aparte. C6 pide que Docker inicialice MySQL con "el script del modelo relacional y el archivo de inserciones". No está definido cómo se organizan los archivos.
- **Origen:** E p.1; E§3 (Faker); E§6; E§8; C2; C6.
- **Alternativas con respaldo:** sin alternativas definidas en los documentos; el equipo debe decidir la partición de archivos cumpliendo E§8 y C6.
- **Impacto:** DDL, poblamiento reproducible, inicialización de Docker y entregables.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D17. Diseño del escenario de datos

- **Descripción:** E§6 exige datos coherentes y reproducibles, con distribuciones que evidencien diferencias entre bases, sectores, expediciones, especies, períodos y evaluaciones, y que permitan validar los 12 requerimientos. E§11 exige verificar FK, distribuciones, fechas y coherencia del negocio. No está definido el escenario concreto.
- **Origen:** E§6; E§11; C2.
- **Alternativas con respaldo:** ninguna en los documentos; el equipo diseña y documenta el escenario y la validación.
- **Impacto:** poblamiento, calidad de resultados de R1–R12 y del dashboard.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D18. Arquitectura del PMV

- **Descripción:** C5 evalúa separación interfaz/lógica/acceso a datos, uso efectivo de DAO o capa equivalente, conexión centralizada, consultas parametrizadas, manejo de errores y recursos, `requirements.txt` y estructura de carpetas trazable. E§3 fija SQLAlchemy + PyMySQL como acceso a MySQL. La estructura concreta no está definida.
- **Origen:** C5; C11 (e, f); E§3; E§10.
- **Alternativas con respaldo:** "DAO o capa equivalente" (C5). Cualquier otra definición de capas y carpetas debe ser propuesta por el equipo.
- **Impacto:** estructura del código, trazabilidad hacia las tablas del modelo y defensa individual.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D19. Confirmaciones con el docente

- **Descripción:** Información que los documentos no entregan o dejan ambigua:
  1. Observaciones del docente sobre la Fase 1 (E§2 y E§5 exigen consistencia con ellas).
  2. NRC y nombre del docente para la portada (E§13).
  3. Fecha de entrega en Canvas (E p.1, "fecha indicada por el docente").
  4. Herramienta de IA aprobada: E§3 indica "Herramienta aprendida en curso NoCode / OpenCode".
  5. Aceptación de diagrams.net (usado en F1) como herramienta equivalente a ERDPlus (E§3).
  6. Correo completo de Matías Morales (truncado en la portada de F1).
- **Origen:** E p.1; E§2, §3, §5, §13; F1 p.1.
- **Alternativas con respaldo:** no aplica; se resuelve consultando al docente.
- **Impacto:** MERE corregido, portada del informe, herramienta de IA, y plazos.
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente

## D20. Asignación de responsables (matriz de responsabilidades)

- **Descripción:** E§14 exige completar la matriz de 15 actividades **antes de iniciar la implementación**, con responsable principal y colaboradores. Condiciones oficiales: cada integrante es responsable principal en actividades de más de una etapa; distribución razonablemente equilibrada, sin que una sola persona concentre la implementación técnica; las 4 funcionalidades del PMV con responsables principales distintos; coherencia con las bitácoras.
- **Origen:** E§14; E§15; C7.
- **Alternativas con respaldo:** ninguna en los documentos; el equipo reparte las actividades respetando las condiciones de E§14.
- **Impacto:** todo el proyecto, y coherencia matriz–bitácoras–producto evaluada en C7 y contrastada en la defensa (E§14, C11).
- **Responsable por definir:** Por definir
- **Decisión adoptada:** (sin completar) · **Fecha:** (sin completar) · **Justificación:** (sin completar)
- **Estado:** Pendiente