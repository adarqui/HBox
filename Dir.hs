module Dir (
	mkdir,
	mkdir',
	rmdir,
	rmdir',
	cd,
	pwd,
	canon,
	dir,
	(~/),
	mtime,
	mtime') where

import Prelude
import Control.Exception
import System.Posix.Types
import System.Console.GetOpt
import System.Directory
import Data.Maybe
import Control.Monad
import File
import Pipeline

import System.Time
import Data.Time
import Data.Time.Clock.POSIX

type RDir = R String (Maybe Bool) (Maybe IOError)
type RMtime = R FilePath (Maybe UTCTime) (Maybe IOError)

data DirOptions = DirOptions {
	optMode :: FileMode,
	optParents :: Bool,
	optVerbose :: Bool
} deriving (Show)

defaultDirOptions = DirOptions {
	optMode = defaultPermissions,
	optParents = False,
	optVerbose = False
}

dirOptions :: [OptDescr (DirOptions -> DirOptions)]
dirOptions =
	[ Option ['p'] ["parent"]
		(NoArg (\opts -> opts { optParents = True }))
		"p"
	, Option ['v'] ["verbose"]
		(NoArg (\opts -> opts { optVerbose = True }))
		"v"
	, Option ['m'] ["mode"]
		(OptArg ((\m opts -> opts { optMode = sToFileMode (fromJust m) })) "mode")
		"mode"
	]

dirCompilerOpts :: [String] -> IO (DirOptions, [String])
dirCompilerOpts argv =
	case getOpt Permute dirOptions argv of
		(o, n, []) -> return (foldl (flip Prelude.id) defaultDirOptions o, n)
		(_, _, er) -> ioError (userError (concat er ++ usageInfo header dirOptions))
	where header = "Usage: mkdir [-m <mode>, -p] DIRECTORIES ..."



mkdirOne :: DirOptions -> String -> IO RDir
mkdirOne opts dir = do
	catch (createDirectoryIfMissing (optParents opts) dir >> setFilePermissions dir (optMode opts) >> return (R dir Nothing Nothing))
			(\e -> do
				let err = show (e :: IOError)
				return (R dir Nothing (Just e)))


{-
mkdir :: String -> IO RDir
mkdir arg = mkdirOne defaultDirOptions arg
-}

mkdir = mkdir'

mkdir' :: [String] -> IO [RDir]
mkdir' argv = do
	(opts, directories) <- dirCompilerOpts argv
	mapM (\x -> mkdirOne opts x) directories


rmdirOne :: DirOptions -> String -> IO RDir
rmdirOne opts dir = do
	catch (removeDirectory dir >> return (R dir Nothing Nothing))
		(\e -> do
			let err = show (e :: IOError)
			return (R dir Nothing (Just e)))


{-
rmdir :: String -> IO RDir
rmdir arg = rmdirOne defaultDirOptions arg
-}

rmdir = rmdir'

rmdir' :: [String] -> IO [RDir]
rmdir' argv = do
	(opts, directories) <- dirCompilerOpts argv
	mapM (\x -> rmdirOne opts x) directories


cd = setCurrentDirectory


pwd = getCurrentDirectory


dir = getDirectoryContents


(~/) = getHomeDirectory


canon = canonicalizePath


mtime :: FilePath -> IO RMtime
mtime path = do
	catch (getModificationTime path >>= \y -> return (R path (Just y) Nothing))
		(\e -> do
			let err = show (e :: IOError)
			return (R path Nothing (Just e)))


mtime' :: [FilePath] -> IO [RMtime]
mtime' paths = mapM mtime paths
