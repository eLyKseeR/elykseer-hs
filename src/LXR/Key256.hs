
{-# LANGUAGE ForeignFunctionInterface #-}

module LXR.Key256
        (
          Key256 (..)
        , random
        , fromhex
        , lengthBits
        , tohex
        -- * don't abuse
        , Key256Cpp
        , key256_release
        ) where

import System.IO.Unsafe (unsafePerformIO)

import Data.Aeson (FromJSON (..), Value(Object), ToJSON (..), object,
                   (.=), (.:))
import Data.Aeson.Types (typeMismatch)
import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

data Key256Cpp
newtype Key256 = Key256 {ptr :: (ForeignPtr Key256Cpp)}
               deriving (Eq, Ord)

-- binding the external code
foreign import ccall unsafe key256_random :: IO (Ptr Key256Cpp)
foreign import ccall unsafe key256_fromhex :: CString -> CInt -> IO (Ptr Key256Cpp)
foreign import ccall unsafe key256_length :: Ptr Key256Cpp -> IO CInt
foreign import ccall unsafe key256_tohex :: Ptr Key256Cpp -> IO CString

foreign import ccall
    "&key256_release"
    key256_release :: FunPtr (Ptr Key256Cpp -> IO ())

-- implementation
random :: IO Key256
random = do
    res <- newForeignPtr key256_release =<< key256_random
    return $ Key256 res

fromhex :: String -> IO Key256
fromhex s = do
    let l = length s
    s' <- newCString s
    res <- newForeignPtr key256_release =<< key256_fromhex s' (fromIntegral l)
    return $ Key256 res

lengthBits :: Key256 -> IO CInt
lengthBits p = withForeignPtr (ptr p) $ \k -> key256_length k >>= return . fromIntegral

tohex :: Key256 -> IO String
tohex p = withForeignPtr (ptr p) $ \k -> key256_tohex k >>= peekCString

instance Show Key256 where
    show = unsafePerformIO . tohex

instance ToJSON Key256 where
    toJSON k = object ["tag" .= ("Key256"::String), "key" .= show k]
instance FromJSON Key256 where
    parseJSON o@(Object k) = do
        t <- k .: "tag"
        if t == ("Key256"::String)
        then do
            h <- k .: "key"
            return $ unsafePerformIO $ fromhex h
        else
            typeMismatch "Key256" o
    parseJSON some = typeMismatch "Key256" some
    