-- LABORATORIO 3 - TELEMEDICINA PROACTIVA

SET search_path TO "JoseC_Ariel";


-- =============================================
-- BLOQUE DE DATOS
-- =============================================

-- Usuarios base (4 registros: 1 especialista, 3 pacientes)
INSERT INTO usuario (nombre, apellido, email, contraseña, fecha_registro, ubicacion) VALUES
    ('Carlos',  'Méndez',    'carlos.mendez@tele.cr',    'hash_cm1', '2024-01-10', 'San José, CR'),   -- id 1
    ('Ana',     'Vargas',    'ana.vargas@tele.cr',        'hash_av2', '2024-02-20', 'Heredia, CR'),    -- id 2
    ('Luis',    'Fernández', 'luis.fernandez@tele.cr',    'hash_lf3', '2023-06-01', 'Cartago, CR'),    -- id 3 (especialista)
    ('María',   'Solís',     'maria.solis@tele.cr',       'hash_ms4', '2024-03-01', 'Alajuela, CR');   -- id 4

-- Especialista y pacientes
INSERT INTO especialista (id_especialista, biografia, años_experiencia)
VALUES (3, 'Especialista en medicina rehabilitadora con 20 años de experiencia clínica.', 20);

INSERT INTO paciente (id_paciente, alergias, tipo_sangre, fecha_nacimiento) VALUES
    (1, 'Penicilina', 'O+', '1990-05-15'),
    (2, 'Ninguna',    'A-', '1985-11-22'),
    (4, 'Latex',      'AB+','1992-07-30');

-- Areas de especialidad
INSERT INTO area_especialidad (nombre, descripcion) VALUES
    ('Rehabilitación',      'Tratamiento y recuperación física post-lesión'),          -- id 1
    ('Medicina Preventiva', 'Control y prevención de enfermedades crónicas');           -- id 2

INSERT INTO especialista_area (id_especialista, id_area) VALUES (3, 1), (3, 2);

-- Planes de tratamiento
-- Plan 1 tendrá foro    sirve para el caso de reincidencia CON mensajes
-- Plan 2 NO tendrá foro sirve para el caso COALESCE "Sin foros asociados"
INSERT INTO plan_tratamiento (nombre, fecha_inicio, fecha_fin, estado, duracion_total) VALUES
    ('Plan de Rehabilitación de Rodilla',  '2024-01-01', '2024-06-30', 'activo', 180),  -- id 1
    ('Plan de Medicina Preventiva Básica', '2024-01-15', '2024-07-15', 'activo', 180);  -- id 2

-- Fases del plan 1
INSERT INTO fase (id_plan_tra, nombre, n_fase, descripcion, visibilidad) VALUES
    (1, 'Fase Diagnóstica',      1, 'Evaluación inicial del estado articular',     'paciente'),  -- id 1
    (1, 'Fase de Ataque',        2, 'Ejercicios intensivos de rehabilitación',     'familiar'),  -- id 2
    (1, 'Fase de Mantenimiento', 3, 'Seguimiento y consolidación de la movilidad', 'paciente');  -- id 3

-- Contenido multimedia de fases
INSERT INTO video (id_fase, titulo, url, duracion) VALUES
    (1, 'Evaluación inicial de movilidad', 'https://rehab.tele.cr/videos/eval-001', 900),
    (2, 'Ejercicios de fortalecimiento',   'https://rehab.tele.cr/videos/ejer-001', 1800);

INSERT INTO guia_medica (id_fase, titulo, pdf, tamaño) VALUES
    (1, 'Guía de Diagnóstico Ortopédico',             'https://rehab.tele.cr/docs/diag-001.pdf', 2.50),
    (3, 'Manual de Mantenimiento Post-Rehabilitación', 'https://rehab.tele.cr/docs/mant-001.pdf', 1.80);

INSERT INTO protocolo_seguimiento (id_fase, nombre, num_indicadores, tiempo_respuesta) VALUES
    (2, 'Cuestionario de Dolor Diario',      5, 10),
    (3, 'Cuestionario de Movilidad Semanal', 8, 15);

-- Foro vinculado al area de rehabilitación (plan 1)
INSERT INTO foro (id_area, nombre, patologia, fecha_creacion) VALUES
    (1, 'Foro de Rehabilitación de Rodilla', 'Lesión ligamentaria', '2024-01-05');  -- id 1
-- Plan 2 queda sin foro intencionalmente

-- Pagos para inscripciones del bloque de datos
-- Carlos (id 1) — 3 inscripciones en plan 1 → reincidencia
INSERT INTO pago (monto, metodo, fecha, estado, banco_emisor, token_tarjeta) VALUES
    (75000.00, 'Tarjeta de crédito', '2024-01-10', 'aprobado', 'BAC San José',  'tok_bac_c1a'),  -- id 1
    (75000.00, 'Tarjeta de crédito', '2024-02-01', 'aprobado', 'BAC San José',  'tok_bac_c2b'),  -- id 2
    (75000.00, 'Tarjeta de crédito', '2024-03-01', 'aprobado', 'BAC San José',  'tok_bac_c3c');  -- id 3

-- Ana (id 2) — 3 inscripciones en plan 2 (sin foro → COALESCE)
INSERT INTO pago (monto, metodo, fecha, estado, banco_emisor, token_tarjeta) VALUES
    (60000.00, 'Tarjeta de crédito', '2024-01-15', 'aprobado', 'Banco Popular', 'tok_bp_a1d'),   -- id 4
    (60000.00, 'Tarjeta de crédito', '2024-02-15', 'aprobado', 'Banco Popular', 'tok_bp_a2e'),   -- id 5
    (60000.00, 'Tarjeta de crédito', '2024-03-15', 'aprobado', 'Banco Popular', 'tok_bp_a3f');   -- id 6

-- Inscripciones Carlos — plan 1 (3 veces = reincidencia)
INSERT INTO inscripcion_plan (id_paciente, id_plan_tra, id_especialista, id_pago, fecha_inscripcion, puntuacion_satisfaccion) VALUES
    (1, 1, 3, 1, '2024-01-10', 4.5),
    (1, 1, 3, 2, '2024-02-01', 4.0),
    (1, 1, 3, 3, '2024-03-01', 4.8);

-- Inscripciones Ana — plan 2 (3 veces = reincidencia, pero sin foro)
INSERT INTO inscripcion_plan (id_paciente, id_plan_tra, id_especialista, id_pago, fecha_inscripcion, puntuacion_satisfaccion) VALUES
    (2, 2, 3, 4, '2024-01-15', 3.5),
    (2, 2, 3, 5, '2024-02-15', 4.2),
    (2, 2, 3, 6, '2024-03-15', 4.0);

-- Carlos participa en el foro y publica mensajes
INSERT INTO paciente_foro (id_paciente, id_foro) VALUES (1, 1);

INSERT INTO publicacion (id_foro, id_usuario, contenido, fecha) VALUES
    (1, 1, 'El plan mejoró bastante mi movilidad después del tercer ingreso.',        '2024-03-05'),
    (1, 1, 'Los ejercicios de la Fase de Ataque son muy efectivos, los recomiendo.', '2024-03-10');


-- =============================================
-- BLOQUE DE TRANSACCIONES
-- =============================================

-- ACCIÓN 1 — Registrar paciente en plan con pago de copago YA PROCESADO (aprobado)
-- Paciente: María Solís (id=4), Plan: Rehabilitación Rodilla (id=1), Médico: Luis Fernández (id=3)
BEGIN;

WITH nuevo_pago AS (
    INSERT INTO pago (monto, metodo, fecha, estado, banco_emisor, token_tarjeta)
    VALUES (75000.00, 'Tarjeta de crédito', CURRENT_DATE, 'aprobado', 'Scotiabank CR', 'tok_sc_ms1')
    RETURNING id_pago
)
INSERT INTO inscripcion_plan (id_paciente, id_plan_tra, id_especialista, id_pago, fecha_inscripcion)
SELECT 4, 1, 3, id_pago, CURRENT_DATE
FROM nuevo_pago;

COMMIT;


-- ACCIÓN 2 — Registrar paciente en plan con pago PENDIENTE de aprobación por la aseguradora
-- Paciente: María Solís (id=4), Plan: Medicina Preventiva (id=2), Médico: Luis Fernández (id=3)
BEGIN;

WITH nuevo_pago AS (
    INSERT INTO pago (monto, metodo, fecha, estado, banco_emisor, token_tarjeta)
    VALUES (60000.00, 'Seguro médico', CURRENT_DATE, 'pendiente', 'INS Costa Rica', 'tok_ins_ms2')
    RETURNING id_pago
)
INSERT INTO inscripcion_plan (id_paciente, id_plan_tra, id_especialista, id_pago, fecha_inscripcion)
SELECT 4, 2, 3, id_pago, CURRENT_DATE
FROM nuevo_pago;

COMMIT;


-- =============================================
-- CONSULTAS
-- =============================================

-- REPORTE DE GESTIÓN
-- Muestra: Nombre del Paciente, Puntuación de Satisfacción, Plan de Salud,
--          Médico Asignado y Estado del Pago

SELECT
    u_pac.nombre || ' ' || u_pac.apellido        AS nombre_paciente,
    ip.puntuacion_satisfaccion                   AS puntuacion_satisfaccion,
    pt.nombre                                    AS plan_salud,
    u_esp.nombre || ' ' || u_esp.apellido        AS medico_asignado,
    COALESCE(p.estado, 'Sin pago registrado')    AS estado_pago
FROM      inscripcion_plan  ip
JOIN      paciente          pac   ON pac.id_paciente    = ip.id_paciente
JOIN      usuario           u_pac ON u_pac.id_usuario   = pac.id_paciente
JOIN      plan_tratamiento  pt    ON pt.id_plan_tra      = ip.id_plan_tra
JOIN      especialista      esp   ON esp.id_especialista = ip.id_especialista
JOIN      usuario           u_esp ON u_esp.id_usuario    = esp.id_especialista
LEFT JOIN pago              p     ON p.id_pago           = ip.id_pago
ORDER BY  u_pac.apellido, pt.nombre;


-- ANÁLISIS DE REINCIDENCIA
-- Pacientes ingresados al menos 3 veces en el mismo plan,
-- con mensajes del foro o "Sin foros asociados" si no hay foro

SELECT
    u_pac.nombre || ' ' || u_pac.apellido          AS nombre_paciente,
    pt.nombre                                      AS plan_tratamiento,
    u_esp.nombre || ' ' || u_esp.apellido          AS medico_lider,
    reincid.veces_ingresado                        AS total_ingresos,
    COALESCE(pub.contenido, 'Sin foros asociados') AS mensaje_foro
FROM (
    SELECT
        id_paciente,
        id_plan_tra,
        COUNT(*)            AS veces_ingresado,
        MAX(id_inscripcion) AS ultima_inscripcion
    FROM inscripcion_plan
    GROUP BY id_paciente, id_plan_tra
    HAVING COUNT(*) >= 3
) reincid
JOIN      inscripcion_plan  ip    ON ip.id_inscripcion  = reincid.ultima_inscripcion
JOIN      paciente          pac   ON pac.id_paciente    = reincid.id_paciente
JOIN      usuario           u_pac ON u_pac.id_usuario   = pac.id_paciente
JOIN      plan_tratamiento  pt    ON pt.id_plan_tra      = reincid.id_plan_tra
JOIN      especialista      esp   ON esp.id_especialista = ip.id_especialista
JOIN      usuario           u_esp ON u_esp.id_usuario    = esp.id_especialista
LEFT JOIN foro              f     ON f.id_area           = (
                                        SELECT id_area
                                        FROM   especialista_area
                                        WHERE  id_especialista = ip.id_especialista
                                        LIMIT  1
                                    )
LEFT JOIN publicacion       pub   ON pub.id_foro         = f.id_foro
                                 AND pub.id_usuario      = reincid.id_paciente
ORDER BY  nombre_paciente, plan_tratamiento, pub.fecha;
