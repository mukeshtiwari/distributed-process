-- | Built-in closures
module Control.Distributed.Process.Internal.Closure.BuiltIn () where

{-
  ( -- Combinators
    closureApply 
    -- TODO
  , sendClosure
  , returnClosure
  , expectClosure
  ) where

import Data.Binary (encode)
import Data.Typeable (Typeable, typeOf)
import Control.Distributed.Process.Internal.Types 
  ( ProcessId
  , Closure
  , Process
  , SerializableDict(..)
  , Closure(..)
  , Static(..)
  , StaticLabel(..)
  )
import Control.Distributed.Process.Internal.TypeRep () -- Binary instances
import Control.Distributed.Process.Serializable (Serializable)

--------------------------------------------------------------------------------
-- Combinators                                                                --
--------------------------------------------------------------------------------

closureApply :: Closure (a -> b) -> Closure a -> Closure b
closureApply (Closure (Static labelf) envf) (Closure (Static labelx) envx) = 
  Closure (Static ClosureApply) $ encode (labelf, envf, labelx, envx)

closureReturn :: Serializable a => Static (SerializableDict a) -> a -> Closure a
closureReturn (Static dict) x = Closure (Static ClosureReturn) (encode (dict, x)) 

closureStatic :: Static a -> Closure a
closureStatic (Static dict) = Closure (Static ClosureStatic) (encode dict) 

--------------------------------------------------------------------------------
-- Polymorphic closures                                                       --
--                                                                            --
-- TODO: These functions take a SerializableDict as argument. When we get     --
-- proper support for static, ideally this argument disappears completely;    --
-- but if not, it should turn into a static (SerializableDict a). We don't    --
-- require them to be "static" here because we don't have a pure 'unstatic'   --
-- function, and hence have no way of turning a static (SerializableDict a)   --
-- into an actual SerialziableDict a (we need that in order to pattern match  --
-- on the dictionary and bring the type class dictionary into scope, so that  --
-- we can call 'encode' (for instance in 'returnClosure').                    --
--------------------------------------------------------------------------------

-- | Closure version of 'send'
sendClosure :: forall a. SerializableDict a -> ProcessId -> Closure (a -> Process ())
sendClosure SerializableDict pid =
  Closure (Static ClosureSend) (encode (typeOf (undefined :: a), pid)) 

-- | Return any value
returnClosure :: forall a. SerializableDict a -> a -> Closure (Process a)
returnClosure SerializableDict val =
  Closure (Static ClosureReturn) (encode (typeOf (undefined :: a), encode val))

-- | Closure version of 'expect'
expectClosure :: forall a. SerializableDict a -> Closure (Process a)
expectClosure SerializableDict =
  Closure (Static ClosureExpect) (encode (typeOf (undefined :: a)))
-}
