-- ============================================================================
-- Proyecto Semestral TDFI103 - Caso 6
-- Archivo: sql/04_procedimientos.sql  -  Procedimientos R1, R4, R9, R10, R11 y R12
-- Motor: MySQL 8.4   |   Ejecutar DESPUES de 01 (DDL) y 02 (datos)
-- ============================================================================
-- Supuestos (los mismos que en 03_vistas.sql, mas dos propios de los procedimientos):
--   S1. Fecha de termino = fechaInicio + duracionDias (no existe columna en el DDL).
--   S2. Participacion con estado 'CANCELADA' no cuenta como participacion efectiva.
--   S5. "Expedicion dentro del periodo" = fechaInicio BETWEEN fecha_inicio AND fecha_termino.
--       (criterio simple y reproducible; si el docente exige otro, se cambia en un solo lugar
--        por procedimiento: la condicion del WHERE).
--   S6. Promedios generales: R11 usa la media de calificaciones de todas las evaluaciones
--       de expediciones del periodo; R12 usa la media de duracion de todas las expediciones
--       del periodo (no el promedio de promedios por base).
-- Los parametros de fechas son obligatorios y deben cumplir inicio <= termino; si no,
-- el procedimiento lanza un error controlado (SIGNAL SQLSTATE '45000').
-- En R9 y R10, p_id_base = NULL significa "todas las bases".
-- DELIMITER es necesario para cuerpos con varias sentencias (phpMyAdmin lo soporta al importar).
-- ============================================================================

USE expediciones_antarticas_db;

DROP PROCEDURE IF EXISTS sp_r1_bases_mas_expediciones;
DROP PROCEDURE IF EXISTS sp_r4_paises_expediciones_participantes;
DROP PROCEDURE IF EXISTS sp_r9_expediciones_sobre_promedio_base;
DROP PROCEDURE IF EXISTS sp_r10_sectores_sobre_promedio_base;
DROP PROCEDURE IF EXISTS sp_r11_participantes_sobre_promedio;
DROP PROCEDURE IF EXISTS sp_r12_bases_duracion_sobre_promedio;

DELIMITER $$

-- ----------------------------------------------------------------------------
-- R1 - Bases que desarrollan la mayor cantidad de expediciones en un periodo.
-- Parametros: p_fecha_inicio, p_fecha_termino
-- Tablas: EXPEDICION, BASE, PAIS
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_r1_bases_mas_expediciones(
    IN p_fecha_inicio  DATE,
    IN p_fecha_termino DATE
)
READS SQL DATA
BEGIN
    IF p_fecha_inicio IS NULL OR p_fecha_termino IS NULL OR p_fecha_inicio > p_fecha_termino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R1: fechas obligatorias y fecha_inicio debe ser <= fecha_termino';
    END IF;

    SELECT
        DENSE_RANK() OVER (ORDER BY COUNT(e.idExpedicion) DESC)       AS ranking,
        p.nombreOficial                                               AS pais,
        b.idBase,
        b.nombre                                                      AS base,
        COUNT(e.idExpedicion)                                         AS total_expediciones,
        SUM(e.duracionDias)                                           AS dias_totales,
        ROUND(AVG(e.duracionDias), 1)                                 AS duracion_promedio_dias,
        MIN(e.fechaInicio)                                            AS primera_expedicion,
        MAX(e.fechaInicio)                                            AS ultima_expedicion,
        GROUP_CONCAT(e.idExpedicion ORDER BY e.fechaInicio SEPARATOR ', ') AS expediciones
    FROM EXPEDICION e
    JOIN BASE b  ON b.idBase = e.idBase
    JOIN PAIS p  ON p.idPais = b.idPais
    WHERE e.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino      -- S5
    GROUP BY p.nombreOficial, b.idBase, b.nombre
    ORDER BY ranking, b.nombre;
END$$

-- ----------------------------------------------------------------------------
-- R4 - Paises que concentran mas expediciones y participantes en un periodo.
-- Parametros: p_fecha_inicio, p_fecha_termino
-- Tablas: PAIS, BASE, EXPEDICION, PARTICIPACION
-- Nota: COUNT(DISTINCT e.idExpedicion) evita contar de mas las expediciones al unir
--       con PARTICIPACION (1 fila por participante).
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_r4_paises_expediciones_participantes(
    IN p_fecha_inicio  DATE,
    IN p_fecha_termino DATE
)
READS SQL DATA
BEGIN
    IF p_fecha_inicio IS NULL OR p_fecha_termino IS NULL OR p_fecha_inicio > p_fecha_termino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R4: fechas obligatorias y fecha_inicio debe ser <= fecha_termino';
    END IF;

    SELECT
        DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT e.idExpedicion) DESC) AS ranking,
        p.idPais,
        p.nombreOficial                          AS pais,
        p.organismoResponsable                   AS organismo,
        COUNT(DISTINCT b.idBase)                 AS bases_con_expediciones,
        COUNT(DISTINCT e.idExpedicion)           AS total_expediciones,
        COUNT(pa.idPersonal)                     AS total_participaciones,
        COUNT(DISTINCT pa.idPersonal)            AS participantes_distintos
    FROM PAIS p
    JOIN BASE b                ON b.idPais = p.idPais
    JOIN EXPEDICION e          ON e.idBase = b.idBase
    LEFT JOIN PARTICIPACION pa ON pa.idExpedicion = e.idExpedicion
                              AND pa.estado <> 'CANCELADA'                  -- S2
    WHERE e.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino          -- S5
    GROUP BY p.idPais, p.nombreOficial, p.organismoResponsable
    ORDER BY ranking, total_participaciones DESC, p.nombreOficial;
END$$

-- ----------------------------------------------------------------------------
-- R9 - Expediciones que superan la duracion promedio de las expediciones de la
--      misma base en el periodo (subconsulta correlacionada).
-- Parametros: p_id_base (NULL = todas), p_fecha_inicio, p_fecha_termino
-- Tablas: BASE, EXPEDICION, PARTICIPACION
-- Correlacion: e2.idBase = e.idBase (el promedio se recalcula para la base de cada fila).
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_r9_expediciones_sobre_promedio_base(
    IN p_id_base       VARCHAR(10),
    IN p_fecha_inicio  DATE,
    IN p_fecha_termino DATE
)
READS SQL DATA
BEGIN
    IF p_fecha_inicio IS NULL OR p_fecha_termino IS NULL OR p_fecha_inicio > p_fecha_termino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R9: fechas obligatorias y fecha_inicio debe ser <= fecha_termino';
    END IF;
    IF p_id_base IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BASE WHERE idBase = p_id_base) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R9: la base indicada no existe';
    END IF;

    SELECT
        b.idBase,
        b.nombre                                                    AS base,
        e.idExpedicion,
        e.fechaInicio,
        DATE_ADD(e.fechaInicio, INTERVAL e.duracionDias DAY)        AS fechaTermino,
        e.duracionDias,
        (SELECT ROUND(AVG(e2.duracionDias), 2)
           FROM EXPEDICION e2
          WHERE e2.idBase = e.idBase
            AND e2.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino) AS promedio_base_periodo,
        COUNT(pa.idPersonal)                                        AS participantes
    FROM EXPEDICION e
    JOIN BASE b                ON b.idBase = e.idBase
    LEFT JOIN PARTICIPACION pa ON pa.idExpedicion = e.idExpedicion
                              AND pa.estado <> 'CANCELADA'                  -- S2
    WHERE (p_id_base IS NULL OR e.idBase = p_id_base)
      AND e.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino          -- S5
      AND e.duracionDias > (SELECT AVG(e2.duracionDias)
                              FROM EXPEDICION e2
                             WHERE e2.idBase = e.idBase
                               AND e2.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino)
    GROUP BY b.idBase, b.nombre, e.idExpedicion, e.idBase, e.fechaInicio, e.duracionDias
    ORDER BY b.idBase, e.duracionDias DESC, e.idExpedicion;
END$$

-- ----------------------------------------------------------------------------
-- R10 - Sectores con mas muestras recolectadas que el promedio de los sectores
--       de su misma base (subconsulta correlacionada).
-- Parametro: p_id_base (NULL = todas)
-- Tablas: BASE, SECTOR, RECOLECCION, MUESTRA
-- Promedio de la base = recolecciones de la base / sectores de la base (incluye sectores
-- sin recolecciones). "Cantidad de muestras" = numero de recolecciones; se muestran
-- ademas las muestras distintas.
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_r10_sectores_sobre_promedio_base(
    IN p_id_base VARCHAR(10)
)
READS SQL DATA
BEGIN
    IF p_id_base IS NOT NULL AND NOT EXISTS (SELECT 1 FROM BASE WHERE idBase = p_id_base) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R10: la base indicada no existe';
    END IF;

    SELECT
        b.idBase,
        b.nombre                                   AS base,
        s.nroSector,
        s.nombre                                   AS sector,
        COUNT(r.nroRecoleccion)                    AS total_recolecciones,
        COUNT(DISTINCT r.idMuestra)                AS muestras_distintas,
        COUNT(DISTINCT m.tipoMuestra)              AS tipos_distintos,
        ROUND((SELECT COUNT(*) FROM RECOLECCION r2 WHERE r2.idBase = s.idBase)
            / (SELECT COUNT(*) FROM SECTOR s2      WHERE s2.idBase = s.idBase), 2) AS promedio_sectores_base
    FROM SECTOR s
    JOIN BASE b             ON b.idBase = s.idBase
    LEFT JOIN RECOLECCION r ON r.idBase = s.idBase AND r.nroSector = s.nroSector
    LEFT JOIN MUESTRA m     ON m.idMuestra = r.idMuestra
    WHERE (p_id_base IS NULL OR s.idBase = p_id_base)
    GROUP BY b.idBase, b.nombre, s.idBase, s.nroSector, s.nombre
    HAVING COUNT(r.nroRecoleccion) >
           (SELECT COUNT(*) FROM RECOLECCION r2 WHERE r2.idBase = s.idBase)
         / (SELECT COUNT(*) FROM SECTOR s2      WHERE s2.idBase = s.idBase)
    ORDER BY b.idBase, total_recolecciones DESC, s.nroSector;
END$$

-- ----------------------------------------------------------------------------
-- R11 - Participantes con mas expediciones que el promedio Y evaluacion promedio
--       superior al promedio general, en un rango de fechas.
-- Parametros: p_fecha_inicio, p_fecha_termino
-- Tablas: PERSONAL, PARTICIPACION, EXPEDICION, EVALUACION
-- Logica: la CTE calcula por participante (agrupacion) expediciones y evaluacion promedio;
--         las subconsultas del WHERE calculan los dos promedios de referencia (S6).
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_r11_participantes_sobre_promedio(
    IN p_fecha_inicio  DATE,
    IN p_fecha_termino DATE
)
READS SQL DATA
BEGIN
    IF p_fecha_inicio IS NULL OR p_fecha_termino IS NULL OR p_fecha_inicio > p_fecha_termino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R11: fechas obligatorias y fecha_inicio debe ser <= fecha_termino';
    END IF;

    WITH participante_periodo AS (
        SELECT
            per.idPersonal,
            per.nombres,
            per.apellidos,
            per.tipoPersonal,
            COUNT(DISTINCT e.idExpedicion) AS expediciones,
            AVG(ev.calificacion)           AS evaluacion_prom
        FROM PERSONAL per
        JOIN PARTICIPACION pa   ON pa.idPersonal = per.idPersonal
                               AND pa.estado <> 'CANCELADA'                 -- S2
        JOIN EXPEDICION e       ON e.idExpedicion = pa.idExpedicion
        LEFT JOIN EVALUACION ev ON ev.idExpedicion = pa.idExpedicion
                               AND ev.idPersonal = pa.idPersonal
        WHERE e.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino      -- S5
        GROUP BY per.idPersonal, per.nombres, per.apellidos, per.tipoPersonal
    )
    SELECT
        pp.idPersonal,
        pp.nombres,
        pp.apellidos,
        pp.tipoPersonal,
        pp.expediciones,
        ROUND((SELECT AVG(expediciones) FROM participante_periodo), 2) AS promedio_expediciones_periodo,
        ROUND(pp.evaluacion_prom, 2)                                  AS evaluacion_promedio,
        ROUND((SELECT AVG(ev2.calificacion)
                 FROM EVALUACION ev2
                 JOIN EXPEDICION e2 ON e2.idExpedicion = ev2.idExpedicion
                WHERE e2.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino), 2) AS evaluacion_promedio_general
    FROM participante_periodo pp
    WHERE pp.expediciones > (SELECT AVG(expediciones) FROM participante_periodo)
      AND pp.evaluacion_prom > (SELECT AVG(ev2.calificacion)
                                  FROM EVALUACION ev2
                                  JOIN EXPEDICION e2 ON e2.idExpedicion = ev2.idExpedicion
                                 WHERE e2.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino)
    ORDER BY pp.expediciones DESC, pp.evaluacion_prom DESC, pp.idPersonal;
END$$

-- ----------------------------------------------------------------------------
-- R12 - Bases con duracion promedio de expedicion superior al promedio general
--       de las expediciones del periodo (subconsulta + agrupacion).
-- Parametros: p_fecha_inicio, p_fecha_termino
-- Tablas: PAIS, BASE, EXPEDICION
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_r12_bases_duracion_sobre_promedio(
    IN p_fecha_inicio  DATE,
    IN p_fecha_termino DATE
)
READS SQL DATA
BEGIN
    IF p_fecha_inicio IS NULL OR p_fecha_termino IS NULL OR p_fecha_inicio > p_fecha_termino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R12: fechas obligatorias y fecha_inicio debe ser <= fecha_termino';
    END IF;

    SELECT
        p.nombreOficial                                   AS pais,
        b.idBase,
        b.nombre                                          AS base,
        COUNT(e.idExpedicion)                             AS total_expediciones,
        ROUND(AVG(e.duracionDias), 2)                     AS duracion_promedio_base,
        ROUND((SELECT AVG(e2.duracionDias)
                 FROM EXPEDICION e2
                WHERE e2.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino), 2) AS promedio_general_periodo,
        ROUND(AVG(e.duracionDias) - (SELECT AVG(e2.duracionDias)
                 FROM EXPEDICION e2
                WHERE e2.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino), 2) AS diferencia_dias
    FROM EXPEDICION e
    JOIN BASE b  ON b.idBase = e.idBase
    JOIN PAIS p  ON p.idPais = b.idPais
    WHERE e.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino          -- S5
    GROUP BY p.nombreOficial, b.idBase, b.nombre
    HAVING AVG(e.duracionDias) > (SELECT AVG(e2.duracionDias)
                                    FROM EXPEDICION e2
                                   WHERE e2.fechaInicio BETWEEN p_fecha_inicio AND p_fecha_termino)
    ORDER BY duracion_promedio_base DESC, b.nombre;
END$$

DELIMITER ;
