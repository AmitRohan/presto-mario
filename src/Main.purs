module Main where

import Prelude (Unit, bind, discard, not, otherwise, pure, unit, void, ($), (&&), (<$>), (==), (||))

import Data.Maybe (Maybe(Nothing))
import FRP.Event (subscribe)
import FRP.Event.Time (animationFrame)
import FRP.Behavior.Time (millisSinceEpoch)

import FRP.Event.Keyboard (down, up)

import DOM (DOM)
import FRP (FRP)

import Ester as Ester

import Mario.Types (GameState, Keys(..))
import Mario.GameUI as GameUI
import Mario.GameManager as GameManager
import Mario.GameBoard as GameBoard
import Mario.GameConfig as GameConfig


import PrestoDOM.Elements (linearLayout) 
import PrestoDOM.Core
import PrestoDOM.Properties (height, id_, orientation, width)
import PrestoDOM.Types (Length(..), VDom) 
import PrestoDOM.Util as U

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)

foreign import openUrl :: forall eff  a. a -> Eff eff Unit


-- | The Primary Game Screen
widget :: forall r p. GameState -> VDom (Array (Prop p)) r
widget state = linearLayout
              [ id_ "1"
              , height Match_Parent
              , width Match_Parent
              , orientation "vertical"
              ]
              [ GameUI.getControlPane
                , GameUI.getGameBoardHolder
              ]

-- | The entry point of the game. Here we initialize the state, create the entities, and starts rendering the game
main :: forall t195. Eff ( dom :: DOM , console :: CONSOLE , frp :: FRP | t195 ) Unit
main = do
  --- Init State {} empty record--
  U.initializeState
  --- Update State ----
  state <- U.updateState "mario" GameConfig.baseMario 
  ---- Render Widget ---
  U.render (widget state) listen
  pure unit

-- | Here we update the Key Press status 
updateKeyState ::  forall t . Boolean -> Int -> Eff t GameState
updateKeyState mode key
  | key == 37 || key == 72 || key == 65 = U.updateState "keyLeft" mode
  | key == 38 || key == 75 || key == 87 = U.updateState "keyTop" mode
  | key == 39 || key == 76 || key == 68 = U.updateState "keyRight" mode
  | key == 40 || key == 74 || key == 83 = U.updateState "keyBottom" mode
  | otherwise = U.getState
 
getDirection :: GameState -> Keys
getDirection s = Keys { x : if s.keyRight && not s.keyLeft 
                        then 1.0 
                        else if not s.keyRight && s.keyLeft
                          then 2.0
                            else 3.0 ,
                      y : if s.keyTop && not s.keyBottom 
                        then 1.0 
                        else if not s.keyTop && s.keyBottom
                          then 2.0
                            else 3.0          
                      }

-- This function sets up the events to the game and the behaviors. Once that is done, we start patching the dom
listen :: forall e. Eff (console :: CONSOLE, frp :: FRP | e) (Eff (frp :: FRP, console :: CONSOLE | e) Unit)
listen = do
  _ <- GameBoard.initBoard
  resetGame <- U.signal "resetButton" "onClick" Nothing
  _ <- resetGame.event `subscribe` (\_ -> do
                                            let props = Ester.getGameObjectProps (Ester.SvgName "Mario")
                                            U.updateState "mario" GameConfig.baseMario 
                                         )

  -- Setup keydown events
  _ <- down `subscribe` (\key -> void $ updateKeyState true key)
  -- Setup keyup events
  _ <- up `subscribe` (\key -> void $ updateKeyState false key)                                      

  let behavior = eval <$> millisSinceEpoch
  let events = (animationFrame)
  U.patch widget behavior events

-- | The eval function is the function that gets called whenever a UI event occurred. In our case, the only event we
-- | are calling this is with is the animationFrame event which repeatedly occurs when in browser animation frame is
-- | granted for us. And yes, this uses `window.requestAnimationFrame` under the hood.
eval :: forall e. Number -> Eff (console :: CONSOLE | e) GameState
eval _ = do
  s <- U.getState
  let currDirection = getDirection s 
  let newMario = GameManager.step GameConfig.tickInterval currDirection s.mario
  _ <- GameManager.patchBoard newMario
  newState <- U.updateState "mario" newMario    
  pure newState

