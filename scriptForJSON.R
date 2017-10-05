library(rjson)
library(jsonlite)
library(dplyr)


setwd("c:/code/csv2json")

baseFolder = "C:/models/mto"

#file: domestic generation coefficients-------------------------------------------------

fileName = paste(baseFolder,"/input/tripGeneration/tripGenerationCoefficients.csv", sep="")
data1 = read.csv(fileName)

names = data1$factorName

states = c("daytrip", "inout", "away")
purposes = c("business", "visit", "leisure")

group = list()
for (purpose in purposes){
  variable = list()
  for (state in states){
    i = match(state, states)
    values = eval(parse(text = paste("data1$",state,".",purpose,sep ="")))
    variable[[i]] = setNames(object = values, nm = names)
  }
  j = match(purpose, purposes)
  group[[j]] = list(away = variable[[match("away", states)]] ,
                  inout =variable[[match("inout", states)]]  ,
                  daytrip =variable[[match("daytrip", states)]]  )
  
}

list1 = list(business = group[[match("business", purposes)]] ,
                visit =group[[match("visit", purposes)]]  ,
                leisure =group[[match("leisure", purposes)]]  )


jsonObject = prettify(rjson::toJSON(list1))
print(jsonObject)

write(jsonObject, file ="tripGenerationCoefficients.json")


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


#files: trip parties for residents
fileNames = c("travelPartyProbabilities", "intTravelPartyProbabilities")

for (file in fileNames){
  fileName = paste(baseFolder,"/input/tripGeneration/",file,".csv", sep="")
  data1 = read.csv(fileName)
  
  householdSizes = c(1,2,3,4,5, "nonHh")
  purposes = c("business", "visit", "leisure")
  ageGroups = c("","kids.")
  ageGroupsNames = c("adults","kids")
  
  byPurpose = list()
  for (purpose in purposes){
    byAgeGroup = list()
    for(ageGroup in ageGroups){
      bySize = list()
      for (householdSize in householdSizes){
        variableName = paste("data1$",ageGroup, purpose,".", householdSize, sep = "")
        values = eval(parse(text = variableName))
        i = match(householdSize,householdSizes)
        if (!is.null(values)){
          bySize[[i]] = values
        }else {
          bySize[[i]] = 0
        }
      }
      bySize = setNames(bySize, householdSizes)
      j = match(ageGroup, ageGroups)
      byAgeGroup[[j]] = bySize
    }
    byAgeGroup = setNames(byAgeGroup, ageGroupsNames)
    k = match(purpose, purposes)
    byPurpose[[k]] = byAgeGroup
  }
  
  list1 = setNames(byPurpose, purposes)
  
  jsonObject = prettify(rjson::toJSON(list1))
  print(jsonObject)
  
  newFileName = paste(file, ".json", sep = "")
  
  write(jsonObject, file =newFileName)
}



#files: trip parties for visitors-----------------------------------------
fileNames = c("visitorsPartyProbabilities")

for (file in fileNames){
  fileName = paste(baseFolder,"/input/tripGeneration/",file,".csv", sep="")
  data1 = read.csv(fileName)
  
  types = c("adults", " kids", "nonHh")
  purposes = c("business", "visit", "leisure")
  
  
  byPurpose = list()
  for (purpose in purposes){
    byType = list()
    for(type in types){
      
        variableName = paste("data1$",type,".", purpose, sep = "")
        values = eval(parse(text = variableName))
        i = match(type,types)
        byType[[i]] = values
      }
      byType = setNames(byType, types)
      k = match(purpose, purposes)
      byPurpose[[k]] = byType
    }
    
   
  
  
  list1 = setNames(byPurpose, purposes)
  
  jsonObject = prettify(rjson::toJSON(list1))
  print(jsonObject)
  
  newFileName = paste(file, ".json", sep = "")
  
  write(jsonObject, file =newFileName)
}






#files: destination choice-------------------------------------------------

fileNames = c( "destinationChoiceCoefficientsV2",
               "intOutCoefficientsV2",
               "intUsInCoefficientsV2")

for (file in fileNames){
  fileName = paste(baseFolder,"/input/destinationChoice/",file,".csv", sep="")
  
  data1 = read.csv(fileName)
  
  if (file == fileNames[1]){
    names = data1$parameter
  } else {
    names = data1$variable
  }
  
  
  visitLsit = setNames(object = as.list(x = data1$visit), nm = names)
  leisureList = setNames(object = as.list(x = data1$leisure), nm = names)
  businessList = setNames(object = as.list(x = data1$business), nm = names)
  
  list1 = list(visit=visitLsit, leisure = leisureList, business = businessList)
  jsonObject = prettify(rjson::toJSON(list1))
  print(jsonObject)
  
  newFileName = paste(file, ".json", sep = "")
  
  write(jsonObject, file =newFileName)
}







#files: mode choice--------------------------------------

fileNames = c( "domesticModeChoiceCoefOnV2",
               "domesticModeChoiceCoefCanV2",
               "intOutboundModeChoiceCoefV2",
               "intInboundModeChoiceCoefV2")

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
  
  newFileName = paste(file, ".json", sep = "")
  
  write(jsonObject, file =newFileName)
  
  
}




