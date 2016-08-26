module App.AddFormView exposing (addFormView)

import Html exposing (Html, div, text, button, input)
import Html.Attributes exposing (class, type', placeholder, value, disabled, autofocus)
import Html.Events exposing (onClick, onInput)
import App.State exposing (Msg(..), Model)
import Maybe
import List


addFormView : Model -> Html Msg
addFormView model =
  div [ class "AddForm" ]
    [ input
      [ type' "text"
      , placeholder "type a city name"
      , autofocus True
      , onInput CityInput
      ] []
    , autoCompleteView model
    , button [ class "CloseButton", onClick <| SetAddForm False ] [ text "+" ]
    ]


autoCompleteView : Model -> Html Msg
autoCompleteView { searchResult, selectedResult } =
  let
    items =
      case searchResult of
        Nothing ->
          []

        Just result ->
          List.indexedMap
          (\index item ->
            div [ class <| if (index == selectedResult) then "selected" else "" ] [text item]
          )
          result

    hasItemsClass =
      if (List.length items /= 0) then
        "has-items"
      else
        ""
  in
    div [ class <| "AddForm-AutoComplete " ++ hasItemsClass ] items
