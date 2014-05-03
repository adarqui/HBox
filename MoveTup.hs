module MoveTup (toMove, moveToS) where

data MoveTup a = Extend a | Reduce a | AtLeast a | AtMost a | RoundDown a | RoundUp a deriving (Show)

toMove :: [Char] -> MoveTup Int
toMove (c:s)
	| c == '+' = Extend int
	| c == '-' = Reduce int
	| c == '<' = AtLeast int
	| c == '>' = AtMost int
	| c == '/' = RoundDown int
	| c == '%' = RoundUp int
	where
		int = read s :: Int

moveToS :: MoveTup Int -> String
moveToS (Extend a) = '+' : show a
moveToS (Reduce a) = '-' : show a
moveToS (AtLeast a) = '<' : show a
moveToS (AtMost a) = '>' : show a
moveToS (RoundDown a) = '/' : show a
moveToS (RoundUp a) = '%' : show a
