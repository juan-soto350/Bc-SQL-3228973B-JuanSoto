-- ============================================
-- PROYECTO SEMANAL: Jerarquias con CTEs Recursivas
-- Semana 13 -- WITH RECURSIVE
-- PostgreSQL 16
-- Dominio: Lavanderia / Tintoreria
-- ============================================

-- ============================================
-- LIMPIEZA
-- ============================================

DROP TABLE IF EXISTS nodes CASCADE;

-- ============================================
-- TABLA AUTO-REFERENCIAL: estructura de servicios
-- Jerarquia: Area -> Linea de servicio -> Servicio especifico
-- ============================================

CREATE TABLE nodes (
    id        SERIAL PRIMARY KEY,
    name      TEXT   NOT NULL,
    parent_id INT    REFERENCES nodes (id)
);

-- ============================================
-- DATOS: 205 filas en 3 niveles
-- Nivel 1: areas generales (parent_id = NULL)
-- Nivel 2: lineas de servicio (apuntan a un area)
-- Nivel 3: servicios especificos (apuntan a una linea)
-- ============================================

INSERT INTO nodes (id, name, parent_id) VALUES
(1, 'Cuidado de prendas', NULL),
(2, 'Limpieza del hogar', NULL),
(3, 'Servicios especiales', NULL),
(4, 'Atencion al cliente', NULL),
(5, 'Logistica y entregas', NULL),
(6, 'Lavado', 1),
(7, 'Secado', 1),
(8, 'Planchado', 1),
(9, 'Doblado', 1),
(10, 'Ropa de cama', 2),
(11, 'Cortinas y tapetes', 2),
(12, 'Tapiceria', 2),
(13, 'Tintoreria', 3),
(14, 'Restauracion', 3),
(15, 'Impermeabilizacion', 3),
(16, 'Recepcion', 4),
(17, 'Reclamos', 4),
(18, 'Facturacion', 4),
(19, 'Recogida a domicilio', 5),
(20, 'Entrega a domicilio', 5),
(21, 'Rutas', 5),
(22, 'Lavado estandar #1', 6),
(23, 'Secado estandar #2', 7),
(24, 'Planchado estandar #3', 8),
(25, 'Doblado estandar #4', 9),
(26, 'Ropa de cama estandar #5', 10),
(27, 'Cortinas y tapetes estandar #6', 11),
(28, 'Tapiceria estandar #7', 12),
(29, 'Tintoreria estandar #8', 13),
(30, 'Restauracion estandar #9', 14),
(31, 'Impermeabilizacion estandar #10', 15),
(32, 'Recepcion estandar #11', 16),
(33, 'Reclamos estandar #12', 17),
(34, 'Facturacion estandar #13', 18),
(35, 'Recogida a domicilio estandar #14', 19),
(36, 'Entrega a domicilio estandar #15', 20),
(37, 'Rutas estandar #16', 21),
(38, 'Lavado express #17', 6),
(39, 'Secado express #18', 7),
(40, 'Planchado express #19', 8),
(41, 'Doblado express #20', 9),
(42, 'Ropa de cama express #21', 10),
(43, 'Cortinas y tapetes express #22', 11),
(44, 'Tapiceria express #23', 12),
(45, 'Tintoreria express #24', 13),
(46, 'Restauracion express #25', 14),
(47, 'Impermeabilizacion express #26', 15),
(48, 'Recepcion express #27', 16),
(49, 'Reclamos express #28', 17),
(50, 'Facturacion express #29', 18),
(51, 'Recogida a domicilio express #30', 19),
(52, 'Entrega a domicilio express #31', 20),
(53, 'Rutas express #32', 21),
(54, 'Lavado premium #33', 6),
(55, 'Secado premium #34', 7),
(56, 'Planchado premium #35', 8),
(57, 'Doblado premium #36', 9),
(58, 'Ropa de cama premium #37', 10),
(59, 'Cortinas y tapetes premium #38', 11),
(60, 'Tapiceria premium #39', 12),
(61, 'Tintoreria premium #40', 13),
(62, 'Restauracion premium #41', 14),
(63, 'Impermeabilizacion premium #42', 15),
(64, 'Recepcion premium #43', 16),
(65, 'Reclamos premium #44', 17),
(66, 'Facturacion premium #45', 18),
(67, 'Recogida a domicilio premium #46', 19),
(68, 'Entrega a domicilio premium #47', 20),
(69, 'Rutas premium #48', 21),
(70, 'Lavado delicado #49', 6),
(71, 'Secado delicado #50', 7),
(72, 'Planchado delicado #51', 8),
(73, 'Doblado delicado #52', 9),
(74, 'Ropa de cama delicado #53', 10),
(75, 'Cortinas y tapetes delicado #54', 11),
(76, 'Tapiceria delicado #55', 12),
(77, 'Tintoreria delicado #56', 13),
(78, 'Restauracion delicado #57', 14),
(79, 'Impermeabilizacion delicado #58', 15),
(80, 'Recepcion delicado #59', 16),
(81, 'Reclamos delicado #60', 17),
(82, 'Facturacion delicado #61', 18),
(83, 'Recogida a domicilio delicado #62', 19),
(84, 'Entrega a domicilio delicado #63', 20),
(85, 'Rutas delicado #64', 21),
(86, 'Lavado industrial #65', 6),
(87, 'Secado industrial #66', 7),
(88, 'Planchado industrial #67', 8),
(89, 'Doblado industrial #68', 9),
(90, 'Ropa de cama industrial #69', 10),
(91, 'Cortinas y tapetes industrial #70', 11),
(92, 'Tapiceria industrial #71', 12),
(93, 'Tintoreria industrial #72', 13),
(94, 'Restauracion industrial #73', 14),
(95, 'Impermeabilizacion industrial #74', 15),
(96, 'Recepcion industrial #75', 16),
(97, 'Reclamos industrial #76', 17),
(98, 'Facturacion industrial #77', 18),
(99, 'Recogida a domicilio industrial #78', 19),
(100, 'Entrega a domicilio industrial #79', 20),
(101, 'Rutas industrial #80', 21),
(102, 'Lavado estacional #81', 6),
(103, 'Secado estacional #82', 7),
(104, 'Planchado estacional #83', 8),
(105, 'Doblado estacional #84', 9),
(106, 'Ropa de cama estacional #85', 10),
(107, 'Cortinas y tapetes estacional #86', 11),
(108, 'Tapiceria estacional #87', 12),
(109, 'Tintoreria estacional #88', 13),
(110, 'Restauracion estacional #89', 14),
(111, 'Impermeabilizacion estacional #90', 15),
(112, 'Recepcion estacional #91', 16),
(113, 'Reclamos estacional #92', 17),
(114, 'Facturacion estacional #93', 18),
(115, 'Recogida a domicilio estacional #94', 19),
(116, 'Entrega a domicilio estacional #95', 20),
(117, 'Rutas estacional #96', 21),
(118, 'Lavado estandar plus #97', 6),
(119, 'Secado estandar plus #98', 7),
(120, 'Planchado estandar plus #99', 8),
(121, 'Doblado estandar plus #100', 9),
(122, 'Ropa de cama estandar plus #101', 10),
(123, 'Cortinas y tapetes estandar plus #102', 11),
(124, 'Tapiceria estandar plus #103', 12),
(125, 'Tintoreria estandar plus #104', 13),
(126, 'Restauracion estandar plus #105', 14),
(127, 'Impermeabilizacion estandar plus #106', 15),
(128, 'Recepcion estandar plus #107', 16),
(129, 'Reclamos estandar plus #108', 17),
(130, 'Facturacion estandar plus #109', 18),
(131, 'Recogida a domicilio estandar plus #110', 19),
(132, 'Entrega a domicilio estandar plus #111', 20),
(133, 'Rutas estandar plus #112', 21),
(134, 'Lavado economico #113', 6),
(135, 'Secado economico #114', 7),
(136, 'Planchado economico #115', 8),
(137, 'Doblado economico #116', 9),
(138, 'Ropa de cama economico #117', 10),
(139, 'Cortinas y tapetes economico #118', 11),
(140, 'Tapiceria economico #119', 12),
(141, 'Tintoreria economico #120', 13),
(142, 'Restauracion economico #121', 14),
(143, 'Impermeabilizacion economico #122', 15),
(144, 'Recepcion economico #123', 16),
(145, 'Reclamos economico #124', 17),
(146, 'Facturacion economico #125', 18),
(147, 'Recogida a domicilio economico #126', 19),
(148, 'Entrega a domicilio economico #127', 20),
(149, 'Rutas economico #128', 21),
(150, 'Lavado rapido #129', 6),
(151, 'Secado rapido #130', 7),
(152, 'Planchado rapido #131', 8),
(153, 'Doblado rapido #132', 9),
(154, 'Ropa de cama rapido #133', 10),
(155, 'Cortinas y tapetes rapido #134', 11),
(156, 'Tapiceria rapido #135', 12),
(157, 'Tintoreria rapido #136', 13),
(158, 'Restauracion rapido #137', 14),
(159, 'Impermeabilizacion rapido #138', 15),
(160, 'Recepcion rapido #139', 16),
(161, 'Reclamos rapido #140', 17),
(162, 'Facturacion rapido #141', 18),
(163, 'Recogida a domicilio rapido #142', 19),
(164, 'Entrega a domicilio rapido #143', 20),
(165, 'Rutas rapido #144', 21),
(166, 'Lavado completo #145', 6),
(167, 'Secado completo #146', 7),
(168, 'Planchado completo #147', 8),
(169, 'Doblado completo #148', 9),
(170, 'Ropa de cama completo #149', 10),
(171, 'Cortinas y tapetes completo #150', 11),
(172, 'Tapiceria completo #151', 12),
(173, 'Tintoreria completo #152', 13),
(174, 'Restauracion completo #153', 14),
(175, 'Impermeabilizacion completo #154', 15),
(176, 'Recepcion completo #155', 16),
(177, 'Reclamos completo #156', 17),
(178, 'Facturacion completo #157', 18),
(179, 'Recogida a domicilio completo #158', 19),
(180, 'Entrega a domicilio completo #159', 20),
(181, 'Rutas completo #160', 21),
(182, 'Lavado nocturno #161', 6),
(183, 'Secado nocturno #162', 7),
(184, 'Planchado nocturno #163', 8),
(185, 'Doblado nocturno #164', 9),
(186, 'Ropa de cama nocturno #165', 10),
(187, 'Cortinas y tapetes nocturno #166', 11),
(188, 'Tapiceria nocturno #167', 12),
(189, 'Tintoreria nocturno #168', 13),
(190, 'Restauracion nocturno #169', 14),
(191, 'Impermeabilizacion nocturno #170', 15),
(192, 'Recepcion nocturno #171', 16),
(193, 'Reclamos nocturno #172', 17),
(194, 'Facturacion nocturno #173', 18),
(195, 'Recogida a domicilio nocturno #174', 19),
(196, 'Entrega a domicilio nocturno #175', 20),
(197, 'Rutas nocturno #176', 21),
(198, 'Lavado fin de semana #177', 6),
(199, 'Secado fin de semana #178', 7),
(200, 'Planchado fin de semana #179', 8),
(201, 'Doblado fin de semana #180', 9),
(202, 'Ropa de cama fin de semana #181', 10),
(203, 'Cortinas y tapetes fin de semana #182', 11),
(204, 'Tapiceria fin de semana #183', 12),
(205, 'Tintoreria fin de semana #184', 13);


-- ============================================
-- CONSULTA 1: Arbol completo con depth y path
-- Caso base: nodos raiz (areas, parent_id IS NULL).
-- Caso recursivo: cada nodo hijo se une con su padre en la CTE,
-- incrementando depth y concatenando el path.
-- ============================================

WITH RECURSIVE arbol AS (
    -- Caso base: nodos raiz
    SELECT
        id,
        name,
        parent_id,
        1        AS depth,
        name     AS path
    FROM nodes
    WHERE parent_id IS NULL

    UNION ALL

    -- Caso recursivo: nodos hijo
    SELECT
        n.id,
        n.name,
        n.parent_id,
        a.depth + 1,
        a.path || ' > ' || n.name
    FROM nodes n
    INNER JOIN arbol a ON n.parent_id = a.id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || name AS indented_name,
    path
FROM arbol
ORDER BY path;


-- ============================================
-- CONSULTA 2: Nodos de un nivel especifico
-- Reutiliza la misma CTE recursiva y filtra depth = 2,
-- es decir, las lineas de servicio (nivel intermedio).
-- ============================================

WITH RECURSIVE arbol AS (
    SELECT id, name, parent_id, 1 AS depth, name AS path
    FROM nodes
    WHERE parent_id IS NULL
    UNION ALL
    SELECT n.id, n.name, n.parent_id, a.depth + 1, a.path || ' > ' || n.name
    FROM nodes n
    INNER JOIN arbol a ON n.parent_id = a.id
)
SELECT name, depth, path
FROM arbol
WHERE depth = 2
ORDER BY path;


-- ============================================
-- CONSULTA 3: Hojas del arbol (nodos sin hijos)
-- Un nodo es hoja si ningun otro nodo tiene su id como parent_id.
-- En este dominio, las hojas son los servicios especificos finales.
-- ============================================

SELECT
    n.id,
    n.name
FROM nodes n
WHERE NOT EXISTS (
    SELECT 1
    FROM nodes child
    WHERE child.parent_id = n.id
)
ORDER BY n.name;
