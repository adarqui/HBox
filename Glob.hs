module Glob (
	glob,
	globs) where

import Control.Monad (liftM)
import Data.List (concat)
import Misc (concatMapM)
import qualified System.Path.Glob as GLOB

glob = GLOB.glob

globs xs = liftM concat $ mapM glob xs
