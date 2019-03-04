\begin{code}

module Main where

import qualified LXR.Key128 as Key128
import qualified LXR.Key256 as Key256
import qualified LXR.Md5    as Md5
import qualified LXR.Sha256 as Sha256


main :: IO ()
main = do
    h1 <- Md5.hash_string "hello world"
    print =<< Key128.tohex h1
    h2 <- Sha256.hash_string "hello world"
    print =<< Key256.tohex h2

\end{code}
