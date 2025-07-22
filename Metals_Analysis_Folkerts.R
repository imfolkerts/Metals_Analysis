rm(list = ls())

library('tidyr')
library('dplyr')
library('stringr')
library('ggplot2')
library('RColorBrewer')
library('ggpubr')
library("purrr")
library('readxl')
library('plyr')
library('car')

D <- read_excel('2024_1104_Aerosol_e-cig_SENT_stratified_andres.xlsx', 
                sheet='FINAL_"Aerosol" e-cig')

colnames(D)[1] <- 'Sample_no'


D$Nicotine = as.numeric(D$Nicotine)  

# Metals are in small decimals, mapping them to match aldehydes
D$Nicotine[D$Nicotine == 0.018] <- 1.8
D$Nicotine[D$Nicotine == 0.02] <- 2.0
D$Nicotine[D$Nicotine == 0.024] <- 2.4
D$Nicotine[D$Nicotine == 0.03] <- 3.0
D$Nicotine[D$Nicotine == 0.05] <- 5.0

# Nicotine categories
LABELS_Nic = c("0", "(1.8]", "(2.0]", "(2.4]", "(3.0]", "(5.0]") 

D$Nicotine <- cut(D$Nicotine, breaks = c(-1, 0, 1.8, 2.0, 2.4, 3.0, 5.0),
                  right = TRUE,
                  labels = LABELS_Nic,
                  include.lowest = TRUE)

D$No = as.factor(D$No)

#column names
MetalNames = names(D)
MetalNames = str_replace_all(MetalNames, fixed(' (ng/g)'), "")
MetalNames = str_replace_all(MetalNames, fixed('Sample name'), "ID")
colnames(D) <- MetalNames
colnames(D) <- trimws(colnames(D))  # Remove extra spaces

#Long format
D_wide = gather(D, Metal, conc, V:Pb)

D_wide$DevFla = paste(D_wide$Device, D_wide$Flavor) 
D_wide$conc[ is.na(D_wide$conc) ] = 0





# Statistical Analysis for METALS
D_analysis <- D_wide

