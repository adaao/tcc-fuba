{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Load where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

postInsertLoadR :: Handler Value
postInsertLoadR = do
   newLoad <- requireJasonBody :: Handler Load
   newLoadId <- runDB $ insert newLoad
   sendStatusJSON created201 (object ["resp" .= (fromSqlKey newLoadId)

getReadLoadR :: LoadId -> Handler Value
getReadLoadR loadId = do
   load <- runDB $ get404 loadId
   sendStatusJSON ok200 (object ["resp" .= (toJSON load)])

putUpdateLoadR :: LoadId -> Handler Value
putUpdateLoadR loadId = do
   _ <- runDB $ get404 loadId
   updatedLoad <- requireJsonBody :: Handler Load
   runDB $ replace loadId updatedLoad
   sendStatusJSON noContent204 (object ["resp" .= (fromSqlKey loadId)])

getReadClientLoadsR :: ClientId -> Handler Value
getReadClientLoadsR clientId = do
   loadsList <- RunDB $ selectList [LoadClientId ==. clientId] []
   sendStatusJSON ok200 (object ["resp" .= (toJSON loadsList)])

getReadLoadListR :: Handler Value
getReadLoadListR = do
   loadsList <- runDB $ selectList [] []
   sendStatusJSON ok200 (object ["resp" .= (toJSON loadsList)])
   