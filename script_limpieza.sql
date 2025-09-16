-- Analisis Exploratorio y Limpieza de la base de datos TELECOM_BASE
USE telecom_base;

-- TABLA CANALES DE VENTA 
SELECT *
FROM dim_canales_venta;

SELECT COUNT(*)
FROM dim_canales_venta;

SELECT 	canal_nombre,
         COUNT(canal_nombre) as cantidad
FROM dim_canales_venta
GROUP BY canal_nombre
ORDER BY cantidad;
-- Detectamos 31 tiendas (nombre_almacen) de las cuales 5 pertenecen a tiendas_express, 5 pertenecen a kiosco y 21 pertenecen a tiendas.
-- La region se determino con la administracion que sera EJE CAFETERO. 

-- TABLA CONSULTORES 
SELECT *
FROM dim_consultores;
-- Detectamos 124 filas 

SELECT *
FROM dim_consultores
WHERE id_consultor IN(1741,1307);
-- Detectamos dos ID diferentes para una misma persona:
-- id 1307: Akveh Villa Beltran y 1741: Akveh  Villa Beltran
-- NOTA APARTE: Puede ser que este mismo consultor trabaje para dos canales de venta diferente. 


SELECT count(*)
FROM dim_consultores
WHERE id_canal IS NULL;
-- Detectamos 20 valores nulos, la administracion nos confirmo que hubo un error en la copilacion de la tabla de asesores y por problemas tecnicos
-- hay un cruce de informacion entre Asesores y Supervisores. Procedemos a eliminar los valores NULOS. 

DELETE
FROM dim_consultores
WHERE id_canal IS NULL;
-- Corregimos y validamos: OKEY
-- Finalmente tenemos una tabla de 104 filas

SELECT nombre_consultor
FROM dim_consultores
WHERE nombre_consultor LIKE '%?%';
-- Detectamos 4 mal formateados 
-- 1. Yury Tatiana Londo?o Vargas
-- 2. Carolina Mu?oz Gomez
-- 3. Susan Yady Casta?eda Pinto
-- 4.Yessid Oliveros Londo?o

UPDATE dim_consultores
SET nombre_consultor = REPLACE(nombre_consultor, '?','ñ');
-- Corregimos y validamos: OKEY

SELECT id_consultor, nombre_consultor
FROM dim_consultores
WHERE nombre_consultor LIKE '%n%';

SELECT id_consultor, nombre_consultor
FROM dim_consultores
WHERE nombre_consultor LIKE '%Munoz%';

SELECT id_consultor, nombre_consultor
FROM dim_consultores
WHERE id_consultor IN (1253,1341,1886,1677,1361);
-- Detectamos errores de formateo en otros nombres(en vez de una n tendria que ir una ñ)
-- 1.Dany Alexander Londono Robledo
-- 2.Diana Caterine Nino Barbosa
-- 3.Ana Liliana Munoz Perdomo
-- 4.Juan Manuel Abonce Munoz
-- 5.Paulo Cesar Cortes Munoz

UPDATE dim_consultores
SET nombre_consultor = REPLACE(nombre_consultor, 'Munoz','Muñoz');
-- Corregimos y validamos en primer lugar los apellidos Muñoz. 

UPDATE dim_consultores
SET nombre_consultor = REPLACE(nombre_consultor, 'Londono','Londoño');

UPDATE dim_consultores
SET nombre_consultor = REPLACE(nombre_consultor, 'Nino','Niño');
-- Corregimos y validamos el resto de los Apellidos: okey 

SELECT id_consultor, nombre_consultor
FROM dim_consultores
WHERE id_consultor = 1073;
-- Detetamos un nombre sin espacios, stakeholder nos confirman que esta todo bien. 

-- TABLA DE OPERADORES 
SELECT *
FROM dim_operadores;


SELECT COUNT(*)
FROM dim_operadores;
-- Detectamos 12

SELECT *
FROM dim_operadores
WHERE operador='';
-- ID Nro 20301 esta en blanco y la
-- administracion nos solicito nombrarlo como ADDS NUEVA 

UPDATE dim_operadores
SET operador = 'ADDS NUEVA'
WHERE operador = '';

SELECT *
FROM dim_operadores;
-- Corregimos y validamos: okey 

-- TABLA PLANES
SELECT *
FROM dim_planes;
-- Detectamos 11 filas 

SELECT p.id_plan, 
	   t.id_transaccion
FROM dim_planes p 
LEFT JOIN fact_transacciones t ON p.id_plan = t.id_plan
WHERE p.id_plan IN(1,11);
-- ID 1 Y 11 No existen transacciones con estos ID,
-- administracion nos autorizo a eliminarlos

DELETE
FROM dim_planes
WHERE id_plan IN(1,11);
-- Corregimos y validamos: okey obteniendo solo 9 planes
-- en los que la administracion quiere que enfoquemos el analisis 

SELECT tipo_servicio,
       COUNT(*) as totalidad_planes
FROM dim_planes
GROUP BY tipo_servicio
ORDER BY totalidad_planes DESC;
-- Mobile: 5 y B2B: 4

SELECT tipo_servicio, nombre_plan
FROM dim_planes
WHERE tipo_servicio = 'Mobile'
GROUP BY tipo_servicio, nombre_plan;

SELECT tipo_servicio, nombre_plan
FROM dim_planes
WHERE tipo_servicio = 'B2B'
GROUP BY tipo_servicio, nombre_plan;       
-- Corroboramos que planes contiene 
-- cada tipo de servicio


-- TABLA DE TRANSACCIONES
SELECT *
FROM fact_transacciones;

ALTER TABLE fact_transacciones
MODIFY cantidad INT;

SELECT COUNT(*)
FROM fact_transacciones;
-- 7019 transacciones

SELECT *
FROM fact_transacciones
ORDER BY anio ASC,
         mes ASC,
         dia ASC;

-- Ordenamos cronologicamnete la tabla de transacciones

SELECT estado, 
       COUNT(estado) AS tipos
FROM fact_transacciones
GROUP BY estado
ORDER BY tipos DESC;
-- Detectamos:
-- activo: 6709
-- Termination: 275 (cancelacion del servicio que resta a las ventas totales del mes)
-- One-Way Block: 30 (venta del mes anterior con un mes de mora, no han pagado)
-- Two-Way Block: 5 (dos meses sin pagar)

-- Moficamos el tipo de dato de las columnas mencionadas a continuacion
ALTER TABLE fact_transacciones
MODIFY revenue INT;

ALTER TABLE fact_transacciones
MODIFY plan_revenue INT;

-- FIN SCRIPT DE LIMPIEZA
































