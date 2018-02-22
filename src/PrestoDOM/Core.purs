module PrestoDOM.Core
	( MEvent
    , class IsProp
    , toPropValue
    , PropName(..)
    , click
    , module Exports
	) where

import Prelude




import Data.Generic (class Generic)


import Data.Newtype (class Newtype)

import Halogen.VDom.DOM.Prop (PropValue, propFromBoolean, propFromInt, propFromNumber, propFromString)

import Halogen.VDom.DOM.Prop (Prop(..), PropValue) as Exports

import PrestoDOM.Types (Length, renderLength)

foreign import click :: MEvent
foreign import getId :: String

data MEvent

{-- data AttrTypes = String | Foreign --}
-- data AttrValue = AttrValue String | ScreenTag Foreign | Some MEvent

-- newtype Attr a = Attr (Array (Prop a))

-- type Prop = Tuple String AttrValue type-safe wrapper for property names.
-- |
-- | The phantom type `value` describes the type of value which this property
-- | requires.
newtype PropName value = PropName String

derive instance newtypePropName :: Newtype (PropName value) _
derive newtype instance eqPropName :: Eq (PropName value)
derive newtype instance ordPropName :: Ord (PropName value)
derive instance genericPropName :: Generic (PropName value)

class IsProp a where
  toPropValue :: a -> PropValue

instance stringIsProp :: IsProp String where
  toPropValue = propFromString

instance intIsProp :: IsProp Int where
  toPropValue = propFromInt

instance numberIsProp :: IsProp Number where
  toPropValue = propFromNumber

instance booleanIsProp :: IsProp Boolean where
  toPropValue = propFromBoolean

instance lengthIsProp :: IsProp Length where
  toPropValue = propFromString <<< renderLength

