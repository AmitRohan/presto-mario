module Ester where

{- helper functions to render svg game objects and update them -}

import Prelude 
import Control.Monad.Eff (Eff)

import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

import FRP.Event (Event)

foreign import logAny :: forall a. a -> Unit

data SvgName = SvgName String
derive instance genericSvgName :: Generic (SvgName) _
instance showSvgName :: Show SvgName where show = genericShow
instance encodeSvgName :: Encode SvgName where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeSvgName :: Decode SvgName where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x

data SvgNameCache = SvgNameCache (Array SvgName)
derive instance genericSvgNameCache :: Generic (SvgNameCache) _
instance showSvgNameCache :: Show SvgNameCache where show = genericShow
instance encodeSvgNameCache :: Encode SvgNameCache where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeSvgNameCache :: Decode SvgNameCache where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x

data GameObject = GameObject { name :: String }
derive instance genericGameObject :: Generic (GameObject) _
instance showGameObject :: Show GameObject where show = genericShow
instance encodeGameObject :: Encode GameObject where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeGameObject :: Decode GameObject where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x


data GameObjectCache = GameObjectCache (Array GameObject)
derive instance genericGameObjectCache :: Generic (GameObjectCache) _
instance showGameObjectCache :: Show GameObjectCache where show = genericShow
instance encodeGameObjectCache :: Encode GameObjectCache where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeGameObjectCache :: Decode GameObjectCache where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x



data NodeType = Rectangle | Circle | TextArea | Image | Path | Group | Oval
derive instance genericNodeType :: Generic (NodeType) _
instance showNodeType :: Show NodeType where show = genericShow
instance encodeNodeType :: Encode NodeType where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeNodeType :: Decode NodeType where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x

data Property = Property { key :: String, value :: String }
derive instance genericProperty :: Generic (Property) _
instance showProperty :: Show Property where show = genericShow
instance encodeProperty :: Encode Property where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeProperty :: Decode Property where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x 

data PropertyList = PropertyList (Array Property)
derive instance genericPropertyList :: Generic (PropertyList) _
instance showPropertyList :: Show PropertyList where show = genericShow
instance encodePropertyList :: Encode PropertyList where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodePropertyList :: Decode PropertyList where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x  

data Speed = Speed { vx :: Number, vy :: Number}
derive instance genericSpeed :: Generic (Speed) _
instance showSpeed :: Show Speed where show = genericShow
instance encodeSpeed :: Encode Speed where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeSpeed :: Decode Speed where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x

data Node = Node { name :: String, nodeType :: String, props :: Array Property }
derive instance genericNode :: Generic (Node) _
instance showNode :: Show Node where show = genericShow
instance encodeNode :: Encode Node where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeNode :: Decode Node where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x

data GameBoard = GameBoard { id :: String, height :: Number, width :: Number}
derive instance genericGameBoard :: Generic (GameBoard) _
instance showGameBoard :: Show GameBoard where show = genericShow
instance encodeGameBoard :: Encode GameBoard where
  encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeGameBoard :: Decode GameBoard where
  decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x

type Collision a = { xP :: String, xM :: String, yP :: String, yM :: String | a }
foreign import initGameBoard :: forall eff . GameBoard -> Eff eff Unit
foreign import clearGameBoard :: forall eff . Eff eff Unit
foreign import getSvgNameCache :: forall eff . Eff eff SvgNameCache
foreign import addGameObject :: forall eff . SvgName -> Node -> Eff eff Unit
foreign import getGameObjectProps :: forall eff . SvgName -> Eff eff PropertyList
foreign import detectCollision :: forall a c. a -> SvgName -> (Collision c)
foreign import modifyGameObject :: forall eff . SvgName -> PropertyList -> Eff eff Unit
foreign import removeGameObject :: forall eff . SvgName -> Eff eff Unit


foreign import keyController :: Event { keyCode :: Int }
foreign import joyStickPressController :: Event { keyCode :: Int }
foreign import joyStickReleaseController :: Event { keyCode :: Int }

getProp :: String -> String -> Property
getProp k v = Property { key : k , value : v }

