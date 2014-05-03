{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances, FlexibleContexts, UndecidableInstances, OverlappingInstances #-}

module Loader where

import Control.Monad
import Control.Applicative

import System.Process

import Data.List
import Data.Maybe
import Data.Either
import Data.Either.Unwrap
import qualified Data.ByteString.Char8 as B

import Control.Lens -- lens.github.io/tutorial.html
--import Data.Lens -- https://github.com/ekmett/lens/wiki
import qualified Database.Redis as RED

import Database.Redis -- http://hackage.haskell.org/package/hedis-0.4.1/docs/Database-Redis.html
import Database.MongoDB
import qualified Database.MongoDB as MGO

import Pipeline
import Applicative
import Dir
import Kill
import Blocks
import Cat
import File
import Id
import Uname
import Misc
import MoveTup
import Pool
import Stat
import StatInc
import Time
--import Truncate
import Tuples
import Glob
import Env
import Web

import Redis
import Mongo

import Aliases
