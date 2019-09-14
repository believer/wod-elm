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
    , parts : List WodPart
    , rounds : Maybe Int
    }


unitToString : WodWeight -> String
unitToString weight =
    case weight of
        Kg _ ->
            " kg"

        Cm _ ->
            " cm"


toSplit : Float -> Float -> WodWeight -> String
toSplit a b weight =
    " ("
        ++ String.fromFloat a
        ++ "/"
        ++ String.fromFloat b
        ++ unitToString weight
        ++ ")"


weightToString : ( Maybe WodWeight, Maybe WodWeight ) -> String
weightToString unit =
    case unit of
        ( Just (Kg a), Just (Kg b) ) ->
            toSplit a b (Kg a)

        ( Just (Cm a), Just (Cm b) ) ->
            toSplit a b (Cm a)

        ( _, _ ) ->
            ""


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
    ]
        |> List.reverse
