{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LAVGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Ship where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postInsertShipR :: Handler Value
postInsertShipR = do
   ship <- requireJsonBody :: Handler Ship
   shipId <- runDB $ insert ship
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey shipId)])

getReadShipR :: ShipId -> Handler Value
getReadShipR shipId = do
   ship <- runDB $ get404 shipId
   sendStatusJson ok200 (object ["resp" .= (toJSON ship)])

getShipListR :: Handler Value
getShipListR = do
   shipList <- runDB $ selectList [] [Asc ShipName]
   sendStatusJSON ok200 (object ["resp" .= (toJSON shipList)])   