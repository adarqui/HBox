module StatInc (
	FilePair(..),
	) where

import System.Posix.Files

data FilePair = FilePair { path :: FilePath, stat :: FileStatus }
