Resumen ejecutivo: PROYECTO INTEGRADOR 9.0 - UNICORN ACADEMY 

Este documento es un resumen de un proyecto final realizado por el equipo de Data-Consulting SH. El objetivo principal fue analizar datos brutos de una empresa de telecomunicaciones ficticia, TELECOM, para proporcionar a sus directivos información valiosa y propuestas estratégicas que ayuden a mejorar el rendimiento del negocio.

Los datos, que abarcaban desde enero hasta julio de 2025 y se entregaron en múltiples archivos de Excel, fueron sometidos a un riguroso proceso de limpieza, análisis y visualización. Para ello, se utilizó una metodología integral con herramientas clave como Excel, MySQL, Google Colab, Power BI y SQLite.

1. Descripción del Proyecto:
   
Fuente de Datos:

TELECOM, una empresa colombiana de telecomunicaciones simulada para proteger la información real.

La información consistía en registros de ventas y transacciones mensuales de enero a julio de 2025.

Para optimizar el proyecto, el alcance se redujo al segundo trimestre de 2025 (abril, mayo y junio) y a la región del Eje Cafetero. Esta decisión permitió enfocar el análisis en 7,019 filas de datos, una cantidad mucho más manejable que las más de 300,000 iniciales.

Objetivos Principales:

Transformar los datos brutos en un formato estructurado y limpio.

Realizar un análisis estadístico descriptivo para descubrir tendencias clave.

Responder a preguntas de negocio específicas del cliente.

Crear un panel de visualización claro y efectivo.

Desarrollar propuestas de valor accionables basadas en los hallazgos.

2. Metodología y Análisis:
   
El proyecto siguió un proceso estructurado de análisis de datos:

Recepción y Limpieza Inicial (Excel):

Se recibieron los datos de transacciones en archivos mensuales de Excel (.xlsm).

Se realizó una primera limpieza y concatenación de los archivos para consolidar la información.

Modelado de Base de Datos Relacional (MySQL):

Los datos se transformaron y se importaron a una base de datos en MySQL.

Se creó un modelo relacional con cinco tablas: dim_planes, dim_consultores, dim_operadores, dim_canales_de_ventas y fact_transacciones.

Un script específico se usó para una limpieza inicial, corrigiendo errores, manejando valores nulos y estandarizando los tipos de datos.

Análisis Exploratorio de Datos (Google Colab - Python):

Se utilizó Python en Google Colab para realizar un análisis estadístico descriptivo.

Se verificaron los valores nulos, la integridad de los datos y la distribución de las variables y valores atípicos.

Resolución de Preguntas de Negocio (SQLite):

Se conectó Google Colab con SQLite.

Se escribieron consultas SQL para responder directamente a las preguntas del cliente, obteniendo información sobre:

Rendimiento de los Planes: Ingresos y volumen de ventas por tipo de servicio (Mobile, B2B), valor promedio de las transacciones y planes más rentables.

Rendimiento de Canales y Asesores: Ingresos totales por canal, consultores más rentables y número de consultores por tienda.

Rendimiento del Equipo de Ventas: Ingreso promedio por asesor, desempeño mensual frente a metas y un análisis del estado de los consultores ("Active", "Termination" y "Bloqueados").

Evaluación de Operadores: Correlación entre el operador del cliente y el tipo de plan contratado.

Visualización de Datos (Power BI):

Se creó un completo dashboard en Power BI para presentar los hallazgos de forma clara y visualmente atractiva.

El dashboard incluyó informes detallados sobre el rendimiento general, el ranking de tiendas y asesores, y un informe de insights clave.

3. Hallazgos Clave y Propuestas de Valor:
   
El análisis reveló información crucial que sirvió de base para las siguientes propuestas estratégicas:

Propuestas de Marketing:

Foco en el servicio Mobile: Se recomienda seguir potenciando los planes más rentables del servicio Mobile, ya que son un pilar en los ingresos.

Estrategia de precios: Realizar una auditoría del plan B2B XL. La amplia variabilidad en sus precios sugiere la necesidad de renegociar con clientes jurídicos para mantener la competitividad.

Impulsar el Plan M: Lanzar una campaña de marketing específica para el Plan M de Mobile, ya que es el más rentable por unidad y su crecimiento podría tener un impacto significativo en las ganancias generales.

Propuestas de Gobierno de Datos:

Mejora en la Calidad de Datos: Implementar procesos para limpiar y unificar los registros de los consultores, eliminando duplicados y sesgos.

Separar los Registros: Se sugiere manejar las transacciones de pospago y prepago en formatos separados para evitar confusiones y registros nulos.

Propuestas para Canales de Venta:

Ubicación Estratégica de Kioscos: Se recomienda validar que los kioscos estén en lugares estratégicos para maximizar el tráfico y las ventas.

Evaluar las Tiendas Express: Analizar la baja rentabilidad de las Tiendas Express y desarrollar un plan para mejorar la productividad de los consultores en estas ubicaciones.

Propuestas para el Equipo de Ventas:

Reevaluar las Metas: Dado que una gran parte de los consultores no cumplen la meta mensual de dos ventas diarias, se sugiere reevaluar si esta meta es realista.

Asignar Roles por Especialidad: Proponer que los consultores con mejor rendimiento en ventas B2B se enfoquen en tiendas con clientes jurídicos para maximizar su labor.

Controlar la Tasa de Abandono: Establecer una meta para el estado de "Termination" (ej. no más de tres transacciones por mes) e investigar las causas de estas bajas.

Seguimiento a Clientes Bloqueados: Implementar un seguimiento detallado para los clientes en estado "One-way Block" y "Two-Way Block" para evitar que pasen a "Termination".

Propuestas de Evaluación de Competencia:

Análisis de Mercado Constante: Se recomienda realizar un análisis de mercado quincenal de las estrategias de la competencia para que TELECOM se mantenga a la vanguardia y evite la pérdida de clientes.

4. Conclusiones del Análisis:
   
Este proyecto demostró el valor del análisis de datos para la toma de decisiones estratégicas. El análisis del segundo trimestre de TELECOM reveló que, aunque las tiendas físicas son el pilar del negocio, el segmento Mobile es, de manera sorprendente, más rentable por unidad que el B2B. Este hallazgo desafía la intuición y subraya la necesidad de que TELECOM optimice su estrategia de precios y la eficiencia del servicio B2B.

Además, el bajo rendimiento de los consultores y los problemas de calidad de los datos destacan la necesidad de mejoras internas. Antes de buscar nuevas estrategias de venta, TELECOM debe solucionar estos problemas fundamentales. Las propuestas de Data-Consulting SH son un primer paso crucial para optimizar procesos, capacitar al equipo y refinar las estrategias comerciales, asegurando así un crecimiento sostenible.







