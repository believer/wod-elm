module Types exposing (DecimalSystem(..), Model, Msg(..))

import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Wods exposing (Category, Wod, WorkoutType)


type DecimalSystem
    = Metric
    | Imperial


type Msg
    = NoOp
    | FilterOnCategory (Maybe Category)
    | FilterOnWorkoutType (Maybe WorkoutType)
    | UrlChanged Url
    | UpdateDecimalSystem
    | ChangeWorkoutLevel Wod


type alias Model =
    { category : Maybe Category
    , workoutType : Maybe WorkoutType
    , decimalSystem : DecimalSystem
    , navigationKey : Key
    , wods : List Wod
    }
