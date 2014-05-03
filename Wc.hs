module HMisc.Wc (wc, wc') where

import System.Posix.Types
import System.Posix.User
import System.Console.GetOpt
import Data.Maybe
import Control.Monad

data WcData = WcData {
	uwc :: UserID,
	gwc :: GroupID,
	groups :: [GroupID],
	login :: String
} deriving (Show)

data WcOptions = WcOptions {
	optUser :: Bool,
	optGroup :: Bool,
	optGroups :: Bool
}

defaultWcOptions = WcOptions {
	optUser = False,
	optGroup = False,
	optGroups = False
}

wcOptions :: [OptDescr (WcOptions -> WcOptions)]
wcOptions =
	[ Option ['u'] ["user"]
		(NoArg (\opts -> opts { optUser = True }))
		"u"
	, Option ['g'] ["group"]
		(NoArg (\opts -> opts { optGroup = True }))
		"g"
	, Option ['G'] ["groups"]
		(NoArg (\opts -> opts { optGroups = True }))
		"G"
	]

wcCompilerOpts :: [String] -> IO (WcOptions, [String])
wcCompilerOpts argv =
	case getOpt Permute wcOptions argv of
		(o, n, []) -> return (foldl (flip Prelude.wc) defaultWcOptions o, n)
		(_, _, er) -> ioError (userError (concat er ++ usageInfo header wcOptions))
	where header = "Usage: wc [-u, -g, -G]"

wc :: IO WcData
wc = do
	_u <- getRealUserID
	_g <- getRealGroupID
	_gs <- getGroups
	return $
		WcData {
			uwc=_u,
			gwc=_g,
			groups=_gs,
			login="nobody"
		}

creds = HMisc.Wc.wc


wc' :: [String] -> IO ()
wc' argv = do
	_wc <- creds
	(wcopts, _) <- wcCompilerOpts argv
	parse _wc (optUser wcopts) (optGroup wcopts) (optGroups wcopts) >> return ()
	where
		parse _wc True False False = print $ uwc _wc
		parse _wc False False False = print $ uwc _wc
		parse _wc False True False = print $ gwc _wc
		parse _wc False False True = print $ groups _wc
		parse _ _ _ _ = print "wc: cannot print \"only\" of more than one choice"
