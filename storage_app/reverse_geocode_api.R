
#----------------
#https://locationiq.com/sandbox/geocoding/reverse
library(httr)
key <- Sys.getenv('api_key')
url <- function(lat='54.53',lon='-5.31'){
  url <- paste0('https://us1.locationiq.com/v1/reverse.php?key=',key,'&',
'lat=',lat,
'&',
'lon=',lon,
'&format=json')
}

response <- VERB('GET',url())

content(response)
