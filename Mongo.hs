{-# LANGUAGE OverloadedStrings #-}

module Mongo (
	mcon,
	mrun
	) where

import Database.MongoDB
import Data.CompactString ()
import Data.Text.Internal
import Control.Monad.IO.Class

mcon h = runIOE $ connect $ host h

mrun p collection act = do access p master collection act
