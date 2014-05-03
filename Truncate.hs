module Truncate (trunc, trunc') where

import System.Posix.Types
import System.Posix.Files
import System.Console.GetOpt
import Data.Maybe
import Control.Monad
import MoveTup
import Blocks


data TruncateData = TruncateData {
	before :: FileStatus,
	after :: FileStatus
}

data TruncateOptions = TruncateOptions {
	optNoCreate :: Bool,
	optBlocks :: Int,
	optReference :: Maybe String,
	optSize :: String
} deriving (Show)

defaultTruncateOptions = TruncateOptions {
	optNoCreate = False,
	optBlocks = "B", -- B KB K MB M GB G
	optReference = Nothing,
	optSize = "+0"
}

truncateOptions :: [OptDescr (TruncateOptions -> TruncateOptions)]
truncateOptions =
	[ Option ['c'] ["no-create"]
		(NoArg (\opts -> opts { optNoCreate = True }))
		"c"
	, Option ['b'] ["block-size"]
		(OptArg ((\f opts -> opts { optBlocks = fromJust f })) "Blocks")
		"b"
	, Option ['r'] ["reference"]
		(OptArg ((\f opts -> opts { optReference = f })) "Reference")
		"r"
	, Option ['s'] ["size"]
		(OptArg ((\f opts -> opts { optSize = fromJust f })) "Size")
		"s"
	]

truncateCompilerOpts :: [String] -> IO (TruncateOptions, [String])
truncateCompilerOpts argv =
	case getOpt Permute truncateOptions argv of
		(o, n, []) -> return (foldl (flip id) defaultTruncateOptions o, n)
		(_, _, er) -> ioError (userError (concat er ++ usageInfo header truncateOptions))
	where header = "Usage: truncate [-c, -b, -r, -s]"

truncOne :: String -> IO TruncateData
truncOne file = do
	_b <- getFileStatus file
	_a <- getFileStatus file
	return TruncateData {
		before = _b,
		after = _a
	}

trunc :: [String] -> IO [TruncateData]
trunc argv = mapM truncOne argv


trunc' :: [String] -> IO ()
trunc' argv = do
	(idopts, other) <- truncateCompilerOpts argv
	print idopts
	print other
