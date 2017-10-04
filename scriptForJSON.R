library(rjson)
library(jsonlite)
library(dplyr)


setwd("c:/code/csv2json")

baseFolder = "C:/models/mto"

#file: international trip rates-------------------------------------------------

fileName = paste(baseFolder,"/input/tripGeneration/intTripRates.csv", sep="")
data1 = read.csv(fileName)

names = c("daytrip", "inOut", "away")
visitRates = setNames(object = as.list(x = data1$visit), nm = names)
leisureRates = setNames(object = as.list(x = data1$leisure), nm = names)
businessRates = setNames(object = as.list(x = data1$business), nm = names)

list1 = list(visit=visitRates, leisure = leisureRates, business = businessRates)
jsonObject = prettify(rjson::toJSON(list1))
print(jsonObject)

write(jsonObject, file ="intTripRates.json")


#file: domestci destination choice-------------------------------------------------

fileName = paste(baseFolder,"/input/destinationChoice/destinationChoiceCoefficientsV2.csv", sep="")
data1 = read.csv(fileName)

names = data1$parameter
visitLsit = setNames(object = as.list(x = data1$visit), nm = names)
leisureList = setNames(object = as.list(x = data1$leisure), nm = names)
businessList = setNames(object = as.list(x = data1$business), nm = names)

list1 = list(visit=visitLsit, leisure = leisureList, business = businessList)
jsonObject = prettify(rjson::toJSON(list1))
print(jsonObject)

write(jsonObject, file ="domeDestChoice.json")





#file: domestic mode choice for Ontarians--------------------------------------

fileNames = c( "domesticModeChoiceCoefOnV2",
               "domesticModeChoiceCoefCanV2",
               "intOutboundModeChoiceCoefV2",
               "intOutboundModeChoiceCoefV2")

for (file in fileNames){
  
  fileName = paste( baseFolder,"/input/modeChoice/", file, ".csv", sep="")
  
  data1 = read.csv(fileName)
  
  names = data1$variable
  autoCoef = setNames(object = as.list(data1$auto.visit), nm = names)
  airCoef = setNames(object = as.list(data1$air.visit), nm = names)
  railCoef = setNames(object = as.list(data1$rail.visit), nm = names)
  busCoef = setNames(object = as.list(data1$bus.visit), nm = names)
  visitList = list(auto = autoCoef, air = airCoef, rail = railCoef, bus = busCoef)
  
  autoCoef = setNames(object = as.list(data1$auto.business), nm = names)
  airCoef = setNames(object = as.list(data1$air.business), nm = names)
  railCoef = setNames(object = as.list(data1$rail.business), nm = names)
  busCoef = setNames(object = as.list(data1$bus.business), nm = names)
  businessList = list(auto = autoCoef, air = airCoef, rail = railCoef, bus = busCoef)
  
  autoCoef = setNames(object = as.list(data1$auto.leisure), nm = names)
  airCoef = setNames(object = as.list(data1$air.leisure), nm = names)
  railCoef = setNames(object = as.list(data1$rail.leisure), nm = names)
  busCoef = setNames(object = as.list(data1$bus.leisure), nm = names)
  leisureList = list(auto = autoCoef, air = airCoef, rail = railCoef, bus = busCoef)
  
  list1 = list(visit=visitList, leisure = leisureList, business = businessList)
  
  jsonObject = prettify(rjson::toJSON(list1))
  print(jsonObject)
  
  write(jsonObject, file =paste(file,".json",sep=""))
  
  
}




