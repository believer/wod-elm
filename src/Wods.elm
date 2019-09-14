module Wods exposing (..)


type WorkoutType
    = ForTime
    | EMOM Int


type Category
    = Hero
    | Girl
    | Wodapalooza Int


type WorkoutLevel
    = RX
    | Scaled


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
    | ToesToBar
    | WallBall
    | WeightedButterflySitUp


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
    , scaledParts : Maybe (List WodPart)
    , rounds : Maybe Int
    , timeCap : Maybe Int
    , externalLink : Maybe ( String, String )
    , workoutLevel : WorkoutLevel
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

        ToesToBar ->
            "toes-to-bar"

        WallBall ->
            "wall ball"

        WeightedButterflySitUp ->
            "weighted butterfly sit-up"


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
      , timeCap = Nothing
      , externalLink = Nothing
      , parts =
            [ { reps = Num 30
              , weight = ( Just (Kg 61), Just (Kg 43) )
              , exercise = CleanAndJerk
              }
            ]
      , scaledParts = Nothing
      , workoutLevel = RX
      }
    , { name = "DT"
      , category = Just Hero
      , workoutType = ForTime
      , rounds = Just 5
      , description = Just """
In honor of US Air Force SSgt Timothy P. Davis, 28, who was killed on Feburary, 20 2009 supporting operations in OEF when his vehicle was struck by an IED.
      """
      , timeCap = Nothing
      , externalLink = Nothing
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
      , scaledParts = Nothing
      , workoutLevel = RX
      }
    , { name = "Devil in the Row"
      , category = Nothing
      , workoutType = ForTime
      , rounds = Just 10
      , description = Just "Perfect pacing practice, try to keep the same pace through all ten rounds."
      , timeCap = Nothing
      , externalLink = Nothing
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
      , scaledParts = Nothing
      , workoutLevel = RX
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
      , timeCap = Nothing
      , externalLink = Nothing
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
      , scaledParts = Nothing
      , workoutLevel = RX
      }
    , { name = "WZAOC 4"
      , category = Just (Wodapalooza 2019)
      , workoutType = ForTime
      , rounds = Nothing
      , description = Just """
Perform in any order, until completion of total work. Can be broken down or performed in any order.
      """
      , timeCap = Just 20
      , externalLink = Just ( "Wodapalooza", "https://wodapalooza.com/workout/2019-2020-indy-oc-wod-4/" )
      , parts =
            [ { reps = Num 150
              , weight = ( Just (Kg 9), Just (Kg 6) )
              , exercise = WallBall
              }
            , { reps = Num 75
              , weight = ( Nothing, Nothing )
              , exercise = ToesToBar
              }
            ]
      , scaledParts =
            Just
                [ { reps = Num 100
                  , weight = ( Just (Kg 6), Just (Kg 4) )
                  , exercise = WallBall
                  }
                , { reps = Num 50
                  , weight = ( Nothing, Nothing )
                  , exercise = WeightedButterflySitUp
                  }
                ]
      , workoutLevel = RX
      }
    ]
