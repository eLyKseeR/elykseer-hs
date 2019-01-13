
{-# LANGUAGE ForeignFunctionInterface #-}

module LXR.Sha256
        (
          hash_string
        , hash_file
        ) where

import qualified LXR.Key256

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

-- binding the external code
foreign import ccall unsafe sha256_buffer :: CString -> CInt -> IO (Ptr LXR.Key256.Key256Raw)
foreign import ccall unsafe sha256_file :: CString -> IO (Ptr LXR.Key256.Key256Raw)

-- implementation
hash_string :: String -> IO LXR.Key256.Key256
hash_string s = do
    let l = length s
        l' = fromIntegral l
    s' <- newCString s
    res <- newForeignPtr LXR.Key256.key256_release =<< sha256_buffer s' l'
    return $ LXR.Key256.Key256 res

hash_file :: String -> IO LXR.Key256.Key256
hash_file fp = do
    fp' <- newCString fp
    res <- newForeignPtr LXR.Key256.key256_release =<< sha256_file fp'
    return $ LXR.Key256.Key256 res

