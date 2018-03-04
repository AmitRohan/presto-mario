module Ester.Animation where

{- helper functions to render animate svg game objects -}

import Prelude 

import Data.Foreign.Class (class Decode, class Encode)
-- import Data.Foreign.NullOrUndefined 
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)


-- BASE TYPES 
data IDi = IDi String 	-- ID
data Ti = Ti Number 	-- TIME
data Vi = Vi Number 	-- VALUE

data Transformation = Rotate 
	| Scale 
	| ScaleX 
	| ScaleY 
	| SkewX
	| SkewY
	-- | TranslateX
	-- | TranslateY

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
foreign import transform :: String -> Vi -> SVGObject -> SVGObject
foreign import rotateAt :: Vi -> Number -> Number -> Ti -> SVGObject -> SVGObject
foreign import logAny :: forall a. a -> Unit


-- HELPER FUNCTIONS TO EXTRACT VALUES
getBaseValues::SVGAnimatedLength -> SVGLength 
getBaseValues (SVGAnimatedLength v) = v.baseVal

getAnimValues::SVGAnimatedLength -> SVGLength 
getAnimValues (SVGAnimatedLength v) = v.animValue

getValue:: SVGLength -> Number 
getValue (SVGLength sl) = sl.value

getValueAsString:: SVGLength -> String 
getValueAsString (SVGLength sl) = sl.valueAsString

-- rotate::forall s. Vi -> Vi -> Ti -> SVGObject -> SVGObject
-- rotate v1 v2 t (s::SVGObject) = transform (Transformation "rotate") v1 v2 s


--Map Transformation To Params
mapParam :: Transformation -> String
mapParam Rotate  	= "rotate"
mapParam Scale  	= "scale"
mapParam ScaleX 	= "scaleX "
mapParam ScaleY 	= "scaleY "
mapParam SkewX		= "skewX"
mapParam SkewY		= "skewY"
mapParam _			= "rotate"
-- mapParam TranslateX	= "dx"
-- mapParam TranslateY	= "dy"

-- TRANSFORMATION FUNCTIONS
svgTransform :: Transformation -> Vi -> SVGObject -> SVGObject
svgTransform transformation v (SVGObject s) = do  
	transform ( mapParam transformation) v (SVGObject s)

-- flip::Vi -> Ti -> SVGObject -> SVGObject
-- flip v t (SVGObject s) = svgTransform Flip v (SVGObject s)

rotate::Vi -> Ti -> SVGObject -> SVGObject
rotate v t (SVGObject s) = svgTransform Rotate v (SVGObject s)
	
rotateAtCenter::Vi -> Ti -> SVGObject -> SVGObject
rotateAtCenter v t (SVGObject s) = rotateAt v fixX fixY t (SVGObject s)
	where
		fixY = ( getValue $ getBaseValues $ s.y ) + heightFix
		fixX = ( getValue $ getBaseValues $ s.x ) + widthFix
		heightFix = ( getValue $ getBaseValues $ s.height ) / 2.0
		widthFix = ( getValue $ getBaseValues $ s.width ) / 2.0		
	


-- instances for JS parsing
derive instance genericIdi :: Generic (IDi) _
derive instance genericVi :: Generic (Vi) _
derive instance genericTi :: Generic (Ti) _
derive instance genericTransformation :: Generic (Transformation) _
derive instance genericSVGObject :: Newtype SVGObject _
derive instance genericSVGAnimatedLength :: Newtype SVGAnimatedLength _
derive instance genericSVGLength :: Newtype SVGLength _

instance showIDi :: Show IDi where show = genericShow
instance showVi :: Show Vi where show = genericShow
instance showTi :: Show Ti where show = genericShow
instance showTransformation :: Show Transformation where show = genericShow


instance encodeIDi :: Encode IDi where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeVi :: Encode Vi where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeTi :: Encode Ti where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x
instance encodeTransformation :: Encode Transformation where
	encode x = genericEncode (defaultOptions { unwrapSingleConstructors = true }) x


instance decodeIDi :: Decode IDi where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeVi :: Decode Vi where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
instance decodeTi :: Decode Ti where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x	
instance decodeTransformation :: Decode Transformation where
	decode x = genericDecode (defaultOptions { unwrapSingleConstructors = true }) x
