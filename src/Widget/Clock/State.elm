module Widget.Clock.State exposing (Model, Msg(Tick), subscriptions, update, initCmd, initialState)

import Time exposing (Time, second)
import Task

-- MODEL
type alias Model = Time


initialState : Model
initialState =
  0


-- MESSAGES
type Msg
  = Tick Time
  | NoOp String


initCmd : Cmd Msg
initCmd =
  Task.perform NoOp Tick Time.now


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick time ->
      (time, Cmd.none)

    NoOp str ->
      (model, Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick
