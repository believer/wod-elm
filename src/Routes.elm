module Routes exposing (Route(..), glossaryPath, homePath, parseUrl)

import Url exposing (Url)
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


type Route
    = GlossaryRoute
    | HomeRoute
    | NotFoundRoute


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map GlossaryRoute (s "glossary")
        , map HomeRoute top
        ]


parseUrl : Url -> Route
parseUrl url =
    case parse routeParser url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


pathFor : Route -> String
pathFor route =
    case route of
        HomeRoute ->
            "/"

        GlossaryRoute ->
            "/glossary"

        NotFoundRoute ->
            "/"


homePath : String
homePath =
    pathFor HomeRoute


glossaryPath : String
glossaryPath =
    pathFor GlossaryRoute
