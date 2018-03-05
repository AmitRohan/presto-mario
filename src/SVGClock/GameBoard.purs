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
	
	_ <- Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "Background", nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" (toString boardHeight),
	  Ester.getProp "width" (toString boardWidth),
	  Ester.getProp "x" "0",
	  Ester.getProp "y" "0",
	  Ester.getProp "fill" "#90CAF9"
	]}) 

	Ester.addGameObject (Ester.SvgName "World") (Ester.Node { name : "PathObject", nodeType : "Path" , props : [ 
		Ester.getProp "id" "MyPath1", 
		Ester.getProp "d" "M0 0 H50 A20 20 0 1 0 100 50 v25 C50 125 0 85 0 85 z", 
		Ester.getProp "fill" "none", 
		Ester.getProp "stroke-linecap" "round", 
		Ester.getProp "stroke-linejoin" "round", 
		Ester.getProp "stroke-width" "4", 
		Ester.getProp "stroke-color" "#ff0066" 
	]}) 


-- Update The Object based on id and model
-- patchBoard:: forall t . String -> ClockModel -> Eff t Unit
-- patchBoard objectName (Model objectModel) = 
-- 	Ester.modifyGameObject (Ester.SvgName objectName) (Ester.PropertyList propList) 
-- 		where
-- 			propList = [
-- 					    Ester.getProp "x" newX ,
-- 					    Ester.getProp "y" newY
-- 					  ]
-- 			newY = toString ( objectModel.y )
-- 			newX = toString ( objectModel.x )   					  

addRectangle ::  forall t. String -> String -> String -> String -> String -> String -> Eff t Unit
addRectangle _name x y width height color = Ester.addGameObject (Ester.SvgName "Obstacles") (Ester.Node { name : _name, nodeType : "Rectangle" , props : [ 
	  Ester.getProp "height" height,
	  Ester.getProp "width" width,
	  Ester.getProp "x" x,
	  Ester.getProp "y" y ,
	  Ester.getProp "fill" color
	]})