module Mario.GameUI where


import DOM.HTML.HTMLTextAreaElement (cols)
import Mario.GameConfig as GameConfig
import PrestoDOM.Core (Prop)
import PrestoDOM.Elements (linearLayout, textView)
import PrestoDOM.Events (onClick)
import PrestoDOM.Properties (background, color, fontStyle, gravity, height, id_, margin, name, orientation, padding, text, textSize, weight, width)
import PrestoDOM.Types (Length(..), VDom)

getButtonUI :: forall t18 t19 t38.             
  { name :: String              
  , buttonColor :: String       
  , text :: String              
  | t38                         
  }                             
  -> VDom (Array (Prop t19)) t18
getButtonUI state = linearLayout
                            [
                              name (state.name)
                            , height (V 40)
                            , width (V 250)
                            , background (state.buttonColor)
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

getTopPane :: forall t37 t38. VDom (Array (Prop t38)) t37
getTopPane = linearLayout
                        [ id_ "topPane"
                        , height (V 100)
                        , width Match_Parent
                        , background "#000000"
                        , gravity "center_vertical"
                        , padding "20,20,20,20"
                        ]
                        [ 
                            textView
                             [
                                id_ "gameName"
                              , height (V 30)
                              , width (V 200)
                              , text "Box Chaser"
                              , fontStyle "Source Sans Pro-Regular"
                              , textSize "25"
                              , gravity "center"
                              , color "#FFFFFF"
                             ]
                        ]

getBottomPane :: forall t37 t38. VDom (Array (Prop t38)) t37
getBottomPane = linearLayout
                        [ id_ "bottomPane"
                        , height (V 100)
                        , width Match_Parent
                        , background "#000000"
                        , orientation "horizontal"
                        , gravity "center_vertical"
                        , padding "20,20,20,20"
                        ]
                        [   
                            linearLayout [ height (V 1), width (V 0), weight "1"] []
                            , getButtonUI { name : "resetButton" , text : "RESET" , buttonColor : "#ff0066"}
                        ]                        

-- getGameBoardHolder state { id_ : "svgContainer" , height : "300" , width : "300" , cubeState : state },
getGameBoardHolder :: forall t1 t2. VDom (Array (Prop t2)) t1
getGameBoardHolder = linearLayout
                        [ id_ "gameBoardParent"
                        , height (V 0)
                        , weight "1"
                        , width Match_Parent
                        , gravity "center"
                        , background "#ff1744"
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