module BoxChaser.GameBoard where

import Prelude (Unit, bind, (*), (+), (-), (/))

import Control.Monad.Eff (Eff)
import Data.Number.Format (toString)
import Ester as Ester
import BoxChaser.Types
import BoxChaser.GameConfig as GameConfig


initBoard :: forall t. Eff t Unit
initBoard = do
	let boardWidth = GameConfig.boardWidth
	let boardHeight = GameConfig.boardHeight
	let groundHeight = GameConfig.groundHeight
	let groundY = boardHeight - groundHeight
	let marioX = GameConfig.startX
	--give a jump to mario at init
	let marioY = GameConfig.startY - 200.0  
	
	_ <- Ester.initGameBoard (Ester.GameBoard { id : "gameBoard", height : boardHeight , width : boardWidth })

	_ <- Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Sky", nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString boardHeight),
	  Ester.getProp "width" (toString boardWidth),
	  Ester.getProp "x" "0",
	  Ester.getProp "y" "0",
	  Ester.getProp "fill" "#90CAF9"
	]}) 

	_ <- Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Obstacles", nodeType : "Group" , props : [ Ester.getProp "x" "0", Ester.getProp "y" "0" ]}) 
	_ <- Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : "Ground", nodeType : "Rectangle" , props :[ 
	  Ester.getProp "height" (toString groundHeight),
	  Ester.getProp "width" (toString boardWidth),
	  Ester.getProp "x" "0",
	  Ester.getProp "y" (toString groundY),
	  Ester.getProp "fill" "#4E342E",
	  Ester.getProp "path" "img/ground.png"
	]}) 
	Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Mario", nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString GameConfig.marioHeight),
	  Ester.getProp "width" (toString GameConfig.marioWidth),
	  Ester.getProp "x" (toString marioX),
	  Ester.getProp "y" (toString marioY),
	  Ester.getProp "fill" "#ff0066",
	  Ester.getProp "path" "img/box.png"
	]}) 

addWalls :: forall t. Number ->  Eff t Unit
addWalls level = do
	let boardWidth = GameConfig.boardWidth
	let boardHeight = GameConfig.boardHeight
	let groundHeight = GameConfig.groundHeight
	let groundY = boardHeight - groundHeight
	let marioX = GameConfig.startX

	_ <- addBarier 1.0 "Wall1" marioX groundY
	_ <- addVerticalBarier 2.0 "Wall2" marioX groundY
	_ <- addBarier 3.0 "Wall3" marioX groundY
	_ <- addVerticalBarier 4.0 "Wall4" marioX groundY
	_ <- addBarier 5.0 "Wall5" marioX groundY
	addBarier 6.0 "Wall6" marioX groundY


addBarier ::  forall t. Number -> String -> Number -> Number -> Eff t Unit
addBarier barierCount barierType marioX groundY= Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : barierType, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString (barierCount/4.0 * 100.0) ),
	  Ester.getProp "width" "50",
	  Ester.getProp "x" (toString ( marioX + barierCount * 150.0) ),
	  Ester.getProp "y" (toString (groundY-(barierCount/4.0 * 100.0)) ),
	  Ester.getProp "fill" "#00E676",
	  Ester.getProp "path" "img/wall.png"
	]}) 	

addVerticalBarier ::  forall t. Number -> String -> Number -> Number -> Eff t Unit
addVerticalBarier barierCount barierType marioX groundY= Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : barierType, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" "50",
	  Ester.getProp "width" "100",
	  Ester.getProp "x" (toString ( marioX + barierCount * 150.0) ),
	  Ester.getProp "y" (toString ( groundY - ( (barierCount/4.0) * 280.0 ) ) ) ,
	  Ester.getProp "fill" "#00E676",
	  Ester.getProp "path" "img/wall.png"
	]})

spawnEnemy ::  forall t. String -> Model -> Eff t Unit
spawnEnemy enemyName (Model enemyObject) = Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : enemyName , nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString GameConfig.enemyHeight),
	  Ester.getProp "width" (toString GameConfig.enemyWidth),
	  Ester.getProp "x" (toString enemyObject.x),
	  Ester.getProp "y" (toString enemyObject.y),
	  Ester.getProp "fill" "#6600ff"
	]}) 

-- Update The Object based on id and model
patchBoard:: forall t . String -> Model -> Eff t Unit
patchBoard objectName (Model objectModel) = 
	Ester.modifyGameObject (Ester.SvgName objectName) (Ester.PropertyList propList) 
		where
			propList = [
					    Ester.getProp "x" newX ,
					    Ester.getProp "y" newY
					  ]
			newY = toString ( objectModel.y )
			newX = toString ( objectModel.x )   					  
