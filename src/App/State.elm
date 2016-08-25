module App.State exposing (init, update, subscriptions, Msg(..), Model, IndexedWidget)

import Widget.State as Widget
import Widget.CommonTypes exposing (LatLon)
import List


-- MODEL
type alias IndexedWidget =
  { id : Int
  , model : Widget.Model
  }


type alias Model =
  { widgets : List IndexedWidget
  , formOpen : Bool
  }


-- MESSAGES
type Msg
  = WidgetMsg Int Widget.Msg
  | SetAddForm Bool


-- INIT
init : (Model, Cmd Msg)
init =
  let
    (widgetModel, widgetCmd) =
      Widget.init <| Nothing
  in
    ( Model [(IndexedWidget 0 widgetModel)] False
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


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch <|
    List.map mapWidgetSubscriptions model.widgets


mapWidgetSubscriptions : IndexedWidget -> Sub Msg
mapWidgetSubscriptions { id, model } =
  Sub.map (WidgetMsg id) <| (Widget.subscriptions model)
