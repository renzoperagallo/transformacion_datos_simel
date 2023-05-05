
# Ingreso por hora nominas de las personas asalariadas según sexo ---------

# Librerias
library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)



# Lectura BD --------------------------------------------------------------

yhndep_sexo <- read_delim("./input/ESI_YH_DEP.csv", 
                          delim = ",", escape_double = FALSE, trim_ws = TRUE)



# Preparación de la BD ----------------------------------------------------


yhndep_sexo <- 
  yhndep_sexo |> 
  mutate(DATAFLOW = "SIMEL_CL:DF_YHNDEP_SEXO(1.0)",
         AREA_REF = "_T",
         FREQ = "A",
         INDICADOR = "YHNDEP",
         SEXO = DTI_CL_SEXO,
         TIME_PERIOD = Año,
         OBS_VALUE = Value,
         OBS_STATUS = "",
         DECIMALS = 0,
         CISE = case_when(DTI_CL_CISE %in% "ICSE93_1_A" ~ "CISE_1A",
                          DTI_CL_CISE %in% "ICSE93_1_B" ~ "CISE_1B",
                          DTI_CL_CISE %in% "ICSE93_1" ~ "CISE_1"),
         UNIDAD = "CLPHR",
         MULT = 0) |> 
  select(DATAFLOW,
         AREA_REF,
         FREQ,
         INDICADOR,
         SEXO,
         TIME_PERIOD,
         OBS_VALUE,
         OBS_STATUS,
         DECIMALS,
         CISE,
         UNIDAD,
         MULT)

# Exportación -------------------------------------------------------------

write_delim(yhndep_sexo, 
            file = "./output/yhndep_sexo.csv",
            delim = ",",
            quote = "needed",
            na = "")