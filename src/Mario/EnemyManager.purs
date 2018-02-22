module Mario.EnemyManager where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Number.Format (toString)
import Ester as Ester
import Mario.Types (Direction(..), Keys(..), Model(..))

-- GAME LOGIC TO MOFICY Enemy OBCECTS 
updateEnemy :: String -> Number -> Model -> Model -> Model
updateEnemy name dt mario enemy =
		enemy
			# rotateEnemy mario
			# gravity dt
			# fixCollision collision
			# physics dt
			  
		where	

			-- newSpeed = getSpeed dt keys mario
			collision = Ester.detectCollision newEnemy objectName

			newEnemy = enemy
					# rotateEnemy mario
					# gravity dt
					# physics dt

			objectName = Ester.SvgName name
						
gravity :: Number -> Model -> Model
gravity dt (Model enemy) =
		Model { 
		      x : enemy.x
		    , y : enemy.y 
		    , vx : enemy.vx
		    , vy : enemy.vy + (dt/10.0) 
		    , dir : enemy.dir
	    }

rotateEnemy :: Model -> Model -> Model
rotateEnemy (Model mario) (Model enemy) =
		Model { 
		      x : enemy.x
		    , y : enemy.y 
		    , vx : newVX
		    , vy : newVY
		    , dir : mario.dir
	    } where
	    	newVY 	| mario.y > enemy.y = 2.0
	    			| otherwise = -2.0

	    	newVX 	| mario.x > enemy.x = 2.0
	    			| otherwise = -2.0




-- fixCollision :: Ester.Collision -> Model -> Model 
fixCollision :: forall t128.       
  { yP :: String   
  , yM :: String   
  , xP :: String   
  , xM :: String   
  | t128           
  }                
  -> Model -> Model
fixCollision collider (Model enemy) = do
	Model { 
		x : enemy.x,
		y : enemy.y,
		vx : _vx ,
		vy : _vy,
		dir : enemy.dir
	} where
		_vy | collider.yP == "None" && collider.yM == "None" = enemy.vy
			| otherwise = ( negate enemy.vy )
		_vx | collider.xP == "None" && collider.xM == "None"= enemy.vx
			| otherwise = ( negate enemy.vx )

physics :: Number -> Model -> Model
physics dt (Model enemy) =
		Model { x : enemy.x + dt * enemy.vx
	    , y : enemy.y + dt * enemy.vy
	    , vx : enemy.vx
	    , vy : enemy.vy 
	    , dir : enemy.dir
	    }
