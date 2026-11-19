# Especificación del Sistema (`SPEC.md`) — Borrador Inicial

**Curso:** TDFI103 — Bases de Datos (Proyecto Semestral 2026)  
**Caso en los documentos analizados:** Caso 6 — *Sistema Integral de Gestión de Expediciones Científicas Antárticas* *(Nota: el prompt indica Caso 8; verificar documento oficial correspondiente)*  
**Estado de las decisiones del equipo:** Todas las decisiones (`D1`–`D20`) constan como **Pendientes** en el documento adjunto; no hay decisiones adoptadas ni confirmadas registradas en él.

---

## 1. Objetivo y alcance

El proyecto corresponde a la **Fase 2: Implementación de Base de Datos y Producto Mínimo Viable asistido por IA** del curso TDFI103. Su alcance abarca:

* Corregir y consolidar el modelo conceptual/extendido (MERE), el modelo relacional y las reglas de negocio a partir de la Fase 1 y de las observaciones del docente.
* Reconstruir desde cero una base de datos en MySQL 8.x mediante script(s), poblarla con datos coherentes y reproducibles, e implementar 12 requerimientos de información SQL (6 vistas y 6 procedimientos almacenados).
* Desarrollar un Producto Mínimo Viable (PMV) integrado en una sola aplicación sobre la misma base de datos MySQL, con 4 funcionalidades obligatorias (formulario transaccional, CRUD de al menos 2 tablas maestras, control de usuarios/roles y dashboard de 4 preguntas).
* Contenerizar y desplegar el sistema con Docker y Docker Compose (`app` + `db`), documentar el proceso en un informe de 13 secciones (incluyendo evidencia resumida del uso de IA, matriz de responsabilidades y bitácoras individuales) y realizar una presentación y defensa individual.
* **Fuera de alcance / restricciones de evaluación:**
  * No se debe usar una base de datos alternativa para el PMV.
  * Las 12 consultas/objetos SQL de requerimientos no deben integrarse al PMV.
  * En el PMV solo se evalúan las 4 funcionalidades exigidas; funcionalidades adicionales no puntúan, y sustituir o modificar una de las 4 funcionalidades constituye incumplimiento.
  * La IA no reemplaza la defensa oral individual.

---

## 2. Requisitos obligatorios y su origen

### 2.1 Generales y entregables
| ID | Requisito obligatorio | Origen en el documento |
| :--- | :--- | :--- |
| G1 | Entregar en Canvas en la fecha indicada por el docente: informe final, script integral SQL, script de generación de datos, código fuente del PMV, `Dockerfile` + `docker-compose.yml` y diapositivas de la disertación. | Enunciado Fase 2 (E p.1) |
| G2 | Usar stack fijo: ERDPlus (o equivalente), MySQL 8.x, MySQL Workbench, Python 3.12+, SQLAlchemy + PyMySQL, Faker (o equivalente), Pandas, Plotly, Streamlit, Docker + Compose y asistente de IA del curso. | Enunciado Fase 2 (E§3) |
| G3 | Redactar el informe siguiendo la estructura de 13 secciones, con portada que incluya integrantes, correos, grupo, NRC y docente. | Enunciado Fase 2 (E§13) |
| G4 | Conservar evidencia resumida del uso de IA y su validación; cada estudiante debe poder explicar cualquier sentencia SQL, decisión de modelo o código en la defensa. | Enunciado Fase 2 (E§11, E§16) |

### 2.2 Modelo, implementación y poblamiento
| ID | Requisito obligatorio | Origen en el documento |
| :--- | :--- | :--- |
| M1 | Presentar MERE corregido, consistente con observaciones de Fase 1, con imagen legible y explicación breve de correcciones. | Enunciado Fase 2 (E§2, E§5) |
| M2 | Mantener coherencia entre reglas de negocio, MERE, especializaciones/generalizaciones y modelo relacional. | Enunciado Fase 2 (E§5); Rúbrica (C1) |
| M3 | Entregar modelo relacional final en Workbench con tablas, atributos, tipos, PK, FK, `NOT NULL`, `UNIQUE`, `CHECK` y otras restricciones justificadas, con imagen legible. | Enunciado Fase 2 (E§5) |
| M4 | Justificar los cambios que alteren estructuras relevantes de Fase 1. | Enunciado Fase 2 (E§5); Rúbrica (C1) |
| M5 | Incluir en el informe la sección *"Correcciones a las reglas de negocio de la Fase 1"*. | Enunciado Fase 2 (E§13 ítem 3) |
| M6 | Reproducir el modelo en el script sin estructuras paralelas ni tablas inventadas; no se aceptan objetos creados a mano en Workbench fuera del script. | Enunciado Fase 2 (E§8); Rúbrica (C1) |
| M7 | Ejecutar el script integral de principio a fin reconstruyendo la BD desde cero (BD, tablas, restricciones, datos, 6 vistas, 6 procedimientos). | Enunciado Fase 2 (E§8); Rúbrica (C2) |
| POB | Poblar todas las tablas con datos coherentes, reproducibles, respetando FK, reglas y fechas, permitiendo validar los 12 requerimientos y visualizaciones (rangos orientativos: Países 5-10, Bases 12-20, Sectores 35-60, Muestras 80-150 incluyendo biológicas, geológicas, climáticas y sin clasificar, Expediciones 120-250, Participantes 80-150, Participaciones 500-1200, Recolecciones 300-700, Evaluaciones 300-700, Personal 40-80, Usuarios/roles 40-80 con ≥2 roles). | Enunciado Fase 2 (E§6, E§11); Rúbrica (C2) |

### 2.3 Requerimientos SQL, PMV, Docker, gestión y defensa
| ID | Requisito obligatorio | Origen en el documento |
| :--- | :--- | :--- |
| SQL | Implementar R1–R12 (6 vistas y 6 procedimientos almacenados con parámetros `IN` útiles y `SELECT` coherentes), sin integrarlos al PMV; documentar en el informe requerimiento, código completo, sentencia de ejecución, captura real de Workbench e interpretación de 2 a 4 líneas. | Enunciado Fase 2 (E§7, E§9); Rúbrica (C3) |
| PMV | Entregar una sola aplicación integrada sobre la BD MySQL con P1–P4 (formulario transaccional, CRUD de ≥2 tablas maestras, login y ≥2 roles con permisos diferenciados, dashboard de 4 preguntas Q1–Q4) y arquitectura/calidad según P5. | Enunciado Fase 2 (E§10, E§10.1); Rúbrica (C4, C5) |
| DOC | Proveer `Dockerfile` para Streamlit y `docker-compose.yml` con al menos servicios `app` y `db` (MySQL 8.x versionada, volumen persistente, puertos, variables de entorno, `requirements.txt`, inicialización con script del modelo y archivo de inserciones, espera de BD, arranque con `docker compose up --build`) e instrucciones mínimas documentadas. | Enunciado Fase 2 (E§12); Rúbrica (C6, C11 g-i) |
| GES | Completar matriz de responsabilidades de 15 actividades antes de implementar (cada integrante responsable principal en >1 etapa; sin concentrar implementación técnica en una persona; 4 funcionalidades del PMV con responsables distintos) y bitácoras individuales coherentes con matriz y producto. | Enunciado Fase 2 (E§14, E§15); Rúbrica (C7) |
| DEF | Realizar presentación de 10 min + 5 min de defensa con participación de todos los integrantes, cubriendo MERE, modelo relacional, poblamiento, vistas/procedimientos, conclusiones, matriz/bitácoras y PMV funcionando en contenedores, más defensa oral individual. | Enunciado Fase 2 (E§16); Rúbrica (C9–C11) |

---

## 3. Actores y casos de uso

En los documentos analizados se identifican los siguientes actores y casos de uso:

### 3.1 Actores
* **Integrantes del equipo / Estudiantes:** diseñan el modelo y la BD, generan/validan datos, implementan las consultas SQL, el PMV y el despliegue Docker, elaboran el informe y defienden individualmente el sistema.
* **Docente del curso:** entrega observaciones de Fase 1, define fecha de entrega y criterios/rubrica, y evalúa la entrega grupal (65 pts, C1–C9) y la exposición/defensa individual (35 pts, C10–C11).
* **Usuarios del PMV (con ≥ 2 roles diferenciados):** usuarios autenticados mediante login cuyos roles controlan el acceso efectivo a las funcionalidades del sistema *(los roles concretos y su matriz de permisos están pendientes de definición en D10)*.
* **Personal / Participantes / Responsables de expedición o recolección:** actores del dominio científico-operativo representados en los datos y procesos del caso *(la estructura exacta de personas, roles laborales y responsables está sujeta a decisiones pendientes D1, D4, D7 y D12)*.

### 3.2 Casos de uso principales
* **CU-01 Reconstrucción y poblamiento de la BD:** ejecutar desde cero el script de estructura/objetos y poblar con datos reproducibles que cumplan restricciones y rangos del caso.
* **CU-02 Consulta analítica y operativa vía SQL (R1–R12):** ejecutar vistas y procedimientos almacenados con parámetros `IN` en MySQL Workbench y documentar su salida e interpretación.
* **CU-03 Autenticación y control de acceso en el PMV:** iniciar sesión y restringir funcionalidades según el rol del usuario autenticado.
* **CU-04 Operación transaccional en el PMV:** registrar una participación en expedición o un registro de recolección (según defina el equipo en D13), seleccionando datos existentes, validando campos y respetando FKs.
* **CU-05 Gestión (CRUD) de tablas maestras en el PMV:** crear, consultar, actualizar y eliminar o desactivar lógicamente registros de al menos dos tablas maestras, resguardando la integridad referencial.
* **CU-06 Exploración analítica en el Dashboard del PMV:** consultar y filtrar las 4 preguntas (Q1–Q4) mediante visualizaciones y tablas de detalle.
* **CU-07 Despliegue y demostración en contenedores:** levantar `app` y `db` con `docker compose up --build`, verificar persistencia/reinicio y demostrar el PMV funcionando.

---

## 4. Reglas de negocio

Las reglas de negocio deben mantener coherencia total entre el informe, el MERE, el modelo relacional, el script SQL, el poblamiento y el PMV:

* **Coherencia y justificación de cambios (E§5, C1, E§13):** toda regla de negocio debe ser consistente con el MERE y el modelo relacional; las correcciones respecto a la Fase 1 deben documentarse en la sección *"Correcciones a las reglas de negocio de la Fase 1"* y justificar cualquier alteración de estructuras relevantes.
* **Restricciones de integridad del modelo (E§5, E§8, C1, C2):** se deben aplicar PK, FK, `NOT NULL`, `UNIQUE`, `CHECK` y demás restricciones justificadas, sin objetos creados manualmente fuera del script ni estructuras paralelas.
* **Reglas heredadas / en revisión de Fase 1 (sujetas a verificación y resolución de decisiones pendientes):**
  * *Participación y evaluación (F1§2 reglas 11–12, F1§3.2):* la evaluación se registra tras finalizar la expedición y la cardinalidad declarada entre participación y evaluación es `1:0..1` *(pendiente formalizar restricciones en D5)*.
  * *Recolección y muestra (F1§2 regla 9, F1§3.2, E§6, E§7):* cada recolección registra una muestra; está por definirse si una muestra puede aparecer en varias recolecciones (`1:N`) o mantener unicidad `1:1` (D2), y si el sector de recolección debe pertenecer a la base de la expedición (D6).
  * *Subtipos de muestra y clasificación (F1§3, F1§4, F1 p.8, E§5, E§6, E§7):* existen muestras biológicas, geológicas, climáticas y sin clasificar; debe definirse cómo garantizar especialización parcial y disjunta y cómo obtener la clasificación (D3).
  * *Tipos de personal, dominios y supervisión (F1§2 reglas 13 y 15, F1§3.3, F1§7, E§5, E§7):* deben definirse dominios/catálogos/restricciones para atributos de estado, función, aislamiento, acceso, conservación y tipo de personal (D4), el tratamiento del responsable de expedición (D7), las reglas de capacidad en base/expedición/participaciones (D9) y si se mantiene la relación unaria de supervisión de `PERSONAL` (D12).
  * *Período de expediciones (E§7, E§10.1, F1§3.1, F1§7):* debe definirse la semántica de *"dentro del período"* y si la fecha de término se deriva o almacena (D8).

---

## 5. Entidades, atributos, PK, FK y relaciones

En el documento adjunto se evidencian discrepancias entre el diagrama MERE, la descripción/relacional de Fase 1 y el enunciado de Fase 2, por lo que la estructura definitiva queda sujeta a las decisiones pendientes indicadas:

* **Convención de nombres y tipos de identificadores:** en los documentos de Fase 1 conviven denominaciones distintas (`Base Científica` / `base_cientifica` / `BASE`, `Sector de investigación` / `sector_investigacion` / `SECTOR`, `Muestra Científica` / `MUESTRA`) y los identificadores figuran como `VARCHAR(10)` en F1§7. El equipo debe unificar nombres en MERE, Workbench, script y PMV, y confirmar el tipo de identificador (D15).
* **Personas, personal y participantes (`D1`, `D4`, `D7`, `D12`):** el texto y el modelo relacional de Fase 1 consideran una tabla `PERSONAL` (con `tipoPersonal`, `idSupervisor` opcional, `EXPEDICION.responsable` como `VARCHAR(100)` y `CUENTA_USUARIO` asociada), mientras el diagrama MERE muestra una generalización `Persona -> Trabajador / Participante` y E§6 indica rangos diferenciados para Participantes (80–150) y Personal (40–80). La estructura final de entidades, PK, FK y relaciones depende de resolver `D1`, `D4`, `D7` y `D12`.
* **Países, bases y sectores (`D6`, `D8`, `D9`, `D11`):** entidades vinculadas a ubicación/instalaciones y zonas de trabajo (con atributos como `capacidadMaxima` en base y numeración de sectores por base; faltan revisar `NOT NULL` obligatorios como `BASE.idPais` o `EXPEDICION.idBase` y la pertenencia del sector a la base de la expedición).
* **Expediciones, participaciones y evaluaciones (`D5`, `D8`, `D9`):** `EXPEDICION` (asociada a base, con `fechaInicio` y `duracionDias`), `PARTICIPACION` y `EVALUACION` (con PK `(idExpedicion, nroEvaluacion)` en F1§7, pendiente de revisar unicidad por participación y restricción temporal posterior al término de la expedición).
* **Muestras, subtipos y recolecciones (`D2`, `D3`, `D6`):** `MUESTRA` y subtipos/clasificaciones para muestras biológicas, geológicas y climáticas (con atributos divergentes entre el diagrama y el texto/relacional de F1) y `RECOLECCION` (con `idBase`, `nroSector` y relación con muestra actualmente restringida por `idMuestra UNIQUE` en F1§7).
* **Usuarios y roles (`D10`):** cuentas de usuario asociadas al personal y roles (con `descripcion` en el relacional de F1 y `permisos` en el diagrama).

---

## 6. Requerimientos SQL

Se deben implementar **6 vistas** y **6 procedimientos almacenados** (total 12 requerimientos), ejecutables desde el script integral y documentados en el informe con requerimiento, código completo, sentencia de ejecución, captura real de Workbench e interpretación de 2 a 4 líneas. **No deben integrarse al PMV.**

| ID | Tipo | Parámetros | Condición / Alcance exigido |
| :--- | :--- | :--- | :--- |
| R1 | Procedure | Fecha inicio, fecha término | País, base, expedición. |
| R2 | View | — | Muestra, subtipo/clasificación, recolección, sector, base. |
| R3 | View | — | Expedición, participación, participante, evaluación; duración y promedio. |
| R4 | Procedure | Fecha inicio, fecha término | País, base, expedición, participación. |
| R5 | View | — | Base, expedición, participación; tasa de ocupación. |
| R6 | View | — | Muestra, subtipo, recolección, sector, base; funciones de grupo. |
| R7 | View | — | Base, sector, recolección, muestra; agrupación y conteo distinto. |
| R8 | View | — | Participante, participación, expedición, evaluación; funciones de grupo y `HAVING`. |
| R9 | Procedure | Base, rango de fechas | Expedición, participación; subconsulta correlacionada. |
| R10 | Procedure | Base | Sector, recolección, muestra; subconsulta correlacionada. |
| R11 | Procedure | Rango de fechas | Participante, participación, expedición, evaluación; subconsulta y agrupación. |
| R12 | Procedure | Fecha inicio, fecha término | País, base, expedición; subconsulta y agrupación. |

---

## 7. Las cuatro funcionalidades del PMV

Debe construirse **una sola aplicación integrada** sobre la misma base de datos MySQL, evaluándose exclusivamente estas 4 funcionalidades (más los criterios arquitectónicos de P5):

1. **Formulario transaccional (P1 — operación elegida en D13):** registrar una participación en expedición o un registro de recolección (a elección del equipo), seleccionando datos existentes, validando campos y respetando FKs.
2. **CRUD de tablas maestras (P2 — tablas y estrategia en D11):** operaciones crear, leer, actualizar y eliminar/desactivar sobre al menos 2 tablas maestras; si la eliminación física viola integridad referencial, aplicar desactivación lógica.
3. **Control de usuarios y roles (P3 — roles y permisos en D10):** login y al menos 2 roles con permisos diferenciados que controlen el acceso real a funcionalidades.
4. **Dashboard analítico de 4 preguntas (P4):**
   * **Q1 (P4a — Fase 1):** bases con más expediciones; ranking o barras con filtros por período, país y base.
   * **Q2 (P4b — Fase 1):** distribución de muestras biológicas, geológicas y climáticas; composición o barras con filtros por base y sector.
   * **Q3 (P4c — Fase 1):** relación entre duración y evaluación promedio; dispersión más tabla de detalle por expedición y base.
   * **Q4 (P4d — Propuesta del equipo en D14):** pregunta nueva, relevante y no equivalente a Q1–Q3; debe formularse, justificarse, resolverse con consulta SQL propia del dashboard (distinta de R1–R12), visualizarse con filtros pertinentes y explicar qué decisión de negocio apoya.

---

## 8. Arquitectura tecnológica

* **Stack tecnológico fijo (E§3):** ERDPlus (o equivalente), MySQL 8.x, MySQL Workbench, Python 3.12+, SQLAlchemy + PyMySQL, Faker (o equivalente), Pandas, Plotly, Streamlit, Docker + Compose y asistente de IA del curso.
* **Arquitectura del PMV (C5, C11 — detalles de carpetas/capas en D18):** separación entre interfaz, lógica y acceso a datos; uso efectivo de DAO o capa equivalente; conexión centralizada a MySQL vía SQLAlchemy + PyMySQL; consultas parametrizadas; manejo básico de errores y recursos; `requirements.txt` y correspondencia trazable entre código y tablas del modelo.
* **Contenerización y despliegue (E§12, C6, C11 g-i):** `Dockerfile` para Streamlit y `docker-compose.yml` con al menos servicios `app` y `db` (MySQL 8.x versionada, volumen persistente, puertos y variables de entorno definidos, dependencias instaladas desde `requirements.txt`, inicialización de MySQL con script del modelo y archivo de inserciones, espera de disponibilidad de la BD y arranque con `docker compose up --build`).

---

## 9. Plan de implementación y pruebas

Siguiendo el flujo de E§4 y la planificación por etapas del análisis:

* **Etapa 0 — Organización:** completar matriz de responsabilidades de 15 actividades (D20), acordar convención de nombres, abrir bitácoras individuales y resolver consultas docentes/confirmaciones (D19).
* **Etapa 1 — Corrección del MERE:** resolver decisiones estructurales/de reglas (D1–D9, D12), revisar las 15 reglas de negocio de Fase 1, redactar correcciones justificadas y obtener MERE legible.
* **Etapa 2 — Modelo relacional:** derivar modelo en Workbench con PK, FK, `NOT NULL`, `UNIQUE`, `CHECK` y dominios/identificadores (D4, D15), exportando imagen legible.
* **Etapa 3 — DDL:** construir script de estructura reproducible desde cero sin intervención manual (D16).
* **Etapa 4 — Poblamiento:** diseñar escenario de datos (D17), generar datos reproducibles con semilla fija y validar FK, fechas, reglas y distribuciones.
* **Etapa 5 — SQL avanzado:** implementar y probar R1–R12 (6 vistas y 6 procedimientos), capturar salidas reales en Workbench y redactar interpretaciones de 2 a 4 líneas.
* **Etapa 6 — PMV:** implementar aplicación integrada (estructura/conexión/`requirements.txt` según D18, login/roles según D10, CRUD según D11, formulario según D13 y dashboard Q1–Q4 según D14).
* **Etapa 7 — Pruebas e integración:** probar restricciones y casos inválidos, permisos por rol, filtros y consultas del dashboard y navegación integral.
* **Etapa 8 — Despliegue:** probar `docker compose up --build` desde cero, inicialización automática, persistencia y comportamiento ante reinicio vs. recreación de volumen, documentando instrucciones mínimas.
* **Etapa 9 — Informe y disertación:** consolidar las 13 secciones del informe, bitácoras, conclusiones individuales y evidencia de IA, preparar diapositivas (10 min de exposición + 5 min de defensa) y ensayar defensa cruzada individual.

---

## 10. Criterios de aceptación

El sistema y los entregables se consideran aceptables cuando cumplen:

* **Consistencia y trazabilidad (C1, C8, E§5):** cero contradicciones entre reglas de negocio, MERE, modelo relacional, script, PMV e informe; cambios respecto a Fase 1 justificados y sin objetos manuales fuera del script.
* **Reconstrucción y calidad de datos (C2, E§6, E§8, E§11):** el script reconstruye la BD desde cero de principio a fin y todas las tablas quedan pobladas de forma coherente y reproducible para validar R1–R12 y el dashboard.
* **Requerimientos SQL (C3, E§7, E§9):** las 6 vistas y 6 procedimientos (con parámetros `IN` útiles y `SELECT` coherentes) funcionan en MySQL, no están integrados al PMV y cuentan con evidencia e interpretación de 2 a 4 líneas en el informe.
* **PMV y arquitectura (C4, C5, E§10):** las 4 funcionalidades operan sobre la misma BD MySQL con control real de acceso por rol, validaciones, respeto a FKs y separación de capas/consultas parametrizadas/`requirements.txt`.
* **Docker y defensa (C6, C7, C9–C11):** el PMV arranca y funciona desde contenedores con `docker compose up --build`, las matrices y bitácoras son coherentes, y cada integrante responde sobre cualquier componente del sistema en la presentación y defensa individual.

---

## 11. Decisiones pendientes

A la fecha del documento analizado (`19/11/2026`), las **20 decisiones (`D1`–`D20`)** están **Pendientes** y deben cerrarse en el registro de decisiones antes de avanzar en las fases dependientes:

* **Antes de escribir el DDL:** `D1` (estructura de personas: `PERSONAL` único vs. generalización `Persona -> Trabajador / Participante`), `D2` (cardinalidad Muestra-Recolección `1:N` vs. `1:1`), `D3` (atributos y garantía de especialización parcial/disjunta en subtipos de muestra), `D4` (dominios/`CHECK`/catálogo para `tipoPersonal`, `estado`, `funcion`, `nivelAislamiento`, `nivelAcceso`, `estadoConservacion`), `D5` (evaluación posterior al término de la expedición y unicidad por participación), `D6` (pertenencia del sector de recolección a la base de la expedición), `D7` (tipo/referencia de `responsable` de expedición), `D8` (semántica de *"dentro del período"* y fecha de término), `D9` (reglas de capacidad en base/expedición/participación), `D12` (mantener o retirar relación unaria de supervisión), `D15` (tipo de identificadores) y `D16` (organización de scripts SQL/datos).
* **Antes de programar el PMV:** `D10` (roles, permisos y representación), `D11` (tablas del CRUD y eliminación física vs. desactivación lógica), `D13` (operación del formulario transaccional: participación o recolección), `D14` (cuarta pregunta del dashboard Q4) y `D18` (arquitectura de capas/carpetas del PMV).
* **Antes de implementar / durante poblamiento y cierre:** `D19` (confirmaciones con el docente: observaciones de Fase 1, NRC/docente, fecha de entrega, herramienta de IA, equivalencia de `diagrams.net` y correo completo de Matías Morales), `D20` (asignación de responsables en la matriz de 15 actividades) y `D17` (diseño del escenario de datos y validación).
```[cite: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42]

---