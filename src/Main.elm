module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
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
view ({ category, workoutType } as model) =
    let
        filteredWods =
            model.wods
                |> List.filter (filterBySelectedCategory category)
                |> List.filter (filterBySelectedWorkoutType workoutType)
                |> List.reverse
                |> List.map (card model)
    in
    { title = "WillWOD"
    , body =
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
