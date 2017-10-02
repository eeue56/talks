module BadRegexExample exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Regex exposing (Regex)
import Json.Decode exposing (Decoder, decodeValue)


type Msg
    = NewRegex String


type alias Model =
    String


defaultText : String
defaultText =
    """

Hello Elm Europe! It's so lovely to see you all in one place.
Hope you have a great time!

"""


init : ( Model, Cmd Msg )
init =
    ( ""
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update (NewRegex regex) model =
    let
        newRegex =
            Regex.regex regex
    in
        ( regex, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div
        []
        [ Html.input
            [ Html.Attributes.placeholder "Enter a regex!"
            , Html.Events.onInput NewRegex
            , Html.Attributes.style
                [ ( "width", "100%" )
                , ( "border-radius", "3px" )
                , ( "border-width", "3px" )
                , ( "border-style", "solid" )
                , ( "margin-bottom", "50px" )
                ]
            ]
            []
        , Html.text model
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
