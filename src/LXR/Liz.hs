
{-# LANGUAGE ForeignFunctionInterface #-}

module LXR.Liz
        (
          verify
        , daysleft
        , name
        , version
        , copyright
        , license
        ) where

import Foreign.C.Types
import Foreign.C.String

-- binding the external code
foreign import ccall unsafe liz_verify :: IO CBool
foreign import ccall unsafe liz_daysleft :: IO CInt
foreign import ccall unsafe liz_name :: IO CString
foreign import ccall unsafe liz_version :: IO CString
foreign import ccall unsafe liz_copyright :: IO CString
foreign import ccall unsafe liz_license :: IO CString

-- implementation
verify :: IO Bool
verify = do
    CBool n <- liz_verify
    return (n /= 0)

daysleft :: IO Int
daysleft = do
    n <- liz_daysleft
    return $ fromIntegral n

name :: IO String
name = peekCString =<< liz_name

version :: IO String
version = peekCString =<< liz_version

copyright :: IO String
copyright = peekCString =<< liz_copyright

license :: IO String
license = peekCString =<< liz_license
