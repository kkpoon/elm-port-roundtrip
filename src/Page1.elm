module Page1 exposing (Model, Msg(..), init, subscriptions, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Ports



-- model


type alias Model =
    { key : Nav.Key
    , message : Maybe String
    }


init : Nav.Key -> ( Model, Cmd Msg )
init key =
    ( Model key Nothing, Ports.ping "Page1" )



-- update


type Msg
    = Pong String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Pong message ->
            ( { model | message = Just message }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.pong Pong



-- view


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Page1" ]
        , p [] [ text <| Maybe.withDefault "" model.message ]
        ]
