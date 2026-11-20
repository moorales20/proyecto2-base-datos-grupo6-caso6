USE expediciones_antarticas_db;

DROP VIEW IF EXISTS vw_r2_distribucion_muestras_base_sector;

CREATE VIEW vw_r2_distribucion_muestras_base_sector AS
SELECT
    b.idBase,
    b.nombre AS nombreBase,
    s.nroSector,
    s.nombre AS nombreSector,
    m.tipoMuestra,
    COUNT(DISTINCT r.idExpedicion, r.nroRecoleccion) AS totalRecolecciones,
    COUNT(DISTINCT m.idMuestra) AS totalMuestrasClasificadas
FROM RECOLECCION r
INNER JOIN MUESTRA m
    ON m.idMuestra = r.idMuestra
INNER JOIN SECTOR s
    ON s.idBase = r.idBase
   AND s.nroSector = r.nroSector
INNER JOIN BASE b
    ON b.idBase = s.idBase
LEFT JOIN MUESTRA_BIOLOGICA mb
    ON mb.idMuestra = m.idMuestra
   AND m.tipoMuestra = 'BIOLOGICA'
LEFT JOIN MUESTRA_GEOLOGICA mg
    ON mg.idMuestra = m.idMuestra
   AND m.tipoMuestra = 'GEOLOGICA'
LEFT JOIN MUESTRA_CLIMATICA mc
    ON mc.idMuestra = m.idMuestra
   AND m.tipoMuestra = 'CLIMATICA'
WHERE m.tipoMuestra IN ('BIOLOGICA', 'GEOLOGICA', 'CLIMATICA')
GROUP BY
    b.idBase,
    b.nombre,
    s.nroSector,
    s.nombre,
    m.tipoMuestra;