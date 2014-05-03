module Cat (cat, cat') where

import System.Posix.Types
import System.Posix.Files
import System.Console.GetOpt
import Data.Maybe
import Control.Monad
import Misc

cat :: [String] -> IO String
cat [] = do getLine
cat argv = do concatMapM readFile argv

cat' :: [String] -> IO ()
cat' argv = do
	i <- cat argv
	print i
	--print "cat io"
