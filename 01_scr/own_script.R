install.packages("pacman")
install.packages("data.table")
install.packages("DT")

require(openxlsx)
require(pacman)
require(data.table)

fileData <- "/Users/willi/Library/Mobile Documents/com~apple~CloudDocs/Universität/Master/3. Semester/RP Data Science and Machine Learning/Seminar-DS-ML/02_data/Unctad.xlsx"

dataInwardFlow <- read.xlsx(fileData, sheet = 'Inward_Flow')
dataGDP <- read.xlsx(fileData, sheet = 'GDP')

#data table
dataInwardFlow <- setDT(dataInwardFlow)
dataGDP <- setDT(dataGDP)

head(dataGDP, 5)
summary(dataGDP)

rm(list = ls())

ls()              # Listet alle Objekte im Environment
objects()         # Gleiches wie ls()
str(data)         # Zeigt Struktur einzelner Objekte


utils::View(dataGDP)
exists("dataGDP"); class(dataGDP); dim(dataGDP)

getOption("vscodeR")   # sollte NICHT NULL sein
View(dataGDP)          # sollte den Data Viewer öffnen


