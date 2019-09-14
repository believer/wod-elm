module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key)
import Html exposing (Html, button, div, header, li, span, text, ul)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Url exposing (Url)
import Wods exposing (Wod, wods)


type alias Flags =
    {}



---- MODEL ----


type alias Model =
    { category : Maybe Wods.Category
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( { category = Nothing }, Cmd.none )



---- UPDATE ----


type Msg
    = FilterOnCategory (Maybe Wods.Category)
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterOnCategory cat ->
            ( { model | category = cat }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


pill : Maybe Wods.Category -> Html Msg
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


wodExercises : Wods.WodPart -> Html Msg
wodExercises exercise =
    li []
        [ div []
            [ text (Wods.exerciseAmount exercise.reps ++ " ")
            , text (Wods.exerciseToString exercise.exercise)
            , span [ class "text-gray-500" ]
                [ text (Wods.weightToString exercise.weight)
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


displayCard : Wod -> Html Msg
displayCard wod =
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
            , ul [ class "text-gray-700 mt-4" ] (wod.parts |> List.map wodExercises)
            ]
        ]


filterWorkouts : Maybe Wods.Category -> Wod -> Bool
filterWorkouts model wod =
    case ( model, wod.category ) of
        ( Just cat, Just wCat ) ->
            cat == wCat

        ( Just _, Nothing ) ->
            False

        ( Nothing, Just _ ) ->
            True

        ( Nothing, Nothing ) ->
            True


filterButton : Maybe Wods.Category -> Maybe Wods.Category -> String -> Html Msg
filterButton cat newCat innerText =
    button
        [ class "inline-block rounded-full px-3 py-1 text-sm font-semibold\n        text-center bg-gray-200 text-gray-700 mr-4"
        , classList
            [ ( "bg-blue-200 text-blue-700"
              , cat == newCat
              )
            ]
        , onClick (FilterOnCategory newCat)
        ]
        [ text innerText ]


view : Model -> Document Msg
view model =
    { title = "WillWOD"
    , body =
        [ div [ class "grid mt-10 mb-20" ]
            [ div [ class "grid--cards mb-10 md:flex justify-between items-center" ]
                [ div []
                    [ div [ class "mb-2" ]
                        [ filterButton model.category Nothing "All"
                        , filterButton model.category (Just Wods.Girl) "Girl"
                        , filterButton model.category (Just Wods.Hero) "Hero"
                        ]
                    ]
                ]
            , div
                [ class "grid--cards" ]
                (wods |> List.filter (filterWorkouts model.category) |> List.map displayCard)
            ]
        ]
    }



---- PROGRAM ----


onUrlRequest : UrlRequest -> Msg
onUrlRequest _ =
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
