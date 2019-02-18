port module Main exposing (..)

import Browser
import Html exposing (Html, audio, button, div, text)
import Html.Attributes exposing (autoplay, controls, id, src)
import Html.Events exposing (onClick)

type alias Model =
  { recording : Bool
  , audio_url: Maybe String
  }

type Msg
  = StartRecording
  | StopRecording
  | PlayRecording String

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : () -> (Model, Cmd Msg)
init _ =
  ( { recording = False, audio_url = Nothing }, Cmd.none )

view : Model -> Html Msg
view model =
  let
    attributes = case model.audio_url of
        Just str ->
          [id "player", controls True, src str, autoplay True]
        Nothing ->
          [id "player", controls True]
    btn = if model.recording then
            button [onClick StopRecording] [ text "停止" ]
          else
            button [onClick StartRecording] [ text "録音" ]
  in
  div []
    [ div []
      [ audio attributes []
      ]
    , btn
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    StartRecording ->
      ({ model | recording = True, audio_url = Nothing }, (start_recording ()))
    StopRecording ->
      ({ model | recording = False }, (stop_recording ()))
    PlayRecording str ->
      ({ model | audio_url = Just str }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  play_recording PlayRecording

port start_recording : () -> Cmd msg
port stop_recording : () -> Cmd msg
port play_recording : (String -> msg) -> Sub msg
