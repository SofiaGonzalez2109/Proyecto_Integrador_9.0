CREATE DATABASE telecom_base;
USE telecom_base;

SET FOREIGN_KEY_CHECKS = 0;

-- TABLA DIMENSIONAL PLANES
DROP TABLE IF EXISTS dim_planes;
CREATE TABLE dim_planes(
id_plan INT AUTO_INCREMENT PRIMARY KEY,
nombre_plan VARCHAR(100),
servicio VARCHAR(50),
tipo_servicio VARCHAR(50)
) ;

-- TABLA DIMENSIONAL OPERADORES
DROP TABLE IF EXISTS dim_operadores;
CREATE TABLE dim_operadores(
id_operador INT AUTO_INCREMENT PRIMARY KEY,
operador VARCHAR(50) UNIQUE NOT NULL
);

-- TABLA DIMENSIONAL CONSULTORES
DROP TABLE IF EXISTS dim_consultores;
CREATE TABLE dim_consultores(
id_consultor INT AUTO_INCREMENT PRIMARY KEY,
nombre_consultor VARCHAR(225) NOT NULL,
id_canal INT
);

-- TABLA DIMENSIONAL CANALES DE VENTA
DROP TABLE IF EXISTS dim_canales_venta;
CREATE TABLE dim_canales_venta(
id_canal INT AUTO_INCREMENT PRIMARY KEY,
nombre_almacen VARCHAR(225),
canal_nombre VARCHAR(100),
region_nombre VARCHAR(50)
);

-- TABLA FACT TABLE (TABLA PRINCIPAL/HECHO)
DROP TABLE IF EXISTS fact_transacciones;
CREATE TABLE fact_transacciones(
id_transaccion INT AUTO_INCREMENT PRIMARY KEY,
dia INT,
mes INT,
anio INT,
estado VARCHAR(50),
fecha_alta DATE,
fecha_factura DATE,
revenue DECIMAL(10,2),
plan_revenue DECIMAL(10,2),
cantidad DECIMAL(10,2),
id_plan INT NOT NULL,
id_consultor INT NOT NULL,
id_operador INT NOT NULL,
id_canal INT NOT NULL,

FOREIGN KEY (id_plan) REFERENCES dim_planes(id_plan),
FOREIGN KEY (id_operador) REFERENCES dim_operadores(id_operador),
FOREIGN KEY (id_canal) REFERENCES dim_canales_venta(id_canal),
FOREIGN KEY (id_consultor) REFERENCES dim_consultores(id_consultor)

);

SET FOREIGN_KEY_CHECKS = 1;

-- modificacion de tipo de dato en la tabla de transacciones, columa revenue y plan_revenue 
ALTER TABLE fact_transacciones
MODIFY revenue INT;

ALTER TABLE fact_transacciones
MODIFY plan_revenue INT;

-- modificacion en el formato de fecha 
UPDATE fact_transacciones
SET 
       fecha_alta = STR_TO_DATE(fecha_alta, '%Y/%m/%d'),
	   fecha_factura =  STR_TO_DATE(fecha_factura, '%Y/%m/%d');

-- FIN SCRIPT MODELADO 