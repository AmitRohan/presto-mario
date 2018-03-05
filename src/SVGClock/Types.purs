module SVGClock.Types where

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
data ClockModel = ClockModel { time  :: Number , radius  :: Number }

-- Time Spent In The Game ( update acc to interval )
type GameTime = Number
type GameInterval = Number

-- | A type for the game state. Consists all the data in the game
type GameState =
  { clock :: ClockModel
  , gameTime :: Number
  }