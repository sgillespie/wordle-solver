module Data.Wordle.PrettyPrinterSpec (spec) where

import Data.Wordle.Import
import Data.Wordle.Solver
import Data.Wordle.PrettyPrinter

import Test.Hspec

spec :: Spec
spec = do
  describe "prettyPrintGuess" $ do
    it "returns empty string on empty guess" $ do
      let guess = []
      prettyPrintGuess guess `shouldBe` ""

    it "returns expected blah bl" $ do
      let guess
            = [ Letter 'T' RightSpot,
                Letter 'E' WrongSpot,
                Letter 'S' NotInWord,
                Letter 'T' RightSpot
              ]
          expectedResult = "T _ - T"

      prettyPrintGuess guess `shouldBe` expectedResult
