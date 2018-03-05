module SVGClock.Main where

import Prelude (Unit, bind, discard, not, otherwise, pure, unit, void, ($), (&&), (+), (-), (<$>), (<=), (==), (>=), (||))

import Data.Maybe (Maybe(Nothing))
import FRP.Event (subscribe)
import FRP.Event.Time (animationFrame)
import FRP.Behavior.Time (millisSinceEpoch)

import FRP.Event.Keyboard (down, up)

import DOM (DOM)
import FRP (FRP)

import Ester as Ester
import Ester.Animation as Animation

import SVGClock.Types 
import SVGClock.GameUI as GameUI
import SVGClock.GameBoard as GameBoard
import SVGClock.GameConfig as GameConfig

import PrestoDOM.Util as U

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)

foreign import openUrl :: forall eff  a. a -> Eff eff Unit

-- | The entry point of the game. Here we initialize the state, create the entities, and starts rendering the game
main :: forall t195. Eff ( dom :: DOM , console :: CONSOLE , frp :: FRP | t195 ) Unit
main = do
  --- Init State {} empty record--
  U.initializeState
  --- Update State ----
  state <- U.updateState "gameTime" GameConfig.baseTick
  ---- Render Widget ---
  U.render (GameUI.windowScreen state) listen
  pure unit

-- This function sets up the events to the game and the behaviors. Once that is done, we start patching the dom
listen :: forall e. Eff (console :: CONSOLE, frp :: FRP | e) (Eff (frp :: FRP, console :: CONSOLE | e) Unit)
listen = do
  s <- U.getState
  -- Add Init GameBaord
  _ <- GameBoard.initBoard
  let behavior = eval <$> millisSinceEpoch
  let events = (animationFrame)
  U.patch GameUI.windowScreen behavior events


-- | The eval function is the function that gets called whenever a UI event occurred. In our case, the only event we
-- | are calling this is with is the animationFrame event which repeatedly occurs when in browser animation frame is
-- | granted for us. And yes, this uses `window.requestAnimationFrame` under the hood.
eval :: forall e. Number -> Eff (console :: CONSOLE | e) GameState
eval _ = do
  s <- U.getState
  -- let p = Ester.logAny s
  let svgObject = Animation.getById (Animation.IDi "MyPath1")
  let anim1 = Animation.startPathAnimation svgObject
  pure s
        
