module BoxChaser.GameUI where

import Prelude 
import BoxChaser.Types
import BoxChaser.GameConfig as GameConfig
import Data.Number.Format (toString)
import PrestoDOM.Core (Prop)
import PrestoDOM.Elements (linearLayout, textView, relativeLayout)
import PrestoDOM.Events (onClick)
import PrestoDOM.Properties (background, color, fontStyle, gravity, height, id_, margin, name, orientation, padding, text, textSize, weight, width, visibility)
import PrestoDOM.Types (Length(..), VDom)

-- | The Primary Game Screen
windowScreen :: forall r p. GameState -> VDom (Array (Prop p)) r
windowScreen state = relativeLayout
              [ id_ "windowScreen"
              , height Match_Parent
              , width Match_Parent
              ]
              [ gameScreen state,
                popupWindow state
              ]

gameScreen :: forall r p. GameState -> VDom (Array (Prop p)) r
gameScreen state = linearLayout
              [ id_ "gameScreen"
              , height Match_Parent
              , width Match_Parent
              , orientation "vertical"
              ]
              [   getTopPane state.gameTime
                , getGameBoardHolder
                , getBottomPane
              ]              

-- | The Primary Game Screen
popupWindow :: forall r p. GameState -> VDom (Array (Prop p)) r
popupWindow state = linearLayout
              [ id_ "popupWindow"
              , height Match_Parent
              , width Match_Parent
              , gravity "center_horizontal"
              , background "#99000000"
              , visibility (_isGameOver)
              , orientation "vertical"
              ]
              [   textView
                  [ height (V 200) 
                    , width (V 300) 
                    , margin "0,30,0,0"
                    , text ( "Can you survive "<> toString (GameConfig.gameTime / 100.0 )<> " seconds ?" )
                    , textSize "26"
                    , fontStyle "Source Sans Pro-Regular"
                    , gravity "center_horizontal"
                    , color "#FFFFFF"
                    ]
                  , 
                  linearLayout
                  [ height (V 0)
                    , width Match_Parent
                    , gravity "center"
                    , weight "1"
                  ]
                  [
                    textView
                    [ height (V 20) 
                      , width Match_Parent
                      , text (_msgTxt)
                      , fontStyle "Source Sans Pro-Regular"
                      , gravity "center"
                      , color "#FFFFFF"
                    ]
                  ]
              ] where
                _isGameOver = case state.gameStatus of
                                    E_GameOver -> "visible"
                                    E_Stop -> "visible"
                                    E_Win -> "visible"
                                    _ -> "gone"
                
                _msgTxt = case state.gameStatus of
                                    E_GameOver -> ( "Game Over"<> "\n\nYou had to survive " <> toString ( state.gameTime / 100.0 ) <> "seconds more" <> "\n\nPress R To Retry" )
                                    E_Stop -> "Press Space To Start "
                                    E_Win -> "VICTORY"<>"\n\nPress Space To Play Again "
                                    _ -> "BOX CHASER"                                    


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
                            , width (V 140)
                            , margin "20,0,0,0"
                            , background (state.buttonColor)
                            , gravity "center"
                            , color "#fff000"
                            , onClick "do"
                            ]
                            [
                             textView
                             [
                                height (V 20)
                              , width Match_Parent
                              , text (state.text)
                              , fontStyle "Source Sans Pro-Regular"
                              , gravity "center"
                             ]
                            ]

getTopPane::forall t2 t3. Number -> VDom (Array (Prop t3)) t2
getTopPane timeLeft = linearLayout
                        [ id_ "topPane"
                        , height (V 70)
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
                          , linearLayout [ height Match_Parent, width (V 0), weight "1"] []   
                          , textView
                             [
                                id_ "gameName2"
                              , height (V 30)
                              , width (V 300)
                              , text _timeLeft
                              , fontStyle "Source Sans Pro-Regular"
                              , textSize "22"
                              , gravity "center"
                              , color "#FFFFFF"
                             ]  
                        ] where 
                            _timeLeft = "Time Left : " <> toString ( timeLeft / 100.0 )


getBottomPane :: forall t37 t38. VDom (Array (Prop t38)) t37
getBottomPane = linearLayout
                        [ id_ "bottomPane"
                        , height (V 90)
                        , width Match_Parent
                        , background "#000000"
                        , orientation "horizontal"
                        , gravity "center_vertical"
                        , padding "20,20,20,20"
                        ]
                        [   
                            linearLayout 
                              [ height Match_Parent
                              , width (V 0), weight "1"
                              , gravity "center_vertical" 
                              ] 
                              [ 
                                textView 
                                [ height (V 40)
                                , width (V 350)
                                , text "Use arrow keys or A/W/D to move"
                                , fontStyle "Source Sans Pro-Regular"
                                , textSize "22"
                                , gravity "center"
                                , color "#FFFFFF"
                                , padding "50,0,0,0" 
                                ] 
                              ]
                            , getButtonUI { name : "playButton"   , text : "PLAY (P)"   , buttonColor : "#ff0066" }
                            , getButtonUI { name : "pauseButton"  , text : "PAUSE (P)"  , buttonColor : "#ff0066" }
                            , getButtonUI { name : "stopButton"  , text : "STOP (Q)"  , buttonColor : "#ff0066" }
                            , getButtonUI { name : "restartButton"  , text : "RESTART (R)"  , buttonColor : "#ff0066" }
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