module Uname (
	arch,
	uname,
	uname',
	UnameData(..),
	systemName,
	nodeName,
	release,
	version,
	machine) where

import System.Posix.Unistd
import System.Console.GetOpt
import Data.Maybe
import Control.Monad
import Pipeline

type UnameData = SystemID

type RUname = R Bool (Maybe SystemID) (Maybe IOError)

data UnameOptions = UnameOptions {
	optAll :: Bool,
	optSysName :: Bool,
	optNodeName :: Bool,
	optRelease :: Bool,
	optVersion :: Bool,
	optMachine :: Bool
}

defaultUnameOptions = UnameOptions {
	optAll = False,
	optSysName = True,
	optNodeName = False,
	optRelease = False,
	optVersion = False,
	optMachine = False
}


instance Show (SystemID) where
	show ud = show $
		"systemName: " ++ (systemName ud) ++
		", nodeName: " ++ (nodeName ud) ++
		", release: " ++ (release ud) ++
		", version: " ++ (version ud) ++
		", machine: " ++ (machine ud)


unameOptions :: [OptDescr (UnameOptions -> UnameOptions)]
unameOptions =
	[ Option ['a'] ["all"]
		(NoArg (\opts -> opts { optAll = True }))
		"a"
	, Option ['s'] ["sys"]
		(NoArg (\opts -> opts { optSysName = True }))
		"s"
	, Option ['n'] ["node"]
		(NoArg (\opts -> opts { optNodeName = True }))
		"n"
	, Option ['r'] ["release"]
		(NoArg (\opts -> opts { optRelease = True }))
		"r"
	, Option ['v'] ["version"]
		(NoArg (\opts -> opts { optVersion = True }))
		"v"
	, Option ['m'] ["machine"]
		(NoArg (\opts -> opts { optMachine = True }))
		"m"
	]

unameCompilerOpts :: [String] -> IO (UnameOptions, [String])
unameCompilerOpts argv =
	case getOpt Permute unameOptions argv of
		(o, n, []) -> return (foldl (flip Prelude.id) defaultUnameOptions o, n)
		(_, _, er) -> ioError (userError (concat er ++ usageInfo header unameOptions))
	where header = "Usage: uname [-a, -s, -n, -r, -v, -m]"

uname :: IO RUname
uname = do
	getSystemID >>= return . (\x -> R True (Just x) Nothing)

{-
uname' :: [String] -> IO ()
uname' argv = do
	(idopts, _) <- unameCompilerOpts argv
	uname >>= print
	-}

uname' = uname

arch :: IO String
arch = uname >>= return . machine . fromJust . ret
