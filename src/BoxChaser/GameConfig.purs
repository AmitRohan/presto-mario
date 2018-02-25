module BoxChaser.GameConfig where
-- Frame Rate and Tick Interval
import Prelude ((+), (-), (/), (*))
import BoxChaser.Types (Direction(..), GameInterval, GameTime, Keys(..), Model(..))


gameTime :: Number
gameTime = 3.0 * 100.0

boardWidth :: Number
boardWidth = 900.0

boardWidthInt :: Int
boardWidthInt = 900

boardHeight :: Number
boardHeight = 500.0

boardHeightInt :: Int
boardHeightInt = 500

groundHeight :: Number
groundHeight = 62.0

groundWidth :: Number
groundWidth = boardWidth

boxHeight :: Number
boxHeight = 40.0

boxWidth :: Number
boxWidth = 40.0

enemyHeight :: Number
enemyHeight = 25.0

enemyWidth :: Number
enemyWidth = 25.0

startX :: Number
startX = 50.0

startY :: Number
startY = boardHeight - groundHeight - boxHeight - 200.0

enemyX :: Number
enemyX = 250.0

enemyY :: Number
enemyY = boardHeight - groundHeight - boxHeight - 25.0

startLevel :: Number
startLevel = 1.0

maxLevel :: Number
maxLevel = 5.0

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

-- Initial Player Config
basePlayer :: Model
basePlayer =
		Model { x : startX
	    , y : startY 
	    , vx : 0.0
	    , vy : 0.0
	    , dir : Right
	    }

baseEnemy :: Model
baseEnemy =
		Model { x : enemyX
	    , y : enemyY 
	    , vx : 0.0
	    , vy : 0.0
	    , dir : Right
	    }	

enemyAt :: Number -> Model
enemyAt index =
		Model { x : ( startX +  ( 200.0 * index ) )
	    , y : ( enemyY -  ( 20.0 * index ) )
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