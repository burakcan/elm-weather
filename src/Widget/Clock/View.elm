module Widget.Clock.View exposing (view)

import Widget.Clock.State exposing (Model, Msg)
import Widget.Clock.DigitalView as Digital
import Html exposing (Html, div)
import Html.Attributes exposing (class)

view : Model -> Html Msg
view model =
  div [ class "Clock" ]
    [ Digital.view model
    ]
