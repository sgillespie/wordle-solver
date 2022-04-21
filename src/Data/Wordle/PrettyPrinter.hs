module Data.Wordle.PrettyPrinter where

import Data.Wordle.Solver
import Data.Wordle.Import
import RIO.List

prettyPrintGuess :: Guess -> String
prettyPrintGuess = intersperse ' ' . map prettyPrintLetter

prettyPrintLetter :: Letter -> Char
prettyPrintLetter (Letter c RightSpot) = c
prettyPrintLetter (Letter _ WrongSpot) = '_'
prettyPrintLetter (Letter _ NotInWord) = '-'
