
# Preaparación datos prueba SIMEL -----------------------------------------

# Libreria 
library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)




# TRL ---------------------------------------------------------------------

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
          delim = ",")
# 
# write_csv(TRLMULT_2, 
#             file = "C:/Users/riperagallod/OneDrive - Instituto Nacional de Estadisticas/Proyectos/SIMEL .stat/rproj/output/TRLMULT_3.csv")




# TSL ---------------------------------------------------------------------

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
            quote = "needed")



# TEL ---------------------------------------------------------------------


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
            quote = "needed")




# IR por actividad económica ----------------------------------------------

ir_rama <- 
  read_excel("./input/ir_rama_2.xlsx")

names(ir_rama[1]) <- "TIME_PERIOD"

ir_rama  <-  
  ir_rama |>
  rename_at(1, ~"TIME_PERIOD") |> 
  tidyr::pivot_longer(cols = names(ir_rama[2:18]),
                      names_to = "ECO",
                      values_to = "OBS_VALUE") |> 
  mutate(AREA_REF = "_T",
         FREQ = "M",
         INDICADOR = "IR",
         DECIMALS = "1",
         UNIDAD = "RT",
         MULT = "0",
         DATAFLOW = "CL01:DF_IR_RAMA(1.0)",
         OBS_STATUS = "") |> 
  select(DATAFLOW, everything())

ir_rama <- ir_rama |> filter(ECO != "B") # La categoría B no era admitida en el content constrain 

ir_rama <- ir_rama |> select(DATAFLOW,AREA_REF,FREQ,INDICADOR,ECO,TIME_PERIOD,OBS_VALUE,OBS_STATUS,DECIMALS,UNIDAD,MULT)


write_delim(ir_rama, 
            file = "./output/ir_rama.csv",
            delim = ",",
            quote = "needed")



# YHNDEP SEXO -------------------------------------------------------------

yhndep_sexo <- read_delim("./input/ESI_YH_DEP.csv", 
                      delim = ",", escape_double = FALSE, trim_ws = TRUE)


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


write_delim(yhndep_sexo, 
            file = "./output/yhndep_sexo.csv",
            delim = ",",
            quote = "needed")


# Otros -------------------------------------------------------------------


