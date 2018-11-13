module Main where

import Lib

import Data.Csv
import Data.Monoid
import Options.Applicative as OA
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V

data CLIOptions = CLIOptions {
  optsDataFile :: FilePath
, optsResultFile :: FilePath
}

options :: OA.Parser CLIOptions
options = CLIOptions
  <$> strArgument (metavar "DATA_FILE" <> value "data.csv" <> showDefault)
  <*> strOption (long "output" <> short 'o' <> metavar "OUTPUT_FILE" <> value "results.csv" <> showDefault)

main :: IO ()
main = do
  CLIOptions inpF outF <- execParser opts
  eInp <- decode NoHeader <$> BL.readFile inpF
  BL.writeFile outF $ case fmap (encodeDefaultOrderedByName . calculateCorrelations . V.toList) eInp of
    Left err -> BL.fromStrict $ BC.pack err
    Right bs -> bs
  where
    opts = info (options <**> helper) (fullDesc <> progDesc "Calculate correlations" <> OA.header "Correlation calculator")
