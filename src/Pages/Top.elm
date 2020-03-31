module Pages.Top exposing (Flags, Model, Msg, page)

import Browser.Events
import Html exposing (..)
import Html.Attributes as Attr exposing (alt, class, href, src, style)
import Json.Decode as D exposing (Decoder)
import Page exposing (Document, Page)
import Set exposing (Set)


type alias Flags =
    ()


type alias Model =
    { keys : Set Key
    , position : Position
    }


type alias Position =
    { x : Float, y : Float }


type Msg
    = Pressed Key
    | Released Key
    | Render Float


type alias Key =
    ( Float, Float )


page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { keys = Set.empty
      , position =
            { x = 200
            , y = 500
            }
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Pressed key ->
            ( { model | keys = Set.insert key model.keys }
            , Cmd.none
            )

        Released key ->
            ( { model | keys = Set.remove key model.keys }
            , Cmd.none
            )

        Render delta ->
            let
                speed =
                    delta / 6
            in
            ( { model
                | position =
                    model.keys
                        |> Set.foldl (\( x1, y1 ) ( x2, y2 ) -> ( (speed * x1) + x2, (speed * y1) + y2 )) ( model.position.x, model.position.y )
                        |> (\( x, y ) -> Position x y)
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        key : (Key -> Msg) -> Decoder Msg
        key toMsg =
            D.field "code" D.string
                |> D.andThen
                    (\code ->
                        case code of
                            "KeyW" ->
                                D.succeed (toMsg ( 0, -1 ))

                            "KeyS" ->
                                D.succeed (toMsg ( 0, 1 ))

                            "KeyA" ->
                                D.succeed (toMsg ( -1, 0 ))

                            "KeyD" ->
                                D.succeed (toMsg ( 1, 0 ))

                            _ ->
                                D.fail ""
                    )
    in
    Sub.batch
        [ Browser.Events.onKeyDown (key Pressed)
        , Browser.Events.onKeyUp (key Released)
        , Browser.Events.onAnimationFrameDelta Render
        ]


view : Model -> Document Msg
view model =
    { title = "Top"
    , body =
        [ img
            [ style "width" "100px"
            , style "height" "auto"
            , style "position" "absolute"
            , style "top" "0"
            , style "left" "0"
            , style "transform" ("translate(" ++ toPixels model.position.x ++ ", " ++ toPixels model.position.y ++ ")")
            , src "/images/tony.jpg"
            ]
            []
        , img
            [ style "width" "75px"
            , style "height" "auto"
            , style "position" "absolute"
            , style "left" "800px"
            , style "top" "100px"
            , src "/images/bossman_racoon.jpg"
            ]
            []
        ]
    }


toPixels : Float -> String
toPixels pixels =
    String.fromFloat pixels ++ "px"
