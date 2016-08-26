module App.State exposing (init, update, subscriptions, Msg(..), Model, IndexedWidget)

import Config exposing (googleAutoComplete)
import Widget.State as Widget
import Widget.CommonTypes exposing (LatLon)
import Json.Decode as Json
import Http
import Task
import Process
import List
import Debug



-- MODEL
type alias IndexedWidget =
  { id : Int
  , model : Widget.Model
  }

type alias Model =
  { widgets : List IndexedWidget
  , formOpen : Bool
  , searchTerm : String
  , searchResult : Maybe (List String)
  , selectedResult : Int
  }


-- MESSAGES
type Msg
  = WidgetMsg Int Widget.Msg
  | SetAddForm Bool
  | CityInput String
  | AutoCompleteSuccess String (List String)
  | AutoCompleteFailed Http.Error


-- INIT
init : (Model, Cmd Msg)
init =
  let
    (widgetModel, widgetCmd) =
      Widget.init <| Nothing
  in
    ( Model [(IndexedWidget 0 widgetModel)] False "" Nothing 0
    , Cmd.map (WidgetMsg 0) <| widgetCmd
    )


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    WidgetMsg id widgetMsg ->
      let
        (widgets, cmds) =
          ( List.map (updateWidgetModel id widgetMsg) model.widgets
          , List.map (updateWidgetCmd id widgetMsg) model.widgets
          )
      in
        ({ model | widgets = widgets }, Cmd.batch cmds)

    SetAddForm nextState ->
      ({ model | formOpen = nextState }, Cmd.none)

    CityInput input ->
      ({ model | searchTerm = input}, autoComplete input)

    AutoCompleteSuccess input result ->
      let
        maybeResult =
          if (input /= model.searchTerm) then
            model.searchResult
          else
            Maybe.withDefault (Just result) Nothing

        _ = Debug.log "result: " maybeResult
      in
        ({ model | searchResult = maybeResult }, Cmd.none)

    AutoCompleteFailed error ->
      let
        _ = Debug.log "error" error
      in
        (model, Cmd.none)


updateWidgetModel : Int -> Widget.Msg -> IndexedWidget -> IndexedWidget
updateWidgetModel id msg model =
  let
    (newModel, cmd) =
      Widget.update msg model.model
  in
    IndexedWidget id newModel


updateWidgetCmd : Int -> Widget.Msg -> IndexedWidget -> Cmd Msg
updateWidgetCmd id msg model =
  let
    (newModel, cmd) =
      Widget.update msg model.model
  in
    Cmd.map (WidgetMsg id) <| cmd


autoComplete : String -> Cmd Msg
autoComplete input =
  let
    url =
      googleAutoComplete.base ++
      "?input=" ++ input ++
      "&types=(cities)&key=" ++ googleAutoComplete.key
  in
    Task.perform
      AutoCompleteFailed
      (AutoCompleteSuccess input)
      (Http.get decodeAutoComplete url)


decodeAutoComplete : Json.Decoder (List String)
decodeAutoComplete =
  Json.at ["predictions"]
    (Json.list <| Json.at ["description"] Json.string)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch <|
    List.map mapWidgetSubscriptions model.widgets


mapWidgetSubscriptions : IndexedWidget -> Sub Msg
mapWidgetSubscriptions { id, model } =
  Sub.map (WidgetMsg id) <| (Widget.subscriptions model)
