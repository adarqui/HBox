module Id (
	Id.id,
	creds,
	id',
	IdData(..)) where

import System.Posix.Types
import System.Posix.User
import System.Console.GetOpt
import Data.Maybe
import Control.Monad

data IdData = IdData {
	uid :: UserID,
	gid :: GroupID,
	groups :: [GroupID],
	login :: String
} deriving (Show)

data IdOptions = IdOptions {
	optUser :: Bool,
	optGroup :: Bool,
	optGroups :: Bool
}

defaultIdOptions = IdOptions {
	optUser = False,
	optGroup = False,
	optGroups = False
}

idOptions :: [OptDescr (IdOptions -> IdOptions)]
idOptions =
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

idCompilerOpts :: [String] -> IO (IdOptions, [String])
idCompilerOpts argv =
	case getOpt Permute idOptions argv of
		(o, n, []) -> return (foldl (flip Prelude.id) defaultIdOptions o, n)
		(_, _, er) -> ioError (userError (concat er ++ usageInfo header idOptions))
	where header = "Usage: id [-u, -g, -G]"

id :: IO IdData
id = do
	_u <- getRealUserID
	_g <- getRealGroupID
	_gs <- getGroups
	return $
		IdData {
			uid=_u,
			gid=_g,
			groups=_gs,
			login="nobody"
		}

creds = Id.id


id' :: [String] -> IO ()
id' argv = do
	_id <- creds
	(idopts, _) <- idCompilerOpts argv
	parse _id (optUser idopts) (optGroup idopts) (optGroups idopts) >> return ()
	where
		parse _id True False False = print $ uid _id
		parse _id False False False = print $ uid _id
		parse _id False True False = print $ gid _id
		parse _id False False True = print $ groups _id
		parse _ _ _ _ = print "id: cannot print \"only\" of more than one choice"
