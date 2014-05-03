module Pool (
	thread,
	sec,
	sleep,
	tkill,
	createBoundedPool,
	boundedWrite,
	boundedPoolIO) where

import Control.Monad (forever, forM_)
import Control.Concurrent (forkIO,forkOS,threadDelay,killThread)
import Control.Concurrent.Chan
import Control.Concurrent.BoundedChan


sec n = n * 1000000


sleep n = threadDelay $ sec n


thread = forkIO


tkill = killThread


boundedPoolIO :: Int -> (a -> IO b) -> IO (BoundedChan a)
boundedPoolIO nr mutator = do
		input <- newBoundedChan nr
		forM_ [1..nr] $
			\n -> forkOS (forever $ do
					i <- Control.Concurrent.BoundedChan.readChan input
					mutator i
					)
		return input


createBoundedPool :: Int -> (a -> IO b) -> IO (BoundedChan a)
createBoundedPool = boundedPoolIO


boundedWrite :: BoundedChan a -> a -> IO ()
boundedWrite = Control.Concurrent.BoundedChan.writeChan
