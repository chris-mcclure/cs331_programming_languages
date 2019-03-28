-- PA5.hs  INCOMPLETE
-- Glenn G. Chappell
-- 21 Mar 2019
--
-- For CS F331 / CSCE A331 Spring 2019
-- Solutions to Assignment 5 Exercise B

module PA5 where
import Data.List
import Data.Fixed
import System.IO 

-- collatz
collatz :: Integer -> Integer
collatz 1 = 0
collatz n
  | odd n     = collatz(3 * n + 1) + 1
  | otherwise = collatz(div n 2) + 1

-- collatzCounts
collatzCounts :: [Integer]
collatzCounts = [collatz x | x <- [1..]]


findList :: Eq a => [a] -> [a] -> Maybe Int
findList [] [] = Just 0 -- empty list, empty list = Just 0
findList _ [] = Nothing -- anything, empty list = Nothing
findList [] _ = Just 0  -- empty list, anything = Just 0
findList a b = findIndex (isPrefixOf a) (tails b)

-- operator ##
(##) :: Eq a => [a] -> [a] -> Int
[] ## [] = 0
_ ## [] = 0
a ## b = length (filter (uncurry (==)) (zip a b))

-- (##) :: Eq a => [a] -> [a] -> Int
-- [] ## _ = 0
-- _ ## [] = 0
-- (x:xs) ## (y:ys)
--   | x == y                  = (xs ## ys) + 1
--   | otherwise               = xs ## ys

-- filterAB
filterAB :: (a -> Bool) -> [a] -> [b] -> [b]
filterAB _ [] [] = []
filterAB _ _ []  = []
filterAB _ [] _  = []
filterAB f (x:xs) (y:ys)
   | f x       = y : filterAB f xs ys
   | otherwise = filterAB f xs ys

-- sumEvenOdd
sumEvenOdd :: Num a => [a] -> (a, a)
   
{-
  The assignment requires sumEvenOdd to be written using a fold.
  Something like this:

    sumEvenOdd xs = fold* ... xs where
        ...

  Above, "..." should be replaced by other code. The "fold*" must be
  one of the following: foldl, foldr, foldl1, foldr1.
-}
sumEvenOdd _ = (0, 0)  -- DUMMY; REWRITE THIS!!!

