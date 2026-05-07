-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK
-- Dominio: Lavandería / Tintorería
-- Juan Esteban Soto Pérez — 3228973B
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

-- Tabla de categorías de servicio (lavar, planchar, teñir, etc.)
CREATE TABLE service_types (
    id   INTEGER PRIMARY KEY,
    name TEXT    NOT NULL UNIQUE
);

-- Tabla de precios por tipo de prenda y servicio
CREATE TABLE pricing (
    id              INTEGER PRIMARY KEY,
    garment_type    TEXT    NOT NULL,
    service_type_id INTEGER NOT NULL
        REFERENCES service_types(id) ON DELETE RESTRICT,
    price           REAL    NOT NULL CHECK (price > 0),
    UNIQUE (garment_type, service_type_id)
);

-- Tabla de clientes
CREATE TABLE customers (
    id    INTEGER PRIMARY KEY,
    name  TEXT    NOT NULL,
    phone TEXT    UNIQUE          -- puede ser NULL si no se registra
);

-- Tabla principal de órdenes
CREATE TABLE orders (
    id          INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL
        REFERENCES customers(id) ON DELETE RESTRICT,
    created_at  TEXT    NOT NULL DEFAULT (date('now')),
    status      TEXT    NOT NULL DEFAULT 'pendiente'
                        CHECK (status IN ('pendiente','listo','entregado'))
);

-- Tabla de prendas por orden
CREATE TABLE garments (
    id              INTEGER PRIMARY KEY,
    order_id        INTEGER NOT NULL
        REFERENCES orders(id) ON DELETE RESTRICT,
    garment_type    TEXT    NOT NULL,
    color           TEXT,           -- opcional: puede ser NULL
    notes           TEXT            -- observaciones opcionales
);


-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- ============================================

INSERT INTO service_types (id, name) VALUES
    (1, 'Lavado'),
    (2, 'Planchado'),
    (3, 'Tintorería');

INSERT INTO pricing (id, garment_type, service_type_id, price) VALUES
    (1, 'Camisa',   1, 5000),
    (2, 'Pantalón', 1, 7000),
    (3, 'Camisa',   2, 3000),
    (4, 'Vestido',  3, 15000),
    (5, 'Chaqueta', 1, 12000),
    (6, 'Corbata',  2, 4000);

INSERT INTO customers (id, name, phone) VALUES
    (1, 'Carlos Mendoza',  '3001234567'),
    (2, 'Laura Ríos',      NULL),          -- sin teléfono registrado
    (3, 'Pedro Salcedo',   '3119876543');

INSERT INTO orders (id, customer_id, status) VALUES
    (1, 1, 'entregado'),
    (2, 2, 'listo'),
    (3, 3, 'pendiente');

INSERT INTO garments (id, order_id, garment_type, color, notes) VALUES
    (1, 1, 'Camisa',   'blanco', 'mancha de café'),
    (2, 1, 'Pantalón', 'azul',   NULL),        -- sin observaciones
    (3, 2, 'Vestido',  NULL,     NULL),        -- color y notas NULL
    (4, 2, 'Chaqueta', 'negro',  'botón roto'),
    (5, 3, 'Corbata',  NULL,     'urgente'),   -- color NULL
    (6, 3, 'Camisa',   'gris',   NULL);        -- sin observaciones


-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- Prendas sin color registrado (color IS NULL)
SELECT id, garment_type
FROM   garments
WHERE  color IS NULL;

-- Todas las prendas mostrando color con COALESCE
SELECT
    garment_type,
    COALESCE(color, 'Sin color')   AS color_display,
    COALESCE(notes, 'Sin notas')   AS notas_display
FROM garments;

-- Clientes sin teléfono registrado
SELECT id, name
FROM   customers
WHERE  phone IS NULL;