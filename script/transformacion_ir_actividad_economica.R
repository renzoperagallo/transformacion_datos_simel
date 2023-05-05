
# Transformacion Indice Remuneraciones por actividad económica ------------

# Librerias
library(readr)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)

# Lectura BD  -------------------------------------------------------------

ir_rama <- 
  read_excel("./input/ir_rama_2.xlsx")

# Preparacion BD ----------------------------------------------------------

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

ir_rama <- 
  ir_rama |> 
  filter(ECO != "B") # La categoría B no era admitida en el content constraint

ir_rama <- 
  ir_rama |> 
  select(DATAFLOW,AREA_REF,FREQ,INDICADOR,ECO,TIME_PERIOD,OBS_VALUE,OBS_STATUS,DECIMALS,UNIDAD,MULT)

# Exportación -------------------------------------------------------------

write_delim(ir_rama, 
            file = "./output/ir_rama.csv",
            delim = ",",
            quote = "needed",
            na = "")