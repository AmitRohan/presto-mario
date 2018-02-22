module Mario.GameConfig where
-- Frame Rate and Tick Interval
import Prelude ((+), (-), (/), (*))
import Mario.Types (Direction(..), GameInterval, GameTime, Keys(..), Model(..))


gameTime :: Number
gameTime = 10.0 * 100.0

boardWidth :: Number
boardWidth = 1000.0

boardWidthInt :: Int
boardWidthInt = 1000

boardHeight :: Number
boardHeight = 500.0

boardHeightInt :: Int
boardHeightInt = 500

groundHeight :: Number
groundHeight = 62.0

groundWidth :: Number
groundWidth = boardWidth

marioHeight :: Number
marioHeight = 50.0

marioWidth :: Number
marioWidth = 50.0

enemyHeight :: Number
enemyHeight = 30.0

enemyWidth :: Number
enemyWidth = 30.0

startX :: Number
startX = 50.0

startY :: Number
startY = boardHeight - groundHeight - marioHeight - 25.0

framesPerSercondInt :: Int
framesPerSercondInt = 1000

framesPerSercond :: Number
framesPerSercond = 1000.0

tickInterval :: GameInterval
tickInterval = 1000.0 / framesPerSercond

tickIntervalInt :: Int
tickIntervalInt = 1000 / framesPerSercondInt

tick:: GameTime -> GameTime
tick gameTime = gameTime + tickInterval

tickAt:: GameTime -> GameInterval -> GameTime
tickAt gameTime interval = gameTime + interval

baseTick :: GameTime
baseTick = 0.0

-- Initial MarioConfig
baseMario :: Model
baseMario =
		Model { x : startX
	    , y : startY 
	    , vx : 0.0
	    , vy : 0.0
	    , dir : Right
	    }

baseEnemy :: Model
baseEnemy =
		Model { x : (startX + 150.0)
	    , y : startY 
	    , vx : 0.0
	    , vy : 0.0
	    , dir : Right
	    }	

enemyAt :: Number -> Model
enemyAt index =
		Model { x : ( startX +  ( 150.0 * index ) )
	    , y : startY 
	    , vx : 0.0
	    , vy : 0.0
	    , dir : Right
	    }
    
-- Initial KeyConfig 
baseKeys :: Keys
baseKeys =
		Keys { x : 0.0
	    , y : 0.0 
	    }