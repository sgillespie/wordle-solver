{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TemplateHaskell #-}
module Main (main) where

import Data.Wordle.Import
import Data.Wordle.Run (run)
import qualified Paths_wordle_solver

import RIO.Process (ProcessContext(), mkDefaultProcessContext)
import Options.Applicative.Simple

main :: IO ()
main = do
  options <- mkOptions
  logOptions <- logOptionsHandle stderr (verbose options)
  processContext <- mkDefaultProcessContext

  runApp options logOptions processContext

mkOptions :: IO Options
mkOptions = do
  (opts, ()) <- simpleOptions
    $(simpleVersion Paths_wordle_solver.version)
    "Automatically solve a Wordle"
    "Derive a solution for ANSWER"
    optionsParser
    empty

  return opts

runApp :: Options -> LogOptions -> ProcessContext -> IO ()
runApp options logOptions processContext = withLogFunc logOptions withApp
  where withApp logF = runRIO (app logF) run

        app logF = App
          { appLogFunc = logF,
            appProcessContext = processContext,
            appOptions = options
          }

optionsParser :: Parser Options
optionsParser = Options
  <$> switch verbose
  <*> answer

  where verbose = long "verbose"
          <> short 'v'
          <> help "Verbose output?"

        answer = argument str (metavar "ANSWER")
