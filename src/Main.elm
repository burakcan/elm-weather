import Html.App exposing (program)
import App.View exposing (appView)
import App.State exposing (init, update, subscriptions)

main =
  program
    { view = appView
    , init = init
    , update = update
    , subscriptions = subscriptions
    }
