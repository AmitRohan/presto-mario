#BoxChaser

PrestoDOM is a new in-development UI library written in PureScript language by Juspay Technologies Pvt. Ltd.

This repository showcases the capabilities of the library by making a Box Chaser game that you can play with the keyboard.

PS: The PrestoDOM library is internal at the moment, so you need access to it in order to compile this source code. We are going to open source it soon, so until then, you can browse the code to see how it is done. This notice will be removed once the code is made public for everyone.

#Demo
https://amitrohan.github.io/presto-mario/

#Cloning the repository

`$ git clone https://github.com/AmitRohan/presto-mario/
$ npm i
$ bower i`

#Running in the server

`$ npm start`

Once that is done, browse to http://localhost:8080/ to play the game.

#Compiling for distribution

`$ npm run compile-ps
$ npm run compile-js`

Now package everything in the dist directory and distribute.

#About	
	
	BoxChaser
		GameUI -> Presto Dom for User InterFace							
		GameBoard -> Functions to add game objects to game board  	
		GameConfig -> Constants for the Game 					   		
		EnemyManager -> Helper functions to modify Enemy objects			
		PlayerManager -> Helper functions to modify Player objects			
		Types -> Contains Types declared needed for the Game 			

