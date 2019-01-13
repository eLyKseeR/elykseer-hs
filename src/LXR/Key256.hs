
{-# LANGUAGE ForeignFunctionInterface #-}

module LXR.Key256
        (
          Key256 (..)
        , random
        , fromhex
        , lengthBits
        , tohex
        -- * don't abuse
        , Key256Raw
        , key256_release
        ) where

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

data Key256Raw
newtype Key256 = Key256 {ptr :: (ForeignPtr Key256Raw)}
               deriving (Eq, Ord)

-- binding the external code
foreign import ccall unsafe key256_random :: IO (Ptr Key256Raw)
foreign import ccall unsafe key256_fromhex :: CString -> CInt -> IO (Ptr Key256Raw)
foreign import ccall unsafe key256_length :: Ptr Key256Raw -> IO CInt
foreign import ccall unsafe key256_tohex :: Ptr Key256Raw -> IO CString

foreign import ccall
    "&key256_release"
    key256_release :: FunPtr (Ptr Key256Raw -> IO ())

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
lengthBits p = withForeignPtr (ptr p) $ key256_length

tohex :: Key256 -> IO String
tohex p = withForeignPtr (ptr p) $ \k -> key256_tohex k >>= peekCString

