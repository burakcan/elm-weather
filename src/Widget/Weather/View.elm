module Widget.Weather.View exposing (view)

import Widget.Weather.State exposing (Model, Msg)
import Html exposing (Html, div, text, h2, i)
import Html.Attributes exposing (class)


waitingLocationView : Model -> Html Msg
waitingLocationView model =
  div [ class "WaitingLocationView" ] [ text "Waiting for location..." ]

loadingView : Model -> Html Msg
loadingView model =
  div [ class "LoadingView" ] [ text "Loading..." ]

weatherView : Model -> Html Msg
weatherView model =
  let
    (icon, temp, city) =
      case model.current of
        Nothing ->
          ("", 0, "")

        Just weather ->
          ( toString weather.icon
          , round weather.temp
          , weather.city
          )

  in
    div [ class "WeatherView" ]
      [ div [ class "Weather-Icon" ] [ i [ class <| "wi wi-owm-" ++ icon ] [] ]
      , div [ class "Weather-Temp" ] [ text <| (toString temp) ++ "°" ]
      , div [ class "Weather-City" ] [ text city ]
      ]


view : Model -> Html Msg
view model =
  let
    activeView =
      case model.location of
        Nothing ->
          waitingLocationView

        Just location ->
          case model.current of
            Nothing ->
              loadingView

            Just weather ->
              weatherView
  in
    div [ class "Weather" ] [ activeView model ]
