module BoxChaser.PlayerManager where

import Prelude

import Ester as Ester
import BoxChaser.Types (Direction(..), Keys(..), Model(..))

-- GAME LOGIC TO MOFICY GAME OBCECTS 
updatePlayer :: String -> Number -> Keys -> Model -> Model
updatePlayer name dt keys mario =
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

			objectName = Ester.SvgName name
						
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
fixCollision :: forall a.       
  { yP :: String   
  , yM :: String   
  , xP :: String   
  , xM :: String   
  | a           
  }                
  -> Model -> Model
fixCollision collider (Model mario) = do
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