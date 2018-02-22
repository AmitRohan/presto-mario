module Mario.GameUI where


import PrestoDOM.Core (Prop)
import PrestoDOM.Elements (linearLayout, textView)
import PrestoDOM.Events (onClick)
import PrestoDOM.Properties (background, color, fontStyle, gravity, height, id_, margin, name, text, weight, width)
import PrestoDOM.Types (Length(..), VDom)



import Mario.GameConfig as GameConfig

getApplyButtonUI :: forall t18 t19 t38.             
  { name :: String              
  , buttonColor :: String       
  , text :: String              
  | t38                         
  }                             
  -> VDom (Array (Prop t19)) t18
getApplyButtonUI state = linearLayout
                            [
                              name (state.name)
                            , height (V 40)
                            , width (V 250)
                            , background (state.buttonColor)
                            , margin "0,20,0,0"
                            , gravity "center"
                            , color "#fff000"
                            , onClick "do"
                            ]
                            [
                             textView
                             [
                                id_ "7"
                              , height (V 20)
                              , width Match_Parent
                              , text (state.text)
                              , fontStyle "Source Sans Pro-Regular"
                              , gravity "center"
                             ]
                            ]

getControlPane :: forall t37 t38. VDom (Array (Prop t38)) t37
getControlPane = linearLayout
                        [ id_ "8"
                        , height (V 100)
                        , width Match_Parent
                        , background "#000000"
                        ]
                        [ 
                            getApplyButtonUI { name : "resetButton" , text : "RESET" , buttonColor : "#ff0066"}
                        ]

-- getGameBoardHolder state { id_ : "svgContainer" , height : "300" , width : "300" , cubeState : state },
getGameBoardHolder :: forall t1 t2. VDom (Array (Prop t2)) t1
getGameBoardHolder = linearLayout
                        [ id_ "gameBoardParent"
                        , height (V 0)
                        , weight "1"
                        , width Match_Parent
                        , gravity "center"
                        , background "#000000"
                        ]
                        [
                          linearLayout
                          [ id_ "gameBoard"
                          , height (V GameConfig.boardHeightInt )
                          , width (V GameConfig.boardWidthInt )
                          , margin "20,20,20,20"
                          , background "#FFFFFF"
                          ]
                          [
                          ]
                        ]

