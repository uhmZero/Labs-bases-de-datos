-- LABORATORIO 3 - TELEMEDICINA PROACTIVA

CREATE SCHEMA IF NOT EXISTS estudiante1_estudiante2;
SET search_path TO estudiante1_estudiante2;

-- USUARIO
CREATE TABLE usuario (
    id_usuario       SERIAL       PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    apellido         VARCHAR(100) NOT NULL,
    email            VARCHAR(150) NOT NULL UNIQUE,
    contraseña       VARCHAR(255) NOT NULL,
    fecha_registro   DATE         NOT NULL DEFAULT CURRENT_DATE,
    foto             VARCHAR(300),
    ubicacion        VARCHAR(200)
);

-- ESPECIALISTA (rol)
CREATE TABLE especialista (
    id_especialista  INT  PRIMARY KEY,
    biografia        TEXT,
    años_experiencia INT,
    CONSTRAINT fk_esp_usuario
        FOREIGN KEY (id_especialista) REFERENCES usuario(id_usuario)
);

-- PACIENTE (rol)
CREATE TABLE paciente (
    id_paciente      INT         PRIMARY KEY,
    alergias         TEXT,
    tipo_sangre      VARCHAR(5),
    fecha_nacimiento DATE,
    CONSTRAINT fk_pac_usuario
        FOREIGN KEY (id_paciente) REFERENCES usuario(id_usuario)
);

-- AREA DE ESPECIALIDAD
CREATE TABLE area_especialidad (
    id_area     SERIAL       PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    descripcion TEXT
);

-- M:N especialista — area_especialidad
CREATE TABLE especialista_area (
    id_especialista INT NOT NULL,
    id_area         INT NOT NULL,
    PRIMARY KEY (id_especialista, id_area),
    CONSTRAINT fk_ea_esp  FOREIGN KEY (id_especialista) REFERENCES especialista(id_especialista),
    CONSTRAINT fk_ea_area FOREIGN KEY (id_area)         REFERENCES area_especialidad(id_area)
);

-- PLAN DE BIENESTAR
CREATE TABLE plan_bienestar (
    id_plan_bn          SERIAL        PRIMARY KEY,
    nombre              VARCHAR(200)  NOT NULL,
    precio              NUMERIC(10,2) NOT NULL,
    tipo                VARCHAR(50),
    consultas_incluidas INT,
    duracion_total      INT,
    fecha_inicio        DATE,
    fecha_fin           DATE,
    estado              VARCHAR(50)
);

-- PLAN DE TRATAMIENTO
CREATE TABLE plan_tratamiento (
    id_plan_tra    SERIAL       PRIMARY KEY,
    nombre         VARCHAR(200) NOT NULL,
    fecha_inicio   DATE,
    fecha_fin      DATE,
    estado         VARCHAR(50),
    duracion_total INT
);

-- FASE
CREATE TABLE fase (
    id_fase     SERIAL       PRIMARY KEY,
    id_plan_tra INT          NOT NULL,
    nombre      VARCHAR(150) NOT NULL,
    n_fase      INT          NOT NULL,
    descripcion TEXT,
    visibilidad VARCHAR(50),
    CONSTRAINT fk_fase_plan FOREIGN KEY (id_plan_tra) REFERENCES plan_tratamiento(id_plan_tra)
);

-- VIDEO
CREATE TABLE video (
    id_video SERIAL       PRIMARY KEY,
    id_fase  INT          NOT NULL,
    titulo   VARCHAR(200) NOT NULL,
    url      VARCHAR(300) NOT NULL,
    duracion INT,
    CONSTRAINT fk_video_fase FOREIGN KEY (id_fase) REFERENCES fase(id_fase)
);

-- GUIA MEDICA
CREATE TABLE guia_medica (
    id_guia  SERIAL        PRIMARY KEY,
    id_fase  INT           NOT NULL,
    titulo   VARCHAR(200)  NOT NULL,
    pdf      VARCHAR(300)  NOT NULL,
    tamaño   NUMERIC(10,2),
    CONSTRAINT fk_guia_fase FOREIGN KEY (id_fase) REFERENCES fase(id_fase)
);

-- PROTOCOLO DE SEGUIMIENTO
CREATE TABLE protocolo_seguimiento (
    id_protocolo     SERIAL       PRIMARY KEY,
    id_fase          INT          NOT NULL,
    nombre           VARCHAR(200) NOT NULL,
    num_indicadores  INT,
    tiempo_respuesta INT,
    CONSTRAINT fk_proto_fase FOREIGN KEY (id_fase) REFERENCES fase(id_fase)
);

-- PAGO
CREATE TABLE pago (
    id_pago       SERIAL        PRIMARY KEY,
    monto         NUMERIC(10,2) NOT NULL,
    metodo        VARCHAR(100),
    fecha         DATE          NOT NULL DEFAULT CURRENT_DATE,
    estado        VARCHAR(50),
    banco_emisor  VARCHAR(100),
    token_tarjeta VARCHAR(255)
);

-- INSCRIPCION EN PLAN DE TRATAMIENTO
CREATE TABLE inscripcion_plan (
    id_inscripcion          SERIAL        PRIMARY KEY,
    id_paciente             INT           NOT NULL,
    id_plan_tra             INT           NOT NULL,
    id_especialista         INT           NOT NULL,
    id_pago                 INT,
    fecha_inscripcion       DATE          NOT NULL DEFAULT CURRENT_DATE,
    puntuacion_satisfaccion NUMERIC(3,1),
    CONSTRAINT fk_insc_paciente     FOREIGN KEY (id_paciente)     REFERENCES paciente(id_paciente),
    CONSTRAINT fk_insc_plan         FOREIGN KEY (id_plan_tra)     REFERENCES plan_tratamiento(id_plan_tra),
    CONSTRAINT fk_insc_especialista FOREIGN KEY (id_especialista) REFERENCES especialista(id_especialista),
    CONSTRAINT fk_insc_pago         FOREIGN KEY (id_pago)         REFERENCES pago(id_pago)
);

-- SUSCRIPCION A PLAN DE BIENESTAR
CREATE TABLE suscripcion_plan_bienestar (
    id_suscripcion    SERIAL PRIMARY KEY,
    id_paciente       INT    NOT NULL,
    id_plan_bn        INT    NOT NULL,
    id_pago           INT,
    fecha_suscripcion DATE   NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_spb_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_spb_plan     FOREIGN KEY (id_plan_bn)  REFERENCES plan_bienestar(id_plan_bn),
    CONSTRAINT fk_spb_pago     FOREIGN KEY (id_pago)     REFERENCES pago(id_pago)
);

-- CONSULTA
CREATE TABLE consulta (
    id_consulta     SERIAL        PRIMARY KEY,
    id_paciente     INT           NOT NULL,
    id_especialista INT           NOT NULL,
    fecha_hora      TIMESTAMP     NOT NULL,
    duracion        INT,
    tipo            VARCHAR(100),
    notas           TEXT,
    CONSTRAINT fk_cons_paciente     FOREIGN KEY (id_paciente)     REFERENCES paciente(id_paciente),
    CONSTRAINT fk_cons_especialista FOREIGN KEY (id_especialista) REFERENCES especialista(id_especialista)
);

-- CONSTANCIA DE ALTA
CREATE TABLE constancia_alta (
    id_constancia          SERIAL  PRIMARY KEY,
    id_plan_tra            INT     NOT NULL,
    fecha_emision          DATE    NOT NULL DEFAULT CURRENT_DATE,
    tipo                   VARCHAR(100),
    compartido_aseguradora BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_const_plan FOREIGN KEY (id_plan_tra) REFERENCES plan_tratamiento(id_plan_tra)
);

-- FORO
CREATE TABLE foro (
    id_foro        SERIAL       PRIMARY KEY,
    id_area        INT,
    nombre         VARCHAR(200) NOT NULL,
    patologia      VARCHAR(200),
    fecha_creacion DATE         NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_foro_area FOREIGN KEY (id_area) REFERENCES area_especialidad(id_area)
);

-- PUBLICACION EN FORO
CREATE TABLE publicacion (
    id_publicacion SERIAL    PRIMARY KEY,
    id_foro        INT       NOT NULL,
    id_usuario     INT       NOT NULL,
    contenido      TEXT      NOT NULL,
    fecha          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pub_foro     FOREIGN KEY (id_foro)    REFERENCES foro(id_foro),
    CONSTRAINT fk_pub_usuario  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- M:N paciente — foro
CREATE TABLE paciente_foro (
    id_paciente INT NOT NULL,
    id_foro     INT NOT NULL,
    PRIMARY KEY (id_paciente, id_foro),
    CONSTRAINT fk_pf_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_pf_foro     FOREIGN KEY (id_foro)     REFERENCES foro(id_foro)
);

-- MENSAJE
CREATE TABLE mensaje (
    id_mensaje        SERIAL    PRIMARY KEY,
    id_remitente      INT       NOT NULL,
    id_destinatario   INT       NOT NULL,
    contenido_cifrado TEXT      NOT NULL,
    leido             BOOLEAN   NOT NULL DEFAULT FALSE,
    fecha_hora        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_msj_remitente    FOREIGN KEY (id_remitente)    REFERENCES usuario(id_usuario),
    CONSTRAINT fk_msj_destinatario FOREIGN KEY (id_destinatario) REFERENCES usuario(id_usuario)
);

-- REPORTE DE INCIDENCIA
CREATE TABLE reporte_incidencia (
    id_reporte  SERIAL    PRIMARY KEY,
    id_usuario  INT       NOT NULL,
    tipo        VARCHAR(100),
    descripcion TEXT,
    fecha       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado      VARCHAR(50),
    CONSTRAINT fk_ri_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- ALERTA
CREATE TABLE alerta (
    id_alerta  SERIAL   PRIMARY KEY,
    id_usuario INT      NOT NULL,
    tipo       VARCHAR(100),
    canal      VARCHAR(50),
    frecuencia VARCHAR(100),
    hora       TIME,
    CONSTRAINT fk_alerta_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- LOG DE ACTIVIDAD
CREATE TABLE log_actividad (
    id_log      SERIAL    PRIMARY KEY,
    id_usuario  INT       NOT NULL,
    fecha_hora  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_evento VARCHAR(100),
    descripcion TEXT,
    CONSTRAINT fk_log_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- SIGNO VITAL
CREATE TABLE signo_vital (
    id_registro SERIAL        PRIMARY KEY,
    id_paciente INT           NOT NULL,
    valor       NUMERIC(10,2),
    tipo        VARCHAR(100),
    unidad      VARCHAR(50),
    fecha_hora  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sv_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

-- SEGUIMIENTO M:N paciente sigue especialista
CREATE TABLE seguimiento (
    id_paciente     INT NOT NULL,
    id_especialista INT NOT NULL,
    fecha_inicio    DATE,
    PRIMARY KEY (id_paciente, id_especialista),
    CONSTRAINT fk_seg_paciente     FOREIGN KEY (id_paciente)     REFERENCES paciente(id_paciente),
    CONSTRAINT fk_seg_especialista FOREIGN KEY (id_especialista) REFERENCES especialista(id_especialista)
);
