-- Chris McClure
-- CS331 HW 5 Excercise B
-- Last Revised: 3/29/19
--
-- For HW5 Part B

module PA5 where
import Data.List
import Data.Fixed
import System.IO 

-- collatz
-- takes an Integer, determines if it's even or odd,
-- recursively calls itself as long as the integer isn't 1.
collatz :: Integer -> Integer
collatz 1 = 0
collatz n
  | odd n     = collatz(3 * n + 1) + 1
  | otherwise = collatz(div n 2) + 1

-- collatzCounts
-- calls passes each value in an infinite list to collatz
-- returns the value returned by collatz in a list
collatzCounts :: [Integer]
collatzCounts = [collatz x | x <- [1..]]

-- findList
-- takes two lists and returns the first index at which
-- the first list is determined to be a contiguous part of the
-- second.
findList :: Eq a => [a] -> [a] -> Maybe Int
findList [] [] = Just 0 -- empty list, empty list = Just 0
findList _ [] = Nothing -- anything, empty list = Nothing
findList [] _ = Just 0  -- empty list, anything = Just 0
findList a b = findIndex (isPrefixOf a) (tails b)

-- operator ##
-- takes two lists and returns the number of indices
-- that both lists contain equal value.
(##) :: Eq a => [a] -> [a] -> Int
[] ## [] = 0
_ ## [] = 0

-- filters both lists, zips them together, and then
-- returns the length of the new list.
a ## b = length (filter (uncurry (==)) (zip a b))

-- filterAB
-- takes a function and two lists
-- if the function is evaluated to be true, add
-- the value in the second list to a new list and 
-- recursively call itself until the end of both lists
-- have been reached. 
filterAB :: (a -> Bool) -> [a] -> [b] -> [b]
filterAB _ [] [] = []
filterAB _ _ []  = []
filterAB _ [] _  = []
filterAB f (x:xs) (y:ys)
   | f x       = y : filterAB f xs ys
   | otherwise = filterAB f xs ys


-- evenOrOdd
evenOrOdd [] = [0]
evenOrOdd xs = foldr(\x ls -> if (odd (fst x)) 
                                 then (snd x):ls 
                              else ls) [] (zip [1..] xs)
-- sumEvenOdd
-- Takes a list of numbers and returns a tuple
-- with the first value being a summation of each 
-- even indice in the passed list and the second value
-- being each odd indice.
sumEvenOdd :: Num a => [a] -> (a, a)
sumEvenOdd [] = (0,0)
sumEvenOdd xs = (foldr1 (+) (a), foldr1 (+) (b))
  where a = evenOrOdd xs 
        b = evenOrOdd (tail xs)


