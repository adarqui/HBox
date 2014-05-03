module Env (
	argv,
	env
	) where

import System.Environment

argv = getArgs

env = getEnvironment
