module App.View exposing (appView)

import Html exposing (Html, div, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html.App as App
import App.State exposing (Msg(..), Model, IndexedWidget)
import App.AddFormView exposing (addFormView)
import Widget.View exposing (widgetView)
import Widget.State as WidgetState
import List

appView : Model -> Html Msg
appView model =
  let
    widgets =
      List.map indexedWidgetView model.widgets

    addFormOrButton =
      if (not model.formOpen) then
        [ button [ class "AddButton", onClick <| SetAddForm True ] [ text "+" ] ]
      else
        [ addFormView model
        , button [ class "CloseButton", onClick <| SetAddForm False ] [ text "+" ]
        ]

  in
    div [ class "App" ] <| List.concat [ widgets, addFormOrButton ]

indexedWidgetView : IndexedWidget -> Html Msg
indexedWidgetView model =
  App.map (WidgetMsg model.id) (widgetView model.model)
