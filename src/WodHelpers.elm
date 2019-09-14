module WodHelpers exposing (weightToString)

import Types exposing (..)
import Wods exposing (WodWeight(..))


approxPounds : Float
approxPounds =
    2.205


approxInches : Float
approxInches =
    2.54


unitToString : WodWeight -> DecimalSystem -> String
unitToString weight decimalSystem =
    case ( weight, decimalSystem ) of
        ( Kg _, Metric ) ->
            " kg"

        ( Cm _, Metric ) ->
            " cm"

        ( Kg _, Imperial ) ->
            " lbs"

        ( Cm _, Imperial ) ->
            " in"


round5 : Float -> Float
round5 x =
    toFloat (ceiling (x / 5.0)) * 5.0


kgToPounds : Float -> Float
kgToPounds kg =
    if kg == 6.0 then
        14.0

    else if kg == 13.0 then
        33.0

    else if kg == 25.0 then
        55.0

    else if kg == 30.0 then
        65.0

    else
        round5 (kg * approxPounds)


cmToInches : Float -> Float
cmToInches cm =
    if cm == 60.0 then
        24.0

    else if cm == 45.0 then
        20.0

    else
        round5 (cm / approxInches)


toSplit : Float -> Float -> WodWeight -> DecimalSystem -> String
toSplit a b weight decimalSystem =
    case decimalSystem of
        Metric ->
            " ("
                ++ String.fromFloat a
                ++ "/"
                ++ String.fromFloat b
                ++ unitToString weight decimalSystem
                ++ ")"

        Imperial ->
            case weight of
                Kg _ ->
                    " ("
                        ++ String.fromFloat (kgToPounds a)
                        ++ "/"
                        ++ String.fromFloat (kgToPounds b)
                        ++ unitToString weight decimalSystem
                        ++ ")"

                Cm _ ->
                    " ("
                        ++ String.fromFloat (cmToInches a)
                        ++ "/"
                        ++ String.fromFloat (cmToInches b)
                        ++ unitToString weight decimalSystem
                        ++ ")"


weightToString :
    ( Maybe WodWeight, Maybe WodWeight )
    -> DecimalSystem
    -> String
weightToString unit decimalSystem =
    case unit of
        ( Just (Kg a), Just (Kg b) ) ->
            toSplit a b (Kg a) decimalSystem

        ( Just (Cm a), Just (Cm b) ) ->
            toSplit a b (Cm a) decimalSystem

        ( _, _ ) ->
            ""
