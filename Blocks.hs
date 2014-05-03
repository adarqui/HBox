module Blocks (
	toBlock,
	blockToS) where

data Size = B | K | KB | M | MB | G | GB | T | TB deriving (Show, Read)
data Block = Block { btype :: Size, bsize :: Int, bcount :: Int } deriving (Show)

b = Block { btype = B, bsize = 1, bcount = 1 }
kb = Block { btype = KB, bsize = (bsize b * 1000), bcount = 1 }
k = Block { btype = K, bsize = (bsize b * 1024), bcount = 1 }
mb = Block { btype = MB, bsize = (bsize kb * bsize kb), bcount = 1 }
m = Block { btype = M, bsize = (bsize k * bsize k), bcount = 1 }
gb = Block { btype = GB, bsize = (bsize mb * bsize mb), bcount = 1 }
g = Block { btype = G, bsize = (bsize m * bsize m), bcount = 1 }
tb = Block { btype = TB, bsize = (bsize gb * bsize gb), bcount = 1 }
t = Block { btype = T, bsize = (bsize g * bsize g), bcount = 1 }

toBlock s = case s of
	"B" -> b
	"KB" -> kb
	"K" -> k
	"MB" -> mb
	"M" -> m
	"GB" -> gb
	"G" -> g
	"TB" -> tb
	"T" -> t

blockToS a = a
