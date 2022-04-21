module Data.Wordle.Types where

import RIO
import RIO.Process

data Options = Options
  { verbose :: !Bool,
    answer :: !String
  }
  deriving (Show)

data App = App
  { appLogFunc :: !LogFunc,
    appProcessContext :: !ProcessContext,
    appOptions :: !Options
  }

class HasOptions env where
  optionL :: Lens' env Options

class HasOptions env => HasAnswer env where
  answerL :: Lens' env String

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x { appLogFunc = y })

instance HasProcessContext App where
  processContextL = lens appProcessContext (\x y -> x { appProcessContext = y })

instance HasOptions Options where
  optionL = id
 
instance HasOptions App where
  optionL = lens appOptions (\x y -> x { appOptions = y })

instance HasAnswer Options where
  answerL = lens answer (\opts answer -> opts { answer })

instance HasAnswer App where
  answerL = optionL'.answerL
    where optionL' = lens appOptions (\x y -> x { appOptions = y })

