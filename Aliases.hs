module Aliases (
	ls,
	f) where

import Control.Monad (mapM_)
import Dir (dir)

ls p = dir p

f a = do { mapM_ print a ; return a }
