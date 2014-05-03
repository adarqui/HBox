module Kill (
	kill,
	kill') where

--import System.Posix.Unistd
import Control.Exception
import System.Posix.Types
import System.Posix.Signals
import System.Console.GetOpt
import Foreign.C.Types
import Data.Maybe

import Pipeline

type RKill = R ProcessID CInt (Maybe IOError)

data KillOptions = KillOptions {
	optSignal :: CInt
}


defaultKillOptions = KillOptions {
	optSignal = sigTERM
}


killOptions :: [OptDescr (KillOptions -> KillOptions)]
killOptions =
	[ Option ['s'] ["signal"]
		(OptArg ((\s opts -> opts { optSignal = read (fromJust s) :: CInt})) "signal")
		"s"
	]


killCompilerOpts :: [String] -> IO (KillOptions, [String])
killCompilerOpts argv =
	case getOpt Permute killOptions argv of
		(o, n, []) -> return (foldl (flip Prelude.id) defaultKillOptions o, n)
		(_, _, er) -> ioError (userError (concat er ++ usageInfo header killOptions))
	where header = "Usage: kill [-s<signum> processes ...]"


killOne :: KillOptions -> String -> IO RKill
killOne opts process = do
	catch (signalProcess (optSignal opts) (read process :: ProcessID) >> return (R process_id sig Nothing))
		(\e -> do
			let err = show (e :: IOError)
			return (R process_id sig (Just e)))
	where
		process_id = read process :: ProcessID
		sig = optSignal opts


kill :: [String] -> IO [RKill]
kill argv = do
	(opts, processes) <- killCompilerOpts argv
	mapM (\x -> killOne opts x) processes

kill' = kill
