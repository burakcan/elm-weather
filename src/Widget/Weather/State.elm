module Widget.Weather.State exposing (Model, Msg(..), initCmd, initialState, update, subscriptions)

import Config
import Widget.CommonTypes exposing (LatLon)
import Geolocation exposing (Location, Error)
import Json.Decode exposing ((:=))
import Json.Decode as Json
import Time exposing (Time, minute)
import Http
import Maybe
import Task
import Debug


-- MODEL
type alias Weather =
  { cod : Int
  , city : String
  , temp : Float
  , icon : Int
  }

type alias Model =
  { location : Maybe LatLon
  , current : Maybe Weather
  }


initialState : Maybe LatLon -> Model
initialState latLon =
  Model latLon Nothing


-- MESSAGES
type Msg
  = LocationSuccess Location
  | LocationFailed Error
  | FetchWeather (Maybe LatLon)
  | FetchSuccess Weather
  | FetchFailed Http.Error


initCmd : Model -> Cmd Msg
initCmd model =
  case model.location of
    Nothing ->
      Task.perform LocationFailed LocationSuccess Geolocation.now

    Just latLon ->
      fetchWeather model.location


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LocationSuccess { latitude, longitude } ->
      let
        maybeLatLon =
          Maybe.withDefault (Just <| LatLon latitude longitude) Nothing
      in
        ({ model | location = maybeLatLon }, fetchWeather maybeLatLon)

    FetchWeather maybeLatLon ->
      (model, fetchWeather maybeLatLon)

    LocationFailed error ->
      let
        _ = Debug.log "Error: " error
      in
        (model, Cmd.none)

    FetchSuccess weather ->
      let
        maybeWeather =
          Maybe.withDefault (Just weather) Nothing
      in
        ({ model | current = maybeWeather }, Cmd.none)

    FetchFailed error ->
      let
        _ = Debug.log "Error: " error
      in
        (model, Cmd.none)


fetchWeather : Maybe LatLon -> Cmd Msg
fetchWeather maybeLatLon =
  let
    command =
      case maybeLatLon of
        Nothing ->
          Cmd.none

        Just location ->
          let
            url =
              Config.apiBase ++
              "?lat=" ++ (toString location.latitude) ++
              "&lon=" ++ (toString location.longitude) ++
              "&APPID=" ++ Config.apiKey ++
              "&units=metric"
          in
            Task.perform
              FetchFailed
              FetchSuccess
              (Http.get decodeWeather url)
  in
    command


decodeWeather : Json.Decoder Weather
decodeWeather =
  Json.object4 Weather
    (Json.at ["cod"] Json.int)
    (Json.at ["name"] Json.string)
    (Json.at ["main", "temp"] Json.float)
    (Json.at ["weather", "0", "id"] Json.int)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  case model.location of
    Nothing ->
      Sub.none

    Just latLon ->
      Time.every (5 * minute) <| \_ -> FetchWeather model.location
