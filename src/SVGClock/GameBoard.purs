module SVGClock.GameBoard where

import Prelude (Unit, bind, (*), (+), (-), (/), (<>))

import Control.Monad.Eff (Eff)
import Data.Number.Format (toString)
import Ester as Ester
import Ester.Animation as Animation
import SVGClock.Types
import SVGClock.GameConfig as GameConfig

initBoard :: forall t. Eff t Unit
initBoard = Ester.initGameBoard ( Ester.GameBoard { id : "gameBoard", height : GameConfig.boardHeight, width : GameConfig.boardWidth } )

addBaseWorld :: forall t. Eff t Unit
addBaseWorld = do
	let boardWidth = GameConfig.boardWidth
	let boardHeight = GameConfig.boardHeight
	let groundHeight = GameConfig.groundHeight
	let groundY = boardHeight - groundHeight
	let marioX = GameConfig.startX
	--give a jump to mario at init
	let marioY = GameConfig.startY - 200.0  
	
	_ <- Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Sky", nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString boardHeight),
	  Ester.getProp "width" (toString boardWidth),
	  Ester.getProp "x" "0",
	  Ester.getProp "y" "0",
	  Ester.getProp "fill" "#90CAF9"
	]}) 

	_ <- Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "PathObject", nodeType : "Path" , props : [ 
		Ester.getProp "id" "MyPath1", 
		Ester.getProp "d" "M0 0 H50 A20 20 0 1 0 100 50 v25 C50 125 0 85 0 85 z", 
		Ester.getProp "fill" "none", 
		Ester.getProp "stroke-linecap" "round", 
		Ester.getProp "stroke-linejoin" "round", 
		Ester.getProp "stroke-width" "4", 
		Ester.getProp "stroke-color" "#ff0066" 
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
	_ <- addRectangle "LeftBound" "-10" "0" "10" (toString boardHeight) "#4E342E" 
	_ <- addRectangle "RightBound" (toString boardWidth) "0" "10" (toString boardHeight) "#4E342E" 
	addRectangle "TopBound" "0" "-10" (toString boardWidth) "10" "#4E342E" 

spawnEnemy ::  forall t. String -> Model -> Eff t Unit
spawnEnemy enemyName (Model enemyObject) = Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : enemyName , nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString GameConfig.enemyHeight),
	  Ester.getProp "width" (toString GameConfig.enemyWidth),
	  Ester.getProp "x" (toString enemyObject.x),
	  Ester.getProp "y" (toString enemyObject.y),
	  Ester.getProp "fill" "#6600ff"
	]}) 

spawnPlayer ::  forall t. String -> Model -> Eff t Unit
spawnPlayer playerName (Model player) = Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : playerName, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "id" "MyID101",
	  Ester.getProp "height" (toString GameConfig.boxHeight),
	  Ester.getProp "width" (toString GameConfig.boxWidth),
	  Ester.getProp "x" (toString player.x),
	  Ester.getProp "y" (toString player.y),
	  Ester.getProp "fill" "#ff0066",
	  Ester.getProp "path" "img/box.png"
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

addWalls :: forall t. Number ->  Eff t Unit
addWalls level = do
	let groundY = GameConfig.boardHeight - GameConfig.groundHeight
	let marioX = GameConfig.startX			
	case level of
		1.0 -> do
				let wallStart = marioX + 50.0
				_ <- addBarier "W1" ( wallStart + 50.0 ) ( groundY - 150.0 ) 50.0 150.0
				_ <- addBarier "W2" ( wallStart + 280.0 ) ( groundY - 150.0 ) 50.0 150.0
				addBarier "W3" ( wallStart + 450.0 ) ( groundY - 150.0 ) 50.0 150.0
		2.0 -> do
				let wallStart = marioX + 50.0
				_ <- addBarier "Wall1" wallStart ( groundY - 50.0 ) 50.0 50.0
				_ <- addVBarierLow 1.0 marioX groundY
				_ <- addVBarierLow 2.0 marioX groundY
				_ <- addVBarierLow 3.0 marioX groundY
				addBarier "Wall1" ( wallStart + 250.0 ) ( groundY - 50.0 ) 50.0 50.0
		3.0 -> do
				_ <- addHBarier 2.0 marioX groundY
				_ <- addHBarier 3.0 marioX groundY
				_ <- addVBarier 4.0 marioX groundY
				_ <- addHBarier 5.0 marioX groundY
				addHBarier 6.0 marioX groundY
		4.0 -> do
				_ <- addHBarier 1.0 marioX groundY
				_ <- addVBarier 2.0 marioX groundY
				_ <- addVBarier 4.0 marioX groundY
				addHBarier 5.0 marioX groundY
		5.0 -> do
				_ <- addVBarierLow 0.0 marioX groundY
				_ <- addHBarier 2.0 marioX groundY
				_ <- addHBarier 3.0 marioX groundY
				_ <- addVBarier 5.0 marioX groundY
				addVBarier 3.0 marioX groundY
		_ -> addHBarier 3.0 marioX groundY		


addBarier ::  forall t. String -> Number -> Number -> Number -> Number -> Eff t Unit
addBarier barierName xPos yPos width height = Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : barierName, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString height ),
	  Ester.getProp "width" (toString width ),
	  Ester.getProp "x" (toString xPos),
	  Ester.getProp "y" (toString yPos),
	  Ester.getProp "fill" "#00E676"
	]})


addHBarier ::  forall t. Number -> Number -> Number -> Eff t Unit
addHBarier barierCount marioX groundY = Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : _barierName, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString (barierCount/4.0 * 100.0) ),
	  Ester.getProp "width" "50",
	  Ester.getProp "x" (toString ( marioX + barierCount * 150.0) ),
	  Ester.getProp "y" (toString ( groundY - (barierCount/4.0 * 100.0) ) ),
	  Ester.getProp "fill" "#00E676",
	  Ester.getProp "path" "img/wall.png"
	]}) where _barierName = "HWall" <> toString barierCount

addVBarier ::  forall t. Number -> Number -> Number -> Eff t Unit
addVBarier barierCount marioX groundY= Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : _barierName, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" "50",
	  Ester.getProp "width" "100",
	  Ester.getProp "x" (toString ( marioX + barierCount * 150.0) ),
	  Ester.getProp "y" (toString ( groundY - 280.0 ) ) ,
	  Ester.getProp "fill" "#00E676",
	  Ester.getProp "path" "img/wall.png"
	]}) where _barierName = "VWall" <> toString barierCount 	

addVBarierLow ::  forall t. Number -> Number -> Number -> Eff t Unit
addVBarierLow barierCount marioX groundY= Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : _barierName, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" "50",
	  Ester.getProp "width" "100",
	  Ester.getProp "x" (toString ( marioX + barierCount * 150.0) ),
	  Ester.getProp "y" (toString ( groundY - 180.0 ) ) ,
	  Ester.getProp "fill" "#00E676",
	  Ester.getProp "path" "img/wall.png"
	]}) where _barierName = "VLWall" <> toString barierCount 

addRectangle ::  forall t. String -> String -> String -> String -> String -> String -> Eff t Unit
addRectangle _name x y width height color = Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : _name, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" height,
	  Ester.getProp "width" width,
	  Ester.getProp "x" x,
	  Ester.getProp "y" y ,
	  Ester.getProp "fill" color
	]})