# 
# cotizantes_sexo_tc
# SIMEL_CL:DF_NCOTSC_SEXO_TDCON(1.0)

# Transformación Número de Cotizantes al Seguro de Cesantía por sexo y tipo de contrato a formato .stat ---------------

## Librerias 

library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)
library(lubridate)
library(janitor)

## Importación del dataset 

cotizantes_sexo_tc <- read_xlsx("./input/SP_cotizantes_tipo_contrato_sexo.xlsx")

## Limpiar nombres de las columnas

cotizantes_sexo_tc <- janitor::clean_names(cotizantes_sexo_tc)
# Obtener TIME PERIOD en formato adecuado ---------------------------------

cotizantes_sexo_tc <- 
  cotizantes_sexo_tc |>
  mutate(fecha = lubridate::ymd(mes)) |> 
  mutate(mes_2 = sprintf("%02d", lubridate::month(fecha)),
         ano = lubridate::year(fecha)) |> 
  mutate(TIME_PERIOD = paste0(ano,"-M", mes_2))


# Preparacion del dataset -------------------------------------------------

## Transformar de formato ancho a formato largo

cotizantes_sexo_tc <- 
  cotizantes_sexo_tc |> 
  group_by(TIME_PERIOD) |> 
  pivot_longer(cols = starts_with("contrato") | starts_with("casa") | starts_with("total"),
               names_to = "desagregaciones",
               values_to = "OBS_VALUE") |> 
  select(TIME_PERIOD, desagregaciones, OBS_VALUE)



# Crear variable sexo y tipo de contrato ----------------------------------

## Sexo
# IMPORTANTE: EN ESTE CASO  LA CONVERSION SE HIZO CON CASE WHEN Y EL ORDEN ES IMPORTANTE PARA QUE LA TRANSFORMACION SE HAGA CORRECTAMENTE
# Ya que la evaluacion de la categoría total debe ser después de haber intentado asignar con las otras posibilidades. 
cotizantes_sexo_tc <- 
  cotizantes_sexo_tc |> 
  mutate(TDCON = case_when(str_detect(desagregaciones, "contratototal") ~ "_T",
                           str_detect(desagregaciones, "contrato_indefinido") ~ "TDC_7",
                           str_detect(desagregaciones, "contrato_plazo_fijo") ~ "TDC_8",
                           str_detect(desagregaciones, "casa_particular") ~ "TDC_9"),
         SEXO = case_when(str_detect(desagregaciones, "sexototal") ~ "_T",
                          str_detect(desagregaciones, "hombres") ~ "M",
                          str_detect(desagregaciones, "mujeres") ~ "F",
                          str_detect(desagregaciones, "sin_informacion") ~ "_X"))


# Creando el dataset ------------------------------------------------------

# Creación de las nuevas columnas (pueden variar dependiendo del indicador)
# Recordar que algunas columnas fueron creadas en pasos anteriores

cotizantes_sexo_tc <- 
  cotizantes_sexo_tc |> 
  mutate(DATAFLOW = "SIMEL_CL:DF_NCOTSC_SEXO_TDCON(1.0)",
         AREA_REF = "_T",
         FREQ = "M",
         INDICADOR = "NCOTSC",
         DECIMALS = 0,
         UNIDAD = "PS",
         MULT = 0) |> 
  ungroup() 
#|>  select(!desagregaciones)

cotizantes_sexo_tc <- 
  cotizantes_sexo_tc |> 
  select(DATAFLOW, everything())

# Exportacion -------------------------------------------------------------

# Este formato es compatible directamente con .stat
# Ojo, es  muy importante el argumento "na" que sea definido en blanco ya que por defecto 
# el csv arroja "NA" como un valor.

write_delim(cotizantes_sexo_tc, 
            file = "./output/sp_cotizantes_tipo_contrato_sexo_transformado.csv",
            delim = ",",
            quote = "needed",
            na = "") # <- importante!

