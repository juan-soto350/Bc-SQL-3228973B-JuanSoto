-- ============================================
-- PROYECTO INTEGRADOR: Etapa 0 — Capstone
-- Semana 08 — DDL + DML + SELECT completo
-- Dominio: Lavandería / Tintorería
-- Juan Esteban Soto Pérez — 3228973B
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA (DDL)
-- ============================================

-- Tabla de referencia: tipos de servicio
CREATE TABLE service_types (
    id          INTEGER PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    description TEXT                        -- opcional
);

-- Tabla secundaria: catálogo de precios por prenda y servicio
CREATE TABLE pricing (
    id              INTEGER PRIMARY KEY,
    garment_type    TEXT    NOT NULL,
    service_type_id INTEGER NOT NULL
        REFERENCES service_types(id) ON DELETE RESTRICT,
    price           REAL    NOT NULL CHECK (price > 0),
    turnaround_days INTEGER NOT NULL DEFAULT 2
                            CHECK (turnaround_days >= 1),
    UNIQUE (garment_type, service_type_id)
);

-- Tabla principal: órdenes de clientes
CREATE TABLE orders (
    id              INTEGER PRIMARY KEY,
    customer_name   TEXT    NOT NULL,
    phone           TEXT    UNIQUE,             -- puede ser NULL
    garment_type    TEXT    NOT NULL,
    color           TEXT,                       -- puede ser NULL
    notes           TEXT,                       -- puede ser NULL
    status          TEXT    NOT NULL DEFAULT 'pendiente'
                            CHECK (status IN ('pendiente','listo','entregado','cancelado')),
    pricing_id      INTEGER NOT NULL
        REFERENCES pricing(id) ON DELETE RESTRICT,
    created_at      TEXT    NOT NULL DEFAULT (date('now')),
    is_active       INTEGER NOT NULL DEFAULT 1
                            CHECK (is_active IN (0, 1))
);


-- ============================================
-- PARTE 2: DATOS (DML)
-- ============================================

-- Tipos de servicio (tabla de referencia)
INSERT INTO service_types (id, name, description) VALUES
    (1, 'Lavado en seco',   'Limpieza sin agua con solventes'),
    (2, 'Lavado húmedo',    'Lavado tradicional con agua y jabón'),
    (3, 'Planchado',        'Solo planchado sin lavado'),
    (4, 'Tintorería',       'Teñido o cambio de color'),
    (5, 'Impermeabilizado', 'Tratamiento repelente de agua');

-- Catálogo de precios (tabla secundaria — 12 registros)
INSERT INTO pricing (id, garment_type, service_type_id, price, turnaround_days) VALUES
    (1,  'Camisa',    1,  8000,  2),
    (2,  'Camisa',    3,  4000,  1),
    (3,  'Pantalón',  1, 10000,  2),
    (4,  'Pantalón',  3,  5000,  1),
    (5,  'Vestido',   1, 18000,  3),
    (6,  'Vestido',   4, 25000,  5),
    (7,  'Chaqueta',  1, 15000,  3),
    (8,  'Chaqueta',  5, 20000,  4),
    (9,  'Corbata',   3,  4500,  1),
    (10, 'Abrigo',    1, 22000,  4),
    (11, 'Abrigo',    4, 30000,  6),
    (12, 'Sábana',    2,  9000,  2);

-- Órdenes de clientes (tabla principal — 30 registros)
-- Al menos 4 con phone NULL y varios con color/notes NULL
INSERT INTO orders (id, customer_name, phone, garment_type, color, notes, status, pricing_id) VALUES
    (1,  'Carlos Mendoza',    '3001234561', 'Camisa',   'blanco',  'mancha de café',    'entregado', 1),
    (2,  'Laura Ríos',        NULL,         'Vestido',  'rojo',    NULL,                'listo',     5),
    (3,  'Pedro Salcedo',     '3119876541', 'Pantalón', 'azul',    'cremallera rota',   'pendiente', 3),
    (4,  'Ana Gómez',         '3201234562', 'Chaqueta', NULL,      NULL,                'entregado', 7),
    (5,  'Mario Herrera',     NULL,         'Abrigo',   'gris',    'urgente',           'listo',     10),
    (6,  'Sofía Castro',      '3011234563', 'Corbata',  'negro',   NULL,                'entregado', 9),
    (7,  'Julián Torres',     '3121234564', 'Camisa',   'azul',    NULL,                'pendiente', 2),
    (8,  'Valentina Ruiz',    NULL,         'Sábana',   'blanco',  'manchas de humedad','listo',     12),
    (9,  'Diego Morales',     '3031234565', 'Vestido',  NULL,      'tela delicada',     'pendiente', 6),
    (10, 'Camila Peña',       '3141234566', 'Pantalón', 'gris',    NULL,                'entregado', 4),
    (11, 'Andrés Vargas',     '3051234567', 'Chaqueta', 'café',    'botón faltante',    'listo',     8),
    (12, 'Mariana López',     NULL,         'Abrigo',   'negro',   NULL,                'cancelado', 11),
    (13, 'Felipe Jiménez',    '3161234568', 'Camisa',   'blanco',  'cuello amarillento','entregado', 1),
    (14, 'Natalia Silva',     '3071234569', 'Corbata',  'azul',    NULL,                'pendiente', 9),
    (15, 'Sebastián Ríos',    '3181234570', 'Pantalón', 'negro',   'desgaste en rodilla','listo',    3),
    (16, 'Daniela Ortiz',     '3091234571', 'Vestido',  'verde',   NULL,                'entregado', 5),
    (17, 'Tomás Reyes',       '3201234572', 'Camisa',   'rosado',  NULL,                'pendiente', 2),
    (18, 'Isabella Mora',     '3011234573', 'Chaqueta', 'gris',    'forro dañado',      'listo',     7),
    (19, 'Mateo Suárez',      '3121234574', 'Sábana',   'beige',   NULL,                'entregado', 12),
    (20, 'Luciana Pardo',     '3031234575', 'Abrigo',   'azul',    'urgente',           'pendiente', 10),
    (21, 'Samuel Castro',     '3141234576', 'Pantalón', 'café',    NULL,                'entregado', 4),
    (22, 'Valeria Gómez',     '3051234577', 'Vestido',  'morado',  'bordado especial',  'listo',     6),
    (23, 'Emmanuel Torres',   '3161234578', 'Corbata',  'rojo',    NULL,                'entregado', 9),
    (24, 'Alejandra Herrera', '3071234579', 'Camisa',   'gris',    'manchas de tinta',  'pendiente', 1),
    (25, 'Nicolás Vargas',    '3181234580', 'Chaqueta', 'negro',   NULL,                'entregado', 8),
    (26, 'Sara Mendoza',      '3091234581', 'Abrigo',   'blanco',  'mancha de aceite',  'listo',     11),
    (27, 'David Ríos',        '3201234582', 'Sábana',   NULL,      NULL,                'pendiente', 12),
    (28, 'Gabriela Salcedo',  '3011234583', 'Pantalón', 'verde',   NULL,                'entregado', 3),
    (29, 'Simón Morales',     '3121234584', 'Vestido',  'blanco',  'urgente boda',      'listo',     5),
    (30, 'Paulina Peña',      '3031234585', 'Camisa',   'amarillo', NULL,               'pendiente', 2);


-- ============================================
-- PARTE 3: REPORTES (SELECT)
-- ============================================

-- REPORTE 1: Totales globales
-- Total de órdenes, suma y promedio de precios facturados
SELECT
    COUNT(*)        AS total_ordenes,
    SUM(p.price)    AS total_facturado,
    AVG(p.price)    AS precio_promedio
FROM orders o
JOIN pricing p ON p.id = o.pricing_id
WHERE o.is_active = 1;


-- REPORTE 2: Órdenes por tipo de servicio (GROUP BY)
-- Cuántas órdenes tiene cada servicio y su precio promedio
SELECT
    st.name             AS tipo_servicio,
    COUNT(o.id)         AS total_ordenes,
    AVG(p.price)        AS precio_promedio
FROM orders o
JOIN pricing p      ON p.id = o.pricing_id
JOIN service_types st ON st.id = p.service_type_id
WHERE o.is_active = 1
GROUP BY st.name
ORDER BY total_ordenes DESC;


-- REPORTE 3: Tipos de prenda con más de 4 órdenes (HAVING)
-- Detecta las prendas más solicitadas en el negocio
SELECT
    garment_type        AS tipo_prenda,
    COUNT(*)            AS total_ordenes
FROM orders
WHERE is_active = 1
GROUP BY garment_type
HAVING total_ordenes > 4
ORDER BY total_ordenes DESC;


-- REPORTE 4: Órdenes sin teléfono registrado (NULL + COALESCE)
-- Clientes que no dejaron contacto
SELECT
    customer_name,
    COALESCE(phone, 'Sin teléfono') AS contacto,
    COALESCE(notes, 'Sin notas')    AS observaciones,
    status
FROM orders
WHERE phone IS NULL;


-- REPORTE 5: Búsqueda combinada — órdenes activas de precio medio
-- Órdenes vigentes cuyo servicio cuesta entre $8.000 y $20.000
SELECT
    o.customer_name,
    o.garment_type,
    st.name     AS servicio,
    p.price     AS precio
FROM orders o
JOIN pricing p      ON p.id = o.pricing_id
JOIN service_types st ON st.id = p.service_type_id
WHERE p.price BETWEEN 8000 AND 20000
  AND o.is_active = 1
  AND o.status != 'cancelado'
ORDER BY p.price DESC
LIMIT 10;