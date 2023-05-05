
# Transformación Tabulado Accidentes en trabajo fatales  excel a formato .stat ---------------

## Librerias 

library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)

## Importación del dataset 

accidentes_fatales <- read_xlsx("./input/SUSESO_actidentes_trabajo _fatales.xlsx")



# Preparacion del dataset -------------------------------------------------
# El formato original del archivo ya viene en formato largo, por lo que no se precisa transformación

# Creando la variable TIME_PERIOD ------------------------------------------
# Esta variable es anual, asi que el time period es el año unicamente, por lo que no necesita transformacion. 


# Creando variable area_ref -----------------------------------------------

accidentes_fatales <- 
  accidentes_fatales |> 
  mutate(AREA_REF = case_when(region %in% "Tarapacá" ~ "01",
                              region %in% "Antofagasta" ~ "02",
                              region %in% "Atacama" ~ "03",
                              region %in% "Coquimbo" ~ "04",
                              region %in% "Valparaíso" ~ "05",
                              region %in% "O'Higgins" ~ "06",
                              region %in% "Maule" ~ "07",
                              region %in% "Bío Bío" ~ "08",
                              region %in% "Araucanía" ~ "09",
                              region %in% "Los Lagos" ~ "10",
                              region %in% "Aysén" ~ "11",
                              region %in% "Magallanes" ~ "12",
                              region %in% "Santiago (Metropolitana)" ~ "13",
                              region %in% "Los Ríos" ~ "14",
                              region %in% "Arica y Parinacota" ~ "15",
                              region %in% "Ñuble" ~ "16",
                              region %in% "Sin información" ~ "_X",
                              region %in% "Chile" ~ "_T")) # Se acordó que Chile corresponde al total

accidentes_fatales |> group_by(AREA_REF) |> tally()

# Creando el dataset ------------------------------------------------------

# Creación de las nuevas columnas (pueden variar dependiendo del indicador)
# Recordar que algunas columnas fueron creadas en pasos anteriores

accidentes_fatales <- 
  accidentes_fatales |> 
  mutate(DATAFLOW = "CL01:DF_TLOF_SEXO(1.0)",
         FREQ = "A",
         INDICADOR = "TLOF",
         SEXO = case_when(sexo %in% "Hombre" ~ "M",
                          sexo %in% "Mujer" ~ "F",
                          sexo %in% "Total" ~ "_T",
                          sexo %in% "Sin información" ~ "_X",),
         TIME_PERIOD = año,
         OBS_VALUE = `Tasa de frecuencia de accidentes del trabajo fatales`,
         DECIMALS = 1,
         UNIDAD = "RT",
         MULT = 0) |> 
  ungroup()

# Selección de las columnas finales 
accidentes_fatales <- 
  accidentes_fatales |> 
  select(DATAFLOW,
         AREA_REF,
         FREQ,
         INDICADOR,
         SEXO,
         TIME_PERIOD,
         OBS_VALUE,
         DECIMALS,
         UNIDAD,
         MULT)

# Exportacion -------------------------------------------------------------

# Este formato es compatible directamente con .stat
write_delim(accidentes_fatales, 
            file = "./output/suseso_accidentes_trabajo_fatales_transformado.csv",
            delim = ",",
            quote = "needed",
            na = "")

