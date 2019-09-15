module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, a, div, header, input, text)
import Html.Attributes
    exposing
        ( class
        , classList
        , href
        , placeholder
        , rel
        , target
        , type_
        , value
        )
import Html.Events exposing (onInput)
import Pages.Glossary as Glossary
import Pages.Home as Home
import Routes
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, viewBox)
import Types exposing (DecimalSystem(..), Model, Msg(..))
import Url exposing (Url)
import Wods exposing (Wod, WorkoutLevel(..), wods)


type alias Flags =
    {}



---- MODEL ----


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { category = Nothing
      , workoutType = Nothing
      , navigationKey = key
      , decimalSystem = Metric
      , wods = wods
      , searchQuery = ""
      , route = Routes.parseUrl url
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navigationKey (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        OnUrlChange url ->
            let
                newRoute =
                    Routes.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )

        FilterOnCategory category ->
            ( { model | category = category }, Cmd.none )

        FilterOnWorkoutType workoutType ->
            ( { model | workoutType = workoutType }, Cmd.none )

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


view : Model -> Document Msg
view model =
    { title = "WillWOD"
    , body =
        [ div [] [ nav model ]
        , currentPage model
        , gitHubCorner
        ]
    }


gitHubCorner : Html Msg
gitHubCorner =
    a
        [ class "github-corner"
        , href "https://github.com/believer/wod-elm"
        , target "_blank"
        , rel "noreferrer noopener"
        ]
        [ svg
            [ Svg.Attributes.width "80"
            , Svg.Attributes.height "80"
            , Svg.Attributes.style "fill:#a0aec0; color:#fff; position: absolute; top: 0; border: 0; right: 0;"
            , viewBox "0 0 250 250"
            ]
            [ path [ d "M0,0 L115,115 L130,115 L142,142 L250,250 L250,0 Z" ]
                []
            , path
                [ d "M128.3,109.0 C113.8,99.7 119.0,89.6 119.0,89.6 C122.0,82.7 120.5,78.6 120.5,78.6 C119.2,72.0 123.4,76.3 123.4,76.3 C127.3,80.9 125.5,87.3 125.5,87.3 C122.9,97.6 130.6,101.9 134.4,103.2"
                , Svg.Attributes.fill "currentColor"
                , Svg.Attributes.class "octo-arm"
                , Svg.Attributes.style "transform-origin: 130px 106px;"
                ]
                []
            , path
                [ d "M115.0,115.0 C114.9,115.1 118.7,116.5 119.8,115.4 L133.7,101.6 C136.9,99.2 139.9,98.4 142.2,98.6 C133.8,88.0 127.5,74.4 143.8,58.0 C148.5,53.4 154.0,51.2 159.7,51.0 C160.3,49.4 163.2,43.6 171.4,40.1 C171.4,40.1 176.1,42.5 178.8,56.2 C183.1,58.6 187.2,61.8 190.9,65.4 C194.5,69.0 197.7,73.2 200.1,77.6 C213.8,80.2 216.3,84.9 216.3,84.9 C212.7,93.1 206.9,96.0 205.4,96.6 C205.1,102.4 203.0,107.8 198.3,112.5 C181.9,128.9 168.3,122.5 157.7,114.1 C157.9,116.9 156.7,120.9 152.7,124.9 L141.0,136.5 C139.8,137.7 141.6,141.9 141.8,141.8 Z"
                , Svg.Attributes.fill "currentColor"
                , Svg.Attributes.class "octo-body"
                ]
                []
            ]
        ]


nav : Model -> Html Msg
nav model =
    header
        [ class "grid mt-16" ]
        [ div
            [ class "flex items-center justify-between border-b pb-4 flex-wrap sm:h-16 grid--center"
            ]
            [ div []
                [ a
                    [ class "mr-8"
                    , classList
                        [ ( "text-blue-500"
                          , model.route
                                == Routes.HomeRoute
                          )
                        ]
                    , href Routes.homePath
                    ]
                    [ text "Workouts" ]
                , a
                    [ classList
                        [ ( "text-blue-500"
                          , model.route
                                == Routes.GlossaryRoute
                          )
                        ]
                    , href Routes.glossaryPath
                    ]
                    [ text "Glossary" ]
                ]
            , case model.route of
                Routes.HomeRoute ->
                    searchField model.searchQuery

                _ ->
                    text ""
            ]
        ]


searchField : String -> Html Msg
searchField searchQuery =
    div [ class "flex text-gray-700 items-center mt-4 sm:mt-0" ]
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


currentPage : Model -> Html Msg
currentPage model =
    let
        page =
            case model.route of
                Routes.HomeRoute ->
                    Home.view model

                Routes.GlossaryRoute ->
                    Glossary.view

                Routes.NotFoundRoute ->
                    notFoundView
    in
    div [] page


notFoundView : List (Html msg)
notFoundView =
    [ div []
        [ text "Not found"
        ]
    ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }
