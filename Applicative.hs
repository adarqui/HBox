module Applicative (
	(<$$>)) where

import Control.Monad

infixl 4 <$$>

{-
(<$$>) :: Functor f => (a -> b) -> f a -> f b
(<$$>) a b = a `fmap` b
-}

(<$$>) :: Functor f => f a -> (a -> b) -> f b
(<$$>) a b = fmap b a
