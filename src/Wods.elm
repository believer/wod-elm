module Wods exposing (..)


type WorkoutType
    = ForTime
    | EMOM Int


type Category
    = Hero
    | Girl


type WodReps
    = Num Int
    | Cal2 Int Int
    | Min Int


type WodWeight
    = Kg Float
    | Cm Float


type Exercise
    = BoxJump
    | CleanAndJerk
    | Deadlift
    | DevilPress
    | HangPowerClean
    | PowerClean
    | PushJerk
    | Rest
    | Row


type alias WodPart =
    { reps : WodReps
    , weight : ( Maybe WodWeight, Maybe WodWeight )
    , exercise : Exercise
    }


type alias Wod =
    { name : String
    , category : Maybe Category
    , workoutType : WorkoutType
    , description : Maybe String
    , parts : List WodPart
    , rounds : Maybe Int
    }


exerciseToString : Exercise -> String
exerciseToString exercise =
    case exercise of
        BoxJump ->
            "box jump"

        CleanAndJerk ->
            "clean and jerk"

        Deadlift ->
            "deadlift"

        DevilPress ->
            "devil press"

        HangPowerClean ->
            "hang power clean"

        PowerClean ->
            "power clean"

        PushJerk ->
            "push jerk"

        Rest ->
            "rest"

        Row ->
            "row"


exerciseAmount : WodReps -> String
exerciseAmount reps =
    case reps of
        Num i ->
            String.fromInt i

        Cal2 a b ->
            String.fromInt a ++ "/" ++ String.fromInt b

        Min min ->
            String.fromInt min ++ " min "


wods : List Wod
wods =
    [ { name = "Grace"
      , category = Just Girl
      , workoutType = ForTime
      , rounds = Nothing
      , description = Nothing
      , parts =
            [ { reps = Num 30
              , weight = ( Just (Kg 61), Just (Kg 43) )
              , exercise = CleanAndJerk
              }
            ]
      }
    , { name = "DT"
      , category = Just Hero
      , workoutType = ForTime
      , rounds = Just 5
      , description = Nothing
      , parts =
            [ { reps = Num 12
              , weight = ( Just (Kg 70), Just (Kg 47) )
              , exercise = Deadlift
              }
            , { reps = Num 9
              , weight = ( Just (Kg 70), Just (Kg 47) )
              , exercise = HangPowerClean
              }
            , { reps = Num 6
              , weight = ( Just (Kg 70), Just (Kg 47) )
              , exercise = PushJerk
              }
            ]
      }
    , { name = "Devil in the Row"
      , category = Nothing
      , workoutType = ForTime
      , rounds = Just 10
      , description = Just "Perfect pacing practice, try to keep the same pace through all ten rounds."
      , parts =
            [ { reps = Cal2 9 7
              , weight = ( Nothing, Nothing )
              , exercise = Row
              }
            , { reps = Num 6
              , weight = ( Just (Cm 60), Just (Cm 45) )
              , exercise = BoxJump
              }
            , { reps = Num 3
              , weight = ( Just (Kg 15), Just (Kg 10) )
              , exercise = DevilPress
              }
            ]
      }
    , { name = "190617-Mayhem"
      , category = Nothing
      , workoutType = EMOM 23
      , rounds = Nothing
      , description = Just """
Each set EMOM 5 min, then 1 min rest before next EMOM.

* First set (5 reps) light weight, touch and go
* Second set (3 reps) medium weight, touch and go
* Third set (1 rep - E30s) heavy weight
* Last set (5 reps) same as first set
      """
      , parts =
            [ { reps = Num 5
              , weight = ( Nothing, Nothing )
              , exercise = PowerClean
              }
            , { reps = Min 1
              , weight = ( Nothing, Nothing )
              , exercise = Rest
              }
            , { reps = Num 3
              , weight = ( Nothing, Nothing )
              , exercise = PowerClean
              }
            , { reps = Min 1
              , weight = ( Nothing, Nothing )
              , exercise = Rest
              }
            , { reps = Num 1
              , weight = ( Nothing, Nothing )
              , exercise = PowerClean
              }
            , { reps = Min 1
              , weight = ( Nothing, Nothing )
              , exercise = Rest
              }
            , { reps = Num 5
              , weight = ( Nothing, Nothing )
              , exercise = PowerClean
              }
            ]
      }
    , { name = "WZAOC 4"
      , category = Nothing
      , workoutType = EMOM 23
      , rounds = Nothing
      , description = Just """
Perform in any order, until completion of total work. Can be broken down or performed in any order.
      """
      , parts =
            []
      }
    ]
