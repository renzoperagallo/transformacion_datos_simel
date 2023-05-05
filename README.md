# Transformación de Datos para SIMEL: Ejemplo

Este proyecto ofrece ejemplos de código en R para transformar y adaptar datos a los requerimientos del SIMEL Chile.

Aquí se alojan archivos de ejemplo con datos enviados por instituciones para el taller de preparación de datos del SIMEL.

## Contenido del proyecto

Primero deberán abrir el proyecto en R para definir el espacio de trabajo. A continuación, pueden acceder a la carpeta ´scripts´, que contiene un script específico para cada conjunto de datos que se desea transformar.

En la carpeta ´input´, encontrarán los datos originales proporcionados por las instituciones, así como una versión preprocesada en la que se han limpiado y ordenado los datos para que puedan abrir los tabulados en r. 

En la carpeta ´output´, se ubican los resultados del procesamiento.

La carpeta ´extras´ contiene esquemas de estructuras de datos definidas en los DSD (archivo de Excel) y archivos DSD para trabajar con SMART, correspondientes a cada uno de los indicadores de ejemplo.

Hay tres ejemplos completos que se recomienda revisar: 

	- Indice de remuneraciones por tamaño de empresa (INE).
	- Cotizantes según tipo de contrato (Superintendencia de pensiones).
	- Nº accidentes fatales en el trabajo (SUSESO).

También existen otros scripts con transformaciones que se pueden revisar, pero no se cargó su dsd y formato en  la carpeta extras. Vale mencionar que, dado que los datos de entrada son distintos para cada indicador, las transformaciones programadas en los script son diferentes entre cada indicador. 	

## Sobre la estructura de datos

En el sistema de información de SIMEL cada ´dataflow´ o tabulado tiene una estructura de datos específicada en el archivo ´DSD´. Esta estructura establece el formato en el que deben estar los datos para  ser visualizados en los tabulados. 

Por lo tanto, cada tabulado requiere una planilla de datos con un formato específico. Este formato requerido puede visualizarse en la carpeta ´extras´ como se mencionó anteriormente.

## Advertencia

Este es un proyecto de ejemplo. Las estructuras de datos y los requerimientos podrían cambiar en la medida que se ponga en funcionamiento la versión definitiva. 

Por ahora el proyecto está incompleto, iré cargando los script para los indicadores faltantes prontamente. 

Si se usa **R Studio** para transformar los datos, es  importante considerar los `NA` al momento de exportar los datos al CSV ya que por defecto quedan como valores string "NA" y para SDMX deben ser datos vacíos. Para eso se puede usar el comando `write_delim` con el argumento `na = ""`. 
