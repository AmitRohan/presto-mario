module SVGClock.GameUI where

import Prelude ((/), (<>))
import SVGClock.Types
import SVGClock.GameConfig as GameConfig
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
              [   getTopPane state
                , getMidPane state
              ]              

getTopPane::forall t2 t3. GameState -> VDom (Array (Prop t3)) t2
getTopPane state = linearLayout
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
                              , text "Presto SVG Clock"
                              , fontStyle "Source Sans Pro-Regular"
                              , textSize "25"
                              , color "#FFFFFF"
                             ]
                          , linearLayout [ height Match_Parent, width (V 0), weight "1"] []   
                          , textView
                             [
                                id_ "timeSpent"
                              , height (V 30)
                              , width (V 200)
                              , text _timeLeft
                              , fontStyle "Source Sans Pro-Regular"
                              , textSize "22"
                              , gravity "end"
                              , color "#FFFFFF"
                             ]  
                        ] where 
                            _timeLeft = "Time Left : " <> toString ( state.gameTime / 100.0 )


                    
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
                          [ 
                            linearLayout
                            [ id_ "gameBoard"
                            , height Match_Parent
                            , width Match_Parent
                            , background "#FFFFFF"
                            ]
                            [
                            ] 
                          ]
                        ]




                  
