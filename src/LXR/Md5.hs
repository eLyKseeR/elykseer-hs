
{-# LANGUAGE ForeignFunctionInterface #-}

module LXR.Md5
        (
          hash_string
        ) where

import qualified LXR.Key128

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

-- binding the external code
foreign import ccall unsafe md5_buffer :: CString -> CInt -> IO (Ptr LXR.Key128.Key128Cpp)

-- implementation
hash_string :: String -> IO LXR.Key128.Key128
hash_string s = do
    let l = length s
        l' = fromIntegral l
    s' <- newCString s
    res <- newForeignPtr LXR.Key128.key128_release =<< md5_buffer s' l'
    return $ LXR.Key128.Key128 res
