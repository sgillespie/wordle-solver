module Data.Wordle.SolverSpec (spec) where

import Data.Wordle.Import
import Data.Wordle.Solver

import RIO.List
import RIO.NonEmpty (nonEmpty)
import Test.Hspec

import Data.Maybe (fromJust)

spec :: Spec
spec = do
  let candidateWords
        = fromJust $ nonEmpty
          [ "steal",
            "frail",
            "stale",
            "piles",
            "radio",
            "spear"
          ]
  
  describe "solve" $ do
    it "returns success on first try" $ solve "steal" `shouldBe`
      Identity
        [ [ Letter 's' RightSpot,
            Letter 't' RightSpot,
            Letter 'e' RightSpot,
            Letter 'a' RightSpot,
            Letter 'l' RightSpot
        ] ]

    it "returns success after multiple tries" $ fromJust . lastMaybe <$> solve "radio" `shouldBe`
      Identity
        [ Letter 'r' RightSpot,
          Letter 'a' RightSpot,
          Letter 'd' RightSpot,
          Letter 'i' RightSpot,
          Letter 'o' RightSpot
        ]

  describe "chooseWord" $ do
    it "picks a word from candidates" $
      chooseWord candidateWords `shouldBe` "steal"
      
  describe "checkGuess" $ do
    it "returns all NotInWord if no letters match" $
      checkGuess "steal" "couch" `shouldBe` map (\c -> Letter c NotInWord) "couch"

    it "returns all RightSpot if all letters match" $
      checkGuess "steal" "steal" `shouldBe` map (\c -> Letter c RightSpot) "steal"

    it "returns all WrongSpot if all letters are in the wrong spot" $
      checkGuess "steal" "leats" `shouldBe` map (\c -> Letter c WrongSpot) "leats"
    
  describe "filterWords" $ do
    it "returns exactly one word if guess is all RightSpot" $
      filterWords  (map (\c -> Letter c RightSpot) "steal") (toList candidateWords) `shouldBe` ["steal"]

    it "returns multiple words that match" $
      filterWords  (map (\c -> Letter c NotInWord) "steal") (toList candidateWords) `shouldBe` ["piles", "radio"]
