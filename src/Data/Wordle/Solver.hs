module Data.Wordle.Solver where

import Data.Wordle.Import

import RIO.NonEmpty (head, nonEmpty)

import Data.Maybe (fromJust)

type Word = String

type Result = [Guess]

type Guess = [Letter]

data Letter = Letter Char LetterResult
  deriving (Eq, Show)

data LetterResult = RightSpot | WrongSpot | NotInWord
  deriving (Eq, Show)

solve :: Monad m => String -> m Result
solve answer = solve' answer candidateWords

solve' :: Monad m => String -> [String] -> m Result
solve' _ [] = return []
solve' answer candidates = do
  -- 1. Choose a random word
  let candidates' = fromJust $ nonEmpty candidates
      word = chooseWord candidates'
      guess = checkGuess answer word

  if
    | word == answer -> return [map (\l -> Letter l RightSpot) word]
    | otherwise -> do
        let nextCandidates = filterWords guess candidates
        res <- solve' answer nextCandidates
        return (guess:res)

chooseWord :: NonEmpty String -> String
chooseWord = head

checkGuess :: String -> String -> Guess
checkGuess answer guess
  = map (uncurry Letter) . map (uncurry checkLetter) $ zipped
  where zipped = zip answer guess
        checkLetter answerLetter guessLetter
          | answerLetter == guessLetter = (guessLetter, RightSpot)
          | guessLetter `elem` answer = (guessLetter, WrongSpot)
          | otherwise = (guessLetter, NotInWord)

filterWords :: Guess -> [String] -> [String]
filterWords _ [] = []
filterWords letters (candidate:candidates)
  = let zipped = zip letters candidate
        matches = all (\(l, c) -> letterFilter l c)  zipped
    in if matches then (candidate : filterWords letters candidates) else filterWords letters candidates
  where letterFilter (Letter c RightSpot) letter = letter == c
        letterFilter (Letter c _) letter = letter /= c

candidateWords :: [String]
candidateWords
  = [ "steal",
      "frail",
      "stale",
      "piles",
      "radio",
      "spear"
    ]
