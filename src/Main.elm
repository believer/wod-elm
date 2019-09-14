module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (div)
import Html.Attributes exposing (class)
import Types exposing (..)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>))
import View exposing (card)
import Wods exposing (Wod, wods)


type alias Flags =
    {}



---- MODEL ----


type alias Model =
    { category : Maybe Wods.Category
    , workoutType : Maybe Wods.WorkoutType
    , navigationKey : Key
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ _ key =
    ( { category = Nothing, workoutType = Nothing, navigationKey = key }, Cmd.none )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterOnCategory category ->
            ( { model | category = category }, Cmd.none )

        FilterOnWorkoutType workoutType ->
            ( { model | workoutType = workoutType }, Cmd.none )

        UrlChanged url ->
            let
                _ =
                    Debug.log "url" url
            in
            ( model, Nav.pushUrl model.navigationKey (Url.toString url) )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


filterBySelectedCategory : Maybe Wods.Category -> Wod -> Bool
filterBySelectedCategory category wod =
    case ( category, wod.category ) of
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
view { category, workoutType } =
    { title = "WillWOD"
    , body =
        [ div [ class "grid mt-10 mb-20" ]
            [ div [ class "grid--cards mb-10 md:flex justify-between items-center" ]
                [ div []
                    [ div [ class "mb-2" ]
                        [ View.workoutCategoryButton category Nothing "All"
                        , View.workoutCategoryButton category (Just Wods.Girl) "Girl"
                        , View.workoutCategoryButton category (Just Wods.Hero) "Hero"
                        ]
                    , div []
                        [ View.workoutTypeButton workoutType Nothing "All"
                        , View.workoutTypeButton workoutType (Just Wods.ForTime) "For Time"
                        , View.workoutTypeButton workoutType
                            (Just (Wods.EMOM 0))
                            "EMOM"
                        ]
                    ]
                ]
            , div
                [ class "grid--cards" ]
                (wods
                    |> List.filter (filterBySelectedCategory category)
                    |> List.filter (filterBySelectedWorkoutType workoutType)
                    |> List.map card
                )
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
