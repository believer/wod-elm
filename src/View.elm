module View exposing (..)

import Html exposing (Attribute, Html, a, button, div, header, li, span, text, ul)
import Html.Attributes exposing (class, classList, href, rel, target, type_)
import Html.Events exposing (onClick)
import Markdown
import Types exposing (..)
import WodHelpers exposing (weightToString)
import Wods


pillStyle : String
pillStyle =
    "inline-block rounded-full px-3 py-1 text-sm font-semibold text-center"


pill : Maybe Wods.Category -> Html Msg
pill category =
    case category of
        Just Wods.Hero ->
            div
                [ classList
                    [ ( pillStyle, True )
                    , ( "bg-green-200 text-green-700", True )
                    ]
                ]
                [ text "Hero"
                ]

        Just Wods.Girl ->
            div
                [ classList
                    [ ( pillStyle, True )
                    , ( "bg-pink-200 text-pink-700", True )
                    ]
                ]
                [ text "The Girls"
                ]

        Just (Wods.Wodapalooza year) ->
            div
                [ classList
                    [ ( pillStyle, True )
                    , ( "bg-gray-200 text-gray-700", True )
                    ]
                ]
                [ text ("Wodapalooza " ++ String.fromInt year)
                ]

        Nothing ->
            text ""


wodExercises : DecimalSystem -> Wods.WodPart -> Html Msg
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


workoutCategoryButton : Maybe Wods.Category -> Maybe Wods.Category -> String -> Html Msg
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


workoutTypeButton : Maybe Wods.WorkoutType -> Maybe Wods.WorkoutType -> String -> Html Msg
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


listParts : List Wods.WodPart -> Model -> List (Html Msg)
listParts wodParts model =
    wodParts
        |> List.map
            (wodExercises model.decimalSystem)


card : Model -> Wods.Wod -> Html Msg
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
                (case wod.workoutLevel of
                    Wods.RX ->
                        listParts wod.parts model

                    Wods.Scaled ->
                        case wod.scaledParts of
                            Just parts ->
                                listParts parts model

                            Nothing ->
                                listParts wod.parts model
                )
            , case wod.timeCap of
                Just timeCap ->
                    div [ class "mt-4 text-sm text-gray-700" ]
                        [ span
                            [ class
                                "font-semibold"
                            ]
                            [ text "Time cap:" ]
                        , text (" " ++ String.fromInt timeCap ++ " min")
                        ]

                Nothing ->
                    text ""
            , case wod.description of
                Just description ->
                    div [ class "mt-4 text-xs text-gray-500 markdown" ]
                        [ Markdown.toHtml [ class "markdown" ] description
                        ]

                Nothing ->
                    text ""
            , case wod.externalLink of
                Just ( linkText, link ) ->
                    a
                        [ class "text-blue-600 text-xs block mt-2"
                        , href link
                        , rel "noopener noreferrer"
                        , target "_blank"
                        ]
                        [ text linkText
                        ]

                Nothing ->
                    text ""
            ]
        , case wod.scaledParts of
            Just _ ->
                button
                    [ class "bg-gray-200 rounded-b py-3 text-sm text-gray-600 font-semibold hover:bg-gray-300"
                    , onClick (ChangeWorkoutLevel wod)
                    , type_ "button"
                    ]
                    [ case wod.workoutLevel of
                        Wods.RX ->
                            text "Switch to scaled"

                        Wods.Scaled ->
                            text "Switch to RX"
                    ]

            Nothing ->
                text ""
        ]
