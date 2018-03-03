module Ester.Animation where

{- helper functions to render animate svg game objects -}

import Prelude 
import Control.Monad.Eff (Eff)

import Data.Foreign.Class (class Decode, class Encode)
import Data.Foreign.NullOrUndefined 
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype


-- BASE TYPES 
data IDi = IDi String 	-- ID
data Ti = Ti Number 	-- TIME
data Vi = Vi Number 	-- VALUE
data Cx = Cx Number 	-- CENTER X
data Cy = Cy Number 	-- CENTER Y

data Transformation = Transformation String

newtype SVGObject = SVGObject { 
		x :: SVGAnimatedLength
		, y :: SVGAnimatedLength
		,height :: SVGAnimatedLength
		, width :: SVGAnimatedLength
	}

newtype SVGAnimatedLength = SVGAnimatedLength { 
		animValue :: SVGLength
		, baseVal :: SVGLength
	}

newtype SVGLength = SVGLength { 
		unitType :: Number
		, value :: Number
		, valueAsString :: String 
		, valueInSpecifiedUnits :: Number
	}


-- JS Functions to perfrom transformation on SVG
foreign import getById :: IDi -> SVGObject
foreign import transform :: Transformation -> Vi -> Vi -> SVGObject -> SVGObject
foreign import rotateAt :: Vi -> Cx -> Cy -> Ti -> SVGObject -> SVGObject
foreign import logAny :: forall a. a -> Unit


-- HELPER FUNCTIONS TO EXTRACT VALUES
getBaseValues::forall sal sl. SVGAnimatedLength -> SVGLength 
getBaseValues (SVGAnimatedLength v) = v.baseVal

getAnimValues::forall sal sl. SVGAnimatedLength -> SVGLength 
getAnimValues (SVGAnimatedLength v) = v.animValue

getValue:: SVGLength -> Number 
getValue (SVGLength sl) = sl.value

getValueAsString:: SVGLength -> String 
getValueAsString (SVGLength sl) = sl.valueAsString

-- rotate::forall s. Vi -> Vi -> Ti -> SVGObject -> SVGObject
-- rotate v1 v2 t (s::SVGObject) = transform (Transformation "rotate") v1 v2 s


-- TRANSFORMATION FUNCTIONS
flip::forall s. Vi -> Vi -> Ti -> SVGObject -> SVGObject
flip v1 v2 t s = transform (Transformation "flip") v1 v2 s

rotate::forall s. Vi -> Ti -> SVGObject -> SVGObject
rotate v t (SVGObject s) = rotateAt v (Cx fixX ) (Cy fixY) t (SVGObject s)
	where
		fixY = ( getValue $ getBaseValues $ s.height ) / 2.0
		fixX = ( getValue $ getBaseValues $ s.width ) / 2.0
		th = logAny fixY
		tw = logAny fixX
		tl = logAny s
	


-- instances for JS parsing
derive instance genericIdi :: Generic (IDi) _
derive instance genericVi :: Generic (Vi) _
derive instance genericTi :: Generic (Ti) _
derive instance genericCx :: Generic (Cx) _
derive instance genericCy :: Generic (Cy) _
derive instance genericTransformation :: Generic (Transformation) _
derive instance genericSVGObject :: Newtype SVGObject _
derive instance genericSVGAnimatedLength :: Newtype SVGAnimatedLength _
derive instance genericSVGLength :: Newtype SVGLength _

instance showIDi :: Show IDi where show = genericShow
instance showVi :: Show Vi where show = genericShow
instance showTi :: Show Ti where show = genericShow
instance showCx :: Show Cx where show = genericShow
instance showCy :: Show Cy where show = genericShow
instance showTransformation :: Show Transformation where show = genericShow
-- instance showSVGObject :: Show SVGObject where show = genericShow
-- instance showSVGAnimatedLength :: Show SVGAnimatedLength where show = genericShow
-- instance showSVGLength :: Show SVGLength where show = genericShow

instance encodeIDi :: Encode IDi where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeVi :: Encode Vi where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeTi :: Encode Ti where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeCx :: Encode Cx where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeCy :: Encode Cy where	
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeTransformation :: Encode Transformation where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
-- instance encodeSVGObject :: Encode SVGObject where
-- 	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
-- instance encodeSVGAnimatedLength :: Encode SVGAnimatedLength where
-- 	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
-- instance encodeSVGLength :: Encode SVGLength where
-- 	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x

instance decodeIDi :: Decode IDi where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeVi :: Decode Vi where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeTi :: Decode Ti where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x	
instance decodeCx :: Decode Cx where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeCy :: Decode Cy where	
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeTransformation :: Decode Transformation where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
-- instance decodeSVGObject :: Decode SVGObject where
-- 	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
-- instance decodeSVGAnimatedLength :: Decode SVGAnimatedLength where
-- 	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
-- instance decodeSVGLength :: Decode SVGLength where
-- 	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
