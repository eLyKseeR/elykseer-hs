
{-# LANGUAGE DeriveAnyClass           #-}
{-# LANGUAGE DeriveGeneric            #-}
{-# LANGUAGE FlexibleInstances        #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE MultiParamTypeClasses    #-}
{-# LANGUAGE OverloadedStrings        #-}
{-# LANGUAGE StandaloneDeriving       #-}
{-# LANGUAGE TypeFamilies             #-}

module LXR.DbFp
        (
          DbFp
        , DbFpBlock
        , DbFpDat
        ) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)
import Data.Int (Int64)
import Data.String

import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr
import Foreign.ForeignPtr

import qualified LXR.Key128 as Key128
import           LXR.Key128 (Key128)
import qualified LXR.Key256 as Key256
import           LXR.Key256 (Key256)
import LXR.DbCtrl (Db (..))

data DbFpBlock = DbFpBlock
                 { _idx    :: Int
                 , _apos   :: Int
                 , _fpos   :: Int64
                 , _blen   :: Int
                 , _clen   :: Int
                 , _compr  :: Bool
                 , _csumbl :: Key128
                 , _aid    :: Key256
                 } deriving (Eq, Show, Generic, ToJSON, FromJSON)

data DbFpDat = DbFpDat
               { _id     :: Key128
               , _fname  :: String
               , _len    :: Int64
               , _osusr  :: String
               , _osgrp  :: String
               , _osattr :: String
               , _chksum :: Key256
               , _blocks :: [DbFpBlock]
               } deriving (Eq, Show, Generic, ToJSON, FromJSON)

empty_DbFpDat :: IO DbFpDat
empty_DbFpDat = do
  r128 <- Key128.random
  r256 <- Key256.random
  return $ DbFpDat {
                   _id = r128
                 , _fname = ""
                 , _len = 0
                 , _osusr = ""
                 , _osgrp = ""
                 , _osattr = ""
                 , _chksum = r256
                 , _blocks = []
                 }

instance Db DbFp String DbFpDat where
  -- data DbInstance DbFp String DbFpDat = DbFpCpp String DbFpDat
  type DbInstance DbFp String DbFpDat = Ptr (DbFpCpp String DbFpDat)
  set db k v = return ()
  get db k = empty_DbFpDat
  count db = fromIntegral <$> dbfp_count db


data DbFpCpp k v
newtype DbFp = DbFp {ptr :: (ForeignPtr (DbFpCpp String DbFpDat))}
               deriving (Eq, Ord)

-- binding the external code
-- foreign import ccall unsafe key128_random :: IO (Ptr Key128Raw)
-- foreign import ccall unsafe key128_fromhex :: CString -> CInt -> IO (Ptr Key128Raw)
foreign import ccall unsafe dbfp_count :: Ptr (DbFpCpp k v) -> IO CInt
foreign import ccall unsafe dbfp_get :: Ptr (DbFpCpp k v) -> CString -> IO CString

foreign import ccall
    "&dbfp_release"
    dbfp_release :: FunPtr (Ptr (DbFpCpp k v) -> IO ())

-- implementation
count :: DbFp -> IO Int
count p = withForeignPtr (ptr p) $ \d -> fromIntegral <$> dbfp_count d