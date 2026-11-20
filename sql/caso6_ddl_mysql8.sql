-- ============================================================================
-- Proyecto Semestral TDFI103 - Caso 6 (Hipótesis de trabajo D01-D07)
-- Script DDL reproducible para MySQL 8.x
-- ============================================================================

DROP DATABASE IF EXISTS expediciones_antarticas_db;

CREATE DATABASE expediciones_antarticas_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE expediciones_antarticas_db;

-- ----------------------------------------------------------------------------
-- 1. Tablas maestras y de ubicación
-- ----------------------------------------------------------------------------

CREATE TABLE PAIS (
    idPais VARCHAR(10) NOT NULL,
    nombreOficial VARCHAR(100) NOT NULL,
    organismoResponsable VARCHAR(120) NOT NULL,
    presupuestoAnual DECIMAL(15,2) NOT NULL,
    CONSTRAINT pk_pais PRIMARY KEY (idPais),
    CONSTRAINT chk_pais_presupuesto CHECK (presupuestoAnual >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BASE (
    idBase VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(150) NULL,
    fechaInstalacion DATE NULL,
    capacidadMaxima INT NOT NULL,
    presupuesto DECIMAL(15,2) NOT NULL,
    nivelAislamiento VARCHAR(30) NOT NULL,
    idPais VARCHAR(10) NOT NULL,
    CONSTRAINT pk_base PRIMARY KEY (idBase),
    CONSTRAINT fk_base_pais FOREIGN KEY (idPais)
        REFERENCES PAIS (idPais)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_base_capacidad CHECK (capacidadMaxima > 0),
    CONSTRAINT chk_base_presupuesto CHECK (presupuesto >= 0),
    CONSTRAINT chk_base_aislamiento CHECK (
        nivelAislamiento IN ('BAJO', 'MEDIO', 'ALTO', 'EXTREMO')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SECTOR (
    idBase VARCHAR(10) NOT NULL,
    nroSector VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    superficie DECIMAL(10,2) NULL,
    condicionesClimaticas VARCHAR(200) NULL,
    nivelAcceso VARCHAR(30) NOT NULL,
    CONSTRAINT pk_sector PRIMARY KEY (idBase, nroSector),
    CONSTRAINT fk_sector_base FOREIGN KEY (idBase)
        REFERENCES BASE (idBase)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_sector_superficie CHECK (
        superficie IS NULL OR superficie > 0
    ),
    CONSTRAINT chk_sector_acceso CHECK (
        nivelAcceso IN ('LIBRE', 'RESTRINGIDO', 'CERRADO')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- 2. Personal, teléfonos, seguridad y roles
-- ----------------------------------------------------------------------------

CREATE TABLE PERSONAL (
    idPersonal VARCHAR(10) NOT NULL,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    tipoPersonal VARCHAR(40) NOT NULL,
    idSupervisor VARCHAR(10) NULL,
    CONSTRAINT pk_personal PRIMARY KEY (idPersonal),
    CONSTRAINT uq_personal_correo UNIQUE (correo),
    CONSTRAINT fk_personal_supervisor FOREIGN KEY (idSupervisor)
        REFERENCES PERSONAL (idPersonal)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT chk_personal_tipo CHECK (
        tipoPersonal IN (
            'CIENTIFICO',
            'TECNICO_TERRENO',
            'COORDINADOR_LOGISTICO',
            'ADMINISTRADOR_BASE'
        )
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE TELEFONO_PERSONAL (
    idPersonal VARCHAR(10) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    CONSTRAINT pk_telefono_personal PRIMARY KEY (idPersonal, telefono),
    CONSTRAINT fk_telefono_personal FOREIGN KEY (idPersonal)
        REFERENCES PERSONAL (idPersonal)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CUENTA_USUARIO (
    idCuenta VARCHAR(10) NOT NULL,
    nombreUsuario VARCHAR(60) NOT NULL,
    claveAcceso VARCHAR(255) NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    idPersonal VARCHAR(10) NOT NULL,
    CONSTRAINT pk_cuenta_usuario PRIMARY KEY (idCuenta),
    CONSTRAINT uq_cuenta_usuario_nombre UNIQUE (nombreUsuario),
    CONSTRAINT uq_cuenta_usuario_personal UNIQUE (idPersonal),
    CONSTRAINT fk_cuenta_usuario_personal FOREIGN KEY (idPersonal)
        REFERENCES PERSONAL (idPersonal)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ROL (
    idRol VARCHAR(10) NOT NULL,
    nombreRol VARCHAR(60) NOT NULL,
    descripcion VARCHAR(150) NULL,
    CONSTRAINT pk_rol PRIMARY KEY (idRol),
    CONSTRAINT uq_rol_nombre UNIQUE (nombreRol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ASIGNACION_ROL (
    idCuenta VARCHAR(10) NOT NULL,
    idRol VARCHAR(10) NOT NULL,
    fechaAsignacion DATE NOT NULL,
    CONSTRAINT pk_asignacion_rol PRIMARY KEY (idCuenta, idRol),
    CONSTRAINT fk_asignacion_rol_cuenta FOREIGN KEY (idCuenta)
        REFERENCES CUENTA_USUARIO (idCuenta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_asignacion_rol_rol FOREIGN KEY (idRol)
        REFERENCES ROL (idRol)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- 3. Expediciones, participaciones y evaluaciones
-- ----------------------------------------------------------------------------

CREATE TABLE EXPEDICION (
    idExpedicion VARCHAR(10) NOT NULL,
    fechaInicio DATE NOT NULL,
    duracionDias INT NOT NULL,
    capacidadMaxima INT NOT NULL,
    responsable VARCHAR(100) NOT NULL,
    idBase VARCHAR(10) NOT NULL,
    CONSTRAINT pk_expedicion PRIMARY KEY (idExpedicion),
    CONSTRAINT fk_expedicion_base FOREIGN KEY (idBase)
        REFERENCES BASE (idBase)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_expedicion_duracion CHECK (duracionDias > 0),
    CONSTRAINT chk_expedicion_capacidad CHECK (capacidadMaxima > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PARTICIPACION (
    idExpedicion VARCHAR(10) NOT NULL,
    idPersonal VARCHAR(10) NOT NULL,
    funcion VARCHAR(80) NOT NULL,
    fechaIncorporacion DATE NOT NULL,
    estado VARCHAR(30) NOT NULL,
    observaciones VARCHAR(250) NULL,
    CONSTRAINT pk_participacion PRIMARY KEY (idExpedicion, idPersonal),
    CONSTRAINT fk_participacion_expedicion FOREIGN KEY (idExpedicion)
        REFERENCES EXPEDICION (idExpedicion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_participacion_personal FOREIGN KEY (idPersonal)
        REFERENCES PERSONAL (idPersonal)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_participacion_estado CHECK (
        estado IN ('ACTIVA', 'FINALIZADA', 'PENDIENTE', 'CANCELADA')
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE EVALUACION (
    idExpedicion VARCHAR(10) NOT NULL,
    nroEvaluacion VARCHAR(10) NOT NULL,
    idPersonal VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    calificacion INT NOT NULL,
    comentario VARCHAR(250) NULL,
    CONSTRAINT pk_evaluacion PRIMARY KEY (idExpedicion, nroEvaluacion),
    CONSTRAINT uq_evaluacion_expedicion_personal UNIQUE (idExpedicion, idPersonal),
    CONSTRAINT fk_evaluacion_expedicion FOREIGN KEY (idExpedicion)
        REFERENCES EXPEDICION (idExpedicion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_evaluacion_participacion FOREIGN KEY (idExpedicion, idPersonal)
        REFERENCES PARTICIPACION (idExpedicion, idPersonal)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_evaluacion_calificacion CHECK (calificacion BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- 4. Muestras (supertipo y subtipos) y recolecciones
-- ----------------------------------------------------------------------------

CREATE TABLE MUESTRA (
    idMuestra VARCHAR(10) NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    fechaHallazgo DATE NOT NULL,
    estadoConservacion VARCHAR(50) NOT NULL,
    tipoMuestra VARCHAR(20) NOT NULL DEFAULT 'SIN_CLASIFICAR',
    CONSTRAINT pk_muestra PRIMARY KEY (idMuestra),
    CONSTRAINT uq_muestra_id_tipo UNIQUE (idMuestra, tipoMuestra),
    CONSTRAINT chk_muestra_conservacion CHECK (
        estadoConservacion IN (
            'OPTIMO',
            'BUENO',
            'REGULAR',
            'DETERIORADO',
            'SIN_DATO'
        )
    ),
    CONSTRAINT chk_muestra_tipo CHECK (
        tipoMuestra IN (
            'SIN_CLASIFICAR',
            'BIOLOGICA',
            'GEOLOGICA',
            'CLIMATICA'
        )
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE MUESTRA_BIOLOGICA (
    idMuestra VARCHAR(10) NOT NULL,
    tipoMuestra VARCHAR(20) NOT NULL DEFAULT 'BIOLOGICA',
    especie VARCHAR(100) NOT NULL,
    tipoTejido VARCHAR(80) NOT NULL,

    CONSTRAINT pk_muestra_biologica
        PRIMARY KEY (idMuestra),

    CONSTRAINT chk_muestra_bio_tipo
        CHECK (tipoMuestra = 'BIOLOGICA'),

    CONSTRAINT fk_muestra_bio_muestra
        FOREIGN KEY (idMuestra, tipoMuestra)
        REFERENCES MUESTRA (idMuestra, tipoMuestra)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE MUESTRA_GEOLOGICA (
    idMuestra VARCHAR(10) NOT NULL,
    tipoMuestra VARCHAR(20) NOT NULL DEFAULT 'GEOLOGICA',
    tipoRoca VARCHAR(80) NOT NULL,
    composicion VARCHAR(150) NOT NULL,

    CONSTRAINT pk_muestra_geologica
        PRIMARY KEY (idMuestra),

    CONSTRAINT chk_muestra_geo_tipo
        CHECK (tipoMuestra = 'GEOLOGICA'),

    CONSTRAINT fk_muestra_geo_muestra
        FOREIGN KEY (idMuestra, tipoMuestra)
        REFERENCES MUESTRA (idMuestra, tipoMuestra)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE MUESTRA_CLIMATICA (
    idMuestra VARCHAR(10) NOT NULL,
    tipoMuestra VARCHAR(20) NOT NULL DEFAULT 'CLIMATICA',
    variableClimatica VARCHAR(80) NOT NULL,
    valorMedido DECIMAL(12,3) NOT NULL,
    unidadMedida VARCHAR(30) NOT NULL,

    CONSTRAINT pk_muestra_climatica
        PRIMARY KEY (idMuestra),

    CONSTRAINT chk_muestra_cli_tipo
        CHECK (tipoMuestra = 'CLIMATICA'),

    CONSTRAINT fk_muestra_cli_muestra
        FOREIGN KEY (idMuestra, tipoMuestra)
        REFERENCES MUESTRA (idMuestra, tipoMuestra)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE RECOLECCION (
    idExpedicion VARCHAR(10) NOT NULL,
    nroRecoleccion VARCHAR(10) NOT NULL,
    idMuestra VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    idBase VARCHAR(10) NOT NULL,
    nroSector VARCHAR(10) NOT NULL,
    idResponsable VARCHAR(10) NOT NULL,
    CONSTRAINT pk_recoleccion PRIMARY KEY (idExpedicion, nroRecoleccion),
    CONSTRAINT fk_recoleccion_expedicion FOREIGN KEY (idExpedicion)
        REFERENCES EXPEDICION (idExpedicion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_recoleccion_muestra FOREIGN KEY (idMuestra)
        REFERENCES MUESTRA (idMuestra)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_recoleccion_sector FOREIGN KEY (idBase, nroSector)
        REFERENCES SECTOR (idBase, nroSector)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_recoleccion_responsable FOREIGN KEY (idResponsable)
        REFERENCES PERSONAL (idPersonal)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;