module View exposing (..)

import Html exposing (Attribute, Html, a, button, div, header, li, span, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Markdown
import Types exposing (..)
import WodHelpers exposing (weightToString)
import Wods exposing (Category, Wod, WodPart, WorkoutType)


pill : Maybe Category -> Html Msg
pill category =
    case category of
        Just Wods.Hero ->
            div [ class "inline-block rounded-full px-3 py-1 text-sm font-semibold text-center bg-green-200 text-green-700" ]
                [ text "Hero"
                ]

        Just Wods.Girl ->
            div [ class "inline-block rounded-full px-3 py-1 text-sm font-semibold text-center bg-pink-200 text-pink-700" ]
                [ text "The Girls"
                ]

        Nothing ->
            text ""


wodExercises : DecimalSystem -> WodPart -> Html Msg
wodExercises decimalSystem exercise =
    li []
        [ div []
            [ text (Wods.exerciseAmount exercise.reps ++ " ")
            , text (Wods.exerciseToString exercise.exercise)
            , span [ class "text-gray-500" ]
                [ text (weightToString exercise.weight decimalSystem)
                ]
            ]
        ]


roundsForTime : Maybe Int -> Html Msg
roundsForTime rounds =
    case rounds of
        Just i ->
            div [ class "text-sm text-gray-500" ] [ text (String.fromInt i ++ " rounds for time of:") ]

        Nothing ->
            text ""


filterButtonStyle : Attribute msg
filterButtonStyle =
    class "inline-block rounded-full px-3 py-1 text-sm font-semibold text-center bg-gray-200 text-gray-700 mr-4"


filterButtonActive : String
filterButtonActive =
    "bg-blue-200 text-blue-700"


workoutCategoryButton : Maybe Category -> Maybe Category -> String -> Html Msg
workoutCategoryButton currentCategory category buttonText =
    button
        [ filterButtonStyle
        , classList
            [ ( filterButtonActive
              , category == currentCategory
              )
            ]
        , onClick (FilterOnCategory category)
        ]
        [ text buttonText ]


workoutTypeButton : Maybe WorkoutType -> Maybe WorkoutType -> String -> Html Msg
workoutTypeButton currentWorkoutType workoutType buttonText =
    button
        [ filterButtonStyle
        , classList
            [ ( filterButtonActive
              , workoutType == currentWorkoutType
              )
            ]
        , onClick (FilterOnWorkoutType workoutType)
        ]
        [ text buttonText ]


card : Model -> Wod -> Html Msg
card model wod =
    div [ class "bg-white rounded shadow-lg flex flex-col justify-between" ]
        [ div [ class "p-6" ]
            [ header [ class "flex items-center justify-between" ]
                [ div [ class "font-bold" ]
                    [ text wod.name
                    ]
                , pill
                    wod.category
                ]
            , roundsForTime wod.rounds
            , ul [ class "text-gray-700 mt-4" ]
                (wod.parts
                    |> List.map
                        (wodExercises model.decimalSystem)
                )
            , case wod.description of
                Just description ->
                    div [ class "mt-4 text-xs text-gray-500 markdown" ]
                        [ Markdown.toHtml [ class "markdown" ] description
                        ]

                Nothing ->
                    text ""
            ]
        ]
