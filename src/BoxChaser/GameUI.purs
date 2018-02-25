module BoxChaser.GameUI where

import Prelude ((/), (<>))
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
windowScreen state = linearLayout
              [ id_ "gameScreen"
              , height Match_Parent
              , width Match_Parent
              , orientation "vertical"
              ]
              [   getTopPane state.gameTime state.gameLevel
                , getMidPane state
                , getBottomPane
              ]              

getTopPane::forall t2 t3. Number -> Number -> VDom (Array (Prop t3)) t2
getTopPane timeLeft gameLevel = linearLayout
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
                          , textView
                             [
                                id_ "gameLevel"
                              , height (V 30)
                              , width (V 200)
                              , text (_gameLevel)
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

                            _gameLevel = "Level " <> toString gameLevel


getButtonUI :: forall v p a.             
  { name :: String , buttonColor :: String , text :: String | a } 
  -> VDom (Array (Prop p)) v
getButtonUI bState = linearLayout
                            [
                              name (bState.name)
                            , height (V 40)
                            , width (V 140)
                            , margin "20,0,0,0"
                            , background (bState.buttonColor)
                            , gravity "center"
                            , color "#fff000"
                            , onClick "do"
                            ]
                            [
                             textView
                             [
                                height (V 20)
                              , width Match_Parent
                              , text (bState.text)
                              , fontStyle "Source Sans Pro-Regular"
                              , gravity "center"
                             ]
                            ]


getBottomPane :: forall v p. VDom (Array (Prop p)) v
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
                                , text "Press H for help"
                                , fontStyle "Source Sans Pro-Regular"
                                , textSize "22"
                                , gravity "center_vertical"
                                , color "#FFFFFF"
                                , padding "50,0,0,0" 
                                ] 
                              ]
                            , getButtonUI { name : "playButton"   , text : "PLAY (P)"   , buttonColor : "#ff0066" }
                            , getButtonUI { name : "pauseButton"  , text : "PAUSE (P)"  , buttonColor : "#ff0066" }
                            , getButtonUI { name : "stopButton"  , text : "STOP (Q)"  , buttonColor : "#ff0066" }
                            , getButtonUI { name : "restartButton"  , text : "RESTART (R)"  , buttonColor : "#ff0066" }
                        ]                        

getMidPane :: forall r p. GameState -> VDom (Array (Prop p)) r
getMidPane state = linearLayout
                        [ id_ "midPane"
                        , height (V 0)
                        , weight "1"
                        , width Match_Parent
                        , gravity "center"
                        , background "#ff1744"
                        , padding "20,20,20,20"
                        ]
                        [
                          relativeLayout
                          [ id_ "myBoards"
                          , height (V GameConfig.boardHeightInt )
                          , width (V GameConfig.boardWidthInt )
                          ]
                          [ gameBoardUI ,
                            messageBoardUI state,
                            helpBoardUI state
                          ]
                        ]

gameBoardUI :: forall t1 t2. VDom (Array (Prop t2)) t1
gameBoardUI = linearLayout
              [ id_ "gameBoard"
              , height Match_Parent
              , width Match_Parent
              , background "#FFFFFF"
              ]
              [
              ]


messageBoardUI :: forall r p. GameState -> VDom (Array (Prop p)) r
messageBoardUI state = linearLayout
                [ id_ "messageBoard"
                , height Match_Parent
                , width Match_Parent
                , background "#CC000000"
                , orientation "vertical"
                , visibility (_hasMessage)
                ]
                [
                  textView
                    [ height (V 0) 
                    , width Match_Parent 
                    , weight "1"
                    , margin "0,50,0,0"
                    , text ( _headerText )
                    , textSize "26"
                    , fontStyle "Source Sans Pro-Regular"
                    , gravity "center"
                    , color "#FFFFFF"
                    ]
                  , textView
                    [ height (V 0) 
                      , width Match_Parent
                      , weight "2"
                      , text ( _primaryText )
                      , textSize "28"
                      , gravity "center"
                      , margin "0,10,0,10"
                      , fontStyle "Source Sans Pro-Regular"
                      , color "#FFFFFF"
                    ]
                  , textView
                    [ height (V 25) 
                      , width Match_Parent
                      , text (_msgTxt)
                      , fontStyle "Source Sans Pro-Regular"
                      , textSize "22"
                      , margin "0,10,0,20"
                      , gravity "center"
                      , color "#FFFFFF"
                    ]
                ] where
                _primaryText = case state.gameStatus of
                                  E_GameOver -> "You had to survive " <> toString ( state.gameTime / 100.0 ) <> " seconds more"
                                  _ -> "Try to survive " <> toString (GameConfig.gameTime / 100.0 )<> " seconds"
                
                _hasMessage = case state.gameStatus of
                                    E_NewGame -> "visible"
                                    E_Win -> "visible"
                                    E_Stop -> "visible"
                                    E_GameOver -> "visible"
                                    _ -> "gone"
                
                _headerText = case state.gameStatus of
                                    E_NewGame -> "Welcome to Level " <> toString state.gameLevel
                                    E_Win -> "VICTORY"
                                    E_GameOver -> "Game Over"
                                    _ -> "BOX CHASER"


                _msgTxt = case state.gameStatus of
                                    E_NewGame -> "Press Space To Start "
                                    E_Win -> "Press Space To Play Again "
                                    E_GameOver -> "Press R To Retry" 
                                    E_Stop -> "Press Space To Start "
                                    _ -> "" 


helpBoardUI :: forall r p. GameState -> VDom (Array (Prop p)) r
helpBoardUI state = linearLayout
              [ id_ "helpWindow"
              , height Match_Parent
              , width Match_Parent
              , background "#CC000000"
              , visibility (_isHelpPressed)
              , orientation "vertical"
              , gravity "center_vertical"
              ]
              [
                textView
                    [   height (V 0)
                      , width Match_Parent
                      , weight "1"
                      , margin "40,40,40,40"
                      , text (storyTxt)
                      , textSize "24"
                      , fontStyle "Source Sans Pro-Regular"
                      , gravity "center"
                      , color "#FFFFFF"
                    ]
                , textView
                    [ height (V 24)
                      , width Match_Parent
                      , margin "20,20,20,5"
                      , text "How to move?"
                      , textSize "20"
                      , fontStyle "Source Sans Pro-Regular"
                      , color "#FFFFFF"
                    ]
                , textView
                    [ height (V 90)
                      , width Match_Parent
                      , margin "20,0,20,20"
                      , text (controlsTxt)
                      , textSize "24"
                      , fontStyle "Source Sans Pro-Regular"
                      , color "#FFFFFF"
                    ]    
              ] where
                _isHelpPressed = if state.keyHelp then "visible" else "gone"
                
                storyTxt = "Hi Box" 
                  <> "\nBlue Boxes are chasing you." 
                  <> "\nTry not to get caught by them."
                
                controlsTxt ="JUMP  : W / I / Top Arrow"
                  <> "\nRIGHT : D / L / Right Arrow" 
                  <> "\nLEFT  : A / J / Left Arrow" 
               
                  
