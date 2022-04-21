module Data.Wordle.Run (run) where

import Data.Wordle.Import
import Data.Wordle.Solver
import Data.Wordle.PrettyPrinter

run :: RIO App ()
run = do
  answer <- asks (^. answerL)

  logInfo $ fromString $ "Solving for: " ++ show answer
  result <- solve answer

  let prettyResult = unlines $ map prettyPrintGuess result
  logInfo $ fromString prettyResult
