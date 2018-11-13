module Lib
    (
      calculateCorrelations
    ) where

import Control.Monad (mzero)
import Data.Csv
import Data.Text(Text, strip)
import qualified Data.Vector as V

data DataRec = DataRec Int Text [Double]
data CorrRec = CorrRec Text Text Double

instance FromRecord DataRec where
  parseRecord v
      | length v > 2 = do
          c <- v .! 0
          n <- v .! 1
          dat <- parseRecord . V.drop 2 $ v
          pure $ DataRec c n dat
      | otherwise     = mzero

instance ToNamedRecord CorrRec where
    toNamedRecord (CorrRec n1 n2 c) = namedRecord ["Range X" .= strip n1, "Range Y" .= strip n2, "Correlation(X,Y)" .= c]

instance DefaultOrdered CorrRec where
    headerOrder _ = header ["Range X", "Range Y", "Correlation(X,Y)"]

trimData :: DataRec -> DataRec -> (DataRec, DataRec)
trimData (DataRec c1 n1 xs) (DataRec c2 n2 ys) = (DataRec c1 n1 (take l xs), DataRec c2 n2 (take l ys))
  where l = min (length xs) (length ys)

correlate :: DataRec -> DataRec -> CorrRec
correlate (DataRec _ n1 xs) (DataRec _ n2 ys) = CorrRec n1 n2 $ numer / denom
  where
    xa = sum xs / (fromIntegral $ length xs)
    ya = sum ys / (fromIntegral $ length ys)
    xd = fmap (\x -> x - xa) xs
    yd = fmap (\y -> y - ya) ys
    numer = sum $ zipWith (*) xd yd
    denom = sqrt $ (sum $ zipWith (*) xd xd) * (sum $ zipWith (*) yd yd)

calculateCorrelations :: [DataRec] -> [CorrRec]
calculateCorrelations dls = [uncurry correlate (trimData a b) | a <- dls, b <- dls, fstD a < fstD b]
  where fstD (DataRec c _ _) = c
