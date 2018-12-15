module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Json.Encode as E
import Page1
import Page2
import Url


type Model
    = Page1 Page1.Model
    | Page2 Page2.Model


init : E.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init val url key =
    case url.fragment of
        Just "page1" ->
            transitTo Page1 Page1Msg <| Page1.init key

        Just "page2" ->
            transitTo Page2 Page2Msg <| Page2.init key

        _ ->
            Page1.init key |> transitTo Page1 Page1Msg


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | Page1Msg Page1.Msg
    | Page2Msg Page2.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        key =
            case model of
                Page1 pageModel ->
                    pageModel.key

                Page2 pageModel ->
                    pageModel.key
    in
    case ( msg, model ) of
        ( UrlChanged url, _ ) ->
            case url.fragment of
                Just "page1" ->
                    transitTo Page1 Page1Msg <| Page1.init key

                Just "page2" ->
                    transitTo Page2 Page2Msg <| Page2.init key

                _ ->
                    ( model, Cmd.none )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model, Nav.pushUrl key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( Page1Msg subMsg, Page1 subModel ) ->
            Page1.update subMsg subModel |> transitTo Page1 Page1Msg

        ( Page2Msg subMsg, Page2 subModel ) ->
            Page2.update subMsg subModel |> transitTo Page2 Page2Msg

        ( _, _ ) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Page1 subModel ->
            Sub.map Page1Msg <| Page1.subscriptions subModel

        Page2 subModel ->
            Sub.map Page2Msg <| Page2.subscriptions subModel


view : Model -> Browser.Document Msg
view model =
    { title = ""
    , body =
        [ a [ href "#page1" ] [ text "Page 1" ]
        , span [] [ text " | " ]
        , a [ href "#page2" ] [ text "Page 2" ]
        , page model
        ]
    }


page : Model -> Html Msg
page model =
    case model of
        Page1 subModel ->
            Html.map Page1Msg <| Page1.view subModel

        Page2 subModel ->
            Html.map Page2Msg <| Page2.view subModel



-- helpers


transitTo : (a -> Model) -> (b -> Msg) -> ( a, Cmd b ) -> ( Model, Cmd Msg )
transitTo toMainModel toMainMsg ( destModel, destMsg ) =
    ( toMainModel destModel, Cmd.map toMainMsg destMsg )



-- main


main : Program E.Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
