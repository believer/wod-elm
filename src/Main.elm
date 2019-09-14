module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (button, div, header, input, text)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, viewBox)
import Types exposing (..)
import Url exposing (Url)
import View exposing (card)
import Wods exposing (Wod, WorkoutLevel(..), wods)


type alias Flags =
    {}



---- MODEL ----


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ _ key =
    ( { category = Nothing
      , workoutType = Nothing
      , navigationKey = key
      , decimalSystem = Metric
      , wods = wods
      , searchQuery = ""
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterOnCategory category ->
            ( { model | category = category }, Cmd.none )

        FilterOnWorkoutType workoutType ->
            ( { model | workoutType = workoutType }, Cmd.none )

        UrlChanged url ->
            ( model, Nav.pushUrl model.navigationKey (Url.toString url) )

        UpdateDecimalSystem ->
            case model.decimalSystem of
                Metric ->
                    ( { model | decimalSystem = Imperial }, Cmd.none )

                Imperial ->
                    ( { model | decimalSystem = Metric }, Cmd.none )

        ChangeWorkoutLevel wod ->
            ( { model
                | wods =
                    model.wods
                        |> List.map
                            (toggleWorkoutLevel wod.name)
              }
            , Cmd.none
            )

        UpdateQuery query ->
            ( { model | searchQuery = query }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


toggleWorkoutLevel : String -> Wod -> Wod
toggleWorkoutLevel name wod =
    if wod.name == name then
        case wod.workoutLevel of
            RX ->
                { wod | workoutLevel = Scaled }

            Scaled ->
                { wod | workoutLevel = RX }

    else
        wod



---- VIEW ----


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


view : Model -> Document Msg
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
    { title = "WillWOD"
    , body =
        [ header [ class "grid mt-16" ]
            [ div
                [ class "flex items-center justify-between border-b pb-4 flex-wrap sm:h-16 grid--center"
                ]
                [ div [] []
                , div [ class "flex text-gray-700 items-center mt-4 sm:mt-0" ]
                    [ div
                        [ class "bg-gray-200 flex items-center px-4 py-3 border-2 border-gray-200 focus-within:bg-white rounded focus-within:border-blue-400"
                        ]
                        [ svg
                            [ viewBox "0 0 20 20"
                            , Svg.Attributes.class "w-4 mr-4"
                            ]
                            [ path
                                [ Svg.Attributes.class "fill-current"
                                , d "M12.9 14.32a8 8 0 1 1 1.41-1.41l5.35 5.33-1.42 1.42-5.33-5.34zM8 14A6 6 0 1 0 8 2a6 6 0 0 0 0 12z"
                                ]
                                []
                            ]
                        , input
                            [ class "appearance-none block w-full bg-transparent text-gray-700 leading-tight focus:outline-none"
                            , placeholder "Find workout"
                            , type_ "text"
                            , onInput UpdateQuery
                            , value searchQuery
                            ]
                            []
                        ]
                    ]
                ]
            ]
        , div [ class "grid mt-10 mb-20" ]
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
    }



---- PROGRAM ----


onUrlRequest : UrlRequest -> Msg
onUrlRequest urlRequest =
    case urlRequest of
        Browser.Internal url ->
            UrlChanged url

        Browser.External _ ->
            NoOp


onUrlChange : Url -> Msg
onUrlChange _ =
    NoOp


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }
