module Widget.State exposing (init, update, subscriptions, Msg(..), Model)

import Widget.Clock.State as Clock
import Widget.Weather.State as Weather
import Widget.CommonTypes exposing (LatLon)
import Time exposing (Time, second)
import Task


-- MODEL
type alias Model =
  { clock : Clock.Model
  , weather : Weather.Model
  }


-- MESSAGES
type Msg
  = ClockMsg Clock.Msg
  | WeatherMsg Weather.Msg


-- INIT
init : Maybe LatLon -> (Model, Cmd Msg)
init latLon =
  let
    weatherInitialState =
      Weather.initialState latLon

    clockInitialState =
      Clock.initialState
  in
    ( Model clockInitialState weatherInitialState
    , Cmd.batch
        [ Cmd.map ClockMsg <| Clock.initCmd
        , Cmd.map WeatherMsg <| Weather.initCmd weatherInitialState
        ]
    )


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ClockMsg clockMsg ->
      let
        (newClockModel, clockCmd) =
          Clock.update clockMsg model.clock
      in
        ( { model | clock = newClockModel }
        , Cmd.map ClockMsg <| clockCmd
        )

    WeatherMsg weatherMsg ->
      let
        (newWeatherModel, weatherCmd) =
          Weather.update weatherMsg model.weather
      in
        ( { model | weather = newWeatherModel }
        , Cmd.map WeatherMsg <| weatherCmd
        )


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [Sub.map ClockMsg <| Clock.subscriptions model.clock]
