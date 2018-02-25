module SampleApp.GameUI where

import Prelude ((/), (<>))
import SampleApp.Types
import Data.Number.Format (toString)
import PrestoDOM.Core (Prop)
import PrestoDOM.Elements (linearLayout, textView, relativeLayout)
import PrestoDOM.Events (onClick)
import PrestoDOM.Properties (background, color, fontStyle, gravity, height, id_, margin, name, orientation, padding, text, textSize, weight, width, visibility)
import PrestoDOM.Types (Length(..), VDom)

-- | The Primary Game Screen
windowScreen :: forall r p. AppState -> VDom (Array (Prop p)) r
windowScreen state = relativeLayout
              [ id_ "rootScreen"
              , height Match_Parent
              , width Match_Parent
              , orientation "vertical"
              ]
              [   screenToShow
              ] where
                screenToShow = case state.currentScreen of 
                                      FirstScreen -> getFirstScreen state
                                      SecondScreen ->  getSecondScreen state
                                      ThirdScreen ->  getThirdScreen state
                                      _ ->  getFirstScreen state
                    

getScreenChangeUI name1 name2 = linearLayout
                        [ height (V 100)
                        , width Match_Parent
                        , gravity "center_vertical"
                        , background "#ff0000"
                        ]
                        [
                          textView
                          [ name (name1)
                          , height (V 50 )
                          , width (V 0 )
                          , weight "1"
                          , text "Back"
                          ]
                          , textView
                          [ name (name2)
                          , height (V 50 )
                          , width (V 0 )
                          , weight "1"
                          , text "Next"
                          ]
                        ]


getFirstScreen :: forall r p. AppState -> VDom (Array (Prop p)) r
getFirstScreen state = linearLayout
                        [ id_ "firstScreenHolder"
                        , height Match_Parent
                        , width Match_Parent
                        , gravity "center_vertical"
                        , orientation "vertical"
                        , background "#ff0000"
                        ]
                        [
                          textView
                          [ height (V 50 )
                          , width (V 50 )
                          , text "Screen 1"
                          ]
                          , getScreenChangeUI "back1" "next1"
                        ]
getSecondScreen :: forall r p. AppState -> VDom (Array (Prop p)) r
getSecondScreen state = linearLayout
                        [ id_ "secondScreenHolder"
                        , height Match_Parent
                        , width Match_Parent
                        , gravity "center_vertical"
                        , orientation "vertical"
                        , background "#00ff00"
                        ]
                        [
                          textView
                          [ height (V 50 )
                          , width (V 50 )
                          , text "Screen 2"
                          ]
                          , getScreenChangeUI "back2" "next2"
                        ]
getThirdScreen :: forall r p. AppState -> VDom (Array (Prop p)) r
getThirdScreen state = linearLayout
                        [ id_ "thirdScreenHolder"
                        , height Match_Parent
                        , width Match_Parent
                        , gravity "center_vertical"
                        , orientation "vertical"
                        , background "#0000ff"
                        ]
                        [
                          textView
                          [ height (V 50 )
                          , width (V 50 )
                          , text "Screen 3"
                          ]
                          , getScreenChangeUI "back3" "next3"
                        ]
