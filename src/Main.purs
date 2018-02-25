module Main where

import Prelude (Unit, bind, discard, pure, unit, (<$>))

import Data.Maybe (Maybe(Nothing))
import FRP.Event (subscribe)
import FRP.Event.Time (animationFrame)
import FRP.Behavior.Time (millisSinceEpoch)

import DOM (DOM)
import FRP (FRP)

import SampleApp.Types 
import SampleApp.GameUI as GameUI

import PrestoDOM.Util as U

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)

foreign import openUrl :: forall eff  a. a -> Eff eff Unit

resetState::forall t1 t4. Eff t4 { | t1 }
resetState = U.updateState "currentScreen" FirstScreen

-- | The entry point of the game. Here we initialize the state, create the entities, and starts rendering the game
main :: forall t195. Eff ( dom :: DOM , console :: CONSOLE , frp :: FRP | t195 ) Unit
main = do
  --- Init State {} empty record--
  U.initializeState
  --- Update State ----
  state <- resetState
  ---- Render Widget ---
  U.render (GameUI.windowScreen state) listen
  pure unit

-- This function sets up the events to the game and the behaviors. Once that is done, we start patching the dom
listen :: forall e. Eff (console :: CONSOLE, frp :: FRP | e) (Eff (frp :: FRP, console :: CONSOLE | e) Unit)
listen = do
  s <- U.getState
  
  -- Subscribe to click events to toggle states
  -- next1 <- U.signal "next1" "onClick" Nothing
  -- _ <- next1.event `subscribe` (\_ -> U.updateState "currentScreen" SecondScreen )

  -- next2 <- U.signal "next2" "onClick" Nothing
  -- _ <- next1.event `subscribe` (\_ -> U.updateState "currentScreen" ThirdScreen )

  -- back2 <- U.signal "back2" "onClick" Nothing
  -- _ <- back2.event `subscribe` (\_ -> U.updateState "currentScreen" FirstScreen )

  -- back3 <- U.signal "back3" "onClick" Nothing
  -- _ <- back3.event `subscribe` (\_ -> U.updateState "currentScreen" SecondScreen )                                 

  let behavior = eval <$> millisSinceEpoch
  let events = (animationFrame)
  U.patch GameUI.windowScreen behavior events

-- | The eval function is the function that gets called whenever a UI event occurred. In our case, the only event we
-- | are calling this is with is the animationFrame event which repeatedly occurs when in browser animation frame is
-- | granted for us. And yes, this uses `window.requestAnimationFrame` under the hood.
eval :: forall e. Number -> Eff (console :: CONSOLE | e) AppState
eval _ = do
  s <- U.getState
  pure s
        



