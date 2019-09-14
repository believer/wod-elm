module Types exposing (Msg(..))

import Url exposing (Url)
import Wods exposing (Category, WorkoutType)


type Msg
    = NoOp
    | FilterOnCategory (Maybe Category)
    | FilterOnWorkoutType (Maybe WorkoutType)
    | UrlChanged Url
