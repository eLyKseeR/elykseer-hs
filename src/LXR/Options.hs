
{-# LANGUAGE OverloadedStrings #-}

module LXR.Options
  (
    Options
  , empty
  , nchunks
  , setNchunks
  , nredund
  , setNredund
  , fpchunks
  , setFpChunks
  , fpmeta
  , setFpMeta
  , isCompressed
  , setCompression
  , isDeduplicated
  , setDeduplication
  )
  where

import           System.IO (FilePath)

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

data OptionsCpp
newtype Options = Options {ptr :: (ForeignPtr OptionsCpp)}
              deriving (Eq, Ord)

foreign import ccall unsafe options_new :: IO (Ptr OptionsCpp)
foreign import ccall unsafe options_get_nchunks :: Ptr OptionsCpp -> IO CInt
foreign import ccall unsafe options_set_nchunks :: Ptr OptionsCpp -> CInt -> IO ()
foreign import ccall unsafe options_get_nredund :: Ptr OptionsCpp -> IO CInt
foreign import ccall unsafe options_set_nredund :: Ptr OptionsCpp -> CInt -> IO ()
foreign import ccall unsafe options_get_iscompr :: Ptr OptionsCpp -> IO CInt
foreign import ccall unsafe options_set_iscompr :: Ptr OptionsCpp -> CInt -> IO ()
foreign import ccall unsafe options_get_isdedup :: Ptr OptionsCpp -> IO CInt
foreign import ccall unsafe options_set_isdedup :: Ptr OptionsCpp -> CInt -> IO ()
foreign import ccall unsafe options_get_fpchunks :: Ptr OptionsCpp -> IO CString
foreign import ccall unsafe options_set_fpchunks :: Ptr OptionsCpp -> CString -> IO ()
foreign import ccall unsafe options_get_fpmeta :: Ptr OptionsCpp -> IO CString
foreign import ccall unsafe options_set_fpmeta :: Ptr OptionsCpp -> CString -> IO ()

foreign import ccall
    "&options_release"
    options_release :: FunPtr (Ptr OptionsCpp -> IO ())

-- implementation
empty :: IO Options
empty = do
    res <- newForeignPtr options_release =<< options_new
    return $ Options res

nchunks :: Options -> IO Int
nchunks p = withForeignPtr (ptr p) $ \o -> fromIntegral <$> options_get_nchunks o

setNchunks :: Options -> Int -> IO ()
setNchunks p n = withForeignPtr (ptr p) $ \o -> options_set_nchunks o (fromIntegral n)

nredund :: Options -> IO Int
nredund p = withForeignPtr (ptr p) $ \o -> fromIntegral <$> options_get_nredund o

setNredund :: Options -> Int -> IO ()
setNredund p n = withForeignPtr (ptr p) $ \o -> options_set_nredund o (fromIntegral n)

fpchunks :: Options -> IO FilePath
fpchunks p = withForeignPtr (ptr p) $ \o -> options_get_fpchunks o >>= peekCString

setFpChunks :: Options -> FilePath -> IO ()
setFpChunks p fp = do
    fp' <- newCString fp
    withForeignPtr (ptr p) $ \o -> options_set_fpchunks o fp'

fpmeta :: Options -> IO FilePath
fpmeta p = withForeignPtr (ptr p) $ \o -> options_get_fpmeta o >>= peekCString

setFpMeta :: Options -> FilePath -> IO ()
setFpMeta p fp = do
    fp' <- newCString fp
    withForeignPtr (ptr p) $ \o -> options_set_fpmeta o fp'

isCompressed :: Options -> IO Bool
isCompressed p = withForeignPtr (ptr p) $ \o -> do
                   b <- options_get_iscompr o
                   return $ if b == 1 then True else False

setCompression :: Options -> Bool -> IO ()
setCompression p True = withForeignPtr (ptr p) $ \o -> options_set_iscompr o 1
setCompression p False = withForeignPtr (ptr p) $ \o -> options_set_iscompr o 0

isDeduplicated :: Options -> IO Bool
isDeduplicated p = withForeignPtr (ptr p) $ \o -> do
                     b <- options_get_isdedup o
                     return $ if b == 1 then True else False

setDeduplication :: Options -> Bool -> IO ()
setDeduplication p True = withForeignPtr (ptr p) $ \o -> options_set_isdedup o 1
setDeduplication p False = withForeignPtr (ptr p) $ \o -> options_set_isdedup o 0

