module Main where

import Prelude (Unit, bind, discard, not, otherwise, pure, unit, void, ($), (&&), (<$>), (==), (||), (-))

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
import Mario.MarioManager as MarioManager
import Mario.EnemyManager as EnemyManager
import Mario.GameBoard as GameBoard
import Mario.GameConfig as GameConfig

import Mario.Types

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
              [   GameUI.getTopPane state.gameTime
                , GameUI.getGameBoardHolder
                , GameUI.getBottomPane
              ]

resetState = do
  _ <- U.updateState "enemy1" (GameConfig.enemyAt 1.0)
  _ <- U.updateState "enemy2" (GameConfig.enemyAt 2.0)
  _ <- U.updateState "enemy3" (GameConfig.enemyAt 3.0)
  _ <- U.updateState "gameTime" GameConfig.gameTime
  _ <- U.updateState "gameStatus" E_Stop
  U.updateState "mario" GameConfig.baseMario

-- | The entry point of the game. Here we initialize the state, create the entities, and starts rendering the game
main :: forall t195. Eff ( dom :: DOM , console :: CONSOLE , frp :: FRP | t195 ) Unit
main = do
  --- Init State {} empty record--
  U.initializeState
  --- Update State ----
  state <- resetState
  ---- Render Widget ---
  let p = Ester.logAny state
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
  s <- U.getState

  _ <- GameBoard.initBoard
  _ <- GameBoard.spawnEnemy "Enemy1" s.enemy1
  _ <- GameBoard.spawnEnemy "Enemy2" s.enemy2
  _ <- GameBoard.spawnEnemy "Enemy3" s.enemy3
  
  resetGame <- U.signal "resetButton" "onClick" Nothing
  _ <- resetGame.event `subscribe` (\_ -> do
                                            let props = Ester.getGameObjectProps (Ester.SvgName "Mario")
                                            resetState 
                                         )
  playGame <- U.signal "playButton" "onClick" Nothing
  _ <- playGame.event `subscribe` (\_ -> U.updateState "gameStatus" E_Play )

  pauseGame <- U.signal "pauseButton" "onClick" Nothing
  _ <- pauseGame.event `subscribe` (\_ -> U.updateState "gameStatus" E_Pause )

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
  newState <- updateUI s.gameStatus
  pure newState

updateUI:: GameStatus -> Eff _ GameState
updateUI gameStatus = case gameStatus of
    E_Play -> do
                  s <- U.getState
                  let timeLeft = s.gameTime - 1.0
                  let currDirection = getDirection s 
                  let newMario = MarioManager.step "Mario" GameConfig.tickInterval currDirection s.mario
                  _ <- GameBoard.patchBoard "Mario" newMario
                  let newEnemy1 = EnemyManager.updateEnemy "Enemy1" GameConfig.tickInterval newMario s.enemy1
                  let newEnemy2 = EnemyManager.updateEnemy "Enemy2" GameConfig.tickInterval newMario s.enemy2
                  let newEnemy3 = EnemyManager.updateEnemy "Enemy3" GameConfig.tickInterval newMario s.enemy3
                  _ <- GameBoard.patchBoard "Enemy1" newEnemy1
                  _ <- GameBoard.patchBoard "Enemy2" newEnemy2
                  _ <- GameBoard.patchBoard "Enemy3" newEnemy3
                  _ <- U.updateState "gameTime" timeLeft
                  _ <- U.updateState "enemy1" newEnemy1    
                  _ <- U.updateState "enemy2" newEnemy2    
                  _ <- U.updateState "enemy3" newEnemy3    
                  U.updateState "mario" newMario
    E_Stop -> do
        s <- resetState
        _ <- GameBoard.patchBoard "Mario" s.mario
        _ <- GameBoard.patchBoard "Enemy1" s.enemy1
        _ <- GameBoard.patchBoard "Enemy2" s.enemy2
        _ <- GameBoard.patchBoard "Enemy3" s.enemy3
        U.getState
    _ -> U.getState