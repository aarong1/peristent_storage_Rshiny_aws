
#----------------
#https://locationiq.com/sandbox/geocoding/reverse
library(httr)
url <- function(lat='54.53',lon='-5.31'){
url <- paste0('https://us1.locationiq.com/v1/reverse.php?key=pk.60846804b3122e58f24c91674fbeddf0&',
'lat=',lat,
'&',
'lon=',lon,
'&format=json')
}

response <- VERB('GET',url)

content(response)
