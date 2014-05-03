module File (
	sToFileMode,
	oToFileMode,
	defaultPermissions,
	setFilePermissions,
	permissionsFromInt) where

import System.Posix.Types
import System.Posix.Files
import qualified Data.Map as M
import Data.Bits

type XFileMode = FileMode

data Permissions =
	S_IRUSR | S_IWUSR | S_IXUSR |
	S_IRGRP | S_IWGRP | S_IXGRP |
	S_IROTH | S_IWOTH | S_IXOTH |
	S_INONE deriving (Show, Enum, Bounded, Eq, Ord)

permissionsMap = M.fromList [
	(S_IRUSR, 0o00400),
	(S_IWUSR, 0o00200),
	(S_IXUSR, 0o00100),
	(S_IRGRP, 0o00040),
	(S_IWGRP, 0o00020),
	(S_IXGRP, 0o00010),
	(S_IROTH, 0o00004),
	(S_IWOTH, 0o00002),
	(S_IXOTH, 0o00001),
	(S_INONE, 0o00000)
	]


permissionsMapHS = M.fromList [
	(S_IRUSR, ownerReadMode),
	(S_IWUSR, ownerWriteMode),
	(S_IXUSR, ownerExecuteMode),
	(S_IRGRP, groupReadMode),
	(S_IWGRP, groupWriteMode),
	(S_IXGRP, groupExecuteMode),
	(S_IROTH, otherReadMode),
	(S_IWOTH, otherWriteMode),
	(S_IXOTH, otherExecuteMode),
	(S_INONE, nullFileMode)
	]


sToFileMode :: String -> FileMode
sToFileMode s = oToFileMode (read s :: Int)

oToFileMode :: Int -> FileMode
oToFileMode o =
	foldl (\x a -> unionFileModes x (snd a)) nullFileMode (permissionsFromInt o)

permissionsFromInt :: Int -> [(Permissions, FileMode)]
permissionsFromInt o = 
	map lambda [S_IRUSR .. S_IXOTH]
	where
		lambda x = if (o .&. (permissionsMap M.! x) >0) then (x, permissionsMapHS M.! x) else (x, nullFileMode)

defaultPermissions = unionFileModes ownerReadMode $ unionFileModes ownerWriteMode ownerExecuteMode

setFilePermissions = setFileMode
