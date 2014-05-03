{-# LANGUAGE FlexibleInstances, FlexibleContexts, UndecidableInstances, OverlappingInstances #-}

module Stat (
	statFiles,
	statFile) where

import StatInc
import Control.Exception
import System.Posix.Types
import System.Posix.Files
import Control.Monad
import Data.Maybe
import Text.Printf(printf)


createFilePair a b = FilePair { path = a, stat = b }


statFiles :: [FilePath] -> IO [FilePair]
statFiles l = liftM catMaybes $ mapM statFile l


statFile :: FilePath -> IO (Maybe FilePair)
statFile s = liftM (Just . createFilePair s . fromJust) (statFileContainer s)


statFileContainer :: FilePath -> IO (Maybe FileStatus)
statFileContainer s =
	catch (getFileStatus s >>= \x -> return (Just x))
			(\e -> do
				let err = show (e :: IOError)
				return Nothing)


instance Show (FilePair) where
	show fp = show $
		"path="++(path fp)++sep++
		(fsToString (stat fp))
		where
			sep = " "

type XFileStatus = FileStatus
{-
instance Show (XFileStatus) where
	show fs = show $ fsToString fs
	-}

fsToString fs =
		"deviceID="++(show (deviceID fs))++sep++
		"fileID="++(show (fileID fs))++sep++
		"fileMode="++(show (fileMode fs))++sep++
		"linkCount="++(show (linkCount fs))++sep++
		"fileOwner="++(show (fileOwner fs))++sep++
		"fileGroup="++(show (fileGroup fs))++sep++
		"specialDeviceID="++(show (specialDeviceID fs))++sep++
		"fileSize="++(show (fileSize fs))++sep++
		"accessTime="++(show (accessTime fs))++sep++
--		"accessTimeHiRes="++(show (accessTimeHiRes fs))++sep++
		"modificationTime="++(show (modificationTime fs))++sep++
--		"modificationTimeHiRes="++(show (modificationTimeHiRes fs))++sep++
		"statusChangeTime="++(show (statusChangeTime fs))++sep++
--		"statusChangeTimeHiRes="++(show (statusChangeTimeHiRes fs))++sep++
		"isBlockDevice="++(show (isBlockDevice fs))++sep++
		"isCharacterDevice="++(show (isCharacterDevice fs))++sep++
		"isNamedPipe="++(show (isNamedPipe fs))++sep++
		"isRegularFile="++(show (isRegularFile fs))++sep++
		"isDirectory="++(show (isDirectory fs))++sep++
		"isSymbolicLink="++(show (isSymbolicLink fs))++sep++
		"isSocket="++(show (isSocket fs))
		where
			sep = " "
