# TFG_ingenieria_electronica_estimacion_torque_caracterizacion_motores

# Caracterización de Motores

Este repositorio contiene scripts de MATLAB para la caracterización de motores eléctricos. Proporciona funciones para calcular varios parámetros de los motores, incluyendo resistencias del estator, reactancias del estator y del rotor, resistencia del rotor, reactancia de magnetización, error de potencia y resistencia del núcleo.

## Contenido

- `caracterizacion_motores.m`: Script principal que realiza la caracterización del motor llamando a diferentes funciones de prueba.
- `prueba_dc.m`: Función para calcular la resistencia del estator a 95 °C a partir de los valores de resistencia medidos a 20 °C y el coeficiente de temperatura del cobre.
- `prueba_rotor_bloqueado.m`: Función para calcular la resistencia del rotor y las reactancias del estator y del rotor utilizando la prueba de rotor bloqueado.
- `prueba_vacio.m`: Función para calcular la reactancia de magnetización, el error de potencia y la resistencia del núcleo basándose en mediciones y parámetros predefinidos en la prueba en vacío.
- `relaciones_de_potencia.m`: Script para validar el circuito equivalente desarrollado mediante relaciones de potencia comparando la potencia estimada con los datos del fabricante.

# CIRCUITO EQUIVALENTE
Este directorio contiene el archivo relaciones_de_potencia.m, el cual es un script en MATLAB que se utiliza para comprobar la validez del circuito equivalente desarrollado mediante relaciones de potencia. Este script contrasta la potencia estimada con los datos del fabricante, utilizando el par motor a plena carga y la velocidad a plena carga.

## Contenido

- `relaciones_de_potencia.m`: Este script calcula las potencias estimadas y compara los resultados con las potencias esperadas. Utiliza datos de resistencia de núcleo, pérdidas de núcleo, pérdidas de fricción, reactancia de magnetización, resistencia del estator, reactancia del estator, resistencia del rotor, reactancia del rotor, corriente de línea, par motor a plena carga, velocidad a plena carga y voltaje nominal. Muestra los resultados en forma de tabla, incluyendo la potencia esperada, la potencia estimada y el porcentaje de error.

# ESTIMACION DEL TORQUE

Esta carpeta contiene los archivos relacionados con la estimación del torque de un motor de inducción. Incluye diferentes enfoques y funciones para calcular el torque en base a las características del motor y la velocidad.

## Contenido

- `Prueba_estimador_torque_ajuste.m`: Script que prueba la función estimadora de torque mediante el análisis de diferentes motores y sus características de torque a diferentes velocidades. Genera un gráfico de torque versus velocidad e identifica puntos clave como el torque máximo, torque de arranque, torque a plena carga y torque mínimo (si corresponde). Utiliza la función `estimador_torque_ajuste` para estimar el torque.
- `estimador_torque_ajuste.m`: Función que estima el torque de un motor de inducción en base a las características del motor proporcionadas y la velocidad del motor. Considera factores como la resistencia del núcleo, las pérdidas, la reactancia y el deslizamiento. Además, incluye variables de ajuste para controlar el pico máximo de torque y el torque de arranque a medida que aumenta la velocidad del motor.
- `estimador_torque_labview.m`: Función que estima el torque de un motor de inducción basándose en las mediciones en tiempo real de velocidad y voltaje. Es especialmente útil para implementar en entornos de control en tiempo real como LabVIEW.
- `caracterizacion_motores.m`: Script principal que realiza la caracterización del motor llamando a diferentes funciones de prueba.
- `prueba_dc.m`: Función para calcular la resistencia del estator a 95 °C a partir de los valores de resistencia medidos a 20 °C y el coeficiente de temperatura del cobre.
- `prueba_rotor_bloqueado.m`: Función para calcular la resistencia del rotor y las reactancias del estator y del rotor utilizando la prueba de rotor bloqueado.
- `prueba_vacio.m`: Función para calcular la reactancia de magnetización, el error de potencia y la resistencia del núcleo basándose en mediciones y parámetros predefinidos en la prueba en vacío.
- `relaciones_de_potencia.m`: Script para validar el circuito equivalente desarrollado mediante relaciones de potencia comparando la potencia estimada con los datos del fabricante.

# LabVIEW

Esta carpeta contiene script en LabVIEW utilizados para la recolección de datos y monitoreo en tiempo real de variables de interés como velocidad, voltaje y corriente, además de la estimación indirecta del torque. Es importante mencionar que la version utilizada en estos scripts fue la versión 2019 de LabVIEW.

## Contenido

- `monitorización de variables.vi`: Script que se utilizó para la monitorización de las variables de interés como la velocidad, corriente y tensión, así mismo, hace una aproximacion del torque inducido por ambos motores, así como el controlautomático para la conexión y desconexión de cargas eléctricas.
- `PID`: Script para el control lineal PID utilizado para el control de la velocidad de operación de la planta.
- `Archivos varios`: Así mismo, esta carpeta contiene archivos varios que son dependencias de los archivos principales, así como archivos de prueba.

# Uso

1. Instala MATLAB y LabVIEW `version 2019` en tu computadora.
2. Clona este repositorio: `git clone https://github.com/DBarrantes45/TFG_ingenieria_electronica_estimacion_torque_caracterizacion_motores.git`.
3. Ejecuta el script deseado o llama a las funciones específicas según sea necesario.

# Autor

Douglas Barrantes Alfaro

# Fecha

Mayo 2023
