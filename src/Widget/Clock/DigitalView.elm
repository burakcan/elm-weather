module Widget.Clock.DigitalView exposing (view)

import Html exposing (Html, text, div)
import Date exposing (fromTime, hour, minute, second)
import Widget.Clock.State exposing (Msg, Model)
import String exposing (padLeft)


view : Model -> Html Msg
view model =
  let
    date =
      fromTime model

    (hourStr, minuteStr, secondStr) =
      ( format <| hour date
      , format <| minute date
      , format <| second date
      )
  in
    div []
      [ text <| hourStr ++ ":" ++ minuteStr ++ ":" ++ secondStr ]


format : Int -> String
format int =
  padLeft 2 '0' <| toString <| int
