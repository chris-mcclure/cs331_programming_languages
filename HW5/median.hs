module Main where

import System.IO
import Data.List

main = do
   putStrLn "Enter a list of integers, one on each line."
   putStrLn "I will compute the median of the list. \n\n"
   putStrLn "Enter number (blank line to end): "
   num <- getLine
 
   -- need to make a base statement that ends the program if a blank line is entered

   let maybeInt = readMaybe num :: Maybe Int

   case maybeInt of
      Just n -> putStrLn "good" 
      Nothing -> putStrLn "BAD" >> main

readMaybe :: Read a => String -> Maybe a
readMaybe s = case reads s of 
   [(val, "")] -> Just val
   _           -> Nothing
