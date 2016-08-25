module App.View exposing (appView)

import Html exposing (Html, Attribute, div, text, button, input)
import Html.Attributes exposing (class, type', placeholder, autofocus)
import Html.Events exposing (onClick)
import Html.App as App
import App.State exposing (Msg(..), Model, IndexedWidget)
import Widget.View exposing (widgetView)
import Widget.State as WidgetState
import Json.Decode as Json
import List

appView : Model -> Html Msg
appView model =
  let
    widgets =
      List.map indexedWidgetView model.widgets

    addFormOrButton =
      if (not model.formOpen) then
        button [ class "AddButton", onClick <| SetAddForm True ] [ text "+" ]
      else
        addFormView

  in
    div [ class "App" ] <| List.concat
      [widgets, [
        addFormOrButton
      ]]

indexedWidgetView : IndexedWidget -> Html Msg
indexedWidgetView model =
  App.map (WidgetMsg model.id) (widgetView model.model)


addFormView : Html Msg
addFormView =
  div [ class "AddForm" ]
    [ input
      [ type' "text"
      , placeholder "type a city name"
      , autofocus True] []
    , button [ class "CloseButton", onClick <| SetAddForm False ] [ text "+" ]
    ]
