module Config exposing (..)


type alias Api =
  { key : String
  , base : String
  }


apiKey : String
apiKey =
  "3df518e5dbf85c99eadf5e87cfe65e5c"


apiBase : String
apiBase =
  "https://crossorigin.me/http://api.openweathermap.org/data/2.5/weather"



googleAutoComplete : Api
googleAutoComplete =
  Api
    "AIzaSyB7M5z9dhB0M2z8zvORMpo1GzHZDHhwC8g"
    "https://crossorigin.me/https://maps.googleapis.com/maps/api/place/autocomplete/json"
