module Components exposing (layout)

import Browser exposing (Document)
import Generated.Route as Route exposing (Route)
import Html exposing (..)
import Html.Attributes as Attr exposing (class, href, style)


layout : { page : Document msg } -> Document msg
layout { page } =
    { title = page.title
    , body =
        [ div
            [ style "position" "relative"
            , style "width" "1000px"
            , style "height" "1000px"
            , style "background" "green"
            ]
            page.body
        ]
    }
