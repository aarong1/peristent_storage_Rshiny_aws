import requests

url = "https://trueway-geocoding.p.rapidapi.com/ReverseGeocode"

querystring = {"location":"37.7879493,-122.3961974","language":"en"}

headers = {
    'x-rapidapi-host': "trueway-geocoding.p.rapidapi.com",
    'x-rapidapi-key': "fad50c9837msh42692375c68e65cp10976ajsndc459510b93f"
    }

response = requests.request("GET", url, headers=headers, params=querystring)

print(response.text)

