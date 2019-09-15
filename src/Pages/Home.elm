module Pages.Home exposing (view)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (DecimalSystem(..), Model, Msg(..))
import View exposing (card)
import Wods exposing (Wod, WorkoutLevel(..))


filterBySearchQuery : String -> Wod -> Bool
filterBySearchQuery query wod =
    let
        lowerCaseQuery =
            query |> String.toLower

        wodName =
            wod.name |> String.toLower
    in
    String.contains lowerCaseQuery wodName


filterBySelectedCategory : Maybe Wods.Category -> Wod -> Bool
filterBySelectedCategory category wod =
    case ( category, wod.category ) of
        ( Just (Wods.Wodapalooza _), Just (Wods.Wodapalooza _) ) ->
            True

        ( Just cat, Just wCat ) ->
            cat == wCat

        ( Just _, Nothing ) ->
            False

        ( Nothing, Just _ ) ->
            True

        ( Nothing, Nothing ) ->
            True


filterBySelectedWorkoutType : Maybe Wods.WorkoutType -> Wod -> Bool
filterBySelectedWorkoutType workoutType wod =
    case ( workoutType, wod.workoutType ) of
        ( Just (Wods.EMOM _), Wods.EMOM _ ) ->
            True

        ( Just w, wt ) ->
            w == wt

        ( Nothing, _ ) ->
            True


view : Model -> List (Html Msg)
view ({ category, workoutType, searchQuery } as model) =
    let
        filteredWods =
            model.wods
                |> List.filter (filterBySearchQuery searchQuery)
                |> List.filter (filterBySelectedCategory category)
                |> List.filter (filterBySelectedWorkoutType workoutType)
                |> List.reverse
                |> List.map (card model)
    in
    [ div [ class "grid mt-10 mb-20" ]
        [ div [ class "grid--center mb-10 md:flex justify-between items-center" ]
            [ div []
                [ div [ class "mb-2" ]
                    [ View.workoutTypeButton workoutType Nothing "All"
                    , View.workoutTypeButton workoutType (Just Wods.ForTime) "For Time"
                    , View.workoutTypeButton workoutType
                        (Just (Wods.EMOM 0))
                        "EMOM"
                    ]
                , div []
                    [ View.workoutCategoryButton category Nothing "All"
                    , View.workoutCategoryButton category (Just Wods.Girl) "Girl"
                    , View.workoutCategoryButton category (Just Wods.Hero) "Hero"
                    , View.workoutCategoryButton category (Just (Wods.Wodapalooza 0)) "Wodapalooza"
                    ]
                ]
            , div [ class "flex items-center mt-4 md:mt-0" ]
                [ button
                    [ class "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                    , onClick UpdateDecimalSystem
                    ]
                    [ case model.decimalSystem of
                        Metric ->
                            text "Imperial"

                        Imperial ->
                            text "Metric"
                    ]
                ]
            ]
        , case filteredWods |> List.length of
            0 ->
                div
                    [ class "bg-white text-center p-8 rounded text-gray-600 css-u6g5pn"
                    ]
                    [ text "I don't have any WODs with this combination yet 💪" ]

            _ ->
                div
                    [ class "grid--cards" ]
                    filteredWods
        ]
    ]
