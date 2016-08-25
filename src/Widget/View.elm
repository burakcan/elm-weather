module Widget.View exposing (widgetView)

import Widget.State exposing (Msg(ClockMsg, WeatherMsg), Model)
import Widget.Clock.View as Clock
import Widget.Weather.View as Weather
import Html exposing (Html, div, text)
import Html.App as App
import Html.Attributes exposing (class)


widgetView : Model -> Html Msg
widgetView model =
    div [ class "Widget" ]
      [ App.map ClockMsg <| Clock.view model.clock
      , App.map WeatherMsg <| Weather.view model.weather
      ]
