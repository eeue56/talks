port module RegexExample exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Regex exposing (Regex)
import Json.Decode exposing (Decoder, decodeValue)


type Msg
    = IsValidRegex (Result String String)
    | NewRegex String
    | NoOp


type alias Model =
    { isWaitingOnRegex : Bool
    , userInput : String
    , regex : Result String (Maybe Regex)
    , color : String
    , searchableText : String
    }


defaultText : String
defaultText =
    """

Hello Elm Europe! It's so lovely to see you all in one place.
Hope you have a great time!

"""


init : ( Model, Cmd Msg )
init =
    ( { isWaitingOnRegex = False
      , userInput = ""
      , regex = Ok Nothing
      , color = "white"
      , searchableText = defaultText
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IsValidRegex result ->
            case result of
                Ok regex ->
                    ( { model | isWaitingOnRegex = False, regex = Ok (Just <| Regex.regex regex), color = "green" }, Cmd.none )

                Err message ->
                    ( { model | isWaitingOnRegex = False, regex = Err message, color = "red" }, Cmd.none )

        NewRegex regex ->
            ( { model | isWaitingOnRegex = True, color = "white", userInput = regex }, checkIfValidRegex regex )

        NoOp ->
            ( model, Cmd.none )


viewInvalidRegexError : String -> Html Msg
viewInvalidRegexError error =
    Html.text error


viewGreen : String -> Html Msg
viewGreen str =
    Html.span
        [ Html.Attributes.style [ ( "background-color", "green" ) ] ]
        [ Html.text str ]


viewYellow : String -> Html Msg
viewYellow str =
    Html.span
        [ Html.Attributes.style [ ( "background-color", "yellow" ) ] ]
        [ Html.text str ]


viewSearchableText : Model -> Html Msg
viewSearchableText model =
    case model.regex of
        Ok Nothing ->
            Html.text model.searchableText

        Ok (Just regex) ->
            if Regex.contains regex model.searchableText then
                Regex.replace Regex.All regex (\match -> "|" ++ match.match ++ "|") model.searchableText
                    |> String.split "|"
                    |> List.indexedMap
                        (\i str ->
                            if i % 2 == 0 then
                                Html.text str
                            else
                                viewGreen str
                        )
                    |> Html.div []
            else
                Html.div
                    []
                    [ Html.div [] [ Html.text model.searchableText ]
                    , Html.div
                        [ Html.Attributes.style
                            [ ( "width", "100%" )
                            , ( "border-radius", "3px" )
                            , ( "border-width", "3px" )
                            , ( "border-color", "yellow" )
                            , ( "border-style", "solid" )
                            , ( "margin-top", "30px" )
                            ]
                        ]
                        [ Html.text "Failed to find any matches in the code!" ]
                    ]

        Err message ->
            viewInvalidRegexError message


view : Model -> Html Msg
view model =
    if model.isWaitingOnRegex then
        Html.text "Watiing for the regex to come back.."
    else
        Html.div
            []
            [ Html.input
                [ Html.Attributes.placeholder "Enter a regex!"
                , Html.Events.onInput NewRegex
                , Html.Attributes.style
                    [ ( "width", "100%" )
                    , ( "border-color", model.color )
                    , ( "border-radius", "3px" )
                    , ( "border-width", "3px" )
                    , ( "border-style", "solid" )
                    , ( "margin-bottom", "50px" )
                    ]
                ]
                []
            , viewSearchableText model
            ]


decodeRegex : Decoder (Result String String)
decodeRegex =
    Json.Decode.oneOf
        [ Json.Decode.field "Ok" Json.Decode.string
            |> Json.Decode.map Ok
        , Json.Decode.field "Err" Json.Decode.string
            |> Json.Decode.map Err
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ isValidRegex (decodeValue decodeRegex >> Result.map IsValidRegex >> Result.withDefault NoOp) ]


port checkIfValidRegex : String -> Cmd msg


port isValidRegex : (Json.Decode.Value -> msg) -> Sub msg


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
