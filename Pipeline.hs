module Pipeline (
	R(..),
	X(..)) where

import Data.Maybe

-- Command Result
data R a b c = R {
	who :: a,
	ret :: b,
	ex :: c
} deriving (Show, Read)

type CommandResult = R

--newtype NRes a b c = NRes { getNRes :: (a, b, c) } deriving (Show,Read)

newtype X a b c = X { getX :: R a b c } deriving (Show,Read)

type CommandResultWrapper = X
