module Mario.GameBoard where

import Prelude
import Control.Monad.Eff (Eff)
import Ester as Ester
import Mario.GameConfig as GameConfig
import Data.Number.Format (toString)


initBoard :: forall t. Eff t Unit
initBoard = do
	let boardWidth = GameConfig.boardWidth
	let boardHeight = GameConfig.boardHeight
	let groundHeight = GameConfig.groundHeight
	let groundY = boardHeight - groundHeight
	let marioX = GameConfig.startX
	--give a jump to mario at init
	let marioY = GameConfig.startY - 50.0  
	_ <- Ester.initGameBoard (Ester.GameBoard { id : "gameBoard", height : boardHeight , width : boardWidth })
	_ <- Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Sky", nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString boardHeight),
	  Ester.getProp "width" (toString boardWidth),
	  Ester.getProp "x" "0",
	  Ester.getProp "y" "0",
	  Ester.getProp "fill" "#0000ff"
	]}) 
	_ <- Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Obstacles", nodeType : "Group" , props : [ Ester.getProp "x" "0", Ester.getProp "y" "0" ]}) 
	_ <- Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : "Ground", nodeType : "Image" , props :[ 
	  Ester.getProp "height" (toString groundHeight),
	  Ester.getProp "width" (toString boardWidth),
	  Ester.getProp "x" "0",
	  Ester.getProp "y" (toString groundY),
	  Ester.getProp "path" "img/ground.png"
	]}) 
	_ <- addBarier 1.0 "Wall1" marioX groundY
	_ <- addVerticalBarier 2.0 "Wall2" marioX groundY
	_ <- addBarier 3.0 "Wall3" marioX groundY
	_ <- addVerticalBarier 4.0 "Wall4" marioX groundY
	_ <- addBarier 5.0 "Wall5" marioX groundY
	_ <- addBarier 6.0 "Wall6" marioX groundY
	Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Mario", nodeType : "Image" , props : [ 
	  Ester.getProp "height" (toString GameConfig.marioHeight),
	  Ester.getProp "width" (toString GameConfig.marioWidth),
	  Ester.getProp "x" (toString marioX),
	  Ester.getProp "y" (toString marioY),
	  Ester.getProp "fill" "#ff0066",
	  Ester.getProp "path" "img/box.png"
	]}) 


addBarier ::  forall t. Number -> String -> Number -> Number -> Eff t Unit
addBarier barierCount barierType marioX groundY= Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : barierType, nodeType : "Image" , props : [ 
	  Ester.getProp "height" (toString (barierCount/4.0 * 100.0) ),
	  Ester.getProp "width" "50",
	  Ester.getProp "x" (toString ( marioX + barierCount * 150.0) ),
	  Ester.getProp "y" (toString (groundY-(barierCount/4.0 * 100.0)) ),
	  Ester.getProp "fill" "#22ff22",
	  Ester.getProp "path" "img/wall.png"
	]}) 	

addVerticalBarier ::  forall t. Number -> String -> Number -> Number -> Eff t Unit
addVerticalBarier barierCount barierType marioX groundY= Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : barierType, nodeType : "Image" , props : [ 
	  Ester.getProp "height" "50",
	  Ester.getProp "width" "100",
	  Ester.getProp "x" (toString ( marioX + barierCount * 150.0) ),
	  Ester.getProp "y" (toString ( groundY - ( (barierCount/4.0) * 280.0 ) ) ) ,
	  Ester.getProp "fill" "#22ff22",
	  Ester.getProp "path" "img/wall.png"
	]}) 	