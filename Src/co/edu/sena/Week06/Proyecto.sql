-- ============================================
-- PROYECTO SEMANAL: Funciones de Agregación
-- Semana 06 — COUNT, SUM, AVG, GROUP BY, HAVING
-- ============================================
-- Dominio: Lavandería / Tintorería
-- Juan Esteban Soto Pérez — 3228973B
-- ============================================

-- ============================================
-- REPORTE 1: Totales globales
-- ============================================
-- Cuenta todas las órdenes y calcula el total
-- facturado y el precio promedio por orden

SELECT
    COUNT(*)        AS total_ordenes,
    SUM(p.price)    AS total_facturado,
    AVG(p.price)    AS precio_promedio
FROM orders o
JOIN garments g ON g.order_id = o.id
JOIN pricing p  ON p.garment_type = g.garment_type;


-- ============================================
-- REPORTE 2: Extremos
-- ============================================
-- Precio mínimo y máximo registrado en la tabla pricing

SELECT
    MIN(price) AS precio_minimo,
    MAX(price) AS precio_maximo
FROM pricing;


-- ============================================
-- REPORTE 3: Subtotales por categoría (GROUP BY)
-- ============================================
-- Prendas agrupadas por tipo: cuántas hay y cuánto
-- cuesta en promedio lavarlas

SELECT
    g.garment_type          AS tipo_prenda,
    COUNT(*)                AS total_prendas,
    AVG(p.price)            AS precio_promedio
FROM garments g
JOIN pricing p ON p.garment_type = g.garment_type
GROUP BY g.garment_type
ORDER BY total_prendas DESC;


-- ============================================
-- REPORTE 4: Filtro de grupos (HAVING)
-- ============================================
-- Clientes con más de 3 órdenes registradas
-- (clientes frecuentes)

SELECT
    c.name              AS cliente,
    COUNT(o.id)         AS total_ordenes
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.name
HAVING COUNT(o.id) > 3
ORDER BY total_ordenes DESC;