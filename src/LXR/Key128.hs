
{-# LANGUAGE ForeignFunctionInterface #-}

module LXR.Key128
        (
          Key128 (..)
        , random
        , fromhex
        , lengthBits
        , tohex
        -- * don't abuse
        , Key128Raw
        , key128_release
        ) where

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

data Key128Raw
newtype Key128 = Key128 {ptr :: (ForeignPtr Key128Raw)}
               deriving (Eq, Ord)

-- binding the external code
foreign import ccall unsafe key128_random :: IO (Ptr Key128Raw)
foreign import ccall unsafe key128_fromhex :: CString -> CInt -> IO (Ptr Key128Raw)
foreign import ccall unsafe key128_length :: Ptr Key128Raw -> IO CInt
foreign import ccall unsafe key128_tohex :: Ptr Key128Raw -> IO CString

foreign import ccall
    "&key128_release"
    key128_release :: FunPtr (Ptr Key128Raw -> IO ())

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

lengthBits :: Key128 -> IO CInt
lengthBits p = withForeignPtr (ptr p) $ key128_length

tohex :: Key128 -> IO String
tohex p = withForeignPtr (ptr p) $ \k -> key128_tohex k >>= peekCString

