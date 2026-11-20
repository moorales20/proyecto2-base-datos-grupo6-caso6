-- ============================================================================
-- Proyecto Semestral TDFI103 - Caso 6
-- Archivo: sql/03_vistas.sql  -  Vistas de los requerimientos R2, R3, R5, R6, R7 y R8
-- Motor: MySQL 8.4   |   Ejecutar DESPUES de 01 (DDL) y 02 (datos)
-- ============================================================================
-- Supuestos de negocio (documentarlos en el informe):
--   S1. Fecha de termino de una expedicion = fechaInicio + duracionDias (el DDL no la almacena).
--   S2. Una participacion con estado 'CANCELADA' NO cuenta como participacion efectiva
--       (ni como cupo ocupado ni como intervencion en la expedicion).
--   S3. "Muestra clasificada" = muestra que existe en MUESTRA_BIOLOGICA, MUESTRA_GEOLOGICA
--       o MUESTRA_CLIMATICA. Las muestras con tipoMuestra = 'SIN_CLASIFICAR' no tienen subtipo.
--   S4. Una muestra puede aparecer en varias recolecciones (en los datos: 420 recolecciones
--       sobre 117 muestras distintas), por eso se cuentan "recolecciones" y "muestras distintas".
-- Las sentencias son compatibles con ONLY_FULL_GROUP_BY (modo por defecto de MySQL 8.4).
-- ============================================================================

USE expediciones_antarticas_db;

-- ----------------------------------------------------------------------------
-- R2 (VIEW) - Distribucion de muestras clasificadas (biologicas / geologicas /
--             climaticas) por base y sector de recoleccion.
-- Tablas: RECOLECCION, MUESTRA, MUESTRA_BIOLOGICA, MUESTRA_GEOLOGICA,
--         MUESTRA_CLIMATICA, SECTOR, BASE
-- Logica: una fila por base+sector; los LEFT JOIN a cada subtipo no duplican filas
--         porque una muestra pertenece como maximo a un subtipo (FK compuesta con tipoMuestra).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_r2_distribucion_muestras_clasificadas AS
SELECT
    b.idBase,
    b.nombre                                         AS base,
    s.nroSector,
    s.nombre                                         AS sector,
    COUNT(mb.idMuestra)                              AS recolecciones_biologicas,
    COUNT(mg.idMuestra)                              AS recolecciones_geologicas,
    COUNT(mc.idMuestra)                              AS recolecciones_climaticas,
    COUNT(*)                                         AS total_clasificadas,
    ROUND(100 * COUNT(mb.idMuestra) / COUNT(*), 1)   AS pct_biologicas,
    ROUND(100 * COUNT(mg.idMuestra) / COUNT(*), 1)   AS pct_geologicas,
    ROUND(100 * COUNT(mc.idMuestra) / COUNT(*), 1)   AS pct_climaticas
FROM RECOLECCION r
JOIN MUESTRA m                  ON m.idMuestra = r.idMuestra
LEFT JOIN MUESTRA_BIOLOGICA mb  ON mb.idMuestra = m.idMuestra
LEFT JOIN MUESTRA_GEOLOGICA mg  ON mg.idMuestra = m.idMuestra
LEFT JOIN MUESTRA_CLIMATICA mc  ON mc.idMuestra = m.idMuestra
JOIN SECTOR s                   ON s.idBase = r.idBase AND s.nroSector = r.nroSector
JOIN BASE b                     ON b.idBase = s.idBase
WHERE COALESCE(mb.idMuestra, mg.idMuestra, mc.idMuestra) IS NOT NULL   -- solo clasificadas (S3)
GROUP BY b.idBase, b.nombre, s.nroSector, s.nombre;

-- ----------------------------------------------------------------------------
-- R3 (VIEW) - Relacion entre duracion de la expedicion y evaluacion promedio
--             entregada por sus participantes.
-- Tablas: EXPEDICION, BASE, PAIS, PARTICIPACION, PERSONAL, EVALUACION
-- Logica: una fila por expedicion con al menos una evaluacion. La evaluacion se une por
--         (idExpedicion, idPersonal), que es unica por participacion (UNIQUE del DDL),
--         por lo que no hay duplicacion de filas.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_r3_duracion_vs_evaluacion AS
SELECT
    e.idExpedicion,
    p.nombreOficial                                           AS pais,
    b.idBase,
    b.nombre                                                  AS base,
    e.fechaInicio,
    DATE_ADD(e.fechaInicio, INTERVAL e.duracionDias DAY)      AS fechaTermino,
    e.duracionDias,
    CASE
        WHEN e.duracionDias < 30 THEN 'CORTA (<30 d)'
        WHEN e.duracionDias < 60 THEN 'MEDIA (30-59 d)'
        ELSE 'LARGA (>=60 d)'
    END                                                       AS categoria_duracion,
    COUNT(DISTINCT per.idPersonal)                            AS participantes_evaluados,
    COUNT(ev.nroEvaluacion)                                   AS total_evaluaciones,
    ROUND(AVG(ev.calificacion), 2)                            AS evaluacion_promedio
FROM EXPEDICION e
JOIN BASE b            ON b.idBase = e.idBase
JOIN PAIS p            ON p.idPais = b.idPais
JOIN PARTICIPACION pa  ON pa.idExpedicion = e.idExpedicion
JOIN PERSONAL per      ON per.idPersonal = pa.idPersonal
JOIN EVALUACION ev     ON ev.idExpedicion = pa.idExpedicion AND ev.idPersonal = pa.idPersonal
GROUP BY e.idExpedicion, p.nombreOficial, b.idBase, b.nombre, e.fechaInicio, e.duracionDias;

-- ----------------------------------------------------------------------------
-- R5 (VIEW) - Tasa de ocupacion de participantes respecto de la capacidad maxima
--             de las expediciones, por base.
-- Tablas: BASE, PAIS, EXPEDICION, PARTICIPACION (agregada por expedicion)
-- Logica: ocupados = participaciones no canceladas (S2). Se agregan primero por expedicion
--         para no multiplicar la capacidad de cada expedicion por el numero de participantes.
--         tasa = SUM(ocupados) / SUM(capacidadMaxima de las expediciones de la base).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_r5_ocupacion_por_base AS
SELECT
    b.idBase,
    b.nombre                                              AS base,
    p.nombreOficial                                       AS pais,
    COUNT(e.idExpedicion)                                 AS total_expediciones,
    SUM(e.capacidadMaxima)                                AS cupos_totales,
    SUM(COALESCE(x.ocupados, 0))                          AS cupos_ocupados,
    ROUND(100 * SUM(COALESCE(x.ocupados, 0)) / SUM(e.capacidadMaxima), 2) AS tasa_ocupacion_pct,
    RANK() OVER (ORDER BY SUM(COALESCE(x.ocupados, 0)) / SUM(e.capacidadMaxima) DESC) AS ranking_ocupacion
FROM BASE b
JOIN PAIS p        ON p.idPais = b.idPais
JOIN EXPEDICION e  ON e.idBase = b.idBase
LEFT JOIN (
    SELECT idExpedicion, COUNT(*) AS ocupados
    FROM PARTICIPACION
    WHERE estado <> 'CANCELADA'
    GROUP BY idExpedicion
) x ON x.idExpedicion = e.idExpedicion
GROUP BY b.idBase, b.nombre, p.nombreOficial;

-- ----------------------------------------------------------------------------
-- R6 (VIEW) - Tipos de muestra que concentran mas recolecciones por base y sector.
-- Tablas: RECOLECCION, MUESTRA, SECTOR, BASE
-- Logica: una fila por base+sector+tipo (incluye SIN_CLASIFICAR). ranking_en_sector = 1
--         identifica el tipo dominante de cada sector (funcion de ventana sobre el COUNT).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_r6_tipos_muestra_por_sector AS
SELECT
    b.idBase,
    b.nombre                                   AS base,
    s.nroSector,
    s.nombre                                   AS sector,
    m.tipoMuestra,
    COUNT(*)                                   AS total_recolecciones,
    COUNT(DISTINCT m.idMuestra)                AS muestras_distintas,
    MIN(r.fecha)                               AS primera_recoleccion,
    MAX(r.fecha)                               AS ultima_recoleccion,
    DENSE_RANK() OVER (
        PARTITION BY b.idBase, s.nroSector
        ORDER BY COUNT(*) DESC
    )                                          AS ranking_en_sector
FROM RECOLECCION r
JOIN MUESTRA m  ON m.idMuestra = r.idMuestra
JOIN SECTOR s   ON s.idBase = r.idBase AND s.nroSector = r.nroSector
JOIN BASE b     ON b.idBase = s.idBase
GROUP BY b.idBase, b.nombre, s.nroSector, s.nombre, m.tipoMuestra;

-- ----------------------------------------------------------------------------
-- R7 (VIEW) - Sectores con mayor diversidad de muestras y cantidad total obtenida.
-- Tablas: SECTOR, BASE, RECOLECCION, MUESTRA
-- Logica: LEFT JOIN desde SECTOR para listar tambien sectores sin recolecciones.
--         diversidad = COUNT(DISTINCT idMuestra); el ranking prioriza diversidad y
--         desempata por total de recolecciones.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_r7_diversidad_muestras_por_sector AS
SELECT
    b.idBase,
    b.nombre                                   AS base,
    s.nroSector,
    s.nombre                                   AS sector,
    s.nivelAcceso,
    COUNT(r.nroRecoleccion)                    AS total_recolecciones,
    COUNT(DISTINCT r.idMuestra)                AS muestras_distintas,
    COUNT(DISTINCT m.tipoMuestra)              AS tipos_distintos,
    RANK() OVER (
        ORDER BY COUNT(DISTINCT r.idMuestra) DESC, COUNT(r.nroRecoleccion) DESC
    )                                          AS ranking_diversidad
FROM SECTOR s
JOIN BASE b                ON b.idBase = s.idBase
LEFT JOIN RECOLECCION r    ON r.idBase = s.idBase AND r.nroSector = s.nroSector
LEFT JOIN MUESTRA m        ON m.idMuestra = r.idMuestra
GROUP BY b.idBase, b.nombre, s.nroSector, s.nombre, s.nivelAcceso;

-- ----------------------------------------------------------------------------
-- R8 (VIEW) - Participantes con mayor numero de expediciones y su evaluacion promedio.
-- Tablas: PERSONAL, PARTICIPACION, EXPEDICION, EVALUACION
-- Logica: funciones de grupo + HAVING. Se listan quienes intervinieron en 5 o mas
--         expediciones (umbral ajustable; en los datos hay 5 a 25 por persona).
--         LEFT JOIN a EVALUACION: no toda participacion fue evaluada.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_r8_participantes_mas_expediciones AS
SELECT
    per.idPersonal,
    per.nombres,
    per.apellidos,
    per.tipoPersonal,
    COUNT(DISTINCT e.idExpedicion)             AS total_expediciones,
    COUNT(ev.nroEvaluacion)                    AS total_evaluaciones,
    ROUND(AVG(ev.calificacion), 2)             AS evaluacion_promedio
FROM PERSONAL per
JOIN PARTICIPACION pa      ON pa.idPersonal = per.idPersonal
JOIN EXPEDICION e          ON e.idExpedicion = pa.idExpedicion
LEFT JOIN EVALUACION ev    ON ev.idExpedicion = pa.idExpedicion AND ev.idPersonal = pa.idPersonal
WHERE pa.estado <> 'CANCELADA'                                   -- S2
GROUP BY per.idPersonal, per.nombres, per.apellidos, per.tipoPersonal
HAVING COUNT(DISTINCT e.idExpedicion) >= 5;
