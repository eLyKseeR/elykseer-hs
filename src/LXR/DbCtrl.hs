
{-# LANGUAGE AllowAmbiguousTypes   #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}

module LXR.DbCtrl
  (
    Db (..)
  )
  where

class Db t k v where
  type DbInstance t k v :: *  -- -> * -> *
  get   :: DbInstance t k v -> k -> IO v
  set   :: DbInstance t k v -> k -> v -> IO ()
  count :: DbInstance t k v -> IO Int
