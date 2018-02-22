module Mario.GameManager where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Number.Format (toString)
import Ester as Ester
import Mario.Types (Direction(..), Keys(..), Model(..))

-- GAME LOGIC TO MOFICY GAME OBCECTS 
step :: Number -> Keys -> Model -> Model
step dt keys mario =
		mario
			# walk keys
			# jump keys
			# gravity dt
			# fixCollision collision
			# physics dt
			  
		where	

			-- newSpeed = getSpeed dt keys mario
			collision = Ester.detectCollision newMario objectName

			newMario = mario
					# walk keys
					# jump keys
					# gravity dt
					# physics dt

			objectName = Ester.SvgName "Mario"
						
gravity :: Number -> Model -> Model
gravity dt (Model mario) =
		Model { 
		      x : mario.x
		    , y : mario.y 
		    , vx : mario.vx
		    , vy : mario.vy + (dt/10.0) 
		    , dir : mario.dir
	    }

jump :: Keys -> Model -> Model
jump (Keys keys) (Model mario)
    | keys.y == 1.0 && mario.vy == 0.0 = Model { 
								    			x : mario.x
								    			, y : mario.y
								    			, vx : mario.vx
								    			, vy : negate 6.0 
								    			, dir : mario.dir
										    }
   	| otherwise = (Model mario)

-- fixCollision :: Ester.Collision -> Model -> Model 
fixCollision :: forall t128.       
  { yP :: String   
  , yM :: String   
  , xP :: String   
  , xM :: String   
  | t128           
  }                
  -> Model -> Model
fixCollision collider (Model mario) = do
	let p22 = Ester.logAny collider	
	Model { 
		x : mario.x,
		y : mario.y,
		vx : _vx ,
		vy : _vy,
		dir : mario.dir
	} where
		_vy | collider.yP == "None" && collider.yM == "None" = mario.vy
			| otherwise = 0.0
		_vx | collider.xP == "None" && collider.xM == "None"= mario.vx
			| otherwise = 0.0


	


walk :: Keys -> Model -> Model
walk (Keys keys) (Model mario) = 
		Model { 
			x : mario.x
			, y : mario.y
			, vx :	_newSpeed
			, vy : mario.vy
			, dir : newDirection
	    } where
    		newDirection	| keys.x == 2.0 		= Left
					 		| keys.x == 1.0 		= Right
					 		| otherwise 			= mario.dir     
    		_newSpeed	| keys.x == 2.0 		= negate 5.0 
					 	| keys.x == 1.0 		= 5.0 
					 	| keys.x == 3.0 		= 0.0 
					 	| otherwise 			= mario.vx 

physics :: Number -> Model -> Model
physics dt (Model mario) =
		Model { x : mario.x + dt * mario.vx
	    , y : mario.y + dt * mario.vy
	    , vx : mario.vx
	    , vy : mario.vy 
	    , dir : mario.dir
	    }

-- Update The Game UI here
patchBoard:: forall t . Model -> Eff t Unit
patchBoard (Model mario) = 
	Ester.modifyGameObject (Ester.SvgName "Mario") (Ester.PropertyList propList) 
		where
			propList = [
					    Ester.getProp "x" newX ,
					    Ester.getProp "y" newY
					  ]
			newY = toString ( mario.y )
			newX = toString ( mario.x )   					  



-- Helper Functions to Modify 
-- 1 Yes 2 Opp 3 Stop 
startKeyConfig :: Direction -> Keys
startKeyConfig direction = 
	case direction of
		Right 	-> Keys { x : 1.0, y : 0.0 }
		Left 	-> Keys { x : 2.0 , y : 0.0 }
		Top 	-> Keys { x : 0.0 , y : 1.0} 
		Bottom 	-> Keys { x : 3.0 , y : 3.0}
		_ -> Keys { x : 0.0 , y : 0.0}

getJoyStickYDirection :: Int -> Direction
getJoyStickYDirection key
  | key == 38 || key == 75 || key == 87 = Top
  | key == 40 || key == 74 || key == 83 = Bottom
  | otherwise = Released

getJoyStickXDirection :: Int -> Direction
getJoyStickXDirection key
  | key == 39 || key == 76 || key == 68 = Right
  | key == 37 || key == 72 || key == 65 = Left
  | otherwise = Released