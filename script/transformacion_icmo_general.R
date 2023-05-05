
# Transformacion Indice Remuneraciones por actividad económica ------------

# Librerias
library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)

# Lectura BD  -------------------------------------------------------------

icmo_general <- 
  read_csv("./input/icmo_general.csv")

# Preparacion BD ----------------------------------------------------------
icmo_general <- janitor::clean_names(icmo_general)

names(icmo_general)

icmo_general <- 
  icmo_general |> 
  select(TIME_PERIOD = dti_cl_mes,
         OBS_STATUS = flag_codes,
         OBS_VALUE = value,
         UNIDAD = dti_cl_unidad_medida)

icmo_general <- 
  icmo_general |> 
  mutate(DATAFLOW = "CL01:DF_ICMO(1.0)",
         AREA_REF = "_T",
         FREQ = "M",
         INDICADOR = "ICMO",
         DECIMALS = "2",
         MULT = "0")

icmo_general <- 
  icmo_general |> 
  mutate(UNIDAD = ifelse(UNIDAD %in% "12_M_VAR", "VAR12",UNIDAD)) |> 
  select(DATAFLOW, everything())

# Exportación -------------------------------------------------------------

write_delim(icmo_general, 
            file = "./output/icmo_general.csv",
            delim = ",",
            quote = "needed",
            na = "")