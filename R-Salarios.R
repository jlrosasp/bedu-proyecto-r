library(httr)
library(jsonlite)

#install.packages("plotly")
library(dplyr)
library(plotly)


#Cubo de datos

repositorio = GET("https://api.datamexico.org/tesseract/cubes/imss/aggregate.jsonrecords?captions%5B%5D=Date+Month.Date.Quarter.Quarter+ES&drilldowns%5B%5D=Date+Month.Date.Quarter&measures%5B%5D=Insured+Employment&parents=false&sparse=false")

rawToChar(repositorio$content) #convierte en string o serie de caracteries

Datos = fromJSON(rawToChar(repositorio$content))
names(Datos)


Datos<-Datos$data
Datos <- Datos[,-c(1)] #elimina la primera columna

#Convierte a un dataframe

Datos <- data.frame(Datos)
colnames(Datos)<- c("Trimestre", "Asegurados")


p = plot_ly(Datos, x = ~Trimestre,y = ~Asegurados,
            name = 'Asegurados',
            type = 'scatter',
            mode = 'lines+markers')

p %>% layout(title="Asegurados 2019Q1 al 2020Q4 de México")


Crecimiento <- data.frame(diff(log(Datos$Asegurados), lag=1)*100)

Fechas<-Datos$Trimestre[2:8]

Crecimiento <- data.frame(cbind(Fechas,Crecimiento))
colnames(Crecimiento)<- c("Trimestre", "Crecimiento")


p1 = plot_ly(Crecimiento, x = ~Trimestre,y = ~Crecimiento,
             name = 'Crecimiento',
             type = 'scatter',
             mode = 'lines+markers'
)

p1 %>% layout(title="Variación  (variación porcentual respecto al trimestre anterior) ")
