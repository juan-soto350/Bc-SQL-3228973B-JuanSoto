-- ============================================
-- PROYECTO SEMANAL: Ranking con Window Functions
-- Semana 14 -- Window Functions (ROW_NUMBER, RANK, DENSE_RANK)
-- PostgreSQL 16
-- Dominio: Lavanderia / Tintoreria
-- ============================================

DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
    id   SERIAL PRIMARY KEY,
    name TEXT   NOT NULL
);

CREATE TABLE items (
    id          SERIAL         PRIMARY KEY,
    name        TEXT           NOT NULL,
    value       NUMERIC(10, 2) NOT NULL,  -- precio del servicio para esa prenda
    category_id INT            REFERENCES categories (id),
    is_active   BOOLEAN        NOT NULL DEFAULT TRUE
);

-- ============================================
-- DATOS: categorias de servicio
-- ============================================

INSERT INTO categories (id, name) VALUES
    (1, 'Lavado'),
    (2, 'Tintoreria'),
    (3, 'Planchado'),
    (4, 'Restauracion');

-- ============================================
-- DATOS: items (222 filas, con empates reales en value
-- y duplicados intencionales por name para el ejercicio de dedup)
-- ============================================

INSERT INTO items (id, name, value, category_id) VALUES
    (1, 'Pantalon de lana', 32000, 2),
    (2, 'Vestido de noche', 16000, 3),
    (3, 'Chaqueta de cuero', 45000, 4),
    (4, 'Traje completo', 7000, 1),
    (5, 'Blusa de seda', 24000, 2),
    (6, 'Jeans', 19000, 3),
    (7, 'Camisa casual', 31000, 4),
    (8, 'Falda plisada', 11000, 1),
    (9, 'Abrigo de lana', 22000, 2),
    (10, 'Corbata', 19000, 3),
    (11, 'Vestido casual', 35000, 4),
    (12, 'Pantalon de algodon', 7000, 1),
    (13, 'Sueter de lana', 24000, 2),
    (14, 'Camiseta deportiva', 18000, 3),
    (15, 'Bufanda de seda', 45000, 4),
    (16, 'Pantalon formal', 8000, 1),
    (17, 'Chaqueta de tela', 28000, 2),
    (18, 'Vestido de cocktail', 15000, 3),
    (19, 'Camisa de lino', 50000, 4),
    (20, 'Falda de cuero', 12000, 1),
    (21, 'Blazer', 22000, 2),
    (22, 'Pantalon de vestir', 19000, 3),
    (23, 'Camisa polo', 31000, 4),
    (24, 'Vestido largo', 9500, 1),
    (25, 'Abrigo largo', 22000, 2),
    (26, 'Pantalon deportivo', 19000, 3),
    (27, 'Camisa vaquera', 50000, 4),
    (28, 'Sueter fino', 12000, 1),
    (29, 'Vestido floral', 22000, 2),
    (30, 'Chaqueta impermeable', 16000, 3),
    (31, 'Pantalon cuero', 31000, 4),
    (32, 'Camisa manga larga', 9000, 1),
    (33, 'Falda midi', 30000, 2),
    (34, 'Traje sastre', 18000, 3),
    (35, 'Camiseta lisa', 35000, 4),
    (36, 'Pantalon de mezclilla', 8000, 1),
    (37, 'Vestido boho', 30000, 2),
    (38, 'Camisa hawaiana', 19000, 3),
    (39, 'Sueter cuello alto', 55000, 4),
    (40, 'Pantalon chino', 9000, 1),
    (41, 'Chaqueta de punto', 24000, 2),
    (42, 'Vestido recto', 19000, 3),
    (43, 'Camisa de rayas', 50000, 4),
    (44, 'Falda tubo', 9500, 1),
    (45, 'Blazer cruzado', 32000, 2),
    (46, 'Camisa formal', 15000, 3),
    (47, 'Pantalon de lana', 50000, 4),
    (48, 'Vestido de noche', 8000, 1),
    (49, 'Chaqueta de cuero', 22000, 2),
    (50, 'Traje completo', 19000, 3),
    (51, 'Blusa de seda', 35000, 4),
    (52, 'Jeans', 13000, 1),
    (53, 'Camisa casual', 35000, 2),
    (54, 'Falda plisada', 17000, 3),
    (55, 'Abrigo de lana', 45000, 4),
    (56, 'Corbata', 13000, 1),
    (57, 'Vestido casual', 32000, 2),
    (58, 'Pantalon de algodon', 17000, 3),
    (59, 'Sueter de lana', 35000, 4),
    (60, 'Camiseta deportiva', 9000, 1),
    (61, 'Bufanda de seda', 28000, 2),
    (62, 'Pantalon formal', 15000, 3),
    (63, 'Chaqueta de tela', 50000, 4),
    (64, 'Vestido de cocktail', 10000, 1),
    (65, 'Camisa de lino', 40000, 2),
    (66, 'Falda de cuero', 17000, 3),
    (67, 'Blazer', 55000, 4),
    (68, 'Pantalon de vestir', 13000, 1),
    (69, 'Camisa polo', 30000, 2),
    (70, 'Vestido largo', 19000, 3),
    (71, 'Abrigo largo', 31000, 4),
    (72, 'Pantalon deportivo', 8000, 1),
    (73, 'Camisa vaquera', 35000, 2),
    (74, 'Sueter fino', 16000, 3),
    (75, 'Vestido floral', 40000, 4),
    (76, 'Chaqueta impermeable', 9000, 1),
    (77, 'Pantalon cuero', 40000, 2),
    (78, 'Camisa manga larga', 18000, 3),
    (79, 'Falda midi', 31000, 4),
    (80, 'Traje sastre', 8000, 1),
    (81, 'Camiseta lisa', 32000, 2),
    (82, 'Pantalon de mezclilla', 17000, 3),
    (83, 'Vestido boho', 55000, 4),
    (84, 'Camisa hawaiana', 11000, 1),
    (85, 'Sueter cuello alto', 40000, 2),
    (86, 'Pantalon chino', 19000, 3),
    (87, 'Chaqueta de punto', 45000, 4),
    (88, 'Vestido recto', 8000, 1),
    (89, 'Camisa de rayas', 24000, 2),
    (90, 'Falda tubo', 17000, 3),
    (91, 'Blazer cruzado', 45000, 4),
    (92, 'Camisa formal', 8000, 1),
    (93, 'Pantalon de lana', 22000, 2),
    (94, 'Vestido de noche', 20000, 3),
    (95, 'Chaqueta de cuero', 55000, 4),
    (96, 'Traje completo', 10000, 1),
    (97, 'Blusa de seda', 40000, 2),
    (98, 'Jeans', 17000, 3),
    (99, 'Camisa casual', 55000, 4),
    (100, 'Falda plisada', 12000, 1),
    (101, 'Abrigo de lana', 32000, 2),
    (102, 'Corbata', 15000, 3),
    (103, 'Vestido casual', 45000, 4),
    (104, 'Pantalon de algodon', 11000, 1),
    (105, 'Sueter de lana', 26000, 2),
    (106, 'Camiseta deportiva', 19000, 3),
    (107, 'Bufanda de seda', 31000, 4),
    (108, 'Pantalon formal', 13000, 1),
    (109, 'Chaqueta de tela', 22000, 2),
    (110, 'Vestido de cocktail', 16000, 3),
    (111, 'Camisa de lino', 40000, 4),
    (112, 'Falda de cuero', 9000, 1),
    (113, 'Blazer', 28000, 2),
    (114, 'Pantalon de vestir', 18000, 3),
    (115, 'Camisa polo', 45000, 4),
    (116, 'Vestido largo', 13000, 1),
    (117, 'Abrigo largo', 24000, 2),
    (118, 'Pantalon deportivo', 16000, 3),
    (119, 'Camisa vaquera', 45000, 4),
    (120, 'Sueter fino', 12000, 1),
    (121, 'Vestido floral', 30000, 2),
    (122, 'Chaqueta impermeable', 16000, 3),
    (123, 'Pantalon cuero', 45000, 4),
    (124, 'Camisa manga larga', 10000, 1),
    (125, 'Falda midi', 35000, 2),
    (126, 'Traje sastre', 17000, 3),
    (127, 'Camiseta lisa', 55000, 4),
    (128, 'Pantalon de mezclilla', 12000, 1),
    (129, 'Vestido boho', 28000, 2),
    (130, 'Camisa hawaiana', 16000, 3),
    (131, 'Sueter cuello alto', 31000, 4),
    (132, 'Pantalon chino', 9000, 1),
    (133, 'Chaqueta de punto', 26000, 2),
    (134, 'Vestido recto', 16000, 3),
    (135, 'Camisa de rayas', 55000, 4),
    (136, 'Falda tubo', 9500, 1),
    (137, 'Blazer cruzado', 22000, 2),
    (138, 'Camisa formal', 18000, 3),
    (139, 'Pantalon de lana', 50000, 4),
    (140, 'Vestido de noche', 9000, 1),
    (141, 'Chaqueta de cuero', 30000, 2),
    (142, 'Traje completo', 17000, 3),
    (143, 'Blusa de seda', 31000, 4),
    (144, 'Jeans', 9000, 1),
    (145, 'Camisa casual', 35000, 2),
    (146, 'Falda plisada', 19000, 3),
    (147, 'Abrigo de lana', 40000, 4),
    (148, 'Corbata', 11000, 1),
    (149, 'Vestido casual', 26000, 2),
    (150, 'Pantalon de algodon', 20000, 3),
    (151, 'Sueter de lana', 50000, 4),
    (152, 'Camiseta deportiva', 7000, 1),
    (153, 'Bufanda de seda', 40000, 2),
    (154, 'Pantalon formal', 20000, 3),
    (155, 'Chaqueta de tela', 50000, 4),
    (156, 'Vestido de cocktail', 12000, 1),
    (157, 'Camisa de lino', 35000, 2),
    (158, 'Falda de cuero', 18000, 3),
    (159, 'Blazer', 45000, 4),
    (160, 'Pantalon de vestir', 8000, 1),
    (161, 'Camisa polo', 40000, 2),
    (162, 'Vestido largo', 20000, 3),
    (163, 'Abrigo largo', 45000, 4),
    (164, 'Pantalon deportivo', 7000, 1),
    (165, 'Camisa vaquera', 28000, 2),
    (166, 'Sueter fino', 15000, 3),
    (167, 'Vestido floral', 35000, 4),
    (168, 'Chaqueta impermeable', 13000, 1),
    (169, 'Pantalon cuero', 26000, 2),
    (170, 'Camisa manga larga', 15000, 3),
    (171, 'Falda midi', 40000, 4),
    (172, 'Traje sastre', 7000, 1),
    (173, 'Camiseta lisa', 24000, 2),
    (174, 'Pantalon de mezclilla', 15000, 3),
    (175, 'Vestido boho', 50000, 4),
    (176, 'Camisa hawaiana', 9000, 1),
    (177, 'Sueter cuello alto', 24000, 2),
    (178, 'Pantalon chino', 17000, 3),
    (179, 'Chaqueta de punto', 50000, 4),
    (180, 'Vestido recto', 7000, 1),
    (181, 'Camisa de rayas', 24000, 2),
    (182, 'Falda tubo', 16000, 3),
    (183, 'Blazer cruzado', 50000, 4),
    (184, 'Camisa formal', 12000, 1),
    (185, 'Pantalon de lana', 26000, 2),
    (186, 'Vestido de noche', 20000, 3),
    (187, 'Chaqueta de cuero', 40000, 4),
    (188, 'Traje completo', 11000, 1),
    (189, 'Blusa de seda', 32000, 2),
    (190, 'Jeans', 18000, 3),
    (191, 'Camisa casual', 31000, 4),
    (192, 'Falda plisada', 8000, 1),
    (193, 'Abrigo de lana', 40000, 2),
    (194, 'Corbata', 18000, 3),
    (195, 'Vestido casual', 45000, 4),
    (196, 'Pantalon de algodon', 13000, 1),
    (197, 'Sueter de lana', 30000, 2),
    (198, 'Camiseta deportiva', 15000, 3),
    (199, 'Bufanda de seda', 35000, 4),
    (200, 'Pantalon formal', 8000, 1),
    (201, 'Chaqueta de tela', 32000, 2),
    (202, 'Vestido de cocktail', 20000, 3),
    (203, 'Camisa de lino', 40000, 4),
    (204, 'Falda de cuero', 13000, 1),
    (205, 'Blazer', 26000, 2),
    (206, 'Pantalon de vestir', 19000, 3),
    (207, 'Camisa polo', 31000, 4),
    (208, 'Vestido largo', 9500, 1),
    (209, 'Abrigo largo', 32000, 2),
    (210, 'Pantalon deportivo', 16000, 3),
    (211, 'Falda tubo', 19000, 3),
    (212, 'Falda tubo', 17000, 3),
    (213, 'Traje sastre', 32000, 2),
    (214, 'Traje sastre', 28000, 2),
    (215, 'Pantalon de lana', 20000, 3),
    (216, 'Pantalon de lana', 16000, 3),
    (217, 'Falda midi', 28000, 2),
    (218, 'Falda midi', 35000, 2),
    (219, 'Camisa de lino', 28000, 2),
    (220, 'Camisa de lino', 40000, 2),
    (221, 'Blusa de seda', 20000, 3),
    (222, 'Blusa de seda', 15000, 3);


-- ============================================
-- TODO 1: Eliminar duplicados con ROW_NUMBER()
-- ============================================
-- Algunos items se repiten por nombre (la misma prenda registrada
-- mas de una vez por error). Usamos ROW_NUMBER() particionado por
-- name y ordenado por id para quedarnos con el primer registro
-- de cada nombre duplicado.
-- ============================================

WITH items_numerados AS (
    SELECT
        id,
        name,
        value,
        category_id,
        ROW_NUMBER() OVER (PARTITION BY name ORDER BY id) AS rn
    FROM items
)
SELECT
    id,
    name,
    value,
    category_id
FROM items_numerados
WHERE rn = 1
ORDER BY id;


-- ============================================
-- TODO 2: RANK y DENSE_RANK por categoria
-- ============================================
-- Clasifica cada item por su precio (value) dentro de su categoria.
-- RANK() deja huecos en la numeracion cuando hay empates.
-- DENSE_RANK() no deja huecos, asignando el mismo numero a los empates
-- y continuando consecutivamente con el siguiente valor distinto.
-- ============================================

SELECT
    name,
    value,
    category_id,
    RANK()       OVER (PARTITION BY category_id ORDER BY value DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY value DESC) AS dense_rnk
FROM items
ORDER BY category_id, rnk;


-- ============================================
-- TODO 3: Top-2 por categoria con CTE
-- ============================================
-- El CTE calcula el DENSE_RANK de cada item segun su precio,
-- agrupado por categoria. La consulta exterior filtra solo
-- los que quedan en las dos posiciones mas altas (dense_rnk <= 2),
-- incluyendo todos los empates en esa posicion.
-- ============================================

WITH ranking_categoria AS (
    SELECT
        name,
        value,
        category_id,
        DENSE_RANK() OVER (PARTITION BY category_id ORDER BY value DESC) AS dense_rnk
    FROM items
)
SELECT
    name,
    value,
    category_id,
    dense_rnk
FROM ranking_categoria
WHERE dense_rnk <= 2
ORDER BY category_id, dense_rnk;
