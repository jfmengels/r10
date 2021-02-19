module R10.Svg.Others exposing (mobileWithPerson, mountain, spinnerRotation, greenCheck)

{-|

@docs mobileWithPerson, mountain, spinnerRotation, greenCheck

-}

import Element exposing (..)
import R10.Color.Utils
import R10.Svg.Utils
import Svg
import Svg.Attributes as SA


{-| -}
spinnerRotation : List (Attribute msg) -> Int -> String -> Element msg
spinnerRotation attrs size colorString =
    let
        idElement =
            "r10_spinner"

        speed =
            "0.6s"
    in
    R10.Svg.Utils.wrapperWithViewbox attrs
        "0 0 38 38"
        size
        [ Svg.defs []
            [ Svg.linearGradient
                [ SA.id idElement, SA.x1 "8%", SA.x2 "65.7%", SA.y1 "0%", SA.y2 "23.9%" ]
                [ Svg.stop
                    [ SA.offset "0%", SA.stopColor colorString, SA.stopOpacity "0" ]
                    []
                , Svg.stop
                    [ SA.offset "63.1%", SA.stopColor colorString, SA.stopOpacity ".6" ]
                    []
                , Svg.stop
                    [ SA.offset "100%", SA.stopColor colorString ]
                    []
                ]
            ]
        , Svg.g [ SA.fill "none", SA.fillRule "evenodd", SA.transform "translate(1 1)" ]
            [ Svg.path
                [ SA.d "M36 18C36 8 28 0 18 0"
                , SA.stroke <| "url(#" ++ idElement ++ ")"
                , SA.strokeWidth "2"
                ]
                [ Svg.animateTransform
                    [ SA.attributeName "transform"
                    , SA.dur speed
                    , SA.from "0 18 18"
                    , SA.repeatCount "indefinite"
                    , SA.to "360 18 18"
                    , SA.type_ "rotate"
                    ]
                    []
                ]
            , Svg.circle [ SA.cx "36", SA.cy "18", SA.fill colorString, SA.r "1" ]
                [ Svg.animateTransform
                    [ SA.attributeName "transform"
                    , SA.dur speed
                    , SA.from "0 18 18"
                    , SA.repeatCount "indefinite"
                    , SA.to "360 18 18"
                    , SA.type_ "rotate"
                    ]
                    []
                ]
            ]
        ]


{-| -}
mobileWithPerson : List (Attribute msg) -> Color -> Int -> Element msg
mobileWithPerson attrs cl size =
    let
        clHex =
            R10.Color.Utils.toCssRgba cl
    in
    R10.Svg.Utils.wrapperWithViewbox attrs
        "0 0 209 160"
        size
        [ Svg.path [ SA.fill "#F2F2F2", SA.d "M102.7 160c45.57 0 82.5-4.03 82.5-9s-36.93-9-82.5-9c-45.56 0-82.5 4.03-82.5 9s36.94 9 82.5 9z" ] []
        , Svg.path [ SA.fill "#181818", SA.stroke "#CBCBCB", SA.strokeWidth ".3", SA.d "M49.14 150.55h0a6.45 6.45 0 01-4.42-1.76 6 6 0 01-1.83-4.26V7.13v0a5.84 5.84 0 011.83-4.26 6.27 6.27 0 014.42-1.77h57.79a6.44 6.44 0 014.42 1.77 6.04 6.04 0 011.83 4.26v137.4c0 1.6-.66 3.13-1.84 4.25a6.37 6.37 0 01-4.41 1.77h-57.8z" ] []
        , Svg.path [ SA.fill "#3F3D56", SA.d "M111.07 9v133.7a6 6 0 01-6 6H50.78a6 6 0 01-6.01-6V9a6 6 0 016-6h8.13v1.04A4.95 4.95 0 0063.86 9h27.6a4.9 4.9 0 004.55-3c.26-.62.4-1.28.4-1.95V3h8.65a6.01 6.01 0 016 6z" ] []
        , Svg.path [ SA.fill "#F2F2F2", SA.d "M59.9 26.72a1.44 1.44 0 100-2.89 1.44 1.44 0 000 2.89z" ] []
        , Svg.path [ SA.fill clHex, SA.d "M94.88 7.62c-.15.14-.32.28-.49.4a25.83 25.83 0 0016.68 12.42v-.65a25.22 25.22 0 01-16.2-12.17zM82.54 8.99h-.67a37.47 37.47 0 0029.2 23.32v-.64A36.83 36.83 0 0182.54 8.99z" ] []
        , Svg.path [ SA.fill "#F2F2F2", SA.d "M55.16 35.96h-.38v-.37h-.07v.37h-.38v.08h.38v.37h.07v-.37h.38v-.08zM80.52 17.2h-.37v-.38h-.08v.37h-.37v.08h.37v.37h.08v-.37h.37v-.08zM58.87 50.81h-.38v-.37h-.07v.37h-.38v.08h.38v.37h.07v-.37h.38v-.08zM76.2 39.88h-.38v-.37h-.08v.37h-.37v.07h.37v.38h.08v-.38h.37v-.07zm24.74 6.81h-.37v-.38h-.08v.38h-.37v.07h.37v.38h.08v-.38h.37v-.07z" ] []
        , Svg.path [ SA.fill "#FF6584", SA.d "M96.61 29.6a.82.82 0 100-1.64.82.82 0 000 1.65z" ] []
        , Svg.path [ SA.fill "#E6E6E6", SA.d "M67.06 48.13l-.47.07c.14.94.26 1.9.34 2.84l.48-.04c-.09-.96-.2-1.93-.35-2.87zm-1.28-5.64l-.46.14c.28.9.52 1.83.73 2.76l.46-.1a42.2 42.2 0 00-.73-2.8zm-2.05-5.41l-.43.2c.4.86.77 1.75 1.1 2.64l.45-.17c-.34-.9-.72-1.8-1.12-2.67zm-2.76-5.07l-.4.25c.5.8 1 1.63 1.45 2.46l.42-.22a47.8 47.8 0 00-1.47-2.49zm-3.44-4.65l-.36.31a42.3 42.3 0 011.78 2.24l.38-.28a41.22 41.22 0 00-1.8-2.27zm-4.03-4.13l-.32.35c.7.63 1.4 1.3 2.06 1.98l.34-.33a41.59 41.59 0 00-2.09-2zm-4.57-3.55l-.26.39c.78.53 1.56 1.1 2.31 1.68l.3-.38a42.83 42.83 0 00-2.35-1.7zm-4.15-2.48v.54c.5.26.98.53 1.46.8l.24-.4c-.56-.32-1.13-.63-1.7-.93zm22.17 75.48c.08-.46.15-.94.2-1.4l.48.06-.21 1.41-.47-.07zm-1.32 5.56l.45.14c.28-.91.54-1.85.76-2.79l-.46-.1a42.5 42.5 0 01-.75 2.75zm-2.07 5.33l.43.2c.4-.87.79-1.76 1.14-2.66l-.45-.17a40.7 40.7 0 01-1.12 2.63zm-2.79 5l.4.26c.52-.8 1.02-1.64 1.5-2.48l-.42-.23c-.46.83-.96 1.65-1.48 2.45zm-3.45 4.56l.36.31a43.5 43.5 0 001.82-2.25l-.38-.28a41.8 41.8 0 01-1.8 2.22zm-4.04 4.06l.32.35a39.3 39.3 0 002.1-1.98l-.33-.33c-.67.67-1.37 1.33-2.09 1.95zm-4.54 3.46l.26.4c.8-.53 1.6-1.1 2.36-1.68l-.29-.38a41.6 41.6 0 01-2.33 1.66zm-2.21 1.9c-.57.33-1.16.64-1.75.94v-.54a43.4 43.4 0 001.52-.8l.23.4zm20.56-68.59h.47v1.43l-.47-.01v-1.42z" ] []
        , Svg.path [ SA.fill "#fff", SA.d "M46.86 65.21h48.51A13.61 13.61 0 01109 78.82v1.8H60.47a13.61 13.61 0 01-13.6-13.6v-1.8z" ] []
        , Svg.path [ SA.fill clHex, SA.d "M66.7 89.42a16.5 16.5 0 100-33 16.5 16.5 0 000 33z", SA.opacity ".2" ] []
        , Svg.path [ SA.fill clHex, SA.d "M66.7 84.54a11.62 11.62 0 100-23.24 11.62 11.62 0 000 23.24z", SA.opacity ".2" ] []
        , Svg.path [ SA.fill clHex, SA.d "M66.7 80.59a7.67 7.67 0 100-15.34 7.67 7.67 0 000 15.34z" ] []
        , Svg.path [ SA.fill "#fff", SA.d "M68.1 71.26a1.4 1.4 0 10-2.28 1.08l-.5 3.6h2.78l-.51-3.6a1.4 1.4 0 00.51-1.08z" ] []
        , Svg.path [ SA.fill "#2F2E41", SA.d "M143.78 14s-4.6-4.13-10.79 3.64c-6.19 7.77-15.86 11.58-18.08 14.6 0 0 9.2-3.81 12.37-5.4 3.17-1.59 3.01-1.27 3.01-1.27s-4.28 3.02-5.07 6.03c-.8 3.01-.16 5.55-1.59 8.56-1.42 3.02 27.28 2.07 27.28 2.07s2.86-4.92 2.06-10c-.79-5.07-.31-17.6-9.2-18.24z" ] []
        , Svg.path [ SA.fill "#F4C6C6", SA.d "M135.08 26.97s1 7-3.29 8.57c-4.29 1.57-2.72 3.71-2.72 3.71l6.44 3.15 6.85-2.15 2.29-3.42s-3.72-.86-2.72-3.43c1-2.58 1.29-3.43 1.29-3.43l-8.14-3z" ] []
        , Svg.path [ SA.fill "#000", SA.d "M135.08 26.97s1 7-3.29 8.57c-4.29 1.57-2.72 3.71-2.72 3.71l6.44 3.15 6.85-2.15 2.29-3.42s-3.72-.86-2.72-3.43c1-2.58 1.29-3.43 1.29-3.43l-8.14-3z", SA.opacity ".1" ] []
        , Svg.path [ SA.fill "#F4C6C6", SA.d "M153.08 46.97s-1 13.15-.72 13.72c.3.57 0 20.43 0 20.43s2 10.72-.57 11.29c-2.57.57-2-12-2-12l-2.57-16.58.29-16.43 5.57-.43z" ] []
        , Svg.path [ SA.fill "#000", SA.d "M153.08 46.97s-1 13.15-.72 13.72c.3.57 0 20.43 0 20.43s2 10.72-.57 11.29c-2.57.57-2-12-2-12l-2.57-16.58.29-16.43 5.57-.43z", SA.opacity ".1" ] []
        , Svg.path [ SA.fill "#F4C6C6", SA.d "M125.22 86.55s-4.72 17.86-4.58 26.58c.15 8.71 2 20.86 2 20.86s.3 5.28-.14 5.86c-.43.57 2.14 3 2.14 3l2.72-1.57 1-1.15v-1s-1.57-4.86-.29-8.71c1.3-3.86 2-13.58.72-16.58l8.86-26.29-12.43-1z" ] []
        , Svg.path [ SA.fill "#2F2E41", SA.d "M124.93 140.56s-1.71-2.14-2.86-1.43c-1.14.72-3 5.57-3 5.57s-6.43 6.15-1.85 6.43c4.57.29 6.57-1.28 7.14-2.42.57-1.15 5.86-4.15 5.86-4.15s-.57-5.43-1.43-5.57c-.86-.14-2.14 2.14-2.14 2.14l-1.72-.57z" ] []
        , Svg.path [ SA.fill "#F4C6C6", SA.d "M140.8 87.7v17.71c0 2.15.15 4.3.42 6.43.43 3.14-2.43 26.58-2.43 26.58l.29 4.14 3.57-.28.43-3.58 5.14-15.71s1.72-9.58.86-13.15c-.86-3.57 4.43-26.43 4.43-26.43l-12.72 4.28z" ] []
        , Svg.path [ SA.fill "#2F2E41", SA.d "M137.93 141.56l1.06-.23s.8-1.77 1.8-1.34c.7.32 1.37.72 1.99 1.2l.44.8s1 2.14 2.29 3.57c1.28 1.43 2.71 4.57.57 4.86-2.15.29-5 .43-5.86-.29-.86-.71-.29-1.85-1.14-2.14-.86-.28-1.58-1.14-1.43-1.43.14-.28.28-5 .28-5z" ] []
        , Svg.path [ SA.fill "#F4C6C6", SA.d "M140.8 31.89a6.35 6.35 0 100-12.7 6.35 6.35 0 000 12.7z" ] []
        , Svg.path [ SA.fill clHex, SA.d "M128.79 36.68l1.89-.66s-.75 1.23 3.25 1.95c4 .71 8.15.97 10-1.38 0 0 .72-.34 1.72.66s1.57.72 1.57.72l-.71 3.71-1.43 6.86-1.86 5.15-5.29-1.15-5.71-4.14-2.15-5.57v-5.15l-1.28-1z" ] []
        , Svg.path [ SA.fill clHex, SA.d "M146.22 38.68l1.43-1s4.86.86 5.14 3.15l-3.71 7.14c.76 1.99.7 4.2-.14 6.14-1.43 3.3-1.29 4-1.29 4l-1 4.3-18.15 1.42s-.71-1.71-1-2c-.28-.29-.28-1.29 0-1.29.29 0 0-.42-.28-.85-.29-.43-.43-.57 0-1.15.43-.57-.72-5.71-.72-5.71v-5.57l-4.86-6.43s1.72-2.58 2.58-2.86c.85-.29 4.93-1.41 4.93-1.41l.92 1.35 1.3 10.35 1.85 6.28 7.82-1.33 3.04-5.1 2-6 .14-3.43z" ] []
        , Svg.path [ SA.fill clHex, SA.d "M151.65 39.97l1.14.86s1 8 .72 8.57c-.29.57-5.29 1.14-5.43.86-.14-.29 3.57-10.3 3.57-10.3z" ] []
        , Svg.path [ SA.fill "#2F2E41", SA.d "M128.07 35.97l1.43 9.43s-1.28 14-1 16.86l.29.86s-.57-.29-.72.28c-.14.57 0 2.43 0 2.43s-.85.86-1.14 5.57c-.28 4.72-3.71 16-2.43 16.44 1.29.42 9 2.57 13.15 2.14 4.14-.43 19-5.43 18.86-6.72-.14-1.28-7.29-19.43-7.29-19.43s-1.28-2.14-1.28-2.43c0-.28 1.71-1.43 1.28-2.57-.43-1.14-2.71-13.15-2.71-13.15l1.57-8.57-2.15-.57-1.57 8.29s-6.14 3-12.57.28l-1.43-9.71-2.29.57zm6.88-14.99s10.57 7.29 13.43 4c2.86-3.29-5-6.14-5-6.14l-6.57-.72-1.86 2.86z" ] []
        , Svg.path [ SA.fill clHex, SA.d "M118.52 98.5a5.57 5.57 0 10-1.75-2.17l-14.58 12.14-1.94-2.3-.88.58-.97-1.15.8-.67-.97-1.16-1.24 1.05.6.71-1.33 1.12-.6-.7-1.95 1.63.9 1.07.7-.6.98 1.15-.89.75 1.8 2.13-2.13 1.79 2.16 2.57 21.3-17.94zm3.64-8.14a3.69 3.69 0 11-.63 7.34 3.69 3.69 0 01.63-7.34z" ] []
        , Svg.path [ SA.fill "#F4C6C6", SA.d "M120.64 48.69s1 13.14.72 13.71c-.29.57 0 20.43 0 20.43s-2 10.72.57 11.3c2.57.56 2-12.01 2-12.01l2.57-16.57-.28-16.44-5.58-.42z" ] []
        , Svg.path [ SA.fill clHex, SA.d "M122.79 40.4l-1.15.43s-2.14 9-1.57 9c.58 0 7.43.86 7.43.57 0-.29-1.28-7.29-1.28-7.29l-3.43-2.71z" ] []
        ]


{-| -}
mountain : List (Attribute msg) -> Int -> Element msg
mountain attrs size =
    R10.Svg.Utils.wrapperWithViewbox attrs
        "0 0 152 148"
        size
        [ Svg.g [ SA.fill "none" ]
            [ Svg.mask [ SA.id "a", SA.width "152", SA.height "152", SA.x "0", SA.y "0", SA.maskUnits "userSpaceOnUse" ]
                [ Svg.path [ SA.fill "#fff", SA.d "M73.8 148A74 74 0 1 0 73.7.2a74 74 0 0 0 .1 147.8z" ] []
                ]
            , Svg.g [ SA.mask "url(#a)" ]
                [ Svg.path [ SA.fill "#98C9F2", SA.d "M73.8 148A74 74 0 1 0 73.7.2a74 74 0 0 0 .1 147.8z" ] []
                , Svg.path [ SA.fill "#B58A5A", SA.fillRule "evenodd", SA.d "M29.9 92.4L4.5 138.2c15.8 12.8 33.3 14.6 52.5 5.3-1-3.9-10-21-27.1-51.1z", SA.clipRule "evenodd" ] []
                , Svg.path [ SA.fill "#B58A5A", SA.fillRule "evenodd", SA.d "M29.9 92.4L4.5 138.2c6.9 9.1 15.9 11.7 27 7.8-.5-3.6-1-21.5-1.6-53.6z", SA.clipRule "evenodd" ] []
                , Svg.path [ SA.fill "#fff", SA.fillRule "evenodd", SA.d "M29.9 91.7l-9.1 17-2.6 7.2 4.3-5.8 1 9.7 3.7-10.5 4.2 9.4 1.5-8.8 2.6 4.3 1.7-4.3 3.4 4.8-1.3-5.5-9.4-17.5z", SA.clipRule "evenodd" ] []
                , Svg.path [ SA.fill "#C49A6C", SA.fillRule "evenodd", SA.d "M74.5 43.1L23.8 134c31.7 25.4 66.6 28.9 105 10.4-2-7.6-20.1-41.4-54.3-101.3z", SA.clipRule "evenodd" ] []
                , Svg.path [ SA.fill "#BD9263", SA.fillRule "evenodd", SA.d "M74.5 43.1L23.8 134c13.7 18 31.7 23.2 54 15.4-1-7.2-2.1-42.7-3.3-106.3z", SA.clipRule "evenodd" ] []
                , Svg.path [ SA.fill "#fff", SA.fillRule "evenodd", SA.d "M74.5 41.7L56.3 75.4l-5.1 14.4 8.6-11.6 2 19.2 7.5-20.8 8.3 18.6 2.9-17.4 5.3 8.6 3.3-8.6 6.9 9.5-2.6-10.8-19-34.8z", SA.clipRule "evenodd" ] []
                , Svg.g [ SA.fillRule "evenodd", SA.clipRule "evenodd" ]
                    [ Svg.path [ SA.fill "#C99F72", SA.d "M116.9 100.4l-25.4 45.8c15.8 12.8 33.3 14.6 52.5 5.3-1-3.9-10-21-27.1-51.1z" ] []
                    , Svg.path [ SA.fill "#C99F72", SA.d "M116.9 100.4l-25.4 45.8c6.9 9.1 15.9 11.7 27 7.8-.5-3.6-1-21.5-1.6-53.6z" ] []
                    , Svg.path [ SA.fill "#fff", SA.d "M116.9 99.7l-9.1 17-2.6 7.2 4.3-5.8 1 9.7 3.7-10.5 4.2 9.4 1.5-8.8 2.6 4.3 1.7-4.3 3.4 4.8-1.3-5.5-9.4-17.5z" ] []
                    ]
                , Svg.g [ SA.fillRule "evenodd", SA.clipRule "evenodd" ]
                    [ Svg.path [ SA.fill "#FFFEFB", SA.d "M74 18.8l-.1 23h-.6v2.5h2.5v-2.6h-.6v-23H74z" ] []
                    , Svg.path [ SA.fill "#BF0000", SA.d "M75.2 19.3H54.1l3 5.6-3 5.9h21.1V19.4z" ] []

                    --
                    -- Removing the rakuten logo from inside the little flag
                    --
                    -- , Svg.path [ SA.fill "#fff", SA.d "M65.7 23.6h-.5v1.3h.5c.3 0 .6-.3.6-.7 0-.4-.3-.6-.6-.6z" ] []
                    -- , Svg.path [ SA.fill "#fff", SA.d "M66.8 27l-1-1.3h-.5V27h-.8v-4.3h1.3c.8 0 1.4.7 1.4 1.5 0 .5-.2 1-.6 1.2l1.2 1.6h-1zm-1-6.1a4 4 0 0 0-3.8 4 4 4 0 0 0 3.8 4 4 4 0 0 0 3.8-4 4 4 0 0 0-3.8-4z" ] []
                    ]
                , Svg.path [ SA.fill "#FCF9E8", SA.fillRule "evenodd", SA.d "M89 42.4s.6-5 7.7-5.3c1.4-9.3 12.9-3.8 14-.4 4-1 6.2 1.4 6.6 3.9 2-.5 3.3 1.7 3.3 1.7h-26l-5.6.1zm46.1 16.8s.7-5 7.8-5.3c1.3-9.3 12.8-3.8 14-.4 4-.9 6.1 1.5 6.5 4 2-.6 3.4 1.6 3.4 1.6h-26.1l-5.6.1z", SA.clipRule "evenodd" ] []
                ]
            ]
        ]


{-| -}
greenCheck : List (Attribute msg) -> Int -> Element msg
greenCheck attrs size =
    R10.Svg.Utils.wrapperWithViewbox attrs
        "0 0 131 130"
        size
        [ Svg.circle [ SA.fill "#ECFBEC", SA.cx "65.5", SA.cy "65", SA.r "65" ] []
        , Svg.circle [ SA.fill "#ECFBEC", SA.cx "66", SA.cy "64.5", SA.r "40.5", SA.stroke "#00A400", SA.strokeWidth "4" ] []
        , Svg.path [ SA.fill "#ECFBEC", SA.stroke "#00A400", SA.strokeLinecap "round", SA.strokeLinejoin "round", SA.strokeWidth "4", SA.d "M44.4 65.5L59.9 81l30.6-31" ] []
        ]
