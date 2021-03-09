library(httr)
library(jsonlite)

#install.packages("plotly")
library(dplyr)
library(plotly)
library(ggplot2)

#Cubo de datos

repositorio = GET("https://api.datamexico.org/tesseract/cubes/inegi_gdp/aggregate.jsonrecords?captions%5B%5D=Date.Date.Quarter.Quarter+ES&drilldowns%5B%5D=Date.Date.Quarter&measures%5B%5D=GDP&parents=false&sparse=false")
#repositorio = GET("https://api.datamexico.org/tesseract/cubes/inegi_gdp/aggregate.jsonrecords?captions%5B%5D=Date.Date.Quarter.Quarter+ES&captions%5B%5D=Sector.Sector.Sector.Sector+ES&cuts%5B%5D=Sector.Sector.Sector.23%2C46%2C62&drilldowns%5B%5D=Date.Date.Quarter&drilldowns%5B%5D=Sector.Sector.Sector&measures%5B%5D=GDP&parents=false&sparse=false"

repositorio

rawToChar(repositorio$content) #convierte en string o serie de caracteries

Datos = fromJSON(rawToChar(repositorio$content))
names(Datos)


Datos<-Datos$data
Datos <- Datos[,-c(1)] #elimina la primera columna

#Convierte a un dataframe

Datos <- data.frame(Datos)
colnames(Datos)<- c("Trimestre", "PIB")

# EDA
summary(Datos)
(my_scatplot <- ggplot(Datos, 
                       aes(x = Trimestre, y = PIB)) + 
    geom_point())

(my_scatplot <- ggplot(Datos, 
                       aes(x=Trimestre,y=PIB)) + 
    geom_point() + 
    geom_smooth(method = "lm", se = T))  # modelo lineal, cambia el parametro `se`, este hace referencia al intervalo de confianza


ggplot(Datos, aes(x = Trimestre, y = PIB, fill = Grupo)) + geom_boxplot() +
  ggtitle("Boxplots") +
  xlab("Categorias") +
  ylab("Mediciones")



p = plot_ly(Datos, x = ~Trimestre,y = ~PIB,
            name = 'PIB',
            type = 'scatter',
            mode = 'lines+markers')

p %>% layout(title="Producto Interno Bruto 2000Q1 al 2020Q2 de México")


Crecimiento <- data.frame(diff(log(Datos$PIB), lag=1)*100)

Fechas<-Datos$Trimestre[2:110]

Crecimiento <- data.frame(cbind(Fechas,Crecimiento))
colnames(Crecimiento)<- c("Trimestre", "Crecimiento")


p1 = plot_ly(Crecimiento, x = ~Trimestre,y = ~Crecimiento,
             name = 'Crecimiento',
             type = 'scatter',
             mode = 'lines+markers'
)

p1 %>% layout(title="Crecimiento economico (variación porcentual respecto al trimestre anterior) ")
