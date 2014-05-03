{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

module Web (
	web
	) where

import Web.Scotty
import Data.Monoid (mconcat)
import qualified Database.Redis as RED
import qualified Database.MongoDB as MGO

{-
runScotty port = scotty port $ do
	get "/:word" $ do
		beam <- param "word"
		html beam
-}

web port act = scotty port act
