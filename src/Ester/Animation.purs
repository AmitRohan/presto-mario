module Ester.Animation where

{- helper functions to render animate svg game objects -}

import Prelude 

import Data.Foreign.Class (class Decode, class Encode)
-- import Data.Foreign.NullOrUndefined 
import Data.Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Newtype (class Newtype)


-- | Base types for SVG Transformations
data IDi = IDi String 	-- ID
data Vi = Vi Number 	-- VALUE
data Ti = Ti Number 	-- TIME

-- | Supported SVG Transformations
data Transformation = Rotate 
	| Scale 
	| ScaleX 
	| ScaleY 
	| SkewX
	| SkewY
	| TranslateX
	| TranslateY

-- | Base structure of an SVG
newtype SVGObject = SVGObject { 
		x :: SVGAnimatedLength
		, y :: SVGAnimatedLength
		,height :: SVGAnimatedLength
		, width :: SVGAnimatedLength
	}

-- | Base structure of any parameter of SVG
newtype SVGAnimatedLength = SVGAnimatedLength { 
		animValue :: SVGLength
		, baseVal :: SVGLength
	}

-- | Base structure of any value in SVG
newtype SVGLength = SVGLength { 
		unitType :: Number
		, value :: Number
		, valueAsString :: String 
		, valueInSpecifiedUnits :: Number
	}


-- | Returns SVGObject from DOM based on ID.
foreign import getById :: IDi -> SVGObject

-- | Applies transformation on SVGObject based on Param and Value
foreign import transform :: String -> Vi -> SVGObject -> SVGObject

-- | Rotate SVGObject on a pivot point with an Angle
foreign import rotateAt :: Vi -> Number -> Number -> Ti -> SVGObject -> SVGObject

-- | Starts Stroke Animation on Path
foreign import startPathAnimation :: SVGObject -> SVGObject

-- | Function to log any data
foreign import logAny :: forall a. a -> Unit


-- | Returns BaseValue of an SVGAnimatedLength Object
getBaseValues::SVGAnimatedLength -> SVGLength 
getBaseValues (SVGAnimatedLength v) = v.baseVal

-- | Returns AnimValue of an SVGAnimatedLength Object
getAnimValues::SVGAnimatedLength -> SVGLength 
getAnimValues (SVGAnimatedLength v) = v.animValue


-- | Returns the value of an SVGLength Object in NUMBER
getValue:: SVGLength -> Number 
getValue (SVGLength sl) = sl.value

-- | Returns the value of an SVGLength Object in STRING
getValueAsString:: SVGLength -> String 
getValueAsString (SVGLength sl) = sl.valueAsString

-- | Map Transformation To Params
mapParam :: Transformation -> String
mapParam Rotate  	= "rotate"
mapParam Scale  	= "scale"
mapParam ScaleX 	= "scaleX "
mapParam ScaleY 	= "scaleY "
mapParam SkewX		= "skewX"
mapParam SkewY		= "skewY"
-- mapParam _			= "rotate"
mapParam TranslateX	= "dx"
mapParam TranslateY	= "dy"

-- | Applies a Transformation with a Value over and SVGObject and returns and instance of modified object.
svgTransform :: Transformation -> Vi -> SVGObject -> SVGObject
svgTransform t v (SVGObject s) =  transform ( mapParam t) v (SVGObject s)

-- | Applies a Rotation Transformation ( pivot = center ) with a Value over and SVGObject and returns and instance of modified object.
rotateAtCenter::Vi -> Ti -> SVGObject -> SVGObject
rotateAtCenter v t (SVGObject s) = rotateAt v fixX fixY t (SVGObject s)
	where
		fixY = ( getValue $ getBaseValues $ s.y ) + heightFix
		fixX = ( getValue $ getBaseValues $ s.x ) + widthFix
		heightFix = ( getValue $ getBaseValues $ s.height ) / 2.0
		widthFix = ( getValue $ getBaseValues $ s.width ) / 2.0		
	
-- | Helper functions for JS comunication
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
