module Types exposing (DecimalSystem(..), Model, Msg(..))

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Routes exposing (Route)
import Url exposing (Url)
import Wods exposing (Category, Wod, WorkoutType)


type DecimalSystem
    = Metric
    | Imperial


type Msg
    = NoOp
    | FilterOnCategory (Maybe Category)
    | FilterOnWorkoutType (Maybe WorkoutType)
    | UpdateDecimalSystem
    | ChangeWorkoutLevel Wod
    | UpdateQuery String
    | OnUrlChange Url
    | OnUrlRequest UrlRequest


type alias Model =
    { category : Maybe Category
    , workoutType : Maybe WorkoutType
    , decimalSystem : DecimalSystem
    , navigationKey : Key
    , searchQuery : String
    , wods : List Wod
    , route : Route
    }
