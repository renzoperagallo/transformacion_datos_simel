
# Transformación Taubaldo IR nominal  excel a formato .stat ---------------

## Librerias 

library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)

## Importación del dataset 

# La versión original del tabulado se puede descargar desde http://stat.ine.cl/
# Previamente se limpiaron las celdas y columnas vacias, celdas compuestas, etc. 

ir_nominal <- read_xlsx("./input/ir_marzo_2023_tamano_empresa.xlsx")



# Preparacion del dataset -------------------------------------------------

## Transformar de formato ancho a formato largo
ir_nominal <- 
  ir_nominal |> 
  group_by(Mes) |> 
  pivot_longer(cols = starts_with("Empresas"),
               names_to = "tamano_emp",
               values_to = "OBS_VALUE") |> 
  select(ano_mes = Mes, everything()) # Se recodifica la columna mes para evitar confusiones




# Creando la variable TIME_PERIOD ------------------------------------------

## Transformar el mes al formato requerido por .stat
## En este caso es mensual así que el formato eso {Ano}-M{Numero mes}, ej: 2017-M11


# Construyendo diccionario de meses y años 
numero_mes <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
meses <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
llave_conversion <- tibble(numero_mes, meses)

# Obteniendo año y mes de la variable Mes
ir_nominal <- 
  ir_nominal |> 
  mutate(ano = str_sub(ano_mes, start = 1, end = 4),
         mes = str_extract(ano_mes, "[A-Za-z]+") ) |> 
  left_join(llave_conversion, by = c("mes" = "meses")) # Se agrega el número del mes en el formato deseado para crear time period


#Crear variable time period
ir_nominal <- 
  ir_nominal |> 
  mutate(TIME_PERIOD = paste0(ano,"-M", numero_mes))



# Creando el dataset ------------------------------------------------------

# Creación de las nuevas columnas (pueden variar dependiendo del indicador)
# Recordar que algunas columnas fueron creadas en pasos anteriores
ir_nominal <- 
  ir_nominal |> 
  mutate(DATAFLOW = "CL01:DF_IR_NTRAB(1.0)",
         AREA_REF = "_T",
         FREQ = "M",
         INDICADOR = "IR",
         NTRAB = case_when(tamano_emp %in% "Empresas pequeñas" ~ "ENTSIZE1",
                           tamano_emp %in% "Empresas medianas" ~ "ENTSIZE2",
                           tamano_emp %in% "Empresas grandes" ~ "ENTSIZE3"),
         OBS_STATUS = "",
         DECIMALS = 1,
         UNIDAD = "IX",
         MULT = 0) |> 
  ungroup()

# Selección de las columnas finales 
ir_nominal <- 
  ir_nominal |> 
  select(DATAFLOW,
         AREA_REF,
         FREQ,
         INDICADOR,
         NTRAB,
         TIME_PERIOD,
         OBS_VALUE,
         DECIMALS,
         UNIDAD,
         MULT)

# Exportacion -------------------------------------------------------------

# Este formato es compatible directamente con .stat
write_delim(ir_nominal, 
            file = "./output/ir_marzo_2023_tamano_empresa_transformado.csv",
            delim = ",",
            quote = "needed")

