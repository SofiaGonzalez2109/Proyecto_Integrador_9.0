-- Analisis Estadistico Descriptivo de la base de datos TELECOM
USE telecom_base;

-- A. Rentabilidad y Estrategia de Producto
-- Rendimiento por planes:

-- 1. Requerimos saber el volumen de venta e ingresos generados de los planes según su tipo de servicio.  
SELECT p.id_plan,
       p.nombre_plan,
       p.tipo_servicio,
       SUM(t.cantidad) as cantidad_total,
       FORMAT(SUM(t.revenue),2) as ingresos_totales 
FROM dim_planes p 
LEFT JOIN fact_transacciones t ON p.id_plan = t.id_plan
GROUP BY p.id_plan, p.nombre_plan, p.tipo_servicio
ORDER BY cantidad_total, ingresos_totales ASC;

-- 2. ¿Cómo se distribuyen los ingresos y la cantidad de transacciones entre los diferentes tipos de servicio como Mobile y B2B?
SELECT
    p.tipo_servicio,
    FORMAT(SUM(t.revenue),2) AS ingresos_totales,
    COUNT(t.id_transaccion) AS cantidad_transacciones,
    SUM(t.cantidad) AS total_planes_vendidos
FROM dim_planes p
LEFT JOIN fact_transacciones t ON p.id_plan = t.id_plan
GROUP BY p.tipo_servicio
ORDER BY ingresos_totales DESC;

-- 2A.Cual es el valor promedio de cada transaccion para Mobile y B2B?
SELECT FORMAT(AVG(t.revenue),2) as valor_promedio,
       P.tipo_servicio
FROM dim_planes p
LEFT JOIN fact_transacciones t ON p.id_plan = t.id_plan
GROUP BY tipo_servicio
ORDER BY valor_promedio;

-- 4. Cual es el valor MAX y MIN del servicio B2B y Mobile? 
-- Valor Maximo y Minimo B2B
SELECT p.tipo_servicio,
       MAX(t.plan_revenue) as valor_maximo
FROM fact_transacciones t
JOIN dim_planes p ON t.id_plan = p.id_plan
WHERE p.tipo_servicio = 'B2B';

SELECT p.tipo_servicio,
       MIN(t.plan_revenue) as valor_maximo
FROM fact_transacciones t
JOIN dim_planes p ON t.id_plan = p.id_plan
WHERE p.tipo_servicio = 'B2B';

-- Valor Maximo y Minimo Mobile 
SELECT p.tipo_servicio,
	   MAX(t.plan_revenue) as valor_maximo,
       p.nombre_plan
from fact_transacciones t
LEFT JOIN dim_planes p ON t.id_plan = p.id_plan
where p.tipo_servicio = 'Mobile'
group by p.tipo_servicio, p.nombre_plan
order by valor_maximo;

SELECT p.tipo_servicio,
	   MIN(t.plan_revenue) as valor_minimo,
       p.nombre_plan
from fact_transacciones t
LEFT JOIN dim_planes p ON t.id_plan = p.id_plan
where p.tipo_servicio = 'Mobile'
group by p.tipo_servicio, p.nombre_plan
order by valor_minimo;

-- 5. ¿Qué planes específicos son los más rentables dentro de cada tipo de servicio?
SELECT
    p.tipo_servicio,
    p.nombre_plan,
    FORMAT(SUM(t.revenue),2) AS ingresos_totales,
    SUM(t.cantidad) AS ventas_totales
FROM dim_planes AS p
JOIN fact_transacciones AS t ON p.id_plan = t.id_plan
GROUP BY p.tipo_servicio, p.nombre_plan
ORDER BY p.tipo_servicio, ingresos_totales DESC;

-- 5.A En base a la pregunta anterior, cual es la relacion entre ingresos totales y ventas totales por plan? 
SELECT
    p.tipo_servicio,
    p.nombre_plan,
    FORMAT(((SUM(t.revenue)) / (SUM(t.cantidad))),2) AS relacion 
FROM dim_planes AS p
JOIN fact_transacciones AS t ON p.id_plan = t.id_plan
GROUP BY p.tipo_servicio, p.nombre_plan
ORDER BY relacion DESC;

-- 6. Teniendo en cuenta el nombre del plan, ¿Qué consultores están llevando las ventas del servicio B2B? 
SELECT
    dc.nombre_consultor,
    dp.tipo_servicio,
    dp.nombre_plan,
    dcv.canal_nombre,
    FORMAT(SUM(ft.revenue),2) AS ingresos_totales,
    COUNT(ft.id_transaccion) AS ventas_totales,
    SUM(ft.cantidad) AS cantidad_vendida
FROM fact_transacciones AS ft
JOIN dim_planes AS dp ON ft.id_plan = dp.id_plan
JOIN dim_consultores AS dc ON ft.id_consultor = dc.id_consultor
JOIN dim_canales_venta AS dcv ON dc.id_canal = dcv.id_canal
WHERE dp.tipo_servicio = 'B2B'
GROUP BY dc.nombre_consultor, dcv.canal_nombre, dp.tipo_servicio, dp.nombre_plan
ORDER BY ingresos_totales DESC;

SELECT t.*, 
	    p.nombre_plan
FROM fact_transacciones t
LEFT JOIN dim_planes p ON t.id_plan = p.id_plan
WHERE nombre_plan = 'PLAN XL';

-- 7. Hay canales más efectivos para vender planes B2B que para Mobile?
SELECT 
    dcv.canal_nombre,
    dp.tipo_servicio,
    FORMAT(SUM(ft.revenue),2) AS ingresos_totales,
    COUNT(ft.id_transaccion) AS cantidad_transacciones
FROM fact_transacciones AS ft
JOIN dim_planes AS dp ON ft.id_plan = dp.id_plan
JOIN dim_canales_venta AS dcv ON ft.id_canal = dcv.id_canal
WHERE dp.tipo_servicio IN ('B2B', 'Mobile')
GROUP BY dcv.canal_nombre, dp.tipo_servicio
ORDER BY dcv.canal_nombre, ingresos_totales DESC;

-- 7A. En base a la pregunta anterior, cual es la rentabilidad de los servicios por canal? 
SELECT 
    dcv.canal_nombre,
    dp.tipo_servicio,
    FORMAT((SUM(ft.revenue) / (SUM(ft.cantidad))),2) AS relacion
FROM fact_transacciones AS ft
JOIN dim_planes AS dp ON ft.id_plan = dp.id_plan
JOIN dim_canales_venta AS dcv ON ft.id_canal = dcv.id_canal
WHERE dp.tipo_servicio IN ('B2B', 'Mobile')
GROUP BY dcv.canal_nombre, dp.tipo_servicio
ORDER BY dcv.canal_nombre, relacion DESC;

-- 8. Cual es el estado de cada plan?
SELECT COUNT(t.estado) as cantidad,
       t.estado,
       p.nombre_plan
FROM dim_planes p
LEFT JOIN fact_transacciones t ON p.id_plan = t.id_plan
GROUP BY p.nombre_plan, t.estado
ORDER BY cantidad;

-- 2. Eficiancia de los canales de venta 
-- Rendimiento cruzado de canales y consultores
-- 1. Requerimos el volumen de venta e ingresos totales por los diferentes canales de venta 
SELECT
    dcv.canal_nombre,
    COUNT(ft.id_transaccion) AS volumen_venta,
    FORMAT(SUM(ft.revenue),2) AS ingresos_totales
FROM fact_transacciones AS ft
JOIN dim_canales_venta AS dcv ON ft.id_canal = dcv.id_canal
GROUP BY dcv.canal_nombre
ORDER BY dcv.canal_nombre, volumen_venta DESC;

-- 2. ¿Qué almacenes son los más rentables por consultor?
SELECT cv.nombre_almacen,
       c.nombre_consultor,
       SUM(t.revenue) AS ingresos_totales
FROM dim_canales_venta cv
LEFT JOIN fact_transacciones t ON cv.id_canal = t.id_canal
LEFT JOIN dim_consultores c ON t.id_consultor = c.id_consultor
GROUP BY cv.nombre_almacen, c.nombre_consultor
ORDER BY ingresos_totales ASC;

-- 4. Cuantos consultores trabajan para los diversos canales de venta? 
-- ( cuantos consultores tengo )
SELECT COUNT(nombre_consultor)
FROM dim_consultores;
-- 104 cosultores

-- 4A. Por mes cuantos consultores tiene cada estado ?
SELECT t.estado,
       MONTH(t.fecha_alta) AS mes,
	   COUNT(DISTINCT t.id_consultor) AS numero_consultores_activos
FROM fact_transacciones AS t
GROUP BY MONTH(t.fecha_alta), t.estado
ORDER BY mes;

-- 4B. Cuantos consultores hay por canal de venta? 
SELECT id_canal,
       COUNT(c.nombre_consultor) as cantidad_consultores
FROM dim_consultores c
GROUP BY id_canal
ORDER BY cantidad_consultores;

-- id 32012
SELECT id_canal,
	   id_consultor,
       nombre_consultor
FROM dim_consultores
WHERE id_canal = 32012
ORDER BY nombre_consultor ASC
LIMIT 2;
-- Se detecto que una misma persona trabaja para un solo canal con dos ID diferentes... 

-- 5. Que tienda son mas rentables para la venta de los servicios B2B y mobile 
SELECT
    dcv.nombre_almacen,
    dp.tipo_servicio,
    SUM(ft.revenue) AS ingresos_totales,
    COUNT(ft.id_transaccion) AS cantidad_transacciones
FROM fact_transacciones AS ft
JOIN dim_planes AS dp ON ft.id_plan = dp.id_plan
JOIN dim_canales_venta AS dcv ON ft.id_canal = dcv.id_canal
GROUP BY dcv.nombre_almacen, dp.tipo_servicio
ORDER BY dcv.nombre_almacen, ingresos_totales DESC;

-- 5A. En base a la pregunta anterior, cual es la relacion entre el volumen de venta e ingresos generados por tienda?
SELECT
    dcv.nombre_almacen,
    dp.tipo_servicio,
    FORMAT(((SUM(ft.revenue)) / (SUM(ft.cantidad))),2) AS relacion
FROM fact_transacciones AS ft
JOIN dim_planes AS dp ON ft.id_plan = dp.id_plan
JOIN dim_canales_venta AS dcv ON ft.id_canal = dcv.id_canal
GROUP BY dcv.nombre_almacen, dp.tipo_servicio
ORDER BY dcv.nombre_almacen, relacion DESC;

-- 3. Rendimiento del Equipo de Ventas (Consultores) 
-- 1. ¿Cuál es el ingreso promedio y el volumen de venta por consultor?
SELECT  c.nombre_consultor,
       FORMAT(AVG(t.revenue),2) as promedio_ingresos,
       SUM(t.cantidad) AS volumen_venta
FROM dim_consultores c
LEFT JOIN fact_transacciones t ON c.id_consultor = t.id_consultor
GROUP BY c.nombre_consultor
ORDER BY volumen_venta DESC;

-- 2. Que planes vende cada consultor?
SELECT c.nombre_consultor,
       p.nombre_plan,
       FORMAT(SUM(t.plan_revenue),2) as precio_plan
FROM dim_consultores c
LEFT JOIN fact_transacciones t ON c.id_consultor = t.id_consultor
LEFT JOIN dim_planes p ON t.id_plan = p.id_plan
GROUP BY c.nombre_consultor, p.nombre_plan
ORDER BY precio_plan DESC;

-- 3. Cuantos consultores hay por estado y quienes son. 
-- Primer parte: Cuantos consultores hay por estado
SELECT t.estado,
	   COUNT(c.nombre_consultor) AS cantidad_consultores,
       COUNT(t.estado) AS tipo_estado
FROM fact_transacciones t
LEFT JOIN dim_consultores c ON t.id_consultor = c.id_consultor
GROUP BY t.estado
ORDER BY cantidad_consultores, tipo_estado;

-- Segunda parte: Quienes son
SELECT c.nombre_consultor,
       t.estado
FROM dim_consultores c
LEFT JOIN fact_transacciones t ON c.id_consultor  = t.id_consultor
WHERE t.estado = 'Two-Way Block';
-- Detectamos 5 consultores en estado Two-Way Block

SELECT c.nombre_consultor,
       t.estado
FROM dim_consultores c
LEFT JOIN fact_transacciones t ON c.id_consultor  = t.id_consultor
WHERE t.estado = 'One-Way Block';
-- Detectamos 5 consultores en estado One-Way Block

SELECT c.nombre_consultor,
       t.estado
FROM dim_consultores c
LEFT JOIN fact_transacciones t ON c.id_consultor  = t.id_consultor
WHERE t.estado = 'Termination';
-- Detectamos 275 consultores en estado Termination

SELECT c.nombre_consultor,
       t.estado
FROM dim_consultores c
LEFT JOIN fact_transacciones t ON c.id_consultor  = t.id_consultor
WHERE t.estado = 'Active';
-- Detectamos 6709 consultores en estado Active

-- 4. Cuantas ventas mensuales llevan a cabo los asesores solamente en estado activo (META 2 VENTAS POR DIA)
SELECT
    YEAR(t.fecha_alta) AS anio,
    MONTH(t.fecha_alta) AS mes,
    c.nombre_consultor,
    COUNT(t.id_transaccion) AS ventas_mensuales
FROM fact_transacciones AS t
JOIN dim_consultores AS c ON t.id_consultor = c.id_consultor
WHERE t.estado = 'Active'
GROUP BY YEAR(t.fecha_alta), MONTH(t.fecha_alta), c.nombre_consultor  
ORDER BY c.nombre_consultor, anio, mes;

 -- 5. Y por trimestre? (META 180) 2*90
 SELECT
    YEAR(t.fecha_alta) AS anio,
    QUARTER(t.fecha_alta) AS trimestre,
    c.nombre_consultor,
    COUNT(t.id_transaccion) AS ventas_trimestrales
FROM fact_transacciones AS t
JOIN dim_consultores AS c ON t.id_consultor = c.id_consultor
WHERE t.estado = 'Active'
GROUP BY YEAR(t.fecha_alta), QUARTER(t.fecha_alta), c.nombre_consultor
ORDER BY c.nombre_consultor, anio, trimestre;

-- 6. Evaluación del rendimiento vs. la meta EN ESTADO ACTIVO 
SELECT
    YEAR(t.fecha_alta) AS anio,
    QUARTER(t.fecha_alta) AS trimestre,
    c.nombre_consultor,
    cv.nombre_almacen,
    SUM(t.cantidad) AS ventas_trimestrales,
    180 AS meta_trimestral,
    CASE
        WHEN SUM(t.cantidad) >= 180 THEN 'Meta alcanzada'
        ELSE 'Por debajo de la meta'
    END AS estado_meta
FROM fact_transacciones AS t
JOIN dim_consultores AS c ON t.id_consultor = c.id_consultor
JOIN dim_canales_venta cv ON t.id_canal = cv.id_canal
WHERE t.estado = 'Active'
GROUP BY YEAR(t.fecha_alta),  QUARTER(t.fecha_alta), c.nombre_consultor, cv.nombre_almacen
ORDER BY ventas_trimestrales DESC;

-- Cual es la tasa de abandono para TERMINATION
SELECT
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'Termination') AS numero_transacciones,
    COUNT(id_transaccion) AS total_transactions,
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'Termination') * 100 / COUNT(id_transaccion) AS tasa_abandono
FROM fact_transacciones;

-- 7. Evaluación del rendimiento vs. la meta EN ESTADO TERMINATION
SELECT
    YEAR(t.fecha_alta) AS anio,
    QUARTER(t.fecha_alta) AS trimestre,
    c.nombre_consultor,
    cv.nombre_almacen,
    SUM(t.cantidad) AS ventas_trimestrales,
    180 AS meta_trimestral,
    CASE
        WHEN SUM(t.cantidad) >= 180 THEN 'Meta alcanzada'
        ELSE 'Por debajo de la meta'
    END AS estado_meta
FROM fact_transacciones AS t
JOIN dim_consultores AS c ON t.id_consultor = c.id_consultor
JOIN dim_canales_venta AS cv ON t.id_canal = cv.id_canal
WHERE t.estado = 'Termination'
GROUP BY YEAR(t.fecha_alta),  QUARTER(t.fecha_alta), c.nombre_consultor, cv.nombre_almacen
ORDER BY ventas_trimestrales DESC;

-- 8.  Evaluación del rendimiento vs. la meta EN ESTADO One-Way Block
SELECT
    YEAR(t.fecha_alta) AS anio,
    QUARTER(t.fecha_alta) AS trimestre,
    c.nombre_consultor,
    cv.nombre_almacen,
    SUM(t.cantidad) AS ventas_trimestrales,
    180 AS meta_trimestral,
    CASE
        WHEN SUM(t.cantidad) >= 180 THEN 'Meta alcanzada'
        ELSE 'Por debajo de la meta'
    END AS estado_meta
FROM fact_transacciones AS t
JOIN dim_consultores AS c ON t.id_consultor = c.id_consultor
JOIN dim_canales_venta AS cv ON t.id_canal = cv.id_canal
WHERE t.estado = 'One-Way Block'
GROUP BY YEAR(t.fecha_alta),  QUARTER(t.fecha_alta), c.nombre_consultor, cv.nombre_almacen
ORDER BY ventas_trimestrales DESC;

-- 9. Evaluación del rendimiento vs. la meta EN ESTADO Two-Way Block
SELECT
    YEAR(t.fecha_alta) AS anio,
    QUARTER(t.fecha_alta) AS trimestre,
    c.nombre_consultor,
    cv.nombre_almacen,
    SUM(t.cantidad) AS ventas_trimestrales,
    180 AS meta_trimestral,
    CASE
        WHEN SUM(t.cantidad) >= 180 THEN 'Meta alcanzada'
        ELSE 'Por debajo de la meta'
    END AS estado_meta
FROM fact_transacciones AS t
JOIN dim_consultores AS c ON t.id_consultor = c.id_consultor
JOIN dim_canales_venta AS cv ON t.id_canal = cv.id_canal
WHERE t.estado = 'Two-Way Block'
GROUP BY YEAR(t.fecha_alta),  QUARTER(t.fecha_alta), c.nombre_consultor, cv.nombre_almacen
ORDER BY ventas_trimestrales DESC;


-- (Calculo de tasas para los diferentes estados)
SELECT
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'Termination') AS numero_transacciones,
    COUNT(id_transaccion) AS total_transactions,
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'Termination') * 100 / COUNT(id_transaccion) AS tasa_abandono
FROM fact_transacciones;

SELECT
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'Two-Way Block') AS numero_transacciones,
    COUNT(id_transaccion) AS total_transactions,
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'Two-Way Block') * 100 / COUNT(id_transaccion) AS tasa_abandono
FROM fact_transacciones;

SELECT
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'One-Way Block') AS numero_transacciones,
    COUNT(id_transaccion) AS total_transactions,
    (SELECT COUNT(id_transaccion) FROM fact_transacciones WHERE estado = 'One-Way Block') * 100 / COUNT(id_transaccion) AS tasa_abandono 
FROM fact_transacciones;

-- 7. Evaluacion de los antiguos operadores 

-- 1. Que planes estan asociados a los antiguos operadores? 
SELECT o.operador,
	   p.nombre_plan,
       count(p.nombre_plan) as cantidad_plan_asociado
FROM dim_operadores o 
LEFT JOIN fact_transacciones t ON o.id_operador = t.id_operador
LEFT JOIN dim_planes p ON t.id_plan = p.id_plan
GROUP BY o.operador, p.nombre_plan
ORDER BY cantidad_plan_asociado;

-- 2. ¿Existe alguna correlación entre el operador del cliente y el tipo de plan que contratan (B2B o Mobile)?
SELECT
    do.operador,
    dp.tipo_servicio,
    COUNT(ft.id_transaccion) AS cantidad_transacciones,
    FORMAT(SUM(ft.revenue),2) AS ingresos_totales
FROM fact_transacciones AS ft
JOIN dim_planes AS dp ON ft.id_plan = dp.id_plan
JOIN dim_consultores AS dc ON ft.id_consultor = dc.id_consultor
JOIN dim_operadores AS do ON ft.id_operador = do.id_operador
WHERE dp.tipo_servicio IN ('B2B', 'Mobile')
GROUP BY do.operador, dp.tipo_servicio
ORDER BY do.operador, ingresos_totales DESC;

	   





