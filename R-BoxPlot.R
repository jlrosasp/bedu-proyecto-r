

library(httr)
library(jsonlite)

#install.packages("plotly")
library(dplyr)
library(plotly)
library(ggplot2)

#Cubo de datos

repositorio = GET("https://api.datamexico.org/tesseract/cubes/imss/aggregate.jsonrecords?drilldowns%5B%5D=Date+Month.Date.Month&drilldowns%5B%5D=Sex.Sex.Sex&measures%5B%5D=Insured+Employment&parents=false&sparse=false")

repositorio

rawToChar(repositorio$content) #convierte en string o serie de caracteries

Datos = fromJSON(rawToChar(repositorio$content))
names(Datos)


Datos<-Datos$data
Datos <- Datos[,-c(1)] #elimina la primera columna
Datos <- Datos[,-c(3)] #elimina la primera columna

View(Datos)

#Convierte a un dataframe

Datos <- data.frame(Datos)
colnames(Datos)<- c("Mes", "Genero", "Asegurados")

# EDA
summary(Datos)


ggplot(Datos, aes(x = Mes, y = Asegurados, fill = Genero)) + geom_boxplot() +
  ggtitle("Boxplots") +
  xlab("Categorias") +
  ylab("Mediciones")
