-- Chris McClure
-- CS331 HW5 Excercise C
-- Last Revised: 3/29/19

-- For HW5 Part C
-- Returns the median of a list.

-- PROGRAM WILL THROW AN EXCEPTION IF ANYTHING 
-- OTHER THAN A NUMBER IS INPUT.

import System.IO    
import Data.List 
import Data.Char 

main = do 
    nums <- getNumbers
    if (null nums) then
        putStrLn "Empty list- no median"
    else do
        putStr "Median: "
        print (median nums)
    putStrLn "\nCompute another median? [y/n]"
    input <- getLine
    if (map toLower input == "y") then
        main
    else do 
        putStrLn "Exiting!"

-- getNumbers
-- recursively calls itself, adding inputted numbers 
-- to a list, until an empty string is passed.
getNumbers = do 
    putStr "Enter a number (blank line to end): "
    hFlush stdout
    input <- getLine
    if null input
      then return []
    else do
      let num = read input
      next <- getNumbers
      return (num: next)
     
-- median
-- sorts a list and returns the value in the middle
median :: [Int] -> Int
median [] = 0
median nums = (sort nums) !! div (length nums) 2
