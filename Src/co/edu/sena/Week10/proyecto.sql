-- ============================================
-- PROYECTO SEMANAL: SELF JOIN en tu dominio
-- Semana 10 — SELF JOIN
-- Dominio: Lavandería / Tintorería
-- ============================================

PRAGMA foreign_keys = ON;

-- ============================================
-- LIMPIEZA
-- ============================================

DROP TABLE IF EXISTS categorias_servicio;

-- ============================================
-- TABLA CON AUTO-REFERENCIA: categorías de servicio
-- Jerarquía: área general → servicio → variante
-- Ejemplo: Cuidado de prendas → Lavado → Lavado en seco
-- ============================================

CREATE TABLE categorias_servicio (
    id          INTEGER PRIMARY KEY,
    nombre      TEXT    NOT NULL UNIQUE,
    descripcion TEXT,
    parent_id   INTEGER REFERENCES categorias_servicio (id)
);

-- ============================================
-- DATOS: 3 niveles jerárquicos
-- Nivel 0 (raíz)   → parent_id = NULL  (áreas generales)
-- Nivel 1 (hijos)  → apuntan a una raíz
-- Nivel 2 (nietos) → apuntan a un nivel 1
-- ============================================

-- Nivel 0: raíces (sin padre)
INSERT INTO categorias_servicio (id, nombre, descripcion, parent_id) VALUES
(1,  'Cuidado de prendas',     'Área general de tratamiento de ropa',          NULL),
(2,  'Limpieza del hogar',     'Área general para textiles del hogar',         NULL),
(3,  'Servicios especiales',   'Área general para tratamientos especializados', NULL);

-- Nivel 1: hijos de las raíces
INSERT INTO categorias_servicio (id, nombre, descripcion, parent_id) VALUES
(4,  'Lavado',                 'Servicios de lavado con agua',                 1),
(5,  'Secado',                 'Servicios de secado posterior al lavado',      1),
(6,  'Planchado',              'Servicios de planchado y desdoblado',          1),
(7,  'Ropa de cama',           'Sábanas, cobijas y almohadas',                 2),
(8,  'Cortinas y tapetes',     'Cortinas, tapetes y alfombras',                2),
(9,  'Tintorería',             'Limpieza en seco con solventes',               3),
(10, 'Restauración',           'Recuperación de prendas dañadas',              3),
(11, 'Impermeabilización',     'Aplicación de tratamiento impermeable',        3);

-- Nivel 2: nietos (hijos del nivel 1)
INSERT INTO categorias_servicio (id, nombre, descripcion, parent_id) VALUES
(12, 'Lavado normal',           'Lavado estándar con detergente',              4),
(13, 'Lavado delicado',         'Ciclo suave para telas finas',                4),
(14, 'Lavado a mano',           'Lavado manual para prendas frágiles',         4),
(15, 'Secado al aire',          'Secado natural sin máquina',                  5),
(16, 'Secado a máquina',        'Secado rápido en secadora industrial',        5),
(17, 'Planchado a vapor',       'Planchado con vapor para arrugas profundas',  6),
(18, 'Planchado en frío',       'Planchado suave para telas delicadas',        6),
(19, 'Lavado de sábanas',       'Ciclo específico para ropa de cama',          7),
(20, 'Lavado de cobijas',       'Ciclo de alta capacidad para cobijas',        7),
(21, 'Lavado de cortinas',      'Ciclo delicado para cortinas',                8),
(22, 'Lavado de tapetes',       'Limpieza profunda de tapetes',                8),
(23, 'Tintorería básica',       'Limpieza en seco estándar',                   9),
(24, 'Tintorería premium',      'Limpieza en seco para prendas de lujo',       9),
(25, 'Reparación de costuras',  'Costura y remiendo de prendas',               10),
(26, 'Eliminación de manchas',  'Tratamiento químico para manchas difíciles',  10),
(27, 'Impermeabilización ligera','Spray impermeable para uso cotidiano',       11),
(28, 'Impermeabilización total', 'Tratamiento industrial completo',            11);


-- ============================================
-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Muestra cada categoría junto con su categoría padre.
-- Se excluyen las raíces porque no tienen padre.
-- ============================================

SELECT
    hijo.nombre     AS categoria,
    padre.nombre    AS categoria_padre
FROM categorias_servicio hijo
INNER JOIN categorias_servicio padre ON hijo.parent_id = padre.id
ORDER BY padre.nombre, hijo.nombre;


-- ============================================
-- CONSULTA 2: Incluir la raíz con LEFT JOIN + COALESCE
-- Muestra todas las categorías incluyendo las raíces.
-- COALESCE reemplaza NULL por la etiqueta 'Raíz'.
-- ============================================

SELECT
    hijo.nombre                       AS categoria,
    COALESCE(padre.nombre, 'Raíz')    AS categoria_padre
FROM categorias_servicio hijo
LEFT JOIN categorias_servicio padre ON hijo.parent_id = padre.id
ORDER BY categoria_padre, hijo.nombre;


-- ============================================
-- CONSULTA 3: Contar hijos directos por padre
-- Cuántas subcategorías tiene cada categoría padre.
-- Solo muestra las que tienen al menos un hijo (HAVING).
-- ============================================

SELECT
    padre.nombre        AS categoria_padre,
    COUNT(hijo.id)      AS total_subcategorias
FROM categorias_servicio padre
LEFT JOIN categorias_servicio hijo ON hijo.parent_id = padre.id
GROUP BY padre.id, padre.nombre
HAVING COUNT(hijo.id) > 0
ORDER BY total_subcategorias DESC;


-- ============================================
-- CONSULTA 4: Dos niveles jerárquicos (hijo → padre → abuelo)
-- Encadena tres aliases para navegar la jerarquía completa.
-- LEFT JOIN en cada nivel para no perder registros intermedios.
-- ============================================

SELECT
    hijo.nombre         AS subcategoria,
    padre.nombre        AS categoria,
    abuelo.nombre       AS area_general
FROM categorias_servicio hijo
LEFT JOIN categorias_servicio padre   ON hijo.parent_id  = padre.id
LEFT JOIN categorias_servicio abuelo  ON padre.parent_id = abuelo.id
ORDER BY abuelo.nombre, padre.nombre, hijo.nombre;
