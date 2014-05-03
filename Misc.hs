module Misc (
	concatMapM) where

import Control.Monad

concatMapM f xs = liftM concat (mapM f xs)
