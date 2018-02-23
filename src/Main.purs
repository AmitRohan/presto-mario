module Main where

import Prelude (Unit, bind, discard, not, otherwise, pure, unit, void, ($), (&&), (+), (-), (<$>), (<=), (==), (>), (||))

import Data.Maybe (Maybe(Nothing))
import FRP.Event (subscribe)
import FRP.Event.Time (animationFrame)
import FRP.Behavior.Time (millisSinceEpoch)

import FRP.Event.Keyboard (down, up)

import DOM (DOM)
import FRP (FRP)

import Ester as Ester

import BoxChaser.Types 
import BoxChaser.GameUI as GameUI
import BoxChaser.PlayerManager as BoxManager
import BoxChaser.EnemyManager as EnemyManager
import BoxChaser.GameBoard as GameBoard
import BoxChaser.GameConfig as GameConfig

import PrestoDOM.Util as U

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)

foreign import openUrl :: forall eff  a. a -> Eff eff Unit

resetState = do
  _ <- U.updateState "enemy1" (GameConfig.enemyAt 1.0)
  _ <- U.updateState "enemy2" (GameConfig.enemyAt 2.0)
  _ <- U.updateState "enemy3" (GameConfig.enemyAt 3.0)
  _ <- U.updateState "gameTime" GameConfig.gameTime
  _ <- U.updateState "gameLevel" GameConfig.startLevel
  U.updateState "player1" GameConfig.basePlayer

-- | The entry point of the game. Here we initialize the state, create the entities, and starts rendering the game
main :: forall t195. Eff ( dom :: DOM , console :: CONSOLE , frp :: FRP | t195 ) Unit
main = do
  --- Init State {} empty record--
  U.initializeState
  --- Update State ----
  _ <- U.updateState "gameStatus" E_Stop
  state <- resetState
  ---- Render Widget ---
  U.render (GameUI.windowScreen state) listen
  pure unit

-- | Here we update the Key Press status 
updateKeyPress ::  forall t . Int -> Eff t GameState
updateKeyPress key
  | key == 37 || key == 74 || key == 65 = U.updateState "keyLeft" true
  | key == 38 || key == 73 || key == 87 = U.updateState "keyTop" true
  | key == 39 || key == 76 || key == 68 = U.updateState "keyRight" true
  | key == 40 || key == 75 || key == 83 = U.updateState "keyBottom" true
  | key == 72 = do
                _ <- U.updateState "gameStatus" E_Pause 
                U.updateState "keyHelp" true -- H 
  | key == 81 = U.updateState "gameStatus" E_Stop -- Q
  | key == 82 = U.updateState "gameStatus" E_Restart -- R
  | key == 32 || key == 80 = do  -- Space or P
                t <- U.getState
                case t.gameStatus of 
                  E_Play -> U.updateState "gameStatus" E_Pause 
                  _ -> U.updateState "gameStatus" E_Play 
  | otherwise = U.getState

updateKeyRelease ::  forall t . Int -> Eff t GameState
updateKeyRelease key
  | key == 37 || key == 74 || key == 65 = U.updateState "keyLeft" false
  | key == 38 || key == 73 || key == 87 = U.updateState "keyTop" false
  | key == 39 || key == 76 || key == 68 = U.updateState "keyRight" false
  | key == 40 || key == 75 || key == 83 = U.updateState "keyBottom" false
  | key == 72 = do
                  _ <- U.updateState "gameStatus" E_Play 
                  U.updateState "keyHelp" false -- Help 
  | otherwise = U.getState
 
getDirection :: GameState -> Keys
getDirection s = Keys { x : xVal , y : yVal } where
                        xVal| s.keyRight && not s.keyLeft = 1.0 
                            | not s.keyRight && s.keyLeft = 2.0
                            | otherwise = 3.0
                        yVal| s.keyTop && not s.keyBottom = 1.0 
                            | not s.keyTop && s.keyBottom = 2.0
                            | otherwise = 3.0    

-- This function sets up the events to the game and the behaviors. Once that is done, we start patching the dom
listen :: forall e. Eff (console :: CONSOLE, frp :: FRP | e) (Eff (frp :: FRP, console :: CONSOLE | e) Unit)
listen = do
  s <- U.getState
  -- Add Init GameBaord
  _ <- GameBoard.initBoard
  -- Add Walls in GameBaord
  _ <- GameBoard.addWalls s.gameLevel
  -- Spawn Player && Enemy in GameBaord
  _ <- GameBoard.spawnPlayer "Player1" s.player1 
  _ <- GameBoard.spawnEnemy "Nick" s.enemy1 
  _ <- GameBoard.spawnEnemy "Sam" s.enemy2
  _ <- GameBoard.spawnEnemy "Harry" s.enemy3
  
  
  -- Subscribe to click events to toggle states
  playGame <- U.signal "playButton" "onClick" Nothing
  _ <- playGame.event `subscribe` (\_ -> U.updateState "gameStatus" E_Play )

  pauseGame <- U.signal "pauseButton" "onClick" Nothing
  _ <- pauseGame.event `subscribe` (\_ -> U.updateState "gameStatus" E_Pause )

  stopGame <- U.signal "stopButton" "onClick" Nothing
  _ <- stopGame.event `subscribe` (\_ -> U.updateState "gameStatus" E_Stop )
  
  restartGame <- U.signal "restartButton" "onClick" Nothing
  _ <- restartGame.event `subscribe` (\_ -> U.updateState "gameStatus" E_Restart )

  -- Setup keydown events
  _ <- down `subscribe` (\key -> void $ updateKeyPress key)
  -- Setup keyup events
  _ <- up `subscribe` (\key -> void $ updateKeyRelease key)                                      

  let behavior = eval <$> millisSinceEpoch
  let events = (animationFrame)
  U.patch GameUI.windowScreen behavior events

-- | Small Check for x y touch with height and width range
checkTouch :: Model -> Model -> Number -> Number -> Boolean
checkTouch (Model mario) (Model enemy) rangeX rangeY = not ( ( mario.x <= enemy.x ) && ( enemy.x <= mario.x + rangeX ) && ( mario.y <= enemy.y) && ( enemy.y <= mario.y + rangeY ) )
-- | Small Check for x y touch with same range
checkSquareTouch :: Model -> Model -> Number -> Boolean
checkSquareTouch (Model mario) (Model enemy) range = not ( ( mario.x <= enemy.x ) && ( enemy.x <= mario.x + range ) && ( mario.y <= enemy.y) && ( enemy.y <= mario.y + range ) )


-- | The eval function is the function that gets called whenever a UI event occurred. In our case, the only event we
-- | are calling this is with is the animationFrame event which repeatedly occurs when in browser animation frame is
-- | granted for us. And yes, this uses `window.requestAnimationFrame` under the hood.
eval :: forall e. Number -> Eff (console :: CONSOLE | e) GameState
eval _ = do
  s <- U.getState
  let t=  Ester.logAny s
  if s.gameTime > 0.0 
      then do
        ns <- updateUI s.gameStatus
        pure ns
      else do
        ns <- U.updateState "gameStatus" E_Win
        pure ns

-- | The updateUI function is the function that gets called whenever a the game is running. 
updateUI:: GameStatus -> Eff _ GameState
updateUI gameStatus = case gameStatus of
    E_Restart -> do 
      _ <- resetState
      U.updateState "gameStatus" E_Play
    -- E_Win -> 
    -- E_GameOver -> U.updateState "gameStatus" E_GameOver
    E_Play -> do
                  s <- U.getState
                  if checkTouch s.player1 s.enemy1 GameConfig.boxWidth GameConfig.boxHeight 
                    && checkTouch s.player1 s.enemy2 GameConfig.boxWidth GameConfig.boxHeight 
                    && checkTouch s.player1 s.enemy3 GameConfig.boxWidth GameConfig.boxHeight
                    then do
                      let timeLeft = s.gameTime - 1.0
                      let currDirection = getDirection s 
                      let newPlayer = BoxManager.updatePlayer "Player1" GameConfig.tickInterval currDirection s.player1
                      _ <- GameBoard.patchBoard "Player1" newPlayer
                      let newEnemy1 = EnemyManager.updateEnemy "Nick" GameConfig.tickInterval newPlayer s.enemy1
                      let newEnemy2 = EnemyManager.updateEnemy "Sam" GameConfig.tickInterval newPlayer s.enemy2
                      let newEnemy3 = EnemyManager.updateEnemy "Harry" GameConfig.tickInterval newPlayer s.enemy3
                      _ <- GameBoard.patchBoard "Nick" newEnemy1
                      _ <- GameBoard.patchBoard "Sam" newEnemy2
                      _ <- GameBoard.patchBoard "Harry" newEnemy3
                      _ <- U.updateState "gameTime" timeLeft
                      _ <- U.updateState "enemy1" newEnemy1    
                      _ <- U.updateState "enemy2" newEnemy2    
                      _ <- U.updateState "enemy3" newEnemy3    
                      U.updateState "player1" newPlayer
                    else
                      U.updateState "gameStatus" E_GameOver
    E_Stop -> do
        s <- resetState
        _ <- GameBoard.patchBoard "Player1" s.player1
        _ <- GameBoard.patchBoard "Nick" s.enemy1
        _ <- GameBoard.patchBoard "Sam" s.enemy2
        _ <- GameBoard.patchBoard "Harry" s.enemy3
        U.getState
    _ -> U.getState


