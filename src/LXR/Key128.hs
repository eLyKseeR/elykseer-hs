
{-# LANGUAGE ForeignFunctionInterface #-}

module LXR.Key128
        (
          Key128 (..)
        , random
        , fromhex
        , lengthBits
        , tohex
        -- * don't abuse
        , Key128Cpp
        , key128_release
        ) where

import System.IO.Unsafe (unsafePerformIO)

import Data.Aeson (FromJSON (..), Value(Object), ToJSON (..), object,
                   (.=), (.:))
import Data.Aeson.Types (typeMismatch)
import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

data Key128Cpp
newtype Key128 = Key128 {ptr :: (ForeignPtr Key128Cpp)}
               deriving (Eq, Ord)

-- binding the external code
foreign import ccall unsafe key128_random :: IO (Ptr Key128Cpp)
foreign import ccall unsafe key128_fromhex :: CString -> CInt -> IO (Ptr Key128Cpp)
foreign import ccall unsafe key128_length :: Ptr Key128Cpp -> IO CInt
foreign import ccall unsafe key128_tohex :: Ptr Key128Cpp -> IO CString

foreign import ccall
    "&key128_release"
    key128_release :: FunPtr (Ptr Key128Cpp -> IO ())

-- implementation
random :: IO Key128
random = do
    res <- newForeignPtr key128_release =<< key128_random
    return $ Key128 res

fromhex :: String -> IO Key128
fromhex s = do
    let l = length s
    s' <- newCString s
    res <- newForeignPtr key128_release =<< key128_fromhex s' (fromIntegral l)
    return $ Key128 res

lengthBits :: Key128 -> IO Int
lengthBits p = withForeignPtr (ptr p) $ \k -> key128_length k >>= return . fromIntegral

tohex :: Key128 -> IO String
tohex p = withForeignPtr (ptr p) $ \k -> key128_tohex k >>= peekCString

instance Show Key128 where
    show = unsafePerformIO . tohex

instance ToJSON Key128 where
    toJSON k = object ["tag" .= ("Key128"::String), "key" .= show k]
instance FromJSON Key128 where
    parseJSON o@(Object k) = do
        t <- k .: "tag"
        if t == ("Key128"::String)
        then do
            h <- k .: "key"
            return $ unsafePerformIO $ fromhex h
        else
            typeMismatch "Key128" o
    parseJSON some = typeMismatch "Key128" some
