

# Preparacion datos Tasa rotación laboral, entrada laboral y salid --------

# Libreria 
library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)


# Tasa rotación laboral (TRL) ---------------------------------------------

## Lectura BD
TRLMULT <- read_delim("./input/TRLMULT.csv", 
                      delim = ";", escape_double = FALSE, trim_ws = TRUE)

## Cambiar nombres headings

heads_string <- c("DATAFLOW", 
                  "FREQ", 
                  "INDICADOR", 
                  "AREA_REF", 
                  "ECO",  
                  "SEXO", 
                  "TIME_PERIOD", 
                  "OBS_VALUE", 
                  "OBS_STATUS",
                  "DECIMALS",
                  "NOTAS",
                  "FUENTE",
                  "NOTAS_INDICADOR",
                  "UNIDAD",
                  "MULT")

names(TRLMULT) = c("DATAFLOW", "AREA_REF", "TIME_PERIOD", "INDICADOR", "OBS_VALUE", "FREQ",
                   "UNIDAD", "FUENTE", "OBS_STATUS", "DECIMALS")
names(TRLMULT)

## Creación de variables 

TRLMULT_2 <- TRLMULT |> mutate(ECO = "", 
                               SEXO = "",
                               NOTAS = "",
                               NOTAS_INDICADOR = "",
                               MULT = "0",
                               UNIDAD = "RT",
                               OBS_STATUS = "")

TRLMULT_2 <- TRLMULT_2 |> select(DATAFLOW, 
                                 FREQ, 
                                 INDICADOR, 
                                 AREA_REF, 
                                 ECO,  
                                 SEXO, 
                                 TIME_PERIOD, 
                                 OBS_VALUE, 
                                 OBS_STATUS,
                                 DECIMALS,
                                 UNIDAD,
                                 MULT)

write_delim(TRLMULT_2, 
            file = "./output/TRLMULT_2.csv",
            delim = ",",
            na = "")



# Tasa de salida laboral (TSL) --------------------------------------------

TSL <- TRLMULT_2 |> 
  filter(INDICADOR == "TSL") |> 
  select(DATAFLOW, 
         FREQ, 
         INDICADOR, 
         AREA_REF, 
         TIME_PERIOD, 
         OBS_VALUE, 
         OBS_STATUS,
         DECIMALS,
         UNIDAD,
         MULT) |> 
  mutate(DATAFLOW = "CL01:DF_TSL(1.0)")

write_delim(TSL, 
            file = "./output/TSL.csv",
            delim = ",",
            quote = "needed",
            na = "")



# Tasa de entrada laboral -------------------------------------------------

TEL <- TRLMULT_2 |> 
  filter(INDICADOR == "TEL") |> 
  select(DATAFLOW, 
         FREQ, 
         INDICADOR, 
         AREA_REF, 
         TIME_PERIOD, 
         OBS_VALUE, 
         OBS_STATUS,
         DECIMALS,
         UNIDAD,
         MULT) |> 
  mutate(DATAFLOW = "CL01:DF_TEL(1.0)")

write_delim(TEL, 
            file = "./output/TEL.csv",
            delim = ",",
            quote = "needed",
            na = "")


