#Autor: Iván Rodríguez Palmeros
#Fecha: 16/08/2023
#Descripción: Creación de archivos futuros con input

#Librerias----------------------------------------------------------------------
library(epwshiftr)
library(eplusr)
library(knitr)

#Código-------------------------------------------------------------------------

options(epwshiftr.dir = "C:\\Users\\ivanr\\Documents\\SustainableBuildings\\BasesDeDatos\\Escenarios\\ssp585")
options(epwshiftr.verbose = TRUE)

(nodes <- get_data_node())

idx <- init_cmip6_index(
  activity = "ScenarioMIP",
  
  variable = c("tas", "hurs"),
  
  frequency = "day",
  
  experiment = c("ssp585"),
  
  source = "AWI-CM-1-1-MR",
  
  variant = "r1i1p1f1",
  
  years = c(2050, 2080),
  
  save = TRUE
)
idx <- load_cmip6_index()

str(head(idx))
sm <- summary_database("C:\\Users\\ivanr\\Documents\\SustainableBuildings\\BasesDeDatos\\Escenarios\\ssp585", by = c("source", "variable"), mult = "latest", update = TRUE)

knitr::kable(sm)

epw <- file.path("C:\\Users\\ivanr\\Documents\\SustainableBuildings\\BasesDeDatos\\ClimasActuales\\MEX_HID_.epw")

coord <- match_coord(epw, threshold = list(lon = 1, lat = 1), max_num = 1)

class(coord)

names(coord)

coord$meta

coord$coord[, .(file_path, coord)]

str(coord$coord$coord[[1]])
data <- extract_data(coord, years = c(2050, 2080))
class(data)
names(data)
knitr::kable(head(data$data))

morphed <- morphing_epw(data)

class(morphed)

names(morphed)

knitr::kable(head(morphed$tdb))

knitr::kable(head(morphed$rh))

epws <- future_epw(morphed, by = c("source", "experiment", "interval"),
                   dir = "C:\\Users\\ivanr\\Documents\\SustainableBuildings\\BasesDeDatos\\ClimasFuturos", separate = TRUE, overwrite = TRUE
)

epws

sapply(epws, function (epw) epw$path())

