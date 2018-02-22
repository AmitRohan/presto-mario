module BoxChaser.Types where

import Prelude

data Direction = Left | Right | Top | Bottom | Released
instance directionShow :: Show Direction where
  show (Left)   = "Left"
  show (Right)  = "Right"
  show (Top)    = "Top"
  show (Bottom) = "Bottom"
  show (Released) = "Released"

-- Basic Structures to refer to GameObjects

-- MARIO
data Model = Model { x   :: Number , y   :: Number , vx  :: Number , vy  :: Number , dir :: Direction }

{- KET STATUS
 	Val 	:	Direction 
 	x = 2 	: 	Left 
 	x = 1 	:	Right
 	y = 1 	:	Top
 	y = 2	:	Bottom
-}
data Keys = Keys { x :: Number , y :: Number }

-- Time Spent In The Game ( update acc to interval )
type GameTime = Number
type GameInterval = Number

data GameStatus = E_Pause | E_Play | E_Stop | E_Over | E_Restart | E_GameOver | E_Win

-- | A type for the game state. Consists all the data in the game
type GameState =
  { keyTop :: Boolean
  , keyBottom :: Boolean
  , keyLeft :: Boolean
  , keyRight :: Boolean
  , mario :: Model
  , enemy1 :: Model
  , enemy2 :: Model
  , enemy3 :: Model
  , gameTime :: Number
  , gameStatus :: GameStatus
  , gameLevel :: Number
  }