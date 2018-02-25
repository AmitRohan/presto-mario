module SampleApp.Types where

import Prelude

data Screen = FirstScreen | SecondScreen | ThirdScreen 
-- | A type for the game state. Consists all the data in the game
type AppState =
  { currentScreen :: Screen
  }